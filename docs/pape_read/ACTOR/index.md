# [ACTOR] Action-Conditioned 3D Human Motion Synthesis with Transformer VAE

`3DV` `Human-Motion` `Action-Control`

!!! info "文章信息"
    - 文章题目：*Action-Conditioned 3D Human Motion Synthesis with Transformer VAE*
    - 分类：`Computer Science` > `Computer Vision and Pattern Recognition`
    - 作者：[Mathis Petrovich](https://arxiv.org/search/cs?searchtype=author&query=Petrovich%2C+M), [Michael J. Black](https://arxiv.org/search/cs?searchtype=author&query=Black%2C+M+J), [Gül Varol](https://arxiv.org/search/cs?searchtype=author&query=Varol%2C+G)
    - 项目主页：[🔗](https://mathis.petrovich.fr/actor/)
    - arXiv：[🔗](https://arxiv.org/abs/2104.05670) 2104.05670
    - 代码：[🔗](https://github.com/Mathux/ACTOR)

!!! summary "相关内容"
    - Transformer
    - VAE
    - [SMPL](https://smpl.is.tue.mpg.de/) 一个性质良好的人体模型规范
    - MoCap

## Introduction

>  In this work, our goal is to take a semantic action label like “Throw” and generate an infinite number of realistic 3D human motion sequences, of varying length, that look like realistic throwing (Figure 1).

并且受使用场景限制，它需要有强约束以及相对的高效性。

涉及人体皮肤表面与主客体的交互，所以使用 SMPL 是一个非常好的选择。

> noisy 3D body poses

同样采用 Positional Encoding，这与 NeRF 联系起来。

## Related Work

- Future human motion prediction
- Human motion synthesis
- Monocular human motion estimation
- Transformer VAEs



??? question "疑惑"
    > his allows the generation of variable length sequences without the problem of the motions regressing to the mean pose. 这句话是什么意思？

??? summary "Translate"
    [翻译内容](trans.md)