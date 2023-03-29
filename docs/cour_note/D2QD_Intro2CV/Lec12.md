# Lecture 12 | Computational Photography 1

!!! warning "注意"
    本文尚未完全整理好！

??? question "What's 计算摄影？"
    ...


## High Dynamic Range Imaging (HDR)

我们希望亮的和暗的地方细节都很丰富

曝光 exposure = Gain增益 * Irradiance辐照度 * Time曝光时间

分别取决于……

- 快门
- 光圈
- ISO 感光度
    - 高：更亮、更多噪声

Dynamic range

The ratio between the largest and smallest values of a certain quantity 

HRD: 不同亮度都拍一些，然后合成



12 to 8 -> tone mapping

> Gamma compression



## Deblurring

模糊的两个主要原因：defocus and motion blur

blurred image = clear image * blur kernel

deblurring = deconvolution

- Non-blind image deconvolution, NBID
- Blind image deconvolution, BID

inverse filter

wiener filter

## Colorization

最关键的问题是，如何决定上的颜色

主要有两类方法：

1. sample-based colorization
2. interactive colorization

### Sample-based 

...


### Interactive

...


---

对于视频

Colorful Image Colorization

GAN (Generative Adversarial Network)

- 两个一起训练，min-max problem  
- GAN 很难收敛，不好调
- adversarial loss


### more Image synthesis tasks

- image to image translation
    - pix2pix gan
- style transfer
- text-to-photo
- image dehazing
- customized gaming

GAN 的改进：Cycle-GAN，解决了缺少成对的训练数据的问题

## Super Resolution

up sampling

bi-cubic

super resolution using GAN



