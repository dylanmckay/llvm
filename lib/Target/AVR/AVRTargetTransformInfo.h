//===---- AVRTargetTransformInfo.h - AVR specific TTI -----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file a TargetTransformInfo::Concept conforming object specific to the
// AVR target machine. It uses the target's detailed information to
// provide more precise answers to certain TTI queries, while letting the
// target independent and default TTI implementations handle the rest.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H
#define LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H

#include "AVR.h"
#include "AVRSubtarget.h"
#include "AVRTargetMachine.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/Target/TargetLowering.h"

namespace llvm {
class AVRTTIImpl : public BasicTTIImplBase<AVRTTIImpl, HarvardArchitecture<>> {
  typedef BasicTTIImplBase<AVRTTIImpl, HarvardArchitecture<>> BaseT;
  typedef TargetTransformInfo TTI;
  friend BaseT;

  const AVRSubtarget *ST;
  const AVRTargetLowering *TLI;

  const AVRSubtarget *getST() const { return ST; }
  const AVRTargetLowering *getTLI() const { return TLI; }

public:
  explicit AVRTTIImpl(const AVRTargetMachine *TM, const Function &F)
      : BaseT(TM, F.getParent()->getDataLayout()), ST(TM->getSubtargetImpl(F)),
        TLI(ST->getTargetLowering()) {}

  unsigned getSwitchTableAddressSpace() const { return AVR::ProgramMemory; }
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H
