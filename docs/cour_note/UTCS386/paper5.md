# Paper 5: Scheduling Algorithms for Multiprogramming in a Hard-Real-Time Environment

```bibtex
@article{liu1973scheduling,
  title={Scheduling algorithms for multiprogramming in a hard-real-time environment},
  author={Liu, Chung Laung and Layland, James W},
  journal={Journal of the ACM (JACM)},
  volume={20},
  number={1},
  pages={46--61},
  year={1973},
  publisher={ACM New York, NY, USA}
}
```

Two scheduling algorithms are discussed. Both are **priority-driven** and **preemptive**.

"Hard-Real-Time" refers to that each of the tasks must be completed before some fixed time has elapsed following the request for it.

!!! definition "Assumptions"
    - (A1) The requests for all tasks with hard deadlines are **periodic**, with a constant interval between requests.
    - (A2) Deadlines consist only of run-ability constraints — i.e., each task must be completed **before the next request** for it occurs.
    - (A3) The tasks are independent; requests for one task do not depend on the initiation or completion of requests for other tasks.
    - (A4) The run-time for each task is **constant** for that task and does not vary with time. Run-time refers to the time taken by a processor to execute the task without interruption.
    - (A5) Any non-periodic tasks in the system are special — they are initialization or failure-recovery routines. They displace periodic tasks while they are being executed, and they themselves do not have hard, critical deadlines.

Symbols:

- $\tau_i$: the $i$-th task.
- $T_i$: the request period of task $\tau_i$.
- $C_i$: the run-time of task $\tau_i$. Obviously, $C_i \leq T_i$.

Here, the deadline of each task is also defined as $T_i$.

And we define the **response time** of a task as the time from the request of the task to the completion of the task.

When a task fails to be executed for $C_i$ time in total before the deadline, (i.e., the response time of the task is greater than $T_i$), we say there is a **overflow**.

And a scheduling is feasible if no overflow will occur.

## Fixed-Priority Scheduling / Static Priority Scheduling

!!! key-point "Critical Instant"
    A **critical instant** for a task is defined as the instant at which a request for that task will experience the **largest response time**.
    A **critical time zone** for a task is the time interval between a critical instant and the completion of the corresponding request's response.

!!! property "Theorem 1"
    A critical instant for any task occurs when that task is: requested simultaneously with requests for **all higher-priority tasks**.

    （很显然，因为这些 task 都会抢占当前 task。）

!!! definition "Rate-Monotonic Priority Assignment"
    Tasks with higher request rates should have higher priorities.
    And it's optimal for the fixed-priority scheduling algorithm.

!!! property "Theorem 2"
    If a feasible priority assignment exists for some task set, the rate-monotonic priority assignment is feasible for that task set.

## Achievable Processor Utilization

The utilization factor for $m$ tasks on one processor is defined as:

$$
U = \sum_{i=1}^{m} \frac{C_i}{T_i}
$$

The upper bound of the utilization factor will be bounded by the "feasible scheduling" constraints.

!!! property "Theorem 3"
    For a set of **two** tasks with fixed priority assignment, the **least upper bound** to the processor utilization factor is $U = 2(2 ^\frac{1}{2} - 1)$.

    The proof goes by considering two situations:

    - When $C_1$ is relatively small, while all of $\tau_1$ within $T_2$ is completed, and in this case, U monotonically decreases with $C_1$.
        - We have $C_1 \leq T_2 - T_1\lfloor \frac{T_2}{T_1} \rfloor$.
        - The utilization factor is $U=1+C_1\left[ \frac{1}{T_1} - \frac{1}{T_2}\lceil\frac{T_2}{T_1}\rceil \right]$.
    - When $C_1$ is relatively large, while the last execution of $\tau_1$ within $T_2$ is incomplete, and in this case, U monotonically increases with $C_1$.
        - We have $C_1 \geq T_2 - T_1\lceil \frac{T_2}{T_1} \rceil$.
        - The utilization factor is $U=\frac{T_1}{T_2}\lfloor \frac{T_2}{T_1} \rfloor + C_1\left[ \frac{1}{T_1} - \frac{1}{T_2}\lceil\frac{T_2}{T_1}\rceil \right]$.
    - The minimum value of U is achieved when $C_1 = T_2 - T_1\lfloor \frac{T_2}{T_1} \rfloor$. The equation is $U=1-\frac{T_1}{T_2}\left[ \lceil \frac{T_2}{T_1} \rceil - \frac{T_2}{T_1} \right]\left[ \frac{T_2}{T_1} - \lfloor \frac{T_2}{T_1} \rfloor \right]$.
        - And we denote $I=\lfloor \frac{T_2}{T_1} \rfloor$ and $f=\frac{T_2}{T_1} - \lfloor \frac{T_2}{T_1} \rfloor$, then the results can be rewrite as:
            - $U=1-\frac{1}{(I+f)}(1-f)f$
            - Minimize it and we have $U=2(\sqrt{2}-1)$.

!!! property "Theorem 4"
    For a set of $m$ tasks with fixed priority order, and under the restriction that the ratio between any two request periods is less than 2, the least upper bound of the processor utilization factor is:

    $$
    U = m \left( 2^{\frac{1}{m}} - 1 \right)
    $$

!!! property "Theorem 5"
    For a set of $m$ tasks with fixed priority order, the least upper bound to processor utilization is $U = m (2^\frac{1}{m} - 1)$.

## Deadline-Driven Scheduling / Dynamic Priority Scheduling

!!! definition "Deadline-Driven Scheduling"
    A task will be assigned the highest priority if the deadline of its current request is the nearest, and will be assigned the lowest priority if the deadline of its current request is the furthest.
    At any instant, the task with the highest priority and yet unfulfilled request will be executed.

!!! property "Theorem 6"
    When the deadline driven scheduling algorithm is used to schedule a set of tasks on a processor, there is no processor idle time prior to an overflow.

    （如果有 overflow，则没有 idle time，不过我觉得这句话说的非常不严谨。）

!!! property "Theorem 7"
    For a given set of m tasks, the deadline driven scheduling algorithm is feasible if and only if:

    $$
    \sum_{i}\frac{C_i}{T_i} \leq 1
    $$

    （利用 Theorem 6 辅助证明。）


