误差场/边界磁扰动对于等离子体的影响
- 文献 
- 思路： 边界的磁扰动渗透会影响等离子体的旋转以及激发撕裂模，旋转的降低以及撕裂模的激发都会对湍流输运产生一定的影响。首先从两场出发，验证误差场渗透的参数和现象，然后考虑五场下密度和温度剖面的影响，注意一下异同，以及相关的输运特性和剖面变化。最后考虑温度激发强ITG湍流时候的激发情况。
---
### 两场下
- 约化MHD，单流体假设，不考虑压强剖面带来的抗磁性漂移以及不稳定性。
- 采用$(r,\theta,\zeta)$坐标系，但实际上没有考虑环效应。
- 只取了$(m/n)=(2/1)$模式演示，实际多螺旋的效果大致相同，区别不大。
#### 1. 初始设置
<!-- - 模型方程
    $$ d_t U = \nabla_\parallel J + D_U\nabla^2_\perp U $$
    $$ \beta d_t\psi = - \nabla_\parallel\phi + \eta J $$ -->
- 平衡磁场
    $$ q = \frac{3(1+f)}{4-6r^2+4r^4-r^6} $$
    其中$f = A(r-r_s)\exp(-[(r-r_s)/\delta]^2)，r_s=0.811，\delta=0.05$。选取$A=0,0.01,0.05,0.1$得到不同$\Delta'_{2/1} = -0.13,0.5,3,6$的一组剖面，其中$A=0$时对应的平衡磁场由电流剖面$J_\zeta=J_0(1-r^2)^3$给出，$(m/n)=(2,1)$模有理面位置为$r_s=0.811$处。
- 极向旋转
    $$V_\theta = V_0\cdot r(1-r)/(1-r_s) $$
    这里$V_0$在后边的模拟中一般取3左右的数值大小，我认为这在$\beta$取0.1%时候是合理的，相当于旋转速度为百分之几的alven速度。
- 粘滞系数
    $$\beta=0.001,D_U=10^{-2},\eta=5\times10^{-4}$$
- 边界磁扰动
    $$ \psi|_{r=a} = \psi_a\cdot\psi_{eq}|_{r=a}\exp(im\theta-in\zeta) $$

#### 2. $\Delta'<0$时误差场引起的受迫磁重联(2f-p,2f-p-vl)

不同边界磁扰动下磁岛的演化以及饱和磁岛宽度与边界磁扰动大小的关系：
$$ V_0=3.0, \psi_a=1\times 10^{-5} \sim 1\times 10^{-3} $$
<center class="half">
    <img src="./error field/2f_stable/w_t_psi.png" width="200"/>
    <img src="./error field/2f_stable/sw_psi.png" width="200"/>
</center>

不同旋转大小下磁场演化以及有理面处的极向旋转演化：
$$ \psi_a =1\times 10^{-4}, V_0=3.0,5.0  $$
<center class="half">
    <img src="./error field/2f_stable/w_t.png" width="200"/>
    <img src="./error field/2f_stable/v_t.png" width="200"/>
</center>

不同旋转大小下稳态磁岛宽度以及旋转大小：
$$ \psi_a =1\times 10^{-4}, V_0=-7\sim 7  $$
<center class="half">
    <img src="./error field/2f_stable/sw_v.png" width="200"/>
    <img src="./error field/2f_stable/sv_v.png" width="200"/>
</center>

不同时刻2/1本征模结构和旋转剖面：
$$ \psi_a =1\times 10^{-4}, V_0=3.0 $$
<center class="half">
    <img src="./error field/2f_stable/eig.png" width="200"/>
    <img src="./error field/2f_stable/v_x.png" width="200"/>
</center>

> 极向旋转对于误差场的渗透具有一定的屏蔽作用，边界的磁扰动的渗透会造成有理面处的锁模以及快速激发撕裂模。

--- 
### 五场的结果
- 五场程序目前对于$(1,0)$模式和zonal field并存下的结果不好，不能达到长时间的演化。
- 不考虑$(0,0)$模式的曲率耦合，即不考虑$(1,0)$
- 对于$n=1$的模式只考虑$(2,1)$模
- 湍流为环形ITG激发的湍流
- 初始旋转的添加实际上是$E\times B$流的添加，即径向电场的添加，双流体下需要考虑抗磁性漂移和电漂移的共同作用

#### 1. 平坦的压强剖面(5f-p)
- 两场的ZF并没有单独来解，这里先测试一下五场时两种不同解法下是否有差别，以下是动能的演化以及磁岛宽度的演化：
<center class="half">
    <img src="./error field/5f-0n0t/Ek_zf.png" width="200"/>
    <img src="./error field/5f-0n0t/w_zf.png" width="200"/>
</center>

> 可以看出两种解法没有太大的差别，也说明了zf单独解的正确性

- 单模和多模的区别
<center class="half">
    <img src="./error field/5f-0n0t/Ek_mn.png" width="200"/>
    <img src="./error field/5f-0n0t/w_mn.png" width="200"/>
</center>

> 饱和磁岛宽度略有差别，演化趋势以及渗透阈值都变化不大，可以先用单模计算来找一下参数看一下变化

- 验证5场下磁岛与边界磁扰动的定标关系：
<center class="half">
    <img src="./error field/5f-0n0t/w_t_v.png" width="200"/>
    <img src="./error field/5f-0n0t/sw_psi.png" width="200"/>
</center>

- 对比两场和五场下的磁场宽度以及有理面处旋转的演化：
<center class="half">
    <img src="./error field/5f-0n0t/w_t.png" width="200"/>
    <img src="./error field/5f-0n0t/vy_t.png" width="200"/>
</center>

> 考虑双流体效应之后，误差场更快地渗透并且激发撕裂模，但是撕裂模的饱和幅度比两场的稍小一点。

- 饱和磁岛宽度和旋转的关系（待补充，预计阈值和两场一样关于0对称）

#### 2. 平坦的温度剖面(5f-p-n)
不考虑温度剖面驱动的ITG不稳定性，研究一下抗磁性漂移效应的影响


