; RUN: opt < %s -cost-model -analyze -mtriple=systemz-unknown -mcpu=z13 | FileCheck %s
;
; Note: The scalarized vector instructions costs are not including any
; extracts, due to the undef operands.

define void @fpext() {
  %v0 = fpext double undef to fp128
  %v1 = fpext float undef to fp128
  %v2 = fpext float undef to double
  %v3 = fpext <2 x double> undef to <2 x fp128>
  %v4 = fpext <2 x float> undef to <2 x fp128>
  %v5 = fpext <2 x float> undef to <2 x double>
  %v6 = fpext <4 x double> undef to <4 x fp128>
  %v7 = fpext <4 x float> undef to <4 x fp128>
  %v8 = fpext <4 x float> undef to <4 x double>
  %v9 = fpext <8 x double> undef to <8 x fp128>
  %v10 = fpext <8 x float> undef to <8 x fp128>
  %v11 = fpext <8 x float> undef to <8 x double>
  %v12 = fpext <16 x float> undef to <16 x double>

; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = fpext double undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = fpext float undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = fpext float undef to double
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v3 = fpext <2 x double> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v4 = fpext <2 x float> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v5 = fpext <2 x float> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v6 = fpext <4 x double> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v7 = fpext <4 x float> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v8 = fpext <4 x float> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v9 = fpext <8 x double> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v10 = fpext <8 x float> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v11 = fpext <8 x float> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v12 = fpext <16 x float> undef to <16 x double>

  ret void;
}

define void @fptosi() {
  %v0 = fptosi fp128 undef to i64
  %v1 = fptosi fp128 undef to i32
  %v2 = fptosi fp128 undef to i16
  %v3 = fptosi fp128 undef to i8
  %v4 = fptosi double undef to i64
  %v5 = fptosi double undef to i32
  %v6 = fptosi double undef to i16
  %v7 = fptosi double undef to i8
  %v8 = fptosi float undef to i64
  %v9 = fptosi float undef to i32
  %v10 = fptosi float undef to i16
  %v11 = fptosi float undef to i8
  %v12 = fptosi <2 x fp128> undef to <2 x i64>
  %v13 = fptosi <2 x fp128> undef to <2 x i32>
  %v14 = fptosi <2 x fp128> undef to <2 x i16>
  %v15 = fptosi <2 x fp128> undef to <2 x i8>
  %v16 = fptosi <2 x double> undef to <2 x i64>
  %v17 = fptosi <2 x double> undef to <2 x i32>
  %v18 = fptosi <2 x double> undef to <2 x i16>
  %v19 = fptosi <2 x double> undef to <2 x i8>
  %v20 = fptosi <2 x float> undef to <2 x i64>
  %v21 = fptosi <2 x float> undef to <2 x i32>
  %v22 = fptosi <2 x float> undef to <2 x i16>
  %v23 = fptosi <2 x float> undef to <2 x i8>
  %v24 = fptosi <4 x fp128> undef to <4 x i64>
  %v25 = fptosi <4 x fp128> undef to <4 x i32>
  %v26 = fptosi <4 x fp128> undef to <4 x i16>
  %v27 = fptosi <4 x fp128> undef to <4 x i8>
  %v28 = fptosi <4 x double> undef to <4 x i64>
  %v29 = fptosi <4 x double> undef to <4 x i32>
  %v30 = fptosi <4 x double> undef to <4 x i16>
  %v31 = fptosi <4 x double> undef to <4 x i8>
  %v32 = fptosi <4 x float> undef to <4 x i64>
  %v33 = fptosi <4 x float> undef to <4 x i32>
  %v34 = fptosi <4 x float> undef to <4 x i16>
  %v35 = fptosi <4 x float> undef to <4 x i8>
  %v36 = fptosi <8 x fp128> undef to <8 x i64>
  %v37 = fptosi <8 x fp128> undef to <8 x i32>
  %v38 = fptosi <8 x fp128> undef to <8 x i16>
  %v39 = fptosi <8 x fp128> undef to <8 x i8>
  %v40 = fptosi <8 x double> undef to <8 x i64>
  %v41 = fptosi <8 x double> undef to <8 x i32>
  %v42 = fptosi <8 x double> undef to <8 x i16>
  %v43 = fptosi <8 x double> undef to <8 x i8>
  %v44 = fptosi <8 x float> undef to <8 x i64>
  %v45 = fptosi <8 x float> undef to <8 x i32>
  %v46 = fptosi <8 x float> undef to <8 x i16>
  %v47 = fptosi <8 x float> undef to <8 x i8>
  %v48 = fptosi <16 x double> undef to <16 x i64>
  %v49 = fptosi <16 x double> undef to <16 x i32>
  %v50 = fptosi <16 x double> undef to <16 x i16>
  %v51 = fptosi <16 x double> undef to <16 x i8>
  %v52 = fptosi <16 x float> undef to <16 x i64>
  %v53 = fptosi <16 x float> undef to <16 x i32>
  %v54 = fptosi <16 x float> undef to <16 x i16>
  %v55 = fptosi <16 x float> undef to <16 x i8>

; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = fptosi fp128 undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = fptosi fp128 undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = fptosi fp128 undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v3 = fptosi fp128 undef to i8
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v4 = fptosi double undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v5 = fptosi double undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v6 = fptosi double undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v7 = fptosi double undef to i8
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v8 = fptosi float undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v9 = fptosi float undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v10 = fptosi float undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v11 = fptosi float undef to i8
; CHECK: Cost Model: Found an estimated cost of 3 for instruction:   %v12 = fptosi <2 x fp128> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v13 = fptosi <2 x fp128> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v14 = fptosi <2 x fp128> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v15 = fptosi <2 x fp128> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v16 = fptosi <2 x double> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v17 = fptosi <2 x double> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v18 = fptosi <2 x double> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v19 = fptosi <2 x double> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 5 for instruction:   %v20 = fptosi <2 x float> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v21 = fptosi <2 x float> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v22 = fptosi <2 x float> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v23 = fptosi <2 x float> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v24 = fptosi <4 x fp128> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v25 = fptosi <4 x fp128> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v26 = fptosi <4 x fp128> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v27 = fptosi <4 x fp128> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v28 = fptosi <4 x double> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v29 = fptosi <4 x double> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v30 = fptosi <4 x double> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v31 = fptosi <4 x double> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 10 for instruction:   %v32 = fptosi <4 x float> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v33 = fptosi <4 x float> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v34 = fptosi <4 x float> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v35 = fptosi <4 x float> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v36 = fptosi <8 x fp128> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v37 = fptosi <8 x fp128> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v38 = fptosi <8 x fp128> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v39 = fptosi <8 x fp128> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v40 = fptosi <8 x double> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v41 = fptosi <8 x double> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v42 = fptosi <8 x double> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v43 = fptosi <8 x double> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 20 for instruction:   %v44 = fptosi <8 x float> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v45 = fptosi <8 x float> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v46 = fptosi <8 x float> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v47 = fptosi <8 x float> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v48 = fptosi <16 x double> undef to <16 x i64>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v49 = fptosi <16 x double> undef to <16 x i32>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v50 = fptosi <16 x double> undef to <16 x i16>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v51 = fptosi <16 x double> undef to <16 x i8>
; CHECK: Cost Model: Found an estimated cost of 40 for instruction:   %v52 = fptosi <16 x float> undef to <16 x i64>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v53 = fptosi <16 x float> undef to <16 x i32>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v54 = fptosi <16 x float> undef to <16 x i16>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v55 = fptosi <16 x float> undef to <16 x i8>

  ret void;
}


define void @fptoui() {
  %v0 = fptoui fp128 undef to i64
  %v1 = fptoui fp128 undef to i32
  %v2 = fptoui fp128 undef to i16
  %v3 = fptoui fp128 undef to i8
  %v4 = fptoui double undef to i64
  %v5 = fptoui double undef to i32
  %v6 = fptoui double undef to i16
  %v7 = fptoui double undef to i8
  %v8 = fptoui float undef to i64
  %v9 = fptoui float undef to i32
  %v10 = fptoui float undef to i16
  %v11 = fptoui float undef to i8
  %v12 = fptoui <2 x fp128> undef to <2 x i64>
  %v13 = fptoui <2 x fp128> undef to <2 x i32>
  %v14 = fptoui <2 x fp128> undef to <2 x i16>
  %v15 = fptoui <2 x fp128> undef to <2 x i8>
  %v16 = fptoui <2 x double> undef to <2 x i64>
  %v17 = fptoui <2 x double> undef to <2 x i32>
  %v18 = fptoui <2 x double> undef to <2 x i16>
  %v19 = fptoui <2 x double> undef to <2 x i8>
  %v20 = fptoui <2 x float> undef to <2 x i64>
  %v21 = fptoui <2 x float> undef to <2 x i32>
  %v22 = fptoui <2 x float> undef to <2 x i16>
  %v23 = fptoui <2 x float> undef to <2 x i8>
  %v24 = fptoui <4 x fp128> undef to <4 x i64>
  %v25 = fptoui <4 x fp128> undef to <4 x i32>
  %v26 = fptoui <4 x fp128> undef to <4 x i16>
  %v27 = fptoui <4 x fp128> undef to <4 x i8>
  %v28 = fptoui <4 x double> undef to <4 x i64>
  %v29 = fptoui <4 x double> undef to <4 x i32>
  %v30 = fptoui <4 x double> undef to <4 x i16>
  %v31 = fptoui <4 x double> undef to <4 x i8>
  %v32 = fptoui <4 x float> undef to <4 x i64>
  %v33 = fptoui <4 x float> undef to <4 x i32>
  %v34 = fptoui <4 x float> undef to <4 x i16>
  %v35 = fptoui <4 x float> undef to <4 x i8>
  %v36 = fptoui <8 x fp128> undef to <8 x i64>
  %v37 = fptoui <8 x fp128> undef to <8 x i32>
  %v38 = fptoui <8 x fp128> undef to <8 x i16>
  %v39 = fptoui <8 x fp128> undef to <8 x i8>
  %v40 = fptoui <8 x double> undef to <8 x i64>
  %v41 = fptoui <8 x double> undef to <8 x i32>
  %v42 = fptoui <8 x double> undef to <8 x i16>
  %v43 = fptoui <8 x double> undef to <8 x i8>
  %v44 = fptoui <8 x float> undef to <8 x i64>
  %v45 = fptoui <8 x float> undef to <8 x i32>
  %v46 = fptoui <8 x float> undef to <8 x i16>
  %v47 = fptoui <8 x float> undef to <8 x i8>
  %v48 = fptoui <16 x double> undef to <16 x i64>
  %v49 = fptoui <16 x double> undef to <16 x i32>
  %v50 = fptoui <16 x double> undef to <16 x i16>
  %v51 = fptoui <16 x double> undef to <16 x i8>
  %v52 = fptoui <16 x float> undef to <16 x i64>
  %v53 = fptoui <16 x float> undef to <16 x i32>
  %v54 = fptoui <16 x float> undef to <16 x i16>
  %v55 = fptoui <16 x float> undef to <16 x i8>

; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = fptoui fp128 undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = fptoui fp128 undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = fptoui fp128 undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v3 = fptoui fp128 undef to i8
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v4 = fptoui double undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v5 = fptoui double undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v6 = fptoui double undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v7 = fptoui double undef to i8
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v8 = fptoui float undef to i64
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v9 = fptoui float undef to i32
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v10 = fptoui float undef to i16
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v11 = fptoui float undef to i8
; CHECK: Cost Model: Found an estimated cost of 3 for instruction:   %v12 = fptoui <2 x fp128> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v13 = fptoui <2 x fp128> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v14 = fptoui <2 x fp128> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v15 = fptoui <2 x fp128> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v16 = fptoui <2 x double> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v17 = fptoui <2 x double> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v18 = fptoui <2 x double> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v19 = fptoui <2 x double> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 5 for instruction:   %v20 = fptoui <2 x float> undef to <2 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v21 = fptoui <2 x float> undef to <2 x i32>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v22 = fptoui <2 x float> undef to <2 x i16>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v23 = fptoui <2 x float> undef to <2 x i8>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v24 = fptoui <4 x fp128> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v25 = fptoui <4 x fp128> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v26 = fptoui <4 x fp128> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v27 = fptoui <4 x fp128> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v28 = fptoui <4 x double> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v29 = fptoui <4 x double> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v30 = fptoui <4 x double> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v31 = fptoui <4 x double> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 10 for instruction:   %v32 = fptoui <4 x float> undef to <4 x i64>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v33 = fptoui <4 x float> undef to <4 x i32>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v34 = fptoui <4 x float> undef to <4 x i16>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v35 = fptoui <4 x float> undef to <4 x i8>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v36 = fptoui <8 x fp128> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v37 = fptoui <8 x fp128> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v38 = fptoui <8 x fp128> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v39 = fptoui <8 x fp128> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v40 = fptoui <8 x double> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v41 = fptoui <8 x double> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v42 = fptoui <8 x double> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v43 = fptoui <8 x double> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 20 for instruction:   %v44 = fptoui <8 x float> undef to <8 x i64>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v45 = fptoui <8 x float> undef to <8 x i32>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v46 = fptoui <8 x float> undef to <8 x i16>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v47 = fptoui <8 x float> undef to <8 x i8>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v48 = fptoui <16 x double> undef to <16 x i64>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v49 = fptoui <16 x double> undef to <16 x i32>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v50 = fptoui <16 x double> undef to <16 x i16>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v51 = fptoui <16 x double> undef to <16 x i8>
; CHECK: Cost Model: Found an estimated cost of 40 for instruction:   %v52 = fptoui <16 x float> undef to <16 x i64>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v53 = fptoui <16 x float> undef to <16 x i32>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v54 = fptoui <16 x float> undef to <16 x i16>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v55 = fptoui <16 x float> undef to <16 x i8>

  ret void;
}

define void @fptrunc() {
  %v0 = fptrunc fp128 undef to double
  %v1 = fptrunc fp128 undef to float
  %v2 = fptrunc double undef to float
  %v3 = fptrunc <2 x fp128> undef to <2 x double>
  %v4 = fptrunc <2 x fp128> undef to <2 x float>
  %v5 = fptrunc <2 x double> undef to <2 x float>
  %v6 = fptrunc <4 x fp128> undef to <4 x double>
  %v7 = fptrunc <4 x fp128> undef to <4 x float>
  %v8 = fptrunc <4 x double> undef to <4 x float>
  %v9 = fptrunc <8 x fp128> undef to <8 x double>
  %v10 = fptrunc <8 x fp128> undef to <8 x float>
  %v11 = fptrunc <8 x double> undef to <8 x float>
  %v12 = fptrunc <16 x double> undef to <16 x float>

; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = fptrunc fp128 undef to double
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = fptrunc fp128 undef to float
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = fptrunc double undef to float
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v3 = fptrunc <2 x fp128> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v4 = fptrunc <2 x fp128> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v5 = fptrunc <2 x double> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v6 = fptrunc <4 x fp128> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v7 = fptrunc <4 x fp128> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 3 for instruction:   %v8 = fptrunc <4 x double> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v9 = fptrunc <8 x fp128> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v10 = fptrunc <8 x fp128> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v11 = fptrunc <8 x double> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v12 = fptrunc <16 x double> undef to <16 x float>

  ret void;
}

define void @sitofp() {
  %v0 = sitofp i64 undef to fp128
  %v1 = sitofp i64 undef to double
  %v2 = sitofp i64 undef to float
  %v3 = sitofp i32 undef to fp128
  %v4 = sitofp i32 undef to double
  %v5 = sitofp i32 undef to float
  %v6 = sitofp i16 undef to fp128
  %v7 = sitofp i16 undef to double
  %v8 = sitofp i16 undef to float
  %v9 = sitofp i8 undef to fp128
  %v10 = sitofp i8 undef to double
  %v11 = sitofp i8 undef to float
  %v12 = sitofp <2 x i64> undef to <2 x fp128>
  %v13 = sitofp <2 x i64> undef to <2 x double>
  %v14 = sitofp <2 x i64> undef to <2 x float>
  %v15 = sitofp <2 x i32> undef to <2 x fp128>
  %v16 = sitofp <2 x i32> undef to <2 x double>
  %v17 = sitofp <2 x i32> undef to <2 x float>
  %v18 = sitofp <2 x i16> undef to <2 x fp128>
  %v19 = sitofp <2 x i16> undef to <2 x double>
  %v20 = sitofp <2 x i16> undef to <2 x float>
  %v21 = sitofp <2 x i8> undef to <2 x fp128>
  %v22 = sitofp <2 x i8> undef to <2 x double>
  %v23 = sitofp <2 x i8> undef to <2 x float>
  %v24 = sitofp <4 x i64> undef to <4 x fp128>
  %v25 = sitofp <4 x i64> undef to <4 x double>
  %v26 = sitofp <4 x i64> undef to <4 x float>
  %v27 = sitofp <4 x i32> undef to <4 x fp128>
  %v28 = sitofp <4 x i32> undef to <4 x double>
  %v29 = sitofp <4 x i32> undef to <4 x float>
  %v30 = sitofp <4 x i16> undef to <4 x fp128>
  %v31 = sitofp <4 x i16> undef to <4 x double>
  %v32 = sitofp <4 x i16> undef to <4 x float>
  %v33 = sitofp <4 x i8> undef to <4 x fp128>
  %v34 = sitofp <4 x i8> undef to <4 x double>
  %v35 = sitofp <4 x i8> undef to <4 x float>
  %v36 = sitofp <8 x i64> undef to <8 x fp128>
  %v37 = sitofp <8 x i64> undef to <8 x double>
  %v38 = sitofp <8 x i64> undef to <8 x float>
  %v39 = sitofp <8 x i32> undef to <8 x fp128>
  %v40 = sitofp <8 x i32> undef to <8 x double>
  %v41 = sitofp <8 x i32> undef to <8 x float>
  %v42 = sitofp <8 x i16> undef to <8 x fp128>
  %v43 = sitofp <8 x i16> undef to <8 x double>
  %v44 = sitofp <8 x i16> undef to <8 x float>
  %v45 = sitofp <8 x i8> undef to <8 x fp128>
  %v46 = sitofp <8 x i8> undef to <8 x double>
  %v47 = sitofp <8 x i8> undef to <8 x float>
  %v48 = sitofp <16 x i64> undef to <16 x double>
  %v49 = sitofp <16 x i64> undef to <16 x float>
  %v50 = sitofp <16 x i32> undef to <16 x double>
  %v51 = sitofp <16 x i32> undef to <16 x float>
  %v52 = sitofp <16 x i16> undef to <16 x double>
  %v53 = sitofp <16 x i16> undef to <16 x float>
  %v54 = sitofp <16 x i8> undef to <16 x double>
  %v55 = sitofp <16 x i8> undef to <16 x float>
  
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = sitofp i64 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = sitofp i64 undef to double
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = sitofp i64 undef to float
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v3 = sitofp i32 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v4 = sitofp i32 undef to double
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v5 = sitofp i32 undef to float
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v6 = sitofp i16 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v7 = sitofp i16 undef to double
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v8 = sitofp i16 undef to float
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v9 = sitofp i8 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v10 = sitofp i8 undef to double
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v11 = sitofp i8 undef to float
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v12 = sitofp <2 x i64> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v13 = sitofp <2 x i64> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v14 = sitofp <2 x i64> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v15 = sitofp <2 x i32> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v16 = sitofp <2 x i32> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v17 = sitofp <2 x i32> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v18 = sitofp <2 x i16> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v19 = sitofp <2 x i16> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v20 = sitofp <2 x i16> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v21 = sitofp <2 x i8> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v22 = sitofp <2 x i8> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v23 = sitofp <2 x i8> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v24 = sitofp <4 x i64> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v25 = sitofp <4 x i64> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v26 = sitofp <4 x i64> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v27 = sitofp <4 x i32> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v28 = sitofp <4 x i32> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v29 = sitofp <4 x i32> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v30 = sitofp <4 x i16> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v31 = sitofp <4 x i16> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v32 = sitofp <4 x i16> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v33 = sitofp <4 x i8> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v34 = sitofp <4 x i8> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v35 = sitofp <4 x i8> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v36 = sitofp <8 x i64> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v37 = sitofp <8 x i64> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v38 = sitofp <8 x i64> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v39 = sitofp <8 x i32> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v40 = sitofp <8 x i32> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v41 = sitofp <8 x i32> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v42 = sitofp <8 x i16> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v43 = sitofp <8 x i16> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v44 = sitofp <8 x i16> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v45 = sitofp <8 x i8> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v46 = sitofp <8 x i8> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v47 = sitofp <8 x i8> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v48 = sitofp <16 x i64> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v49 = sitofp <16 x i64> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v50 = sitofp <16 x i32> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v51 = sitofp <16 x i32> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v52 = sitofp <16 x i16> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v53 = sitofp <16 x i16> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v54 = sitofp <16 x i8> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v55 = sitofp <16 x i8> undef to <16 x float>

  ret void;
}

define void @uitofp() {
  %v0 = uitofp i64 undef to fp128
  %v1 = uitofp i64 undef to double
  %v2 = uitofp i64 undef to float
  %v3 = uitofp i32 undef to fp128
  %v4 = uitofp i32 undef to double
  %v5 = uitofp i32 undef to float
  %v6 = uitofp i16 undef to fp128
  %v7 = uitofp i16 undef to double
  %v8 = uitofp i16 undef to float
  %v9 = uitofp i8 undef to fp128
  %v10 = uitofp i8 undef to double
  %v11 = uitofp i8 undef to float
  %v12 = uitofp <2 x i64> undef to <2 x fp128>
  %v13 = uitofp <2 x i64> undef to <2 x double>
  %v14 = uitofp <2 x i64> undef to <2 x float>
  %v15 = uitofp <2 x i32> undef to <2 x fp128>
  %v16 = uitofp <2 x i32> undef to <2 x double>
  %v17 = uitofp <2 x i32> undef to <2 x float>
  %v18 = uitofp <2 x i16> undef to <2 x fp128>
  %v19 = uitofp <2 x i16> undef to <2 x double>
  %v20 = uitofp <2 x i16> undef to <2 x float>
  %v21 = uitofp <2 x i8> undef to <2 x fp128>
  %v22 = uitofp <2 x i8> undef to <2 x double>
  %v23 = uitofp <2 x i8> undef to <2 x float>
  %v24 = uitofp <4 x i64> undef to <4 x fp128>
  %v25 = uitofp <4 x i64> undef to <4 x double>
  %v26 = uitofp <4 x i64> undef to <4 x float>
  %v27 = uitofp <4 x i32> undef to <4 x fp128>
  %v28 = uitofp <4 x i32> undef to <4 x double>
  %v29 = uitofp <4 x i32> undef to <4 x float>
  %v30 = uitofp <4 x i16> undef to <4 x fp128>
  %v31 = uitofp <4 x i16> undef to <4 x double>
  %v32 = uitofp <4 x i16> undef to <4 x float>
  %v33 = uitofp <4 x i8> undef to <4 x fp128>
  %v34 = uitofp <4 x i8> undef to <4 x double>
  %v35 = uitofp <4 x i8> undef to <4 x float>
  %v36 = uitofp <8 x i64> undef to <8 x fp128>
  %v37 = uitofp <8 x i64> undef to <8 x double>
  %v38 = uitofp <8 x i64> undef to <8 x float>
  %v39 = uitofp <8 x i32> undef to <8 x fp128>
  %v40 = uitofp <8 x i32> undef to <8 x double>
  %v41 = uitofp <8 x i32> undef to <8 x float>
  %v42 = uitofp <8 x i16> undef to <8 x fp128>
  %v43 = uitofp <8 x i16> undef to <8 x double>
  %v44 = uitofp <8 x i16> undef to <8 x float>
  %v45 = uitofp <8 x i8> undef to <8 x fp128>
  %v46 = uitofp <8 x i8> undef to <8 x double>
  %v47 = uitofp <8 x i8> undef to <8 x float>
  %v48 = uitofp <16 x i64> undef to <16 x double>
  %v49 = uitofp <16 x i64> undef to <16 x float>
  %v50 = uitofp <16 x i32> undef to <16 x double>
  %v51 = uitofp <16 x i32> undef to <16 x float>
  %v52 = uitofp <16 x i16> undef to <16 x double>
  %v53 = uitofp <16 x i16> undef to <16 x float>
  %v54 = uitofp <16 x i8> undef to <16 x double>
  %v55 = uitofp <16 x i8> undef to <16 x float>
  
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v0 = uitofp i64 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v1 = uitofp i64 undef to double
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v2 = uitofp i64 undef to float
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v3 = uitofp i32 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v4 = uitofp i32 undef to double
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v5 = uitofp i32 undef to float
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v6 = uitofp i16 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v7 = uitofp i16 undef to double
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v8 = uitofp i16 undef to float
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v9 = uitofp i8 undef to fp128
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v10 = uitofp i8 undef to double
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v11 = uitofp i8 undef to float
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v12 = uitofp <2 x i64> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 1 for instruction:   %v13 = uitofp <2 x i64> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v14 = uitofp <2 x i64> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v15 = uitofp <2 x i32> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v16 = uitofp <2 x i32> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v17 = uitofp <2 x i32> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v18 = uitofp <2 x i16> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v19 = uitofp <2 x i16> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v20 = uitofp <2 x i16> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 6 for instruction:   %v21 = uitofp <2 x i8> undef to <2 x fp128>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v22 = uitofp <2 x i8> undef to <2 x double>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v23 = uitofp <2 x i8> undef to <2 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v24 = uitofp <4 x i64> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 2 for instruction:   %v25 = uitofp <4 x i64> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v26 = uitofp <4 x i64> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v27 = uitofp <4 x i32> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v28 = uitofp <4 x i32> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v29 = uitofp <4 x i32> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v30 = uitofp <4 x i16> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v31 = uitofp <4 x i16> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v32 = uitofp <4 x i16> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 12 for instruction:   %v33 = uitofp <4 x i8> undef to <4 x fp128>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v34 = uitofp <4 x i8> undef to <4 x double>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v35 = uitofp <4 x i8> undef to <4 x float>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v36 = uitofp <8 x i64> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 4 for instruction:   %v37 = uitofp <8 x i64> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v38 = uitofp <8 x i64> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 16 for instruction:   %v39 = uitofp <8 x i32> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v40 = uitofp <8 x i32> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v41 = uitofp <8 x i32> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v42 = uitofp <8 x i16> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v43 = uitofp <8 x i16> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v44 = uitofp <8 x i16> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 24 for instruction:   %v45 = uitofp <8 x i8> undef to <8 x fp128>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v46 = uitofp <8 x i8> undef to <8 x double>
; CHECK: Cost Model: Found an estimated cost of 32 for instruction:   %v47 = uitofp <8 x i8> undef to <8 x float>
; CHECK: Cost Model: Found an estimated cost of 8 for instruction:   %v48 = uitofp <16 x i64> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v49 = uitofp <16 x i64> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v50 = uitofp <16 x i32> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 48 for instruction:   %v51 = uitofp <16 x i32> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v52 = uitofp <16 x i16> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v53 = uitofp <16 x i16> undef to <16 x float>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v54 = uitofp <16 x i8> undef to <16 x double>
; CHECK: Cost Model: Found an estimated cost of 64 for instruction:   %v55 = uitofp <16 x i8> undef to <16 x float>

  ret void;
}
