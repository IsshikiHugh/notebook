# [3.x] 多元随机变量及其分布

**联合分布律（Joint Mass Function）**<br />**边际分布律（Marginal Mass Function）**

- 联合分布律的行/列求和
- $P(X=x_i)=P(X=x_1,\bigcup_{j=1}^{\infty}(Y=y_j))=\sum_{j=1}^{\infty}p_{ij}:=p_{i·}$；
- $P(
Y=y_j)=P(\bigcup_{j=1}^{\infty}(X=x_i),Y=y_j)=\sum_{i=1}^{\infty}p_{ij}:=p_{·j}$；

**条件分布律（Conditional Mass Function）**

- $P\{X=x_i|Y=y_j\}=\frac{P(X=x_i,Y=y_j)}{P(Y=y_j)}=\frac{p_{ij}}{p_{·j}}\;\;i,j=1,2,...$；
- $P\{X<x|Y<y\}=\frac{P\{X<x,Y<y\}}{P\{Y<y\}}$然后根据联合分布律和边际分布律读表计算；


$F(x,y)=P\{X\leq x,Y\leq y\}$为$(X,Y)$的**联合概率分布函数**，简称**联合分布函数（Joint Distribution Function）**，其具有如下性质：

1. **固定**其中一个变量，则该二元函数关于另外一个变量单调**不减**；
2. $0\leq F(x,y)\leq 1$，且$F(x,-\infty)=F(-\infty,y)=F(-\infty,-\infty)=0\;,\;F(+\infty,+\infty)=1$；
3. $F(x,y)$关于$x$和$y$**分别**右连续（离散）；
4. $x_1<x_2\;,\;y_1<y_2$时，有：

$P\{x_1<X\leq x_2\;,\;y_1<Y\leq y_2\}=F(x_2,y_2)-F(x_1,y_2)-F(x_2,y_1)+F(x_1,y_1)\geq0$

- Tips：考虑几何意义！

**边际分布函数（Marginal Distribution Function）**<br />$F_X(x)=P\{X\leq x\}=P\{X\leq x ,Y<+\infty\}=F(x,+\infty)=\int_{-\infty}^{+\infty}f(x,y)dy$为$X$关于联合分布函数$F(x,y)$的**边际分布函数**。

- 对$y$来说同理

**条件分布函数（Conditional Distribution Function）**<br />$F_{Y|X}(y|x_i)=P\{Y\leq y | X = x_i\}=\lim_{\delta\rarr0^+}P\{Y\leq y|x<X\leq x+\delta \}$为$X=x_i$条件下$Y$的**条件概率分布函数**。


设二元随机变量$(X,Y)$的联合分布函数为$F(x,y)$，若存在二元函数$f(x,y)\geq0$，则对于任意的实数$x$，$y$有$F(x,y)=\int_{-\infty}^x\int_{-\infty}^yf(u,v)\mathrm{d}u\mathrm{d}v$，则称$(X,Y)$为**二元连续型随即变量（Bivariate Continuous Random Variable）**，称$f(x,y)$为$(X,Y)$的**联合概率密度函数（Joint Probability Density Function）**，简称为**联合密度函数**。 其具有以下性质：

1. $f(x,y)\geq 0$；
2. $F(x,y)=\int_{-\infty}^x\int_{-\infty}^yf(u,v)\mathrm{d}u\mathrm{d}v=F(+\infty,+\infty)=1$；
3. 在$f(x,y)$的连续点上有$\frac{
\partial^2F(x,y)
}{
\partial x\partial y
}=f(x,y)$；
4. $(X,Y)$落入$xOy$平面任意区域$D$的概率为：$P\{(X,Y)\in D\}=\iint \limits_{D} f(x,y)\mathrm{d}x\mathrm{d}y$；
   - 由于其几何意义为落在以$D$为底，以曲面$z=f(x,y)$为顶面的柱体体积，所以当$D$面积为$0$时概率为$0$：
   - `eg`：$P(X=1,Y=1)=0$，$P(X+Y=1)=0$，$P(X^2+Y^2=1)=0$；

（二元）**边际概率密度函数（Marginal Probability Density Function）**，简称**边际密度函数**。<br />$F_X(x)=\int_{-\infty}^{+\infty}f(x,y)dy$

- 在给定$\{X=x\}$的条件下，$Y$的条件概率密度函数（Conditional Prob-ability Density Function）称为条件密度函数，为$f_{Y|X}(y|x)=\int^y_{-\infty}\frac{f(x,v)}{f_X(x)}\mathrm{d}v\;,\;\;f_X(x)\not= 0$；
- $Y$同理。


**均匀分布**<br />如果二元随机变量$(X,Y)$在二维有界区间$D$上取值，且具有联合密度函数$f(x,y)=\left\{
\begin{aligned}
&\frac{1}{\text{D的面积}},&(x,y)\in D,\\
&0,&\text{其他}.
\end{aligned}

\right.$，则称$(X,Y)$服从$D$上的**均匀分布**。<br />得到：$P\{(X,Y)\in D\}=\frac{D_1\text{的面积}}{D\text{的面积}}\;,\;\;\text{且}D_1\subset  D$。


**正态分布**<br />如果二元随机变量$(X,Y)$具有联合密度函数$f(x,y)=\frac{1}{2\pi\sigma_1\sigma_
2\sqrt{1-\rho^2}}\exp\{\frac{-1}{2(1-\rho^2)}[\frac{(x-\mu)^2}{\sigma_1^2}-2\rho\frac{(x-\mu_1)(y-\mu_2)}{\sigma_1\sigma_2}+\frac{(y-\mu_2)^2}{\sigma_2^2}]\}$，且有$|\mu_1|<+\infty,|\mu_2|<+\infty,\sigma_1>0,\sigma_2>0,|\rho|<1$，则称$(X,Y)$服从参数为$(\mu_1,\mu_2,\sigma_1^2,\sigma_2^2,\rho)$的**二元正态分布（Bivariate Normal Distribution）**，记做$(X,Y)\sim N(\mu_1,\mu_2,\sigma_1^2,\sigma_2^2,\rho)$。

- 二维正态分布的两个边际分布都是**对应参数的一维正态分布**，与$\rho$无关。


**随机变量的独立性**<br />如果对于任意的两个实数集合$D_1,D_2$，有$P\{X\in D_1,Y\in D_2\}=P\{X\in D_1\}·P\{Y\in D_2\}$，则称随机变量$X,Y$**相互独立**，即$X,Y$**独立**。<br />即同时有$P\{X\leq x,Y\leq y\}=P\{X\leq x\}·P\{Y\leq y\}$，即$F(x,y)=F_x(x)·F_y(y)$时，$X,Y$独立。


---


**卷积公式**<br />当$X$和$Y$相互独立时，$Z=X+Y$的条件下：

1. $F_Z(z) = \iint \limits_{x+y\leq z}f(x,y)\mathrm{d}x\mathrm{d}y=\int_{-\infty}^{+\infty}[\int_{-\infty}^{z-x}f(x,u-x)\mathrm{d}y]\mathrm{d}x$

$\\
= \int_{-\infty}^{+\infty}[\int_{-\infty}^{z}f(x,u-x)\mathrm{d}u]\mathrm{d}x=\int_{-\infty}^{z}[\int_{-\infty}^{+\infty}f(x,u-x)\mathrm{d}x]\mathrm{d}u$ <br />$\\=\int_{-\infty}^{z}f_Z(u)\mathrm{d}y$；

2. 其密度函数公式称为**卷积公式**：$f_X*f_Y=\int_{-\infty}^{+\infty}f_X(x)f_Y(z-x)\mathrm{d}x=\int_{-\infty}^{+\infty}f_X(z-y)f_Y(y)\mathrm{d}y$；


$M=max(X,Y)\;\;and\;\;N=min(X,Y)$的分布

- $F_{max}(z)=P(M\leq z)=P(X\leq z,Y\leq z)\xlongequal{\text{X,Y独立}}P(X\leq z)P(Y\leq z)=F_X(z)F_Y(z)$；
- $F_{min}(z)=P(N\leq z)=1-P(N>z)=1-P(X>z,Y>z)$

$\xlongequal{\text{X,Y独立}}1-P(X>z)P(Y>z)=1-(1-F_X(z))(1-F_Y(z))$；

