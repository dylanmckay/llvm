#include "Target.h"

#include <cassert>
#include <memory>

#include "MCTargetDesc/X86MCTargetDesc.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

bool operator==(const MCOperand &a, const MCOperand &b) {
  if (a.isImm() && b.isImm())
    return a.getImm() == b.getImm();
  if (a.isReg() && b.isReg())
    return a.getReg() == b.getReg();
  return false;
}

bool operator==(const MCInst &a, const MCInst &b) {
  if (a.getOpcode() != b.getOpcode())
    return false;
  if (a.getNumOperands() != b.getNumOperands())
    return false;
  for (unsigned I = 0; I < a.getNumOperands(); ++I) {
    if (!(a.getOperand(I) == b.getOperand(I)))
      return false;
  }
  return true;
}

} // namespace llvm

namespace exegesis {

void InitializeX86ExegesisTarget();

namespace {

using testing::AllOf;
using testing::ElementsAre;
using testing::ElementsAreArray;
using testing::Eq;
using testing::Gt;
using testing::Matcher;
using testing::NotNull;
using testing::Property;
using testing::SizeIs;

using llvm::APInt;
using llvm::MCInst;
using llvm::MCInstBuilder;
using llvm::MCOperand;

Matcher<MCOperand> IsImm(int64_t Value) {
  return AllOf(Property(&MCOperand::isImm, Eq(true)),
               Property(&MCOperand::getImm, Eq(Value)));
}

Matcher<MCOperand> IsReg(unsigned Reg) {
  return AllOf(Property(&MCOperand::isReg, Eq(true)),
               Property(&MCOperand::getReg, Eq(Reg)));
}

Matcher<MCInst> OpcodeIs(unsigned Opcode) {
  return Property(&MCInst::getOpcode, Eq(Opcode));
}

Matcher<MCInst> IsMovImmediate(unsigned Opcode, int64_t Reg, int64_t Value) {
  return AllOf(OpcodeIs(Opcode), ElementsAre(IsReg(Reg), IsImm(Value)));
}

Matcher<MCInst> IsMovValueToStack(unsigned Opcode, int64_t Value,
                                  size_t Offset) {
  return AllOf(OpcodeIs(Opcode),
               ElementsAre(IsReg(llvm::X86::RSP), IsImm(1), IsReg(0),
                           IsImm(Offset), IsReg(0), IsImm(Value)));
}

Matcher<MCInst> IsMovValueFromStack(unsigned Opcode, unsigned Reg) {
  return AllOf(OpcodeIs(Opcode),
               ElementsAre(IsReg(Reg), IsReg(llvm::X86::RSP), IsImm(1),
                           IsReg(0), IsImm(0), IsReg(0)));
}

Matcher<MCInst> IsStackAllocate(unsigned Size) {
  return AllOf(
      OpcodeIs(llvm::X86::SUB64ri8),
      ElementsAre(IsReg(llvm::X86::RSP), IsReg(llvm::X86::RSP), IsImm(Size)));
}

Matcher<MCInst> IsStackDeallocate(unsigned Size) {
  return AllOf(
      OpcodeIs(llvm::X86::ADD64ri8),
      ElementsAre(IsReg(llvm::X86::RSP), IsReg(llvm::X86::RSP), IsImm(Size)));
}

constexpr const char kTriple[] = "x86_64-unknown-linux";
constexpr const char kFeaturesEmpty[] = "";
constexpr const char kFeaturesAvx[] = "+avx";
constexpr const char kFeaturesAvx512VL[] = "+avx512vl";
constexpr const char kCpuCore2[] = "core2";

template <const char *CPU, const char *Features>
class X86TargetTest : public ::testing::Test {
protected:
  X86TargetTest()
      : ExegesisTarget_(ExegesisTarget::lookup(llvm::Triple(kTriple))) {
    EXPECT_THAT(ExegesisTarget_, NotNull());
    std::string error;
    Target_ = llvm::TargetRegistry::lookupTarget(kTriple, error);
    EXPECT_THAT(Target_, NotNull());
    STI_.reset(Target_->createMCSubtargetInfo(kTriple, kCpuCore2, Features));
  }

  static void SetUpTestCase() {
    LLVMInitializeX86TargetInfo();
    LLVMInitializeX86Target();
    LLVMInitializeX86TargetMC();
    InitializeX86ExegesisTarget();
  }

  std::vector<MCInst> setRegTo(unsigned Reg, const APInt &Value) {
    return ExegesisTarget_->setRegTo(*STI_, Value, Reg);
  }

  const llvm::Target *Target_;
  const ExegesisTarget *const ExegesisTarget_;
  std::unique_ptr<llvm::MCSubtargetInfo> STI_;
};

using Core2TargetTest = X86TargetTest<kCpuCore2, kFeaturesEmpty>;
using Core2AvxTargetTest = X86TargetTest<kCpuCore2, kFeaturesAvx>;
using Core2Avx512TargetTest = X86TargetTest<kCpuCore2, kFeaturesAvx512VL>;

TEST_F(Core2TargetTest, SetRegToGR8Value) {
  const uint8_t Value = 0xFFU;
  const unsigned Reg = llvm::X86::AL;
  EXPECT_THAT(setRegTo(Reg, APInt(8, Value)),
              ElementsAre(IsMovImmediate(llvm::X86::MOV8ri, Reg, Value)));
}

TEST_F(Core2TargetTest, SetRegToGR16Value) {
  const uint16_t Value = 0xFFFFU;
  const unsigned Reg = llvm::X86::BX;
  EXPECT_THAT(setRegTo(Reg, APInt(16, Value)),
              ElementsAre(IsMovImmediate(llvm::X86::MOV16ri, Reg, Value)));
}

TEST_F(Core2TargetTest, SetRegToGR32Value) {
  const uint32_t Value = 0x7FFFFU;
  const unsigned Reg = llvm::X86::ECX;
  EXPECT_THAT(setRegTo(Reg, APInt(32, Value)),
              ElementsAre(IsMovImmediate(llvm::X86::MOV32ri, Reg, Value)));
}

TEST_F(Core2TargetTest, SetRegToGR64Value) {
  const uint64_t Value = 0x7FFFFFFFFFFFFFFFULL;
  const unsigned Reg = llvm::X86::RDX;
  EXPECT_THAT(setRegTo(Reg, APInt(64, Value)),
              ElementsAre(IsMovImmediate(llvm::X86::MOV64ri, Reg, Value)));
}

TEST_F(Core2TargetTest, SetRegToVR64Value) {
  EXPECT_THAT(
      setRegTo(llvm::X86::MM0, APInt(64, 0x1111222233334444ULL)),
      ElementsAre(IsStackAllocate(8),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x33334444UL, 0),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 4),
                  IsMovValueFromStack(llvm::X86::MMX_MOVQ64rm, llvm::X86::MM0),
                  IsStackDeallocate(8)));
}

TEST_F(Core2TargetTest, SetRegToVR128Value_Use_MOVDQUrm) {
  EXPECT_THAT(
      setRegTo(llvm::X86::XMM0,
               APInt(128, "11112222333344445555666677778888", 16)),
      ElementsAre(IsStackAllocate(16),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x77778888UL, 0),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x55556666UL, 4),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x33334444UL, 8),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 12),
                  IsMovValueFromStack(llvm::X86::MOVDQUrm, llvm::X86::XMM0),
                  IsStackDeallocate(16)));
}

TEST_F(Core2AvxTargetTest, SetRegToVR128Value_Use_VMOVDQUrm) {
  EXPECT_THAT(
      setRegTo(llvm::X86::XMM0,
               APInt(128, "11112222333344445555666677778888", 16)),
      ElementsAre(IsStackAllocate(16),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x77778888UL, 0),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x55556666UL, 4),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x33334444UL, 8),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 12),
                  IsMovValueFromStack(llvm::X86::VMOVDQUrm, llvm::X86::XMM0),
                  IsStackDeallocate(16)));
}

TEST_F(Core2Avx512TargetTest, SetRegToVR128Value_Use_VMOVDQU32Z128rm) {
  EXPECT_THAT(
      setRegTo(llvm::X86::XMM0,
               APInt(128, "11112222333344445555666677778888", 16)),
      ElementsAre(
          IsStackAllocate(16),
          IsMovValueToStack(llvm::X86::MOV32mi, 0x77778888UL, 0),
          IsMovValueToStack(llvm::X86::MOV32mi, 0x55556666UL, 4),
          IsMovValueToStack(llvm::X86::MOV32mi, 0x33334444UL, 8),
          IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 12),
          IsMovValueFromStack(llvm::X86::VMOVDQU32Z128rm, llvm::X86::XMM0),
          IsStackDeallocate(16)));
}

TEST_F(Core2AvxTargetTest, SetRegToVR256Value_Use_VMOVDQUYrm) {
  const char ValueStr[] =
      "1111111122222222333333334444444455555555666666667777777788888888";
  EXPECT_THAT(setRegTo(llvm::X86::YMM0, APInt(256, ValueStr, 16)),
              ElementsAreArray(
                  {IsStackAllocate(32),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x88888888UL, 0),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x77777777UL, 4),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x66666666UL, 8),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x55555555UL, 12),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x44444444UL, 16),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x33333333UL, 20),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x22222222UL, 24),
                   IsMovValueToStack(llvm::X86::MOV32mi, 0x11111111UL, 28),
                   IsMovValueFromStack(llvm::X86::VMOVDQUYrm, llvm::X86::YMM0),
                   IsStackDeallocate(32)}));
}

TEST_F(Core2Avx512TargetTest, SetRegToVR256Value_Use_VMOVDQU32Z256rm) {
  const char ValueStr[] =
      "1111111122222222333333334444444455555555666666667777777788888888";
  EXPECT_THAT(
      setRegTo(llvm::X86::YMM0, APInt(256, ValueStr, 16)),
      ElementsAreArray(
          {IsStackAllocate(32),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x88888888UL, 0),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x77777777UL, 4),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x66666666UL, 8),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x55555555UL, 12),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x44444444UL, 16),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x33333333UL, 20),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x22222222UL, 24),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x11111111UL, 28),
           IsMovValueFromStack(llvm::X86::VMOVDQU32Z256rm, llvm::X86::YMM0),
           IsStackDeallocate(32)}));
}

TEST_F(Core2Avx512TargetTest, SetRegToVR512Value) {
  const char ValueStr[] =
      "1111111122222222333333334444444455555555666666667777777788888888"
      "99999999AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF00000000";
  EXPECT_THAT(
      setRegTo(llvm::X86::ZMM0, APInt(512, ValueStr, 16)),
      ElementsAreArray(
          {IsStackAllocate(64),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x00000000UL, 0),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xFFFFFFFFUL, 4),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xEEEEEEEEUL, 8),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xDDDDDDDDUL, 12),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xCCCCCCCCUL, 16),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xBBBBBBBBUL, 20),
           IsMovValueToStack(llvm::X86::MOV32mi, 0xAAAAAAAAUL, 24),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x99999999UL, 28),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x88888888UL, 32),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x77777777UL, 36),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x66666666UL, 40),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x55555555UL, 44),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x44444444UL, 48),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x33333333UL, 52),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x22222222UL, 56),
           IsMovValueToStack(llvm::X86::MOV32mi, 0x11111111UL, 60),
           IsMovValueFromStack(llvm::X86::VMOVDQU32Zrm, llvm::X86::ZMM0),
           IsStackDeallocate(64)}));
}

TEST_F(Core2TargetTest, SetRegToST0_32Bits) {
  EXPECT_THAT(
      setRegTo(llvm::X86::ST0, APInt(32, 0x11112222ULL)),
      ElementsAre(IsStackAllocate(4),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 0),
                  testing::A<MCInst>(), IsStackDeallocate(4)));
}

TEST_F(Core2TargetTest, SetRegToST1_32Bits) {
  const MCInst CopySt0ToSt1 =
      llvm::MCInstBuilder(llvm::X86::ST_Frr).addReg(llvm::X86::ST1);
  EXPECT_THAT(
      setRegTo(llvm::X86::ST1, APInt(32, 0x11112222ULL)),
      ElementsAre(IsStackAllocate(4),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 0),
                  testing::A<MCInst>(), CopySt0ToSt1, IsStackDeallocate(4)));
}

TEST_F(Core2TargetTest, SetRegToST0_64Bits) {
  EXPECT_THAT(
      setRegTo(llvm::X86::ST0, APInt(64, 0x1111222233334444ULL)),
      ElementsAre(IsStackAllocate(8),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x33334444UL, 0),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x11112222UL, 4),
                  testing::A<MCInst>(), IsStackDeallocate(8)));
}

TEST_F(Core2TargetTest, SetRegToST0_80Bits) {
  EXPECT_THAT(
      setRegTo(llvm::X86::ST0, APInt(80, "11112222333344445555", 16)),
      ElementsAre(IsStackAllocate(10),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x44445555UL, 0),
                  IsMovValueToStack(llvm::X86::MOV32mi, 0x22223333UL, 4),
                  IsMovValueToStack(llvm::X86::MOV16mi, 0x1111UL, 8),
                  testing::A<MCInst>(), IsStackDeallocate(10)));
}

} // namespace
} // namespace exegesis
