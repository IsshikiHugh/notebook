# [NeRF] Representing Scenes as Neural Radiance Fields for View Synthesis

`3DV` `Reconstruction`

!!! info "文章信息"
    - 文章题目：*NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis* （神经辐射场）
    - 分类：`Computer Science` > `Computer Vision and Pattern Recognition`
    - 作者：[Ben Mildenhall](https://arxiv.org/search/cs?searchtype=author&query=Mildenhall%2C+B), [Pratul P. Srinivasan](https://arxiv.org/search/cs?searchtype=author&query=Srinivasan%2C+P+P), [Matthew Tancik](https://arxiv.org/search/cs?searchtype=author&query=Tancik%2C+M), [Jonathan T. Barron](https://arxiv.org/search/cs?searchtype=author&query=Barron%2C+J+T), [Ravi Ramamoorthi](https://arxiv.org/search/cs?searchtype=author&query=Ramamoorthi%2C+R), [Ren Ng](https://arxiv.org/search/cs?searchtype=author&query=Ng%2C+R)
    - 项目主页：[🔗](https://www.matthewtancik.com/nerf)
    - arXiv：[🔗](https://arxiv.org/abs/2003.08934) 2003.08934
    - 代码：[🔗](https://paperswithcode.com/paper/nerf-representing-scenes-as-neural-radiance)


## 论文笔记

---

### 贡献

1. 将复杂集合形状和材质的连续场景表达为 5D 神经辐射场的方法，将其参数化为基本的 MLP 网络；
2. 基于经典体积渲染技术的可微分渲染程序，我们用它从标准 RGB 图像中优化这些表示。这包括一种分层采样策略，将 MLP 的容量分配给具有可见场景内容的空间；
3. 使用**位置编码(positional encoding)**，将 5D 座标映射到更高维的空间，以实现更高频率的场景内容的表示；

提出的表示方法有如下好处：

- 可以表达复杂真实的几何形状
- 适合使用投影图像做梯度优化
    - [ ] **问题**：什么意思？
- 降低了高分辨率空间图像的存储成本

---

### 方法

使用如下一个“函数”来表示一个静态场景：

$$
\begin{aligned}
	& F_{\Theta}:(\mathrm{x}, \mathrm{d}) \rightarrow (\mathrm{c}, \sigma)
	\\
	& \text{where } \mathrm{x} = (x,y,z), \; \mathrm{d} \text{ is a 3D Cartesian unit vector}, \; \mathrm{c} = (r,g,b), \; \sigma \text{ is the density}.
\end{aligned} 
$$

- 全是 FC；
- 输入是 5D 座标——点的空间座标 $(x,y,z)$ 和视角方向 $(\theta, \phi)$；
- 输出是体积密度以及对应空间位置的与视角有关的辐射（或者说视角有关的 RGB 颜色）；

> 为了保证多视角下观察到的内容具有一致性，做如下约束：
> 
> - 关于密度 $\sigma$ 的函数，仅与点的空间位置 $\mathrm{x} = (x,y,z)$ 有关，而与视角无关；
> - 关于颜色 $\mathrm{c}$ 的函数，与点的空间位置 $\mathrm{x} = (x,y,z)$ 和观察方向 $\mathrm{d}$ 同时有关；
>     - 这大概与 NeRF 在不同视角上光影表现的良好也有较大关系；
> - 实现上是先通过 MLP 用 $\mathrm{x}$ 训练出 $\sigma$ 和一个中间特征向量，再将这个中间向量与 $\mathrm{d}$ 拼接，继续放到 MLP 中；

利用如上“函数”，具体来说操作如下：

- 在场景中匹配穿过的相机光线以生成采样的 3D 点集合；
- 使用这些点以及对应的 2D 视角方向输入到网络中，以得到颜色和密度集合；
- 使用传统的体积渲染技术累积这些颜色和密度以得到 2D 图像；

为了能够让 MLP 表示更高频率的函数，引入了**位置编码(positional encoding)**。

---

此外，关于渲染，使用的是传统的体积渲染方法，累积一条光线上的颜色和密度，得到最终的颜色，所使用的公式如下：

$$
\begin{aligned}
    & \mathrm{C}(\mathrm{r})=
    \int_{t_n}^{t_f} 
    T(t) \cdot \sigma\left(
    	\mathrm{r}(t) 
    \right)  \cdot \mathrm{c} \left(
    	\mathrm{r}(t), \mathrm{d}
    \right) \cdot \mathrm{d}t
\end{aligned},\;\;
\text{where } T(t) = \exp\left(
	-\int_{t_n}^t \sigma\left(\mathrm{r}(s)\right) \; \mathrm{d}s
\right)
$$

对这个式子稍作解释，$t_n$ 和 $t_f$ 分别表示 near 和 far 的光线边界(bound)，光线结果 $C(\mathrm{r})$ 通过累积这两个端点之间的按权累积得到，其权重为 $T(t)$，观察其定义式可发现，随着 $t$ 的增大，$T(t) \rightarrow 0$，即约往后的点约不容易被看到，这也是符合常识的。而累积的对象为 $\sigma(\mathrm{r}(t)) \cdot \mathrm{c}(\mathrm{r}(t), \mathrm{d})$，即密度和颜色的乘积，注意两个参数——密度表征形状特征，仅与空间位置有关；而颜色同时与观察角度有关，这暗含着光影信息。

然而，由于积分的操作性差，所以使用一种离散的抽样累积来实现这件事，将光线均匀划分为 $N$ 个区间，按均匀分布在每个点采样一个点，进行累积，即对于区间 $t_i$：

$$
t_i \sim U \left[ 
    t_n + \frac{i-1}{N} \left( t_f - t_n \right), 
    t_n + \frac{i}{N} \left( t_f - t_n \right)
\right]
$$

对应的颜色计算公式改写为：

$$
\begin{aligned}
\hat{C}(\mathrm{r}) = \sum_{i=1}^{N} T_i \cdot (1 - \exp(-\sigma_i \delta_i)) \cdot \mathrm{c}_i, \;\;
\text{where } T_i = \exp\left(
    -\sum_{j=1}^{i-1} \sigma_j \delta_j
\right) \text{ and } \delta_i = t_{i+1} - t_i
\end{aligned}
$$

其中，$\sigma(\mathrm{r}(t))$ 别替换为 $(1-\exp(-\sigma_i\delta_i))$，在结合了区间长度的情况下又重新将密度映射回了 $[0,1]$。

在之后的策略中，还会对采样规则做进一步优化。

---

至此为止是 NeRF 主要的方法，但是这些方法仍然不足以让它达到最先进的效果，因此这里引入两个改进措施。

1. 使用**位置编码(positional encoding)**来使 MLP 能够支持更高频的图像信息；
2. 使用**结构化的采样(hierarchical sampling)**使能够更有效地对这种高频表示进行采样；

位置编码为一个 $\gamma : \R \rightarrow \R^{2L}$：

$$
\gamma(p) = \left( \sin(2^0 \pi p), \cos(2^0 \pi p), \cdots, \sin(2^{L-1} \pi p), \cos(2^{L-1} \pi p) \right)
$$

将 $\gamma(\cdot)$ 应用于 $\mathrm{x}$ 的三个分量（被标准化到 $[-1,1]$ 上）和 $\mathrm{d}$ 的两个分量上，实现维度提升，以此优化在高频内容上的表现。在文章中提到，$L_\mathrm{x} = 10, L_\mathrm{d} = 4$。

而分层采样，针对的是之前的均匀划分为 $N$ 个区间进行均匀采样。显然，某些“空气”区域和被遮挡的区域对渲染结果并不会有很大影响，而在空间上这些内容可能占了绝大部分（尤其是没有半透明物体的情况下），均匀采样在这种情况下就显得非常低效。

分层采样的大致思路是，首先使用一个粗略(coarse)的网络，利用 $N_c$ 个粗略(coarse)的均匀采样点，通过计算 $\hat{w}_i = normalize\left( T_i \cdot (1 - \exp(-\sigma_i \delta_i)) \right)$ 得到每个点的权重，而这个权重则反应了每一个采样点附近有效点的分布情况，可以看作一个概率密度函数(PDF)。接下来我们在这个分布的基础上再采样得到 $N_f$ 个精细(fine)采样点，与 $N_c$ 个粗略(coarse)点一起放到精细(fine)网络中进行训练。

---

使用的 loss 如下：

$$
\mathcal{L} = \sum_\mathrm{r\in \text{Rays}} \left[ \left\| \hat{C}_c(\mathrm{r}) - C_{g.t.}(\mathrm{r}) \right\|_2^2 + \left\| \hat{C}_f(\mathrm{r}) - C_{g.t.}(\mathrm{r}) \right\|_2^2 \right]
$$

---

??? quote "参考资料"
    - https://zhuanlan.zhihu.com/p/360365941 （笔记 关于体积渲染讲得很清晰）
    - https://zhuanlan.zhihu.com/p/380015071 （笔记）
    - https://wandb.ai/wandb_fc/chinese/reports/NeRF-Neural-Radiance-Fields-View-Synthesis---VmlldzozNDQxNzk （侧重如何使用）
    - https://www.youtube.com/watch?v=nCpGStnayHk（上面那篇文章的介绍视频）
    - https://blog.csdn.net/qq_43620967/article/details/124467551 （翻译）
    - https://blog.csdn.net/weixin_44292547/article/details/126042398 （翻译）
    - https://blog.csdn.net/weixin_44580210/article/details/122284120 （笔记）


社区 Pytorch 复现代码的注释：https://github.com/IsshikiHugh/nerf-pytorch
