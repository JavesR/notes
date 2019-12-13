import numpy as np
import matplotlib.pyplot as plt

Ny = 128

fig=plt.figure(figsize=(6,6))
ax = plt.subplot(111, projection='polar')

data = np.genfromtxt("./rank_xy.txt")
data = data.reshape(-1,7)

for i in range(0,data.shape[0]):
    rank = data[i,0]
    c_rank0 = data[i,1]; c_rank1 = data[i,2]
    xs = data[i,3]; xp = data[i,4]; xd = xs+xp-1
    ys = data[i,5]; yp = data[i,6]; yd = ys+yp-1


    ax.bar( (ys+yd)/2/Ny*2.0*np.pi, xp-1, width=(yp-1)/Ny*2.0*np.pi, bottom=xs, color='navajowhite' )
    ax.text( (ys+yd)/2/Ny*2.0*np.pi, xs+(xp-1)/2, "rank=%d \n (%d,%d)"%(rank,c_rank0,c_rank1), ha="center", va="center", color="r" )


ax.set_xticks([])
ax.set_yticks([])

ax.set_ylim(0,35)

plt.show()
