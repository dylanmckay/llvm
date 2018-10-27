# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s

vaddps %ymm0, %ymm0, %ymm1
vandps (%rdi), %ymm1, %ymm2

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      11
# CHECK-NEXT: Total uOps:        3

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.27
# CHECK-NEXT: IPC:               0.18
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT:  2      8     1.00    *                   vandps	(%rdi), %ymm1, %ymm2

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeER    .   vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [0,1]     DeeeeeeeeER   vandps	(%rdi), %ymm1, %ymm2

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: 1.     1     1.0    0.0    0.0       vandps	(%rdi), %ymm1, %ymm2
