//===- AVRTargetTransformInfo.cpp - AVR specific TTI pass ----------------===//
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

#include "AVRTargetTransformInfo.h"
#include "AVRSubtarget.h"
#include "llvm/Analysis/TargetTransformInfo.h"

using namespace llvm;

#define DEBUG_TYPE "avrtti"

bool AVRTTIImpl::shouldBuildLookupTables() const {
  return false;
}

