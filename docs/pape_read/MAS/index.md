# [MAS] Multi-view Ancestral Sampling for 3D Motion Generation Using 2D Diffusion

`3DV` `Motion` `Diffusion`

!!! info "文章信息"

    - 文章题目：*MAS: Multi-view Ancestral Sampling for 3D Motion Generation Using 2D Diffusion* 
    - 作者：<span class="author-block"><a href="https://scholar.google.com/citations?user=FAQOuSgAAAAJ&amp;hl=en" target="_blank">Roy Kapon</a>,</span> <span class="author-block"><a href="https://guytevet.github.io/" target="_blank">Guy Tevet</a>,</span> <span class="author-block"><a href="https://danielcohenor.com/" target="_blank">Daniel Cohen-Or</a>,</span> <span class="author-block"><a href="https://www.cs.tau.ac.il/~amberman/" target="_blank">Amit H. Bermano</a></span>
    - 项目主页：[🔗](https://guytevet.github.io/mas-page/)
    - arXiv：[🔗](https://arxiv.org/abs/2310.14729) 2310.14729


## 论文笔记

利用一个在 **2D 单目**数据集上 train 出来的 diffusion model 做 3D Motion 的生成。

- 由于使用 ancestral sampling，MAS 生成 3D motion 的效率很高；


- 数据表示：
    - 表示 J 个 joint 在 L 帧里的 xyz，而且不对骨棒长度做约束（在做法中也不约束）；
        - 这带来的好处是可以增加场景中更多的运动物体；

- 方法
    - 多视角的一致性：
        - 在每个 diffusion denoising step 都利用 **"triangulate"** 进行一次 $n*2D \rightarrow 1*3D \rightarrow n*2D$ 的过程；
        - [x] TODO: 这个 "triangulate" 是什么？ [三角测量](https://zh.wikipedia.org/wiki/%E4%B8%89%E8%A7%92%E6%B8%AC%E9%87%8F){target="_blank"}。
    - 实验认为 V = 3 就够了，再多影响也不大；
    - 


