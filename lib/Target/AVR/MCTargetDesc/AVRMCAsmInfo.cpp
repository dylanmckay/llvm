//===-- AVRMCAsmInfo.cpp - AVR asm properties -----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the AVRMCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "AVRMCAsmInfo.h"

#include "llvm/ADT/Triple.h"

namespace llvm {

AVRMCAsmInfo::AVRMCAsmInfo(const Triple &TT) {
  // Architecture settings.
  CodePointerSize = 2;
  CalleeSaveStackSlotSize = 2;

  // Assembly language settings.
  CommentString = ";";
  PrivateGlobalPrefix = ".L";
  UseIntegratedAssembler = true;

  UsesELFSectionDirectiveForBSS = true;
  SupportsDebugInformation = true;
}

} // end of namespace llvm
