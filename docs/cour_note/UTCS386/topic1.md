# Topic 1: Probabilistic Clock Synchronization

```bibtex
@article{cristian1989probabilistic,
  title={Probabilistic clock synchronization},
  author={Cristian, Flaviu},
  journal={Distributed computing},
  volume={3},
  number={3},
  pages={146--158},
  year={1989},
  publisher={Springer}
}
```

!!! property "Theorem"
    !!! inline end note ""

        <center> ![](assets/1.1.png){ width="200px" } </center>

        > Regard all $H$ as $C$.

    If the clocks of processes $P$ and $Q$ are correct, the value displayed by $Q$'s clock when $P$ receives the ("time = ", $T$) message ($C_Q(t_3)$) is in the interval $[T+min\cdot(1-\rho), T+2D(1+2\rho)-min\cdot(1+\rho)]$.



    Extra definition:

    - $2D = C_P(t_3) - C_P(t_1)$, refers to the P's reading version of $2d$
    - $T := C_Q(t_2)$

    !!! proof "Proof"

        $$
        \begin{aligned}
        \because\; & C_Q(t_3) = C_Q(t_2 + min + \beta)
        \\
        \therefore\; & C_Q(t_2) + (min + \beta)(1 - \rho) \leq C_Q(t_3) \leq C_Q(t_2) + (min + \beta)(1 + \rho)
        \\
        i.e.\; & T + (min + \beta)(1 - \rho) \leq C_Q(t_3) \leq T + (min + \beta)(1 + \rho)
        \\
        \because\; & min + \beta = 2d - (min+\alpha) = 2d - min - \alpha \leq 2d - min
        \\
        \because\; & 2D(1 - \rho) \leq 2d \leq 2D(1 + \rho)
        \\
        \therefore\; & min + \beta \leq 2D(1 + \rho) - min
        \\
        \because\; & \beta \geq 0
        \\
        \therefore\; & T + min(1 - \rho) \leq C_Q(t_3) \leq T + 2D(1 + 2\rho) - min(1 + \rho)
        \\
        i.e.\; & C_Q(t_3) \in [T + min(1 - \rho), T + 2D(1 + 2\rho) - min(1 + \rho)]
        \end{aligned}
        $$

This is the smallest interval which $P$ can determine in terms of $T$ and $D$ that covers $Q$'s clock value.

Thus, in order to minimize the maximum error, $P$ choose the midpoint of this interval as the **estimate** of $Q$'s clock value at $t_3$:

$$
C^P_Q(t_3) = T + D(1 + 2\rho) - min \cdot \rho
$$

And define the **maximum error** $e$ (radius of the interval) as:

$$
e = D(1 + 2\rho) - min
$$

in order to control the precision of the synchronization, we define a boundary condition for the maximum error $\varepsilon$, it discards any reading attempt for which it measures an actual round trip delay greater than $2U$ (while the actual error is $e$ and the reading round trip delay is denoted as $2D$).

!!! property "Theorem"

    $$
    U = (1-2\rho)(\varepsilon+min)
    $$

    !!! proof "Proof"

        $$
        \begin{aligned}
        \because\; & e = D(1 + 2\rho) - min \leq \varepsilon
        \\
        \therefore\; & D \leq \frac{\varepsilon + min}{1 + 2\rho} = (1 - 2\rho)(\varepsilon + min)
        \\
        \therefore\; & U = (1 - 2\rho)(\varepsilon + min)
        \end{aligned}
        $$

Another constrains is $U \geq U_{min} = (1+\rho)min$ for handling the drifting issues.

Given this, we have a judgment: for the timeout delay, closer to $U_{min}$: more precise but higher failure rate, vice versa.

A best reading precision achievable by a clock reading experiment is: $e_{min} = 3\rho\cdot min$

---
