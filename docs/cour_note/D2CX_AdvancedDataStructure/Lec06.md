# Lecture 6 | Backtracing

!!! quote "link"
    OI Wiki: https://oi-wiki.org/search/backtracking/
    
    Wikipedia: https://en.wikipedia.org/wiki/Backtracking

这一节的内容比较散，因为回溯是一个很基础而且很泛用的东西，所以感觉怎么讲都不太合适。更多的是需要在具体问题、具体模型中去体会。

~~加上如果每一个内容都要往死里去叙述的话实在太累了，所以回溯这一章想偷个懒，就简单记录一下课上提到过的一些模型吧。~~

---

## 八皇后

非常经典的问题，相信接触过算法的同学基本上都绕不开这个东西。

!!! quote "link"
    Wikipedia: https://en.wikipedia.org/wiki/Eight_queens_puzzle

---

## [案例] The Turnpike Reconstruction Problem

**收费站重建问题(The Turnpike Reconstruction Problem)**描述的是一条被抽象为直线的公路上，有 $N$ 个收费站（$x_1, x_2, ..., x_N$）。现在给出任意两个收费站之间的距离的可重集合 $D$，（可想而知，一共有 $\frac{N(N-1)}{2}$ 个元素），求收费站的位置，即给定任意两点的距离集合，求出这些点的坐标。

!!! tip "solution"
    大概思路就是，首先假设 $x_1 = 0$，那么很显然 $x_N = \mathop{max} \{D\}$。同时我们也得到这条线段的长度为 $\mathop{max} \{D\}$。接下来 $D$ 中从大到小取出元素，则必定追加在 $x_1$ 右侧或 $x_N$ 左侧，以此类推。（反证法可以证明在完全安排好之前都是追加在左侧或者右侧的既定边界之间的）。而每一次追加的选择都代表决策树中的一个分支，可以利用其它条件进行剪枝（例如 $D$ 中有 $x_p - x_0$ 就一定有 $x_N - x_p$）。

---

## ɑ-β 剪枝

!!! quote "link"
    Wikipedia: https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning

- 实际上就类似于求解不能连续向右的，从根到叶子的路径。