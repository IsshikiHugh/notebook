# Paper 3: Reaching Agreement on Processor Group Membership in Synchronous Distributed Systems

```bibtex
@article{cristian1991reaching,
  title={Reaching agreement on processor-group membrship in synchronous distributed systems},
  author={Cristian, Flaviu},
  journal={Distributed Computing},
  volume={4},
  number={4},
  pages={175--187},
  year={1991},
  publisher={Springer}
}
```

- $d$ refers to the datagram delay bound.
- $D$ refers to the atomic broadcast delay bound.
- $\eta$ refers to the scheduling delay bound.
- $\delta = \eta + d + \eta$ refers to process-to-process datagram delay bound.
- $\Delta = \eta + D + \eta$ refers to the process-to-process atomic broadcast delay bound.

!!! key-point "The Periodic Broadcast Membership Protocol"
    - Periodically (every $\pi$) one **broadcast** for issuing a new membership list; and each processor replies a PRESENT using **broadcast**.
    - One processor issues $M = MEMBERSHIP(V=S+\Delta)$ at time $S$. And a group will be formed at time $C=V+\Delta$.
    - Worst-case-join-delay: $J=2\Delta$

    The main drawback is that it requires $n$ (cardinality) atomic broadcasts every $\pi$ time units, even when no failures or joins occur.

!!! key-point "The Attendance List Membership Protocol"
    - Based on broadcast group forming. One processor will be regarded as the leader of the group.
    - The leader will issue a membership check with an "attendance list" at time $O=V+\pi, C<O$ using datagram.
    - The list will be transmitted to all processors along a virtual ring. (Each processor pass the list to its successor.)
    - For each processor, it will receive the list within the time interval $\left[O-\epsilon, O+\gamma=O+n\delta+\epsilon\right]$.
    - So each processor check at $E=O+\gamma(+\eta)$ on its clock weather they receive the list issued after $E-\gamma$.
        - If any of the processors don't receive the list, it will issue a new membership forming
        - Otherwise, the list will finally go back to the leader with totally **$n$ datagram messages**.

    So the minimum membership formation message cost is $n$ **datagram** messages, while the periodic broadcast protocol requires $n$ **atomic** broadcasts.

    Reconfiguration latency for a single failure is given by $D_1 = \pi+n\delta+\varepsilon+J$ where $J=2\Delta$. This assumes that processor-to-processor delay is between $0$ and $\delta$. *$D_1 = \pi+\delta+\varepsilon+J$ if the processor-to-processor delay is exactly $\delta$. (Why?)*


    Worst-case detection time for $k$ failures is given by:
    - $D_k = 2\pi+(k-1)\delta-(n-1)\delta+\varepsilon+J$ where $J=2\Delta$ if the processor-to-processor delay is exactly $\delta$. This assumes that $\pi>\delta$ so that member check-in can finish before the end of the period.
    - $D_k = 2\pi+(k-1)\delta+\varepsilon+J$ if processor-to-processor delay is between $0$ and $\delta$.

!!! key-point "The Neighbor Surveillance Protocol"
    - A member which does not receive "Present" message from predecessor triggers a new group by atomic broadcast.
    - The reconfiguration latency for $k$ failures is given by: $D = k\pi + \delta + \varepsilon + 2\Delta$
