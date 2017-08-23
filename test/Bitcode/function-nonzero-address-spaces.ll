; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; CHECK: define void @main() addrspace(3)
define void @main() addrspace(3) {
  ret void
}

