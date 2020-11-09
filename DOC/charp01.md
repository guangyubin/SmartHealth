

# 1. VS Code编程环境搭建
## 1.1 VS Code 下C/C++编程
### 1.1.1 安装
1. 下载安装VS Code。  
2. 解压缩mingw64， 把mingw64/bin加入到环境变量的系统变量的PATH中  
3. 下载CMAKE，并安装    
4.  VS Code 安装插件 C/C++ 、 Cmake tools插件,CMake langage support for Visual Studio Code插件，Markdown All in One插件    

### 1.1.2 第一个C/C++程序
1. 从https://github.com/guangyubin/SmartHealth 下载课件，解压缩到某个目录
2. smartHealth分为ccode，python，doc，data四个文件夹
3. 在ccode目录下有test,ecglib,wfdb四个三个文件夹
4. 在vccode中打开文件夹smartHealth文件夹
5. 在smarthealth文件甲下新建CMakeLists.txt文件，写入如下代码
   ```
    cmake_minimum_required(VERSION 3.0.0)
    project(SMARTHEALTH VERSION 0.1.0)
    add_subdirectory(ccode)

   ```
6. 在ccode文件夹下，新建CMakeLists.txt文件，写入如下代码
7. 在test文件夹下，新建main.cpp文件，写入如下代码
```
#include <iostream>
#include "ecglib.h"

int main(int, char**) {
    std::cout << "Hello, world!\n" ; 
}
```
8. 点击生成，运行。
输出结果
Hello, world!  

### 1.1.3 参考文献：  
1. [mingw配置]( https://code.visualstudio.com/docs/cpp/config-mingw)  
2. [Cmake配置](https://code.visualstudio.com/docs/cpp/CMake-linux)
3. [Cmake使用 ](http://phonzia.github.io/2015/12/CMake)

## 1.2 VS Code 下Python编程
### 1.2.1 安装
1. 安装Python
2. 安装Python插件
3. 修改pip路径
``` 
pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
 ```  
<!--  -->
4. 安装Anaconda，修改Anaconda的环境变量
5. 新建一个虚拟环境  conda create -n myevn --clone base
6. 有可能需要初始化conda ：Conda init 
7. 把activate 路径放在环境变量Path中  
C:\ProgramData\Anaconda3\Scripts  
C:\ProgramData\Anaconda3\condabin\
8. numpy 等可能不能用，pip install --upgrade numpy进行升级  

### 1.2.2 Notebook 的使用
1. ctrl+shift+P 输入python notebook ，新建一个ipynb文件
2. 可以在code和markdown之间进行切换。
3. code的cell可以直接运行，画出来的图可以在工作区显示
4. 在上面可以看到变量
5. 可以导出为xml格式的文件，可以用于打印

#### 1.2.3 使用示范
在notebook下实现下面的代码，导出为xml文件
```
import numpy as np
import matplotlib.pyplot as plt
x=np.arange(-5,15,0.1)
y=x*3
plt.plot(x,y)
plt.show()
```
## 1.3  课后作业

1. 编写makefile文件，把wfdb编译成库
2. 在test/main.c 中调用wfdb，读取ate文件，把R波位置存储成文件
3. 熟悉Markdown语法
4. 在python文件夹下新建charp01_py.ipynb文件，编写代码读取R波位置的文件，计算心率曲线。要求计算每一秒的心率值。
5. 运行charp01_py.ipynb文件，保存为xml或者pdf，在下节课前发送到邮箱guangyubin@qq.com
6. 本作业占10分。