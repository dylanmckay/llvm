//===- NativeExeSymbol.h - native impl for PDBSymbolExe ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DEBUGINFO_PDB_NATIVE_NATIVEEXESYMBOL_H
#define LLVM_DEBUGINFO_PDB_NATIVE_NATIVEEXESYMBOL_H

#include "llvm/DebugInfo/PDB/Native/NativeRawSymbol.h"
#include "llvm/DebugInfo/PDB/Native/NativeSession.h"

namespace llvm {
namespace pdb {

class DbiStream;

class NativeExeSymbol : public NativeRawSymbol {
public:
  NativeExeSymbol(NativeSession &Session, SymIndexId SymbolId);

  std::unique_ptr<NativeRawSymbol> clone() const override;

  std::unique_ptr<IPDBEnumSymbols>
  findChildren(PDB_SymType Type) const override;

  uint32_t getAge() const override;
  std::string getSymbolsFileName() const override;
  codeview::GUID getGuid() const override;
  bool hasCTypes() const override;
  bool hasPrivateSymbols() const override;

  std::unique_ptr<PDBSymbolCompiland> getOrCreateCompiland(uint32_t Index);
  uint32_t getNumCompilands() const;

private:
  PDBFile &File;

  DbiStream *Dbi = nullptr;

  // EXE symbol is the authority on the various symbol types.
  mutable std::vector<SymIndexId> Compilands;
};

} // namespace pdb
} // namespace llvm

#endif
