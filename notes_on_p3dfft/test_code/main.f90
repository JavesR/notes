MODULE mod_mpi

    implicit none

    integer ierr, N_proces, rank
    integer dim_yz(0:1), MPI_comm_cart_yz, MPI_comm_cart_y, MPI_comm_cart_z
    integer w_rank, e_rank, s_rank, n_rank, c_rank(0:1)
    logical period_yz(0:1), recorder

END MODULE mod_mpi

MODULE mod_grid

    integer nra, nth, nph, kth, kph
    real(kind=8),dimension(:),allocatable :: r,ra
    real(kind=8) dra, a_minor 

    integer K_y_p, K_z_p, N_x_p, N_y_p

    integer start_r(3), end_r(3), size_r(3),start_k(3), end_k(3), size_k(3), memsize(3)
    real(kind=8) factor

    integer,dimension(:),allocatable :: th_p
    integer,dimension(:,:),allocatable :: ph_p
    integer,dimension(:),allocatable :: kth_p, kph_p, nra_p, nth_p

END MODULE mod_grid

program Main

    use mod_mpi
    implicit none
    include "mpif.h"

    period_yz(0) = .true.
    period_yz(1) = .false.

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_comm_world, N_proces, ierr)
    call MPI_COMM_RANK(MPI_comm_world, rank, ierr)
    print*,"rank=",rank,"is alive."

    dim_yz(1) = 16

    call MPI_DIMS_CREATE(N_proces, 2, dim_yz(0:1), ierr)
    call MPI_CART_CREATE(MPI_comm_world, 2, dim_yz(0:1), period_yz(0:1), .false., MPI_comm_cart_yz, ierr)

    call MPI_CART_SHIFT(MPI_comm_cart_yz, 0, 1, w_rank, e_rank, ierr)
    call MPI_CART_SHIFT(MPI_comm_cart_yz, 1, 1, s_rank, n_rank, ierr)

    ! print*, "my_rank=",rank, "w_rank=",w_rank,"e_rank=",e_rank

    call MPI_CART_COORDS(MPI_comm_cart_yz, rank, 2, c_rank(0:1), ierr)

    call MPI_COMM_SPLIT(MPI_comm_cart_yz, c_rank(1), c_rank(0), MPI_comm_cart_y, ierr)
    call MPI_COMM_SPLIT(MPI_comm_cart_yz, c_rank(0), c_rank(1), MPI_comm_cart_z, ierr)

    call Grid
    ! call Initial
    ! call Flow

    call MPI_FINALIZE(ierr)

end program Main




subroutine Grid

    use mod_grid
    use mod_mpi
    use p3dfft

    implicit none
    include "mpif.h"

    integer x_i,y_i,z_i
    real(kind=8) r0,r1
    integer :: dim_p3d(0:1), x_s, y_s, z_s , n

    nra = 64
    kth = 128
    kph = 32

    nth = kth
    nph = 2*kph - 2

    ! print*, nra,nth,nph
    ! print*, nra,kth,kph

    a_minor = 80.d0

    r0=0.05d0; r1 = 1.d0;
    allocate( ra(nra) )
    dra = a_minor*(r1-r0)/dfloat(nra+1) 
    do x_i = 1,nra
        ra(x_i) = a_minor*r0 + dra*x_i
    enddo
    r = ra/a_minor

    K_y_p = kth/dim_yz(0)
    K_z_p = kph/dim_yz(1)

    N_x_p = int(nra/dim_yz(0))
    N_y_p = int(nth/dim_yz(1))

    allocate( th_p(0:K_y_p+1), ph_p(0:K_y_p+1,1:K_z_p) )
    allocate( kth_p(0:K_y_p+1), kph_p(kph) )
    allocate( nra_p(N_x_p), nth_p(N_y_p) )

    th_p=0; ph_p=0
    kth_p=0; kph_p=0; nra_p=0; nth_p=0

    y_s = c_rank(0)*K_y_p + 1
    z_s = c_rank(1)*K_z_p + 1

    do y_i = 0, K_y_p+1
        if( (y_s + y_i - 1)>= 1 .and. (y_s + y_i - 1)<= kth  )then
            kth_p(y_i) = y_s + y_i - 1
            
            if( kth_p(y_i) <= int(nth/2) ) th_p(y_i) = kth_p(y_i) - 1
            if( kth_p(y_i) > int(nth/2) ) th_p(y_i) = -(nth - kth_p(y_i) + 1)
        endif
    enddo
    
    do z_i = 1, K_z_p
        if( (z_s + z_i - 1)>= 1 .and. (z_s + z_i - 1)<= kph  )then
            kph_p(z_i) = z_s + z_i - 1

            do y_i = 0, K_y_p+1
                if( kth_p(y_i) <= int(nth/2) ) ph_p(y_i,z_i) = kph_p(z_i)-1
                if( kth_p(y_i) > int(nth/2) ) ph_p(y_i,z_i) = -( kph_p(z_i)-1 )
            enddo

        endif
    enddo

    if( c_rank(0)==0 ) then
        th_p(0) = -1
        do z_i = 1, K_z_p
            ph_p(0,z_i) = -ph_p(0,z_i)
            ! print*, rank, th_p(0),ph_p(0,z_i), th_p(K_y_p), ph_p(K_y_p,z_i)
        enddo
    endif


    x_s = c_rank(0)*N_x_p + 1
    y_s = c_rank(1)*N_y_p + 1

    do x_i = 1, N_x_p
        if( (x_s + x_i - 1)>= 1 .and. (x_s + x_i - 1)<= nra  )then
            nra_p(x_i) = x_s + x_i - 1
        endif
    enddo
    
    do y_i = 1, N_y_p
        if( (y_s + y_i - 1)>= 1 .and. (y_s + y_i - 1)<= nth  )then
            nth_p(y_i) = y_s + y_i - 1
        endif
    enddo


    ! print*, rank,nra_p(1),nra_p(N_x_p)

    do n = 0, N_proces
        if(rank==n)then
            if(rank==0)then
                open(1,file="rank_xy.txt",status="replace")
            else 
                open(1,file="rank_xy.txt",status="old", access="append")               
            endif
            write(1,*) rank, c_rank(0), c_rank(1), nra_p(1), N_x_p,  nth_p(1), N_y_p 
            close(1) 
        endif
        call mpi_barrier(MPI_comm_world,ierr)
    enddo

    do n = 0, N_proces
        if(rank==n)then
            if(rank==0)then
                open(1,file="rank_yz.txt",status="replace")
            else 
                open(1,file="rank_yz.txt",status="old", access="append")               
            endif
            write(1,*) rank, c_rank(0), c_rank(1), kth_p(1), K_y_p,  kph_p(1), K_z_p 
            close(1) 
        endif
        call mpi_barrier(MPI_comm_world,ierr)
    enddo

    
    ! dim_p3d(0) = dim_yz(1)
    ! dim_p3d(1) = dim_yz(0)

    ! call P3DFFT_SETUP(MPI_comm_world, dim_p3d , nph, nth, nra, .true., memsize)
    ! ! call P3DFFT_SETUP(MPI_comm_world, dim_yz , nph, nth, nra, .true., memsize)
    
    ! call P3DFFT_GET_DIMS(start_r, end_r, size_r, 1)
    ! call P3DFFT_GET_DIMS(start_k, end_k, size_k, 2)

    ! factor = 1.d0/dfloat(nth*nph)

!     write(*,*),"                 ","    "," x  ","    "," y  ","    "," z  "
!     write(*,101) size_r(3),size_r(2),size_r(1)
!     write(*,102) size_k(3),size_k(2),size_k(1)

! 101 format(" real     space :","    ",I4,"    ",I4,"    ",I4 )
! 102 format(" spectral space :","    ",I4,"    ",I4,"    ",I4 )


!     write(*,103)rank,size_r(3), N_x_p
!     write(*,104)rank,size_r(2), N_y_p
!     write(*,105)rank,size_r(1), nph

! 103 format("my_rank=",I4,"    size_r(3)=",I4,"    N_x_p=",I4)
! 104 format("my_rank=",I4,"    size_r(2)=",I4,"    N_y_p=",I4)
! 105 format("my_rank=",I4,"    size_r(1)=",I4,"      N_z=",I4)


!     write(*,106) rank,size_k(3), nra 
!     write(*,107) rank,size_k(2), K_y_p 
!     write(*,108) rank,size_k(1), K_z_p 

! 106 format("my_rank=",I4,"    size_k(3)=",I4,"      N_x=",I4)
! 107 format("my_rank=",I4,"    size_k(2)=",I4,"    K_y_p=",I4)
! 108 format("my_rank=",I4,"    size_k(1)=",I4,"    K_z_p=",I4)


    ! print*, "my_rank=",rank, start_k(1), kph_p(1), end_k(1), kph_p(K_z_p)
    ! print*, "my_rank=",rank, start_k(2), kth_p(1), end_k(2), kth_p(K_y_p)
    ! print*, "my_rank=",rank, start_k(3), 1, end_k(3), nra

    ! print*, "my_rank=",rank, start_r(1), 1, end_r(1), kph
    ! print*, "my_rank=",rank, start_r(2), Nth_p(1), end_r(2), Nth_p(N_y_p)
    ! print*, "my_rank=",rank, start_r(3), Nra_p(1), end_r(3), Nra_p(N_x_p)



end subroutine Grid
