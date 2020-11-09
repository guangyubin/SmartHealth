# 2. 心电图处理
## 2.1 读取和展示心电图
data文件下存储了心电图，采用short类型存储，采样率为250Hz。要求用python打开该文件并画出心电图波形。
```
import numpy as np
import  os
import matplotlib.pyplot as plt
import math
print(os.getcwd())
ecg = np.fromfile("../DATA/mitbd/234.dat",dtype = np.short)
fs = 250
gain = 200
plt.subplot(1,2,1)
plt.plot(np.arange(0,fs)/fs,ecg[0:1*fs]/gain)

```