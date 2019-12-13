import numpy as np
import matplotlib.pyplot as plt


fig=plt.figure(figsize=(12,6))

data = np.genfromtxt("./rank_xy.txt")
data = data.reshape(-1,7)

ax1 = plt.subplot(121)
ax1.set_xticks([ 1, np.max( (data[:,3]+data[:,4]-1),axis=0) ])
ax1.set_yticks([ 1, np.max( (data[:,5]+data[:,6]-1),axis=0) ])

for i in range(0,data.shape[0]):
    rank = data[i,0]
    c_rank0 = data[i,1]; c_rank1 = data[i,2]
    xs = data[i,3]; xp = data[i,4]; xd = xs+xp-1
    ys = data[i,5]; yp = data[i,6]; yd = ys+yp-1

    ax1.broken_barh([(xs,xp-1)], (ys,yp-1), facecolors='navajowhite')
    ax1.text( xs+(xp-1)/2, ys+(yp-1)/2, "rank=%d \n (%d,%d)"%(rank,c_rank0,c_rank1), ha="center", va="center", color="r" )
    # ax.set_xticks( list(ax.get_xticks() )+  [xs,xd] )
    # ax.set_yticks( list(ax.get_yticks() )+  [ys,yd] )

ax1.set_xlabel('$r$',size=16)
ax1.set_ylabel('$\\theta$',size=16)
ax1.set_title("real space")

data = np.genfromtxt("./rank_yz.txt")
data = data.reshape(-1,7)

ax2 = plt.subplot(122)
ax2.set_xticks([ 1, np.max( (data[:,3]+data[:,4]-1),axis=0) ])
ax2.set_yticks([ 1, np.max( (data[:,5]+data[:,6]-1),axis=0) ])

for i in range(0,data.shape[0]):
    rank = data[i,0]
    c_rank0 = data[i,1]; c_rank1 = data[i,2]
    xs = data[i,3]; xp = data[i,4]; xd = xs+xp-1
    ys = data[i,5]; yp = data[i,6]; yd = ys+yp-1

    ax2.broken_barh([(xs,xp-1)], (ys,yp-1), facecolors='navajowhite')
    ax2.text( xs+(xp-1)/2, ys+(yp-1)/2, "rank=%d \n (%d,%d)"%(rank,c_rank0,c_rank1), ha="center", va="center", color="r" )

ax2.set_xlabel('$m$',size=16)
ax2.set_ylabel('$n$',size=16)
ax2.set_title("spectral space")

plt.show()