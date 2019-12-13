########################################################################
#     Makefile
########################################################################

fc          = mpif90
main        = run.exe


ifeq ($(shell whoami),jr)
    P3DFFT_INCLUDES = -I/home/jr/software/p3dfft-p3dfft.2.5.1/include
    P3DFFT_LIB = /home/jr/software/p3dfft-p3dfft.2.5.1/lib/libp3dfft.a /home/jr/software/fftw-3.3.8/lib/libfftw3.a 
else 
ifeq ($(shell whoami),renguangzhi)
    P3DFFT_INCLUDES = -I/home/renguangzhi/software/p3dfft-p3dfft.2.5.1/include
    P3DFFT_LIB = /home/renguangzhi/software/p3dfft-p3dfft.2.5.1/lib/libp3dfft.a /home/renguangzhi/software/fftw-3.3.8/lib/libfftw3.a
endif
endif

include=   $(P3DFFT_INCLUDES)
lib =   $(P3DFFT_LIB)

fcc	= -O3 -ffree-line-length-200 -fbounds-check

objects =  main.o \

$(main) : $(objects)
	$(fc) $(include) -o $(main) $(objects) $(lib) $(fcc)

main.o : main.f90 
	$(fc) $(include) -c main.f90 $(fcc)

clean :
	rm *.mod *.o run.exe *.dat *.txt *.h5

