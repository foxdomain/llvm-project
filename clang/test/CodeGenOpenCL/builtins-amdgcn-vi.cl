// REQUIRES: amdgpu-registered-target
// RUN: %clang_cc1 -triple amdgcn-unknown-unknown -target-cpu tonga -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple amdgcn-unknown-unknown -target-cpu gfx900 -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple amdgcn-unknown-unknown -target-cpu gfx1010 -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple amdgcn-unknown-unknown -target-cpu gfx1012 -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple spirv64-amd-amdhsa -emit-llvm -o - %s | FileCheck %s

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

typedef unsigned long ulong;
typedef unsigned int  uint;

// CHECK-LABEL: @test_div_fixup_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.div.fixup.f16
void test_div_fixup_f16(global half* out, half a, half b, half c)
{
  *out = __builtin_amdgcn_div_fixuph(a, b, c);
}

// CHECK-LABEL: @test_rcp_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.rcp.f16
void test_rcp_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_rcph(a);
}

// CHECK-LABEL: @test_sqrt_f16
// CHECK: {{.*}}call{{.*}} half @llvm.{{((amdgcn.){0,1})}}sqrt.f16
void test_sqrt_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_sqrth(a);
}

// CHECK-LABEL: @test_rsq_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.rsq.f16
void test_rsq_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_rsqh(a);
}

// CHECK-LABEL: @test_sin_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.sin.f16
void test_sin_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_sinh(a);
}

// CHECK-LABEL: @test_cos_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.cos.f16
void test_cos_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_cosh(a);
}

// CHECK-LABEL: @test_ldexp_f16
// CHECK: [[TRUNC:%[0-9a-z]+]] = trunc i32
// CHECK: {{.*}}call{{.*}} half @llvm.ldexp.f16.i16(half %a, i16 [[TRUNC]])
void test_ldexp_f16(global half* out, half a, int b)
{
  *out = __builtin_amdgcn_ldexph(a, b);
}

// CHECK-LABEL: @test_frexp_mant_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.frexp.mant.f16
void test_frexp_mant_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_frexp_manth(a);
}

// CHECK-LABEL: @test_frexp_exp_f16
// CHECK: {{.*}}call{{.*}} i16 @llvm.amdgcn.frexp.exp.i16.f16
void test_frexp_exp_f16(global short* out, half a)
{
  *out = __builtin_amdgcn_frexp_exph(a);
}

// CHECK-LABEL: @test_fract_f16
// CHECK: {{.*}}call{{.*}} half @llvm.amdgcn.fract.f16
void test_fract_f16(global half* out, half a)
{
  *out = __builtin_amdgcn_fracth(a);
}

// CHECK-LABEL: @test_class_f16
// CHECK: {{.*}}call{{.*}} i1 @llvm.amdgcn.class.f16
void test_class_f16(global half* out, half a, int b)
{
  *out = __builtin_amdgcn_classh(a, b);
}

// CHECK-LABEL: @test_s_memrealtime
// CHECK: {{.*}}call{{.*}} i64 @llvm.amdgcn.s.memrealtime()
void test_s_memrealtime(global ulong* out)
{
  *out = __builtin_amdgcn_s_memrealtime();
}

// CHECK-LABEL: @test_s_dcache_wb()
// CHECK: {{.*}}call{{.*}} void @llvm.amdgcn.s.dcache.wb()
void test_s_dcache_wb()
{
  __builtin_amdgcn_s_dcache_wb();
}

// CHECK-LABEL: @test_mov_dpp
// CHECK: {{.*}}call{{.*}} i32 @llvm.amdgcn.update.dpp.i32(i32 poison, i32 %src, i32 0, i32 0, i32 0, i1 false)
void test_mov_dpp(global int* out, int src)
{
  *out = __builtin_amdgcn_mov_dpp(src, 0, 0, 0, false);
}

// CHECK-LABEL: @test_update_dpp
// CHECK: {{.*}}call{{.*}} i32 @llvm.amdgcn.update.dpp.i32(i32 %arg1, i32 %arg2, i32 0, i32 0, i32 0, i1 false)
void test_update_dpp(global int* out, int arg1, int arg2)
{
  *out = __builtin_amdgcn_update_dpp(arg1, arg2, 0, 0, 0, false);
}

// CHECK-LABEL: @test_ds_fadd
// CHECK: {{.*}}call{{.*}} float @llvm.amdgcn.ds.fadd.f32(ptr addrspace(3) %out, float %src, i32 0, i32 0, i1 false)
#if !defined(__SPIRV__)
void test_ds_faddf(local float *out, float src) {
#else
void test_ds_faddf(__attribute__((address_space(3))) float *out, float src) {
#endif
  *out = __builtin_amdgcn_ds_faddf(out, src, 0, 0, false);
}

// CHECK-LABEL: @test_ds_fmin
// CHECK: {{.*}}call{{.*}} float @llvm.amdgcn.ds.fmin.f32(ptr addrspace(3) %out, float %src, i32 0, i32 0, i1 false)
#if !defined(__SPIRV__)
void test_ds_fminf(local float *out, float src) {
#else
void test_ds_fminf(__attribute__((address_space(3))) float *out, float src) {
#endif
  *out = __builtin_amdgcn_ds_fminf(out, src, 0, 0, false);
}

// CHECK-LABEL: @test_ds_fmax
// CHECK: {{.*}}call{{.*}} float @llvm.amdgcn.ds.fmax.f32(ptr addrspace(3) %out, float %src, i32 0, i32 0, i1 false)
#if !defined(__SPIRV__)
void test_ds_fmaxf(local float *out, float src) {
#else
void test_ds_fmaxf(__attribute__((address_space(3))) float *out, float src) {
#endif
  *out = __builtin_amdgcn_ds_fmaxf(out, src, 0, 0, false);
}

// CHECK-LABEL: @test_s_memtime
// CHECK: {{.*}}call{{.*}} i64 @llvm.amdgcn.s.memtime()
void test_s_memtime(global ulong* out)
{
  *out = __builtin_amdgcn_s_memtime();
}

// CHECK-LABEL: @test_perm
// CHECK: {{.*}}call{{.*}} i32 @llvm.amdgcn.perm(i32 %a, i32 %b, i32 %s)
void test_perm(global uint* out, uint a, uint b, uint s)
{
  *out = __builtin_amdgcn_perm(a, b, s);
}

// CHECK-LABEL: @test_groupstaticsize
// CHECK: {{.*}}call{{.*}} i32 @llvm.amdgcn.groupstaticsize()
void test_groupstaticsize(global uint* out)
{
  *out = __builtin_amdgcn_groupstaticsize();
}
