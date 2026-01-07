### Paper 4: State Restoration

#### Definitions
- **R-normal system**: R-propagation is never necessary during any `RESTORE`
- **Domino-free system**: No domino effect occurs
- **MRS process**: Operations follow pattern `(MARK; RECEIVE*; SEND*)*`
- **xPy**: Operation x must propagate restoration so that operation y is undone
- **Necessarily undone**: Operation y is undone if `bP*y` where b is earliest operation after recovery point r
- **Unnecessarily undone**: Operation y is undone if `bQ*y` but not `bP*y`

#### Theorems

**Theorem 1**: If, for all messagelists `m` of a system, the messages in `m` are received by **no more than one process**, the system is **R-normal**.

**Theorem 2**: A commutative system is R-normal.

**Theorem 3**: If for all messagelists `m` of a system, either 1) the messages in `m` are received by at most one process or 2) `m` is a commutative messagelist, then the system is **R-normal**.

**Theorem 4**: Let S be an R-normal system with `k` processes whose system graph is acyclic. Then S is **domino-free**.

**Theorem 5**: Let `S` be an asynchronous system and suppose that a `MARK` command is executed just before every `RECEIVE` command. Then `S` is domino-free and `D = 0`.

**Theorem 6**: Let S be an R-normal, MRS system. Let the number of processes in the system be `k` and let the number of `RECEIVE` commands that each process performs between any two `MARK` commands be less than or equal to `s`. Then `S` is domino-free and `D <= (k - 1)(s - 1)`.

**Theorem 7**: Let S be an MRS, R-normal system. Let the number of `RECEIVE` commands in process $p_i$ that are executed between any two `MARK` commands be less than or equal to $s_i$. Then `S` is domino-free and:

$$D \leq \max_{i=1} \sum_{j\not=i} (s_j-1) = \sum_j(s_j - 1) - \min_{j}(s_j - 1)$$

**Theorem 8**: Let `S` be an MRS, R-normal system. Then `S` is domino-free.

---

### Paper 5: Real-Time Scheduling

#### Definitions
- **Critical Instant**: The instant at which a request for a task will experience the **largest response time** (occurs when requested simultaneously with all higher-priority tasks)
- **Rate-Monotonic Priority Assignment**: Tasks with higher request rates have higher priorities (optimal for fixed-priority scheduling)
- **Utilization Factor**: $U = \sum_{i=1}^{m} \frac{C_i}{T_i}$
- **Deadline-Driven Scheduling**: Task with nearest deadline has highest priority

#### Theorems

**Theorem 1**: A critical instant for any task occurs when that task is requested simultaneously with requests for **all higher-priority tasks**.

**Theorem 2**: If a feasible priority assignment exists for some task set, the rate-monotonic priority assignment is feasible for that task set.

**Theorem 3**: For a set of **two** tasks with fixed priority assignment, the **least upper bound** to the processor utilization factor is:

$$U = 2(2^{\frac{1}{2}} - 1) \approx 0.828$$

*Proof details* (two cases):
- **Case 1** ($C_1$ relatively small): All $\tau_1$ within $T_2$ completed
  - Condition: $C_1 \leq T_2 - T_1\lfloor \frac{T_2}{T_1} \rfloor$
  - Utilization: $U=1+C_1\left[ \frac{1}{T_1} - \frac{1}{T_2}\lceil\frac{T_2}{T_1}\rceil \right]$
- **Case 2** ($C_1$ relatively large): Last execution of $\tau_1$ within $T_2$ incomplete
  - Condition: $C_1 \geq T_2 - T_1\lceil \frac{T_2}{T_1} \rceil$
  - Utilization: $U=\frac{T_1}{T_2}\lfloor \frac{T_2}{T_1} \rfloor + C_1\left[ \frac{1}{T_1} - \frac{1}{T_2}\lceil\frac{T_2}{T_1}\rceil \right]$
- **Minimum**: Achieved when $C_1 = T_2 - T_1\lfloor \frac{T_2}{T_1} \rfloor$
  - Let $I=\lfloor \frac{T_2}{T_1} \rfloor$ and $f=\frac{T_2}{T_1} - \lfloor \frac{T_2}{T_1} \rfloor$
  - Then $U=1-\frac{1}{(I+f)}(1-f)f$
  - Minimizing yields $U=2(\sqrt{2}-1)$

**Theorem 4**: For a set of $m$ tasks with fixed priority order, and under the restriction that the ratio between any two request periods is less than 2, the least upper bound of the processor utilization factor is:

$$U = m \left( 2^{\frac{1}{m}} - 1 \right)$$

**Theorem 5**: For a set of $m$ tasks with fixed priority order, the least upper bound to processor utilization is:

$$U = m (2^\frac{1}{m} - 1)$$

**Theorem 6**: When the deadline driven scheduling algorithm is used to schedule a set of tasks on a processor, there is no processor idle time prior to an overflow.

**Theorem 7**: For a given set of m tasks, the deadline driven scheduling algorithm is feasible if and only if:

$$\sum_{i}\frac{C_i}{T_i} \leq 1$$
