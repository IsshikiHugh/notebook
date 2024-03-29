# [4.x] 随机变量的数字特征

## 数学期望

设**离散**随机变量$X$的概率分布率为 $P\{X=x_i\}=p_i,\;\;i=1,2,...$，若级数 $\sum_{i=1}^{+\infty}|x_i|p_i<+\infty$（绝对收敛），则称级数 $\sum_{i=1}^{+\infty}x_ip_i$ 为 $X$ 的**数学期望(Mathematical Expectation)**或**均值(Mean)**，简称为期望，记 $E(X)=\sum_{i=1}^{+\infty}x_ip_i$。<br />
如果 $\sum_{i=1}^{+\infty}=|x_i|p_i=+\infty$ 则称随机变量 $X$ 的数学期望不存在。

设**连续**随机变量 $X$ 的密度函数为 $f(x)$，若 $\int^{+\infty}_{-\infty}|x|f(x)\mathrm{d} x<+\infty$（绝对收敛），则称积分 $\int^{+\infty}_{-\infty}xf(x)\mathrm{d} x$ 为 $X$ 的**数学期望**或**均值**，简称为期望，记 $E(X)=\int^{+\infty}_{-\infty}xf(x)\mathrm{d} x$。<br />
如果 $\int^{+\infty}_{-\infty}|x|f(x)\mathrm{d} x=+\infty$ 则称随机变量 $X$ 的数学期望不存在。

### 常见分布的数学期望

**泊松分布**的数学**期望**<br />
设随机变量 $X$ 服从泊松分布 $P(\lambda)\;(\lambda>0)$，则：<br />
$E(X)=\sum_{k=0}^{+\infty}k・ P\{X=k\}=\sum_{k=0}^{+\infty}k・\frac{\lambda^{k}}{k!}e^{-\lambda}=\lambda\sum_{k=1}^{+\infty}\frac{\lambda^{k-1}}{(k-1)!}e^{-\lambda}=\lambda$<br />
由此式可知，已知泊松分布的数学期望可以确定泊松分布。


**指数分布**的数学**期望**<br />
设随机变量$X$服从指数分布 $E(\lambda)\;(\lambda>0)$，则：<br />
$E(X)=\int_{-\infty}^{+\infty}xf(x)\mathrm{d}x=\int_{0}^{+\infty}x\lambda e^{-\lambda x}\mathrm{d}x=-\int_{0}^{+\infty}x\mathrm{d}e^{-\lambda x}\\=-(xe^{-\lambda x})\big|_{0}^{+\infty}+\int_{0}^{+\infty}e^{-\lambda x}\mathrm{d}x=\frac{1}{\lambda}$<br />
由此式可知，已知指数分布的数学期望可以确定指数分布。


**标准正态分布**的数学**期望**<br />
设随机变量$X$服从标准正态分布 $N(0,1)$，注意到其的密度函数：$\varphi(x)=\frac{1}{\sqrt{2\pi}}e^{-x^2/2},\;x\in \R$ 为偶函数，那么 $x\varphi(x)$ 是奇函数，所以 $E(x)=0$。

### 随机变量函数的数学期望

设 $Y$ 是随机变量 $X$ 的函数：$Y=g(X)$（$g$ 是连续函数）。

$X$ 是离散型随机变量，它的分布律为 $P(X=x_k)=p_k,\;\;k=1,2,...$，若 $\sum_{k=1}^{+\infty}g(x_k)p_k$ 绝对收敛，则有：<br />
$E(Y)=E(g(X))=\sum_{k=1}^{+\infty}g(x_k)p_k$。

$X$ 是连续型随机变量，它的概率密度为 $f(x)$，若 $\int_{-\infty}^{+\infty}g(x)f(x)\mathrm{d}x$ 绝对收敛，则有：<br />
$E(Y)=E(g(X))=\int_{-\infty}^{+\infty}g(x)f(x)\mathrm{d}x$。

### 数学期望的性质

1. 若 $C$ 是常数，则 $E(C) = C$；
2. 设 $X$ 是随机变量，$C$ 是常数，则 $E(C・X)=C・E(X)$；
3. 设 $X,Y$ 是两个随机变量，则 $E(X+Y)=E(X)+E(Y)$；
    - 这一性质可以推广到任意有限个随机变量线性组合的情况：<br />$E(c_0+\sum^n_i{c_iX_i})=c_0+\sum^n_i c_iE(X_i)$；
4. 设 $X,Y$ 是相互独立的随机变量，则 $E(X・Y)=E(X)・E(Y)$，但**逆命题不成立**；
    - 这一性质可以推广到任意有限个相互独立的随机变量：<br />$E(\prod_i^nX_i)=\prod_i^nE(X_i)$；

## 方差与变异系数

设 $X$ 为随机变量，若 $E\{[X-E(X)]^2\}$ 存在，则称其为 $X$ 的**方差**，记作 $Var(X)$ 或 $D(X)$，即 $Var(X)=D(X)=E\{[X-E(X)]^2\}$。<br />
记 $\sigma(X)=\sqrt{(Var(X))}$ 为 $X$ 的**标准差**或**均方差**。

数学期望存在是方差存在的必要但不充分条件。

方差刻画了 $X$ 取值的分散程度：

- 若$X$取值集中，则 $Var(X)$ 较小；
- 若$X$取值分散，则 $Var(X)$ 较大；

而其计算方法可以利用随机变量函数的数学期望，记 $g(X)=(X-E(X))^2$，然后计算 $E(g(X))$。

- 离散型：$Var(X)=E\{[X-E(X)]^2\}=\sum_{i=1}^{+\infty}[x_i-E(X)]^2p_i$；
- 连续型：$Var(X)=E\{[X-E(X)]^2\}=\int_{-\infty}^{+\infty}[x-E(X)]^2f(x)\mathrm dx$；
- 利用期望的性质，可以得到 $Var(X)=E(X^2)-E^2(X)$；

### 常见分布的方差

**泊松分布**的**方差**<br />
$\because E(X^2)=E(X(X-1)+X)=E(X(X-1))+E(X)=\sum_{k=0}^{\infty}k(k-1)\frac{\lambda^ke^{-\lambda}}{k!}+\lambda=\lambda^2+\lambda\\
\therefore Var(X)=E(X^2)+E^2(X)=\lambda$


**指数分布**的**方差**<br />
$\because E(X^2)=\int_{-\infty}^{+\infty}x^2f(x)\mathrm dx=\int_0^{+\infty}x^2\lambda e^{-\lambda x}\mathrm d x=-x^2e^{-\lambda x}\big|^{+\infty}_0+\int^{+\infty}_{0}2xe^{-\lambda x}\mathrm dx=\frac{2}{\lambda^2}\\
\therefore Var(X)=E(X^2)-E^2(X)=\frac{1}{\lambda^2}$

### 方差的性质

1. 若 $C$ 是常数，则 $Var(C) = 0$；
2. 设 $X$ 是随机变量，$C$ 是常数，则 $Var(C・X)=C^2・Var(X)$；
3. 设 $X,Y$ 是两个随机变量，则 $Var(X\pm Y)=Var(X)+Var(Y)\pm2E\{[X-E(X)][Y-E(Y)]\}=Var(X)+Var(Y)\pm 2Cov(X,Y)$；
    - 这一性质可以推广到任意有限个随机变量之和的情况：$Var(\sum_{i=1}^{n}X_i)=\sum_{i=1}^{n}Var(X_i)+2\sum_{1\leq i<j\leq n}Cov(X_i,X_j)$；
    - 特别地，如果 $X,Y$ 相互独立，则 $Var(X\pm Y)=Var(X)+Var(Y)$；
    - 进一步地，如果 $X_i\;(i=1,2,...,n)$ 彼此独立，则 $Var(c_0+\sum_{i=1}^{n}c_iX_i)=\sum_{i=1}^{n}c_i^2Var(X_i)$
4. $Var(X)\leq E[(X-c)^2]$，并且当且仅当 $E(X)=c$ 时等号成立；
5. $Var(X)=0\;\;\Leftrightarrow\;\;P(X=c)=1\;\;and\;\;c=E(X)$；

### 变异系数

**变异系数**(Coefficient of Variation)又叫“**标准差率**”，是衡量资料中各观测值变异程度的一个数字特征。它可以消除单位或平均数不同对两个或多个资料变异程度比较的影响。

设随机变量 $X$ 具有数学期望 $E(X)=\mu$，方差 $Var(X)={\sigma}^2 \neq 0$，则称 $C_v = \frac{\sigma}{\mu}$ 为 $X$ 的变异系数。

## 协方差与相关系数

随机变量 $X,Y$ 的**协方差** $Cov(X,Y)=E\{[X-E(X)][Y-E(Y)]\}=E(XY)-E(X)E(Y)$

随机变量 $X,Y$ 的**相关系数** $\rho _{_{XY}}=\frac{Cov(X,Y)}{\sqrt{Var(X)Var(Y)}}=Cov(X^*,Y^*)$

### 协方差的性质

1. $Cov(X,Y)=Cov(Y,X)$；
2. $Cov(X,Y)=E(XY)-E(X)E(Y)$；
3. $Cov(aX,bY)=abCov(X,Y)\;,\;\;a,b\in\R$；
4. $Cov(X+Y,Z)=Cov(X,Z)+Cov(Y,Z)$；
5. $Cov(X,X)=Var(X)$；
6. $Cov(c,Y)=E(cY)-E(c)E(Y)=0\;,\;\;c\in\R$；
7. $Cov(X+Y,X-Y)=Cov(X,X)-Cov(Y,Y)=Var(X)-Var(Y)$；
8. $Cov(X^*,Y^*)=Cov(\frac{X-E(X)}{\sqrt{Var(X)}},\frac{Y-E(Y)}{\sqrt{Var(Y)}})=\frac{Cov(X,Y)}{\sqrt{Var(X)}\sqrt{Var(Y)}}=\rho_{_{XY}}$；
9. $Cov(aX+bY,cX+dY)=acVar(X)+bdVar(Y)+(ad+bc)Cov(X,Y)$；

### 相关系数的性质

1. $|\rho_{_{XY}}|\leq 1$；
2. $|\rho_{_{XY}}|=1 \;\; \Leftrightarrow \;\; \exists a,b\in \R,\;s.t.\;P(Y=a+bX)=1$；
    - $\rho_{_{XY}}=+1$时，$b>0$；
    - $\rho_{_{XY}}=-1$时，$b<0$；
3. 上述两条性质可以合并写成：<br />
   当 $Var(X)Var(Y)\neq 0$ 时，有 $Cov^2(X,Y)\leq Var(X)Var(Y)$，其中等号当且仅当 $X$ 与 $Y$ 之间有严格的线性关系，即存在常数 $a,b$，使 $P(Y=a+bX)=1$；

相关系数 $\rho_{_{XY}}$ 是用来表征 $X,Y$ 之间**线性关系紧密程度**的量。此外，考虑以 $X$ 的线性函数 $a+bX$ 来近似表示 $Y$，均方误差 $e(a,b)=E\{ [Y-(a+bX)]^2 \}$ 也可以用来衡量 $X,Y$ 之间线性关系紧密程度。

- $|\rho_{_{XY}}|$ 比较大时，均方误差较小，表示 $X,Y$ 线性关系的程度好；
- $|\rho_{_{XY}}|=1$ 时，均方误差为 $0$，表示 $X,Y$ 之间以概率 $1$ 存在线性关系；
- $|\rho_{_{XY}}|$ 比较小时，均方误差较大，表明 $X,Y$ 线性关系的程度差；
- $\rho_{_{XY}}>0$ 时，$X,Y$ 正相关；
- $\rho_{_{XY}}<0$ 时，$X,Y$ 负相关；
- $\rho_{_{XY}}=0$ 时，称 $X,Y$ **不相关**或**零相关**（仅仅对于线性关系来说，与**独立**的含义不同）；
    - $\rho_{_{XY}}=0$ 有如下等价条件：<br />
    $Cov(X,Y)=0$；<br />
    $E(XY)=E(X)E(Y)$；<br />
    $Var(X\pm Y)=Var(X)+Var(Y)$；

注意区分独立性和相关性：

- $X,Y$ 互相独立 $\;\;\Rightarrow \;\;$ $X,Y$ 不相关；
- $X,Y$ 不独立 $\;\;\Leftarrow \;\;$ $X,Y$ 相关；

## 多元随机变量的数字特征

设 $n$ 元随机变量 $X=(X_1,X_2,...,X_n)^T$，若每一个分量的数学期望都存在，则称 $E(X)=(E(X_1),E(X_2),...,E(X_n))^T$ 为 $n$ **元随机变量** $X$ **的数学期望（向量）**。

设 $n$ 维随机变量 $\vec{X}=(X_1,X_2,...,X_n)^T$，$Cov(X_i,X_j)\;\;(i,j=1,2,...,n)$ 都存在，则：<br />

$$
\begin{bmatrix} 
Var(X_1) & Cov(X_1,X_2) & ... & Cov(X_1,X_n)\\ 
Cov(X_2,X_1) & Var(X_2) & ... & Cov(X_2,X_n)\\
... & ... & ...  & ... \\
Cov(X_n,X_1) & Cov(X_n,X_2) & ... & Var(X_n)
\end{bmatrix}
$$

称之为 $\vec{X}$ 的**协方差矩阵**，它是一个**对称**的**非负定矩阵**。

### n&thinsp;**维正态变量**重要**性质**

1. $n$ 维正态变量 $(X_1,X_2,...,X_n)^T$ 中的任意子向量 $(X_{i_1},X_{i_2},...,X_{i_k})^T$，$1\leq k\leq n$ 也服从 $k$ 元正态分布；
    - 特别地，每一个分量 $X_i,i=1,2,...,n$ 都是正态变量；
    - 反之，若每个 $X_i$ 都是正态变量，且相互独立，则 $(X_1,X_2,...,X_n)$ 是 $n$ 维正态变量；
2. $n$ 维随机变量 $(X_1,X_2,...,X_n)$ 服从 $n$ 维正态分布的**充要条件**是 $X_1,X_2,...,X_n$ 的任意线性组合 $\sum_{i}^{n} l_iX_i$ 服从一维正态分布，其中 $l_1,l_2,...,l_n$ 不全为 $0$；
3. 若 $(X_1,X_2,...,X_n)$ 服从 $n$ 维正态分布，设 $Y_1,Y_2,...,Y_k$ 是 $X_i$ 的线型函数，则 $(Y_1,Y_2,...,Y_k)$ 也服从多维正态分布，这一性质被称为正态变量的线性变换不变性；
4. 若 $(X_1,X_2,...,X_n)$ 服从 $n$维正态分布，则 $X_1,X_2,...,X_n$ 互相独立的**充要条件**是 $X_i$ 两两不相关，也等价于协方差矩阵为对角矩阵；

















