# Lecture 12 | Local Search

!!! warning "时间匆忙，内容简略"

- local optimum is a best solution in a neighborhood
- start with a feasible solution and search a better one within the neighborhood
- a local optimum is achieved if no improvement is possible

即先找到一个可行解，以及量化其优程度的目标函数，再在这个可行解上寻求优化，直到达到局部最优解。

---

## [案例] The Vertex Cover Problem

**顶点覆盖问题(vertex cover problem)**指给定一个无向图 $G=(V,E)$，找到一个最小的顶点集 $S\subseteq V$，使得每条边 $(u,v)$ 都至少有一个端点在 $S$ 中（即 $u\in S \lor v\in S$）。

这个问题的可行解为 $S = V$，即完全覆盖，其目标函数为 $cost(S) = |S|$。即，我们尝试使用 local search 来降低 $|S|$。

给出几种案例以及可视化，说明局部搜索容易失效。

## 梅特罗波利斯算法

**梅特罗波利斯算法(the Metropolis algorithm)**的过程：

> 凑合一下，之后有空再改。

```cpp
SolutionType Metropolis() {   
    Define constants k and T;
    Start from a feasible solution S \in FS ;
    MinCost = cost(S);
    while (1) {
        S’ = Randomly chosen from N(S); 
        CurrentCost = cost(S’);
        if ( CurrentCost < MinCost ) {
            MinCost = CurrentCost;    S = S’;
        }
        else {
            With a probability e^{-\Delta cost / (kT)}, let S = S’;
            else  break;
        }
    }
    return S;
}
```

注：对于case 1，有一定概率可以跳出local optimum得到正确解。但是对case 0，有可能在加1和减1之间无限震荡……
注：当（温度）T很高时，上坡的概率几乎为1，容易引起底部震荡；当T接近0时，上坡概率几乎为0，接近原始的梯度下降法。

---

## 模拟退火


**模拟退火(simulated annealing)**

---

## [案例] Hopfield Neural Networks

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Hopfield_network

---

## [案例] The Maximum Cut Problem

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Maximum_cut

---

