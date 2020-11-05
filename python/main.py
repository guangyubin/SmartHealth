import numpy as np
import os
import matplotlib.pyplot as plt
#%%
print('hello')
print('1')
x=np.arange(-5,15,0.1)
y=x*3
plt.plot(x,y)
plt.savefig('../doc/pic/test.png')
plt.show()