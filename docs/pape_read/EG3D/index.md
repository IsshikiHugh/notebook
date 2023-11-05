# [EG3D] Efficient Geometry-aware 3D Generative Adversarial Networks

`3DV` `Generation`

!!! info "文章信息"
    - 文章题目：*EG3D: Efficient Geometry-aware 3D Generative Adversarial Networks*
    - 作者：
        <a href="https://ericryanchan.github.io" target="_blank">Eric Ryan Chan</a> <sup> * 1, 2 </sup>, 
        <a href="https://connorzlin.com" target="_blank">Connor Zhizhen Lin</a> <sup> * 1 </sup>, 
        <a href="https://matthew-a-chan.github.io" target="_blank">Matthew Aaron Chan</a> <sup> * 1 </sup>, 
        <a href="https://luminohope.org/" target="_blank">Koki Nagano</a> <sup> * 2 </sup>, 
        <a href="https://cs.stanford.edu/~bxpan/" target="_blank">Boxiao Pan</a> <sup> 1 </sup>, 
        <a href="https://research.nvidia.com/person/shalini-gupta" target="_blank">Shalini De Mello</a><sup> 2 </sup>, 
        <a href="https://oraziogallo.github.io/" target="_blank">Orazio Gallo</a> <sup> 2 </sup>, 
        <a href="https://geometry.stanford.edu/member/guibas/" target="_blank">Leonidas Guibas</a> <sup> 1 </sup>, 
        <a href="https://research.nvidia.com/person/jonathan-tremblay" target="_blank">Jonathan Tremblay</a> <sup> 2 </sup>, 
        <a href="https://www.samehkhamis.com/" target="_blank">Sameh Khamis</a> <sup> 2 </sup>, 
        <a href="https://research.nvidia.com/person/tero-karras" target="_blank">Tero Karras</a> <sup> 2 </sup>, 
        <a href="https://stanford.edu/~gordonwz/" target="_blank">Gordon Wetzstein</a> <sup> 1 </sup>
    - 项目主页：[🔗](https://nvlabs.github.io/eg3d/)
    - arXiv：[🔗](https://arxiv.org/abs/2112.07945) 2112.07945
    - 代码：[🔗](https://github.com/NVlabs/eg3d)


## 论文笔记

---

### Tri-plane hybrid 3D representation

讨论一下 NeRF 和 Tri-plane hybrid 3D representation 的关系。

NeRF 按 ray 体积渲染过程中采样的点从训练好的 MLP 里拿；而 EG3D 则是得到三个投影方向上的特征向量，每一个投影方向上的特征向量都是沿着消失的那个维度聚合得到的，可以看作是拿到了空间中三条正交的线的特征，而之后用一个轻量 MLP 去从这三个特征向量里把这个点的颜色密度拿出来，类似于求三条线的交点。

相比于 NeRF 将数据参数化，每次查询都需要走一边 MLP，EG3D Sec3 则显示的将特征存在三个二维表里，每次查询只需要 O(1) 的开销，因此效率主要取决于后面那个轻量 MLP，以此来实现效率上的提高。

而实现效果上，我胡猜 EG3D 的方法好的原因：

1. 由于使用了座标投影，所以相对于 NeRF 的参数表达，EG3D 对于某个点的空间位置具有更强的约束，因而可能对细节的把控约束更直接，或者说直觉上我感觉 EG3D 这种表达对“特征-座标”的关系更具体；
2. 三个正交方向塞进小 MLP 里学，可能会更容易让 MLP 知道去找交点附近的那些点去学习，感觉有点类似于在一个长得像曼哈顿距离那种立方体一样的空间里去学习周围的信息；


---


!!! note "参考资料"
    - https://www.cnblogs.com/ghostcai/p/16615616.html （笔记）