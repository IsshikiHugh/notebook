# [4.x] 随机变量的数字特征

设**离散**随机变量$X$的概率分布率为$P\{X=x_i\}=p_i,\;\;i=1,2,...$，若级数$\sum_{i=1}^{+\infty}=|x_i|p_i<+\infty$（绝对收敛），则称级数$\sum_{i=1}^{+\infty}x_ip_i$为$X$的**数学期望（Mathematical Expectation）**或**均值（Mean）**，简称为期望，记$E(X)=\sum_{i=1}^{+\infty}x_ip_i$。<br />如果$\sum_{i=1}^{+\infty}=|x_i|p_i=+\infty$则称随机变量$X$的数学期望不存在。

设**连续**随机变量$X$的密度函数为$f(x)$，若$\int^{+\infty}_{-\infty}|x|f(x)\mathrm{d} x<+\infty$，则称积分$\int^{+\infty}_{-\infty}xf(x)\mathrm{d} x$为$X$的**数学期望**或**均值，**简称为期望，记$E(X)=\int^{+\infty}_{-\infty}xf(x)\mathrm{d} x$。<br />如果$\int^{+\infty}_{-\infty}|x|f(x)\mathrm{d} x=+\infty$则称随机变量$X$的数学期望不存在。


**泊松分布**的数学**期望**<br />设随机变量$X$服从泊松分布$P(\lambda)\;(\lambda>0)$，则：<br />$E(X)=\sum_{k=0}^{+\infty}k・ P\{X=k\}=\sum_{k=0}^{+\infty}k・\frac{\lambda^{k}}{k!}e^{-\lambda}=\lambda\sum_{k=1}^{+\infty}\frac{\lambda^{k-1}}{(k-1)!}e^{-\lambda}=\lambda$
由此式可知，已知泊松分布的数学期望可以确定泊松分布。


**指数分布**的数学**期望**<br />设随机变量$X$服从指数分布$E(\lambda)\;(\lambda>0)$，则：<br />$E(X)=\int_{-\infty}^{+\infty}xf(x)\mathrm{d}x=\int_{0}^{+\infty}x\lambda e^{-\lambda x}\mathrm{d}x=-\int_{0}^{+\infty}x\mathrm{d}e^{-\lambda x}\\=-(xe^{-\lambda x})\big|_{0}^{+\infty}+\int_{0}^{+\infty}e^{-\lambda x}\mathrm{d}x=\frac{1}{\lambda}$
由此式可知，已知指数分布的数学期望可以确定指数分布。


**标准正态分布**的数学**期望**<br />设随机变量$X$服从标准正态分布$N(0,1)$，注意到其的密度函数：$\varphi(x)=\frac{1}{\sqrt{2\pi}}e^{-x^2/2},\;x\in \R$为偶函数，那么$x\varphi(x)$是奇函数，所以$E(x)=0$


对于随机变量函数，只需要将定义中$x_i$换为$g(x_i)$即可，当然需要保证期望存在。<br />而除了定义计算，也有一些性质可以简化计算。


**数学期望的性质**：

1. 若$C$是常数，则$E(C) = C$；
2. 设$X$是随机变量，$C$是常数，则$E(C・X)=C・E(X)$；
3. 设$X,Y$是两个随机变量，则$E(X+Y)=E(X)+E(Y)$；
   - 这一性质可以推广到任意有限个随机变量线性组合的情况：$E(\sum^n_i{c_i・X_i})=\sum^n_i c_i・E(X_i)$；
- 上述三条合并起来就是$E(aX+bY+c)=aE(X)+bE(Y)+c$；
4. 设$X,Y$是相互独立的随机变量，则$E(X・Y)=E(X)・E(Y)$，但**逆命题不成立**；
   - 这一性质可以推广到任意有限个随机变量：$E(\prod_i^nX_i)=\prod_i^nE(X_i)$；


---


设$X$为随机变量，若$E\{[X-E(X)]^2\}$存在，则称其为$X$的**方差**，记作$Var(X)$或$D(X)$，即$Var(X)=E\{[X-E(X)]^2\}$。<br />记$\delta(X)=\sqrt{(Var(X))}$为$X$的**标准差**或**均方差**。

数学期望存在是方差存在的必要但不充分存在。

方差刻画了$X$取值的分散程度：

- 若$X$取值集中，则$Var(X)$较小；
- 若$X$取值分散，则$Var(X)$较大；

而其计算方法可以利用期望的性质，记$g(X)=(X-E(X))^2$，然后计算$E(g(X))$。<br />具体的：

- 离散型：$Var(X)=E\{[X-E(X)]^2\}=\sum_{i=1}^{+\infty}[x_i-E(X)]^2p_i$；
- 连续型：$Var(X)=E\{[X-E(X)]^2\}=\int_{-\infty}^{+\infty}[x-E(X)]^2f(x)\mathrm dx$；
- 而利用期望的性质，可以得到$Var(X)=E(X^2)-E^2(X)$；


**泊松分布**的**方差**<br />$\because E(X^2)=E(X(X-1)+X)=E(X(X-1))+E(X)=\sum_{k=0}^{\infty}k(k-1)\frac{\lambda^ke^{-\lambda}}{k!}+\lambda=\lambda^2+\lambda\\
\therefore Var(X)=E(X^2)+E^2(X)=\lambda$


**指数分布**的**方差**<br />$\because E(X^2)=\int_{-\infty}^{+\infty}x^2f(x)\mathrm dx=\int_0^{+\infty}x^2\lambda e^{-\lambda x}\mathrm d x=-x^2e^{-\lambda x}\big|^{+\infty}_0+\int^{+\infty}_{0}2xe^{-\lambda x}\mathrm dx=\frac{2}{\lambda^2}\\
\therefore Var(X)=E(X^2)-E^2(X)=\frac{1}{\lambda^2}$


**方差的性质**：

1. 若$C$是常数，则$Var(C) = 0$；
2. 设$X$是随机变量，$C$是常数，则$Var(C・X)=C^2・Var(X)$；
3. 设$X,Y$是两个随机变量，则$Var(X\pm Y)=Var(X)+Var(Y)\pm2E\{[X-E(X)][Y-E(Y)]\}\\=Var(X)+Var(Y)\pm 2Cov(X,Y)$；
   1. 特别的，如果$X,Y$相互独立，则$Var(X\pm Y)=Var(X)+Var(Y)$；
   2. 进一步的，如果$X_i\;(i=1,2,...,n)$彼此独立，则$Var(c_1X_1\pm c_2X_2\pm...\pm c_nX_n)=c_1^2Var(X_1)+c_2^2Var(X_2)+...+c_n^2Var(X_n)$
- 上述三条合并起来就是$Var(aX+bY+c)=a^2Var(X)+b^2Var(Y)$；
4. $Var(X)\leq E((X-c)^2)$，并且当且仅当$E(X)=c$时等号成立；
5. $Var(X)=0 \;\;\;\;\;\Leftrightarrow \;\;\;\;\;P(X=c)=1 \;\;\;and\;\;\;c=E(X)$；


**变异系数**又叫“**标准差率**”，是衡量资料中各观测值变异程度的另外一个数字特征。<br />**变异系数**$Cv(X)=\frac{\sqrt{Var(X)}}{E(X)}$同样描述离散程度，它可以消除单位或平均数不同对两个或多个资料变异程度比较的影响。


---


随机变量$X,Y$的**协方差**$Cov(X,Y)=E\{[X-E(X)][Y-E(Y)]\}=E(XY)-E(X)E(Y)$


随机变量$X,Y$的**相关系数**$\rho _{_{XY}}=\frac{Cov(X,Y)}{\sqrt{Var(X)Var(Y)}}$


**协方差的性质**：

1. $Cov(X,Y)=Cov(Y,X)$；
2. $Cov(X,Y)=E(XY)-E(X)E(Y)$；
3. $Cov(aX,bY)=abCov(X,Y)\;,\;\;a,b\in\R$；
4. $Cov(X+Y,Z)=Cov(X,Z)+Cov(Y,Z)$；
5. $Cov(X,X)=Var(X)$；
6. $Cov(c,Y)=E(cY)-E(c)E(Y)=0\;,\;\;c\in\R$；
7. $Cov(X+Y,X-Y)=Cov(X,X)-Cov(Y,Y)=Var(X)-Var(Y)$；
8. $Cov(X^*,Y^*)=Cov(\frac{X-E(X)}{\sqrt{Var(X)}},\frac{Y-E(Y)}{\sqrt{Var(Y)}})=\frac{Cov(X,Y)}{\sqrt{Var(X)}\sqrt{Var(Y)}}=\rho_{_{XY}}$；
9. $Cov(aX+bY,cX+dY)=acVar(X)+bdVar(Y)+(ad+bc)Cov(X,Y)$；
10. $D(aX+bY)=a^2Var(X)+b^2Var(Y)+2abCov(X,Y)$；


**相关系数的性质**

1. $|\rho_{_{XY}}|\leq 1$；
2. $|\rho_{_{XY}}|=1 \;\;\; \Leftrightarrow \;\;\; \exists a,b\in \R,\;s.t.\;P(Y=a+bX)=1|$；
   1. $\rho_{_{XY}}=1$时，$b>0$；
   2. $\rho_{_{XY}}=-1$时，$b<0$；


相关系数$\rho_{_{XY}}$是用来表征$X,Y$之间**线性关系紧密程度**的量：

- $|\rho_{_{XY}}|$比较大时，误差较小，表示$X,Y$线性关系的程度好；
- $|\rho_{_{XY}}|=1$时，误差为$0$，表示$X,Y$之间以概率$1$存在线性关系；
- $|\rho_{_{XY}}|$比较小时，误差较大，表明$X,Y$线性关系的程度差；
- $\rho_{_{XY}}>0$时，$X,Y$正相关；
- $\rho_{_{XY}}<0$时，$X,Y$负相关；
- $\rho_{_{XY}}=0$时，称$X,Y$**不相关**或**零相关**（仅仅对于线性关系来说，与**独立**的含义不同）；
   - 此时有：
   1. $Cov(X,Y)=0$；
   2. $E(XY)=E(X)E(Y)$；
   3. $Var(X\pm Y)=Var(X)+Var(Y)$；
   - 于是有结论：

$X,Y\text{互相独立} \;\; \Rightarrow \;\; X,Y\text{不相关}\\
X,Y\text{不独立}\;\;\Leftarrow \;\;X,Y\text{相关}$


---


**多元随机变量的数字特征**<br />设$n$元随机变量$X=(X_1,X_2,...,X_n)^T$，若每一个分量的数学期望都存在，则称$E(X)=(E(X_1),E(X_2),...,E(X_n))^T$为$n$**元随机变量**$X$**的数学期望（向量）**。


设$n$维随机变量$\vec{X}=(X_1,X_2,...,X_n)^T$，$Cov(X_i,X_j)\;\;(i,j=1,2,...,n)$都存在，则：<br />$\begin{bmatrix} 
Var(X_1) & Cov(X_1,X_2) & ... & Cov(X_1,X_n)\\ 
Cov(X_2,X_1) & Var(X_2) & ... & Cov(X_2,X_n)\\
... & ... & ...  & ... \\
Cov(X_n,X_1) & Cov(X_n,X_2) & ... & Var(X_n)
\end{bmatrix}$
称之为$\vec{X}$的**协方差矩阵**。<br />它是一个**对称**的**非负定矩阵**。


$n$**维正态变量**重要**性质**

1. $n$维正态变量$(X_1,X_2,...,X_n)$的每一个分量$X_i$都是正态变量；
- 反之，如果$X_i$都是正态变量，且相互独立，则$(X_1,X_2,...,X_n)$是$n$维正态变量；
2. $n$维随机变量$(X_1,X_2,...,X_n)$服从$n$维正态分布的**充要条件**设不全为$0$的$l_i$常数，均有$\sum_i^n l_iX_i$服从一维正态分布；
3. 若$(X_1,X_2,...,X_n)$服从$n$维正态分布，设$Y_1,Y_2,...,Y_k$是$X_i$的线型函数，则$(Y_1,Y_2,...,Y_k)$也服从多维正态分布；
4. 若$(X_1,X_2,...,X_n)$服从$n$维正态分布，则$X_i$互相独立的**充要条件**是$X_i$两两不相关；

















