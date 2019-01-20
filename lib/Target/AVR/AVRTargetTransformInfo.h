//==- AVRTargetTransformInfo.cpp - AVR specific TTI pass -*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
/// \file
/// This file implements a TargetTransformInfo analysis pass specific to the
/// AVR target machine. It uses the target's detailed information to provide
/// more precise answers to certain TTI queries, while letting the target
/// independent and default TTI implementations handle the rest.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H
#define LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H

#include "AVR.h"
#include "AVRSubtarget.h"
#include "AVRTargetMachine.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/IR/Function.h"

namespace llvm {

class AVRTTIImpl : public BasicTTIImplBase<AVRTTIImpl> {
  using BaseT = BasicTTIImplBase<AVRTTIImpl>;
  using TTI = TargetTransformInfo;

  friend BaseT;

  const AVRSubtarget &ST;
  const AVRTargetLowering &TLI;

  const AVRSubtarget *getST() const { return &ST; }
  const AVRTargetLowering *getTLI() const { return &TLI; }

public:
  explicit AVRTTIImpl(const AVRTargetMachine *TM, const Function &F)
      : BaseT(TM, F.getParent()->getDataLayout()),
        ST(*TM->getSubtargetImpl(F)), TLI(*ST.getTargetLowering()) {}

  // AVR specific decision to generate a lookup table.
  bool shouldBuildLookupTables() const;
};

} // end namespace llvm
#endif // LLVM_LIB_TARGET_AVR_AVRTARGETTRANSFORMINFO_H
