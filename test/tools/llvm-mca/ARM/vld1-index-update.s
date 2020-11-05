# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=armv7-unknown-unknown -mcpu=swift -timeline -iterations=5 < %s | FileCheck %s

# Register r1 is updated in one cycle by instruction vld1.32, so the add.w can
# start one cycle later.

add.w	r1, r1, r12
vld1.32	{d16, d17}, [r1]!

# CHECK:      Iterations:        5
# CHECK-NEXT: Instructions:      10
# CHECK-NEXT: Total Cycles:      16
# CHECK-NEXT: Total uOps:        15

# CHECK:      Dispatch Width:    3
# CHECK-NEXT: uOps Per Cycle:    0.94
# CHECK-NEXT: IPC:               0.63
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        add	r1, r1, r12
# CHECK-NEXT:  2      4     1.00    *                   vld1.32	{d16, d17}, [r1]!

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SwiftUnitDiv
# CHECK-NEXT: [1]   - SwiftUnitP0
# CHECK-NEXT: [2]   - SwiftUnitP1
# CHECK-NEXT: [3]   - SwiftUnitP2
# CHECK-NEXT: [4.0] - SwiftUnitP01
# CHECK-NEXT: [4.1] - SwiftUnitP01

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4.0]  [4.1]
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4.0]  [4.1]  Instructions:
# CHECK-NEXT:  -      -      -      -      -     1.00   add	r1, r1, r12
# CHECK-NEXT:  -      -      -     1.00   1.00    -     vld1.32	{d16, d17}, [r1]!

# CHECK:      Timeline view:
# CHECK-NEXT:                     012345
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    .    .   add	r1, r1, r12
# CHECK-NEXT: [0,1]     D=eeeeER  .    .   vld1.32	{d16, d17}, [r1]!
# CHECK-NEXT: [1,0]     .D=eE--R  .    .   add	r1, r1, r12
# CHECK-NEXT: [1,1]     .D==eeeeER.    .   vld1.32	{d16, d17}, [r1]!
# CHECK-NEXT: [2,0]     . D==eE--R.    .   add	r1, r1, r12
# CHECK-NEXT: [2,1]     . D===eeeeER   .   vld1.32	{d16, d17}, [r1]!
# CHECK-NEXT: [3,0]     .  D===eE--R   .   add	r1, r1, r12
# CHECK-NEXT: [3,1]     .  D====eeeeER .   vld1.32	{d16, d17}, [r1]!
# CHECK-NEXT: [4,0]     .   D====eE--R .   add	r1, r1, r12
# CHECK-NEXT: [4,1]     .   D=====eeeeER   vld1.32	{d16, d17}, [r1]!

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     5     3.0    0.2    1.6       add	r1, r1, r12
# CHECK-NEXT: 1.     5     4.0    0.0    0.0       vld1.32	{d16, d17}, [r1]!
# CHECK-NEXT:        5     3.5    0.1    0.8       <total>
