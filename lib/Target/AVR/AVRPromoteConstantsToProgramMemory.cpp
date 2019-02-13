//===-- AVRPromoteConstantsInsts.cpp - Expand pseudo instructions -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains a pass that expands pseudo instructions into target
// instructions. This pass should be run after register allocation but before
// the post-regalloc scheduling pass.
//
//===----------------------------------------------------------------------===//

#include "AVR.h"
#include "AVRInstrInfo.h"
#include "AVRTargetMachine.h"
#include "MCTargetDesc/AVRMCTargetDesc.h"

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"

using namespace llvm;

#define PASS_NAME "AVR promote constants to program memory pass"

namespace {

class AVRPromoteConstantsToProgmem : public MachineFunctionPass {
public:
  static char ID;

  AVRPromoteConstantsToProgmem() : MachineFunctionPass(ID), STI(nullptr) {
    initializeAVRPromoteConstantsToProgmemPass(
        *PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override { return PASS_NAME; }

private:
  const AVRSubtarget *STI;
};

char AVRPromoteConstantsToProgmem::ID = 0;

bool AVRPromoteConstantsToProgmem::runOnMachineFunction(MachineFunction &MF) {
  STI = &MF.getSubtarget<AVRSubtarget>();

  // If the microcontroller cannot explicitly load from
  // program memory, no constants can be promoted.
  if (!STI.canLoadProgramMemory()) {
    return false;
  }

  bool Modified = false;

  return Modified;
}

} // end of anonymous namespace

INITIALIZE_PASS(AVRPromoteConstantsToProgmem, "avr-promote-constants-to-progmem",
                PASS_NAME, false, false)

namespace llvm {

FunctionPass *createAVRPromoteConstantsToProgmem() { return new AVRPromoteConstantsToProgmem(); }

} // end of namespace llvm
