# NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis

!!! info "文章信息"
    - 文章题目：*NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis* （神经辐射场）
    - 分类：`Computer Science` > `Computer Vision and Pattern Recognition`
    - 作者：[Ben Mildenhall](https://arxiv.org/search/cs?searchtype=author&query=Mildenhall%2C+B), [Pratul P. Srinivasan](https://arxiv.org/search/cs?searchtype=author&query=Srinivasan%2C+P+P), [Matthew Tancik](https://arxiv.org/search/cs?searchtype=author&query=Tancik%2C+M), [Jonathan T. Barron](https://arxiv.org/search/cs?searchtype=author&query=Barron%2C+J+T), [Ravi Ramamoorthi](https://arxiv.org/search/cs?searchtype=author&query=Ramamoorthi%2C+R), [Ren Ng](https://arxiv.org/search/cs?searchtype=author&query=Ng%2C+R)
    - 论文地址：[🔗](https://arxiv.org/abs/2003.08934)
    - 项目主页：[🔗](https://www.matthewtancik.com/nerf)
    - 代码：[🔗](https://paperswithcode.com/paper/nerf-representing-scenes-as-neural-radiance)


!!! summary "相关内容"
    - MLP 神经网络
    - traditional volume rendering


??? quote "参考资料"
    - https://zhuanlan.zhihu.com/p/360365941 （笔记 关于体积渲染讲得很清晰）
    - https://zhuanlan.zhihu.com/p/380015071 （笔记）
    - https://wandb.ai/wandb_fc/chinese/reports/NeRF-Neural-Radiance-Fields-View-Synthesis---VmlldzozNDQxNzk （侧重如何使用）
    - https://www.youtube.com/watch?v=nCpGStnayHk（上面那篇文章的介绍视频）
    - https://blog.csdn.net/qq_43620967/article/details/124467551 （翻译）
    - https://blog.csdn.net/weixin_44292547/article/details/126042398 （翻译）
    - https://blog.csdn.net/weixin_44580210/article/details/122284120 （笔记）


通过对多张图片进行学习，得到原始模型，然后从模型中通过 ray 上的采样与积分来获得对应的图像、光泽等。

其中涉及位置信息编码。

社区 Pytorch 复现代码的注释：https://github.com/IsshikiHugh/nerf-pytorch

??? question "存疑"
    - 随机均匀采样？为何能够得到连续可微？
    - 何为位置信息编码？其原理如何？