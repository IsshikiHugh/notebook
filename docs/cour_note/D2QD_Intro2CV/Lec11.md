# Lecture 11 | 3D Deep Learning

!!! warning "注意"
    本文尚未完全整理好！


Deep Learning for 3D reconstruction




## Feature matching

recap: [SfM](Lec07.md) // Colmap

use deep learning to improve feature matching

传统方法的缺点就是因为这些方法都是 handcrafted 的。所以我们希望能够用 deep learning 来增强效果。

![](img/_slides 对比图)

example: SuperPoint、SuperGlue

- CNN-base descriptor 好有意思！

描述值：

1. contrastive loss
2. triplet loss

实际上本质类似，效果相近

---

主流用 MVS 来生成训练数据



## Object Pose Estimation

本质上是在讨论物体在重建空间中的坐标系和相机空间中的坐标系的变换关系。

[PnP](Lec07.md#多点透视成像问题)

可是难就难在，如何寻找 3D-2D 的关系呢？
 
一个 idea 是，首先得到一个较好的重建，然后基于这个重建模型，我们就可以从别的思路来看这件事。

pose refinement methods

## Human Pose Estimation

(Markerless) MoCap

Monocular 3D Human Pose Estimation (eg. Vnet)

## Depth Estimation

MVSNet

[MVS](Lec08.md)

离散表示、隐式表示（用一个网络来表示一个函数 Implicit Neural Representations，代表：NeRF）

Replacing density field in NeRF by SDF: NeuS

## Single Image to 3D

 


## Deep learning for 3D understanding

计算开销很大

近几年提出的解决方案：Sparse ConvNets

Octree 八叉树，空间划分

稀疏卷积，只有有值的地方进行卷积

由于卷积等操作是建立在网格上的，而点云并不定义在网格上，所以对点云进行卷积则需要一些其他方法。

一个相关工作是 PointNet，专门用在对点云上。还有 PointNet++


3D Semantic Segmentation


3D Object Detection


3D Instance Segmentation


PointRCNN


Frustum PointNets

 
数据集：ShapeNet, PartNet,SceneNet , ScanNet