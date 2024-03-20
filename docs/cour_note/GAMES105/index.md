# GAMES105 Fundamentals of Character Animation

- [bilibili](https://www.bilibili.com/video/BV1GG4y1p7fF/?p=3&vd_source=a63694cf86898f9b2b3f4d6d997aac63){target="_blank"}

---

## Character Kinematics

> 不考虑物理属性的，研究角色运动的学科。

- 一般考虑只刚性运动。
- body -> bones x joints
- kinematics trees
- 关注 DoF 和 $\theta$ 范围
- F(K) / I(K): 参数(eg. Rotation) -> 属性(eg. Position) / 属性(eg. Position) -> 参数(eg. Rotation)
    - 例如，指定关节旋转，求关节位置属于 FK；变换某个特定关节座标，求所有相关参数的变化属于 IK。

- **IK**
    - 可以抽象为非线性方程求根的问题
    - 有解 / 无解 / **多解（常见）**
    - CCD IK：每次优化一个 dim 方向——不稳定，收敛可能较慢
    - GD IK：向梯度方向优化，理论上收敛相对更快，但是计算复杂度相应更高（需要求梯度）
    - GN IK：牛顿法 IK，收敛更快一点，但开销更大一点（需要求逆）