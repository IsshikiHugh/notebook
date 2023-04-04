# Lecture 10 | Recognition

!!! warning "注意"
    本文尚未完全整理好！

二维图像**识别(Recognition)**下有很多任务，主要分为这么几种：

- 分类 Classification
- 语义分割 Semantic segmentation
- 对象检测 Object detection
- 实例分割 Instance segmentation

## Semantic segmentation

每个像素属于哪个类别这种信息叫语义信息。

- 输入：图片
- 输出：每个像素的类别标签，不需要区分同一类别的不同实例

最朴素的做法是 sliding window，取出一个 window 放进分类机得到结果，但是显然由于 window 包含的信息太少，而且效率太低，这个方法非常 naive。

---

现在标准的做法是**全卷积网络(Fully Convolutional Network)**

- Loss function: Per-pixel cross-entropy

局限性：

- Receptive field is linear in number of conv layers
- Convolution on high resolution is expensive（耗时）

改进：

- Downsampling: pooling, strided conv

但是由于我们最后希望得到的是一个和原图一样大的东西，所以有向下采样就肯定会有向上采样（回忆：插值）。

> 图像向上采样以后变大以后又卷积，这个Transposed convolution

![](img/) ppt P13

但是很显然，在变小变大的过程中肯定有信息损失。所以现在一个比较流行的做法是 U-Net，也就是大量应用 skip-connection。

![](img/) ppt P14 https://web.eecs.umich.edu/~justincj/teaching/eecs498/FA2020/

DeepLab P15

考虑相邻像素之间的关联性，使用 CRF(Conditional random field) 优化 P16

> 马可夫随机场？

Unary potential: 体现自己的特性

Pairwise potential: 体现关联性

---

### 衡量指标 Evaluation metric: Per-pixel **Intersection-over-union (IoU)**

$IoU=\frac{
    \text{Ground truth 和 prediction 的交集面积}
}{
    \text{Ground truth 和 prediction 的并集面积}
}$ 
P19

mIoU 指的是分出来的不同类别的 mean IoU



## Object detection

Bounding box (bbox)

- Class label
- Location (x,y)
- Size (w,h)

- 输入：图像
- 输出：一堆 bounding box

那么如何实现呢？我们先假设一共只有 1 个对象，那么此时和分类任务是非常接近的，只需要再额外求解一个窗口位置即可。

那么多个窗口呢？

解决办法还是滑动窗口，只不过不同之前的，我们现在采用的方法基本上也是**基于**滑动窗口展开的。而在这种语境下，这样的一个滑动窗口被称为一个**提议(proposal)**。

但是显然，使用最朴素的滑动窗口会导致“提议”过多，导致效率太低。所以我们要优化这个过程。

一般这些优化的方法都是**启发式(heuristics)**的做法，例如 over-segmentation， 

而这类方法就是 R-CNN (region proposal & CNN) P36


### Evaluation metric

对于单个物体，仍然是 IoU

P39

为了评价预测结果的正确性，我们需要为它设置一个阈值。

而对于多个物体，则不那么简单：P42

（回忆统计学内容）

positive: 肯定的假设 P

negative: 否定的假设 N

true: 假设是成立的 T

false: 假设是错误的 F

我们通过下面两个标准来联合判断效果。

精度 Precision = TP/(TP+FP)：描述给定的 bbox 里有多少是正确的

召回率 Recall = TP/(TP+FN)：描述所有对象中，被我们识别出来的有多少

一般来说，这俩东西有一个 trade-off。（概统里应该有类似的内容）

https://en.wikipedia.org/wiki/Precision_and_recall

而最终的衡量方法，是 Mean Average Precision (mAP)。

1. Run object detector on all test images
2. For each category, compute Average Precision 
   - (AP) = area under Precision vs Recall Curves

PPT p52

先做所有类别的 AP，然后取平均就是 mAP

mAP@threshold = ...

COCOmAP = average(mAP@threshold_i), for i \in {0.5, 0.55, 0.6, …, 0.95}

---

Non-Max Suppression

对于同一个对象，我有可能识别出好几个识别同一个物体的 bbox，所以我可以考虑设计一种算法减少这种识别。

简单来说，做法就是找 score 最大的，然后看其他 bbox 和这个 bbox 的 IoU，大于一定权重时，认为它们是一致的，就可以把较小的那个删掉了。 

--- 

Fast R-CNN

RoI pool （没听懂，整理的时候再仔细学一下）

Faster R-CNN

用网络（Region Proposal Network, RPN）生成提议选框，

锚点 anchor：

> 在计算机视觉中，锚点是用于目标检测的预定义框或感兴趣区域。锚点能够帮助卷积神经网络识别图像中存在的物体及其位置，从而提高目标检测的准确性。锚点通常由一组预定义的长宽比和尺度定义，这些因素决定了它们的大小和形状。在训练期间，CNN学习预测相对于这些锚点的物体的位置和大小。使用锚点可以检测不同大小和宽高比的物体，并有助于提高目标检测在复杂场景下的准确性。----chatGPT

RPN 的大致思路是，把生成选框问题转化为打分问题，具体来说是给每个像素打在该位置有一个特定 size 的框的可能性的分。

二阶段对象检测符 two-stage object detector

1. 
2. 

---

![](img/) P76
各种方法的效果排序。

---

一种对 two-stage object detector 的改进是 single-stage object detector，大概就是在做 RPN 的同时去预测这个框标记的是某个类别的概率。

single-stage 的代表性工作：YOLO

two-stage v.s. single-stage

- Two-stage is generally more accurate （数据量足够大）
- Single-stage is faster

---

但是我们上面的工作都没考虑尺度变化，Feature pyramid network 在这方面提出了解决方案。

---


## Instance segmentation

Faster R-CNN + additional head

Mask R-CNN

Deep snake

### Panoptic segmentation


---

Microsoft COCO dataset

## Human pose estimation

keypoints

represent joint location as the heatmap // hourglass networks

Top-down:
- Detect humans and detect keypoints in each bbox
- Example: Mask R-CNN - 最大的问题还是慢

Bottom-up:
- Detect keypoints and group keypoints to form humans
- Example: OpenPose 先找 kpts，再利用 Affinity Fields 把属于一个人的 kpts 合在一起。

Top-down is generally more accurate
Bottom-up is faster，而且在遮挡情况下也有它的优势


## Optical flow

光流

video classification

一个做法是把视频当作一个 3d 图像去做，即 3D CNN。但是数据维度非常大。

Temporal action localization

Spatial-temporal detection

做法也可以当作一个 3D 的 R-CNN 去做。

Multi-object tracking

对每一帧做物体检测，然后在每一帧之间做关联匹配。




