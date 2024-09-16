#ifndef NOISE_FUNCTIONS_INCLUDED
#define NOISE_FUNCTIONS_INCLUDED

#include "MatrixHelpers.hlsl"

// Hash without Sine
// MIT License...
// Copyright (c)2014 David Hoskins.

float hash11(float p)
{
	p = frac(p * 0.1031);
	p *= p + 33.33;
	p *= p + p;
	return frac(p);
}

float hash11s(float p)
{
	p = frac(p * 443.8975);
	p *= p + 33.33;
	p *= p + p;
	return frac(p);
}

float hash12(float2 p)
{
	float3 p3 = frac(p.xyx * 0.1031);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z);
}

float hash12s(float2 p)
{
	float3 p3 = frac(p.xyx * 443.8975);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z);
}

float hash13(float3 p3)
{
	p3 = frac(p3 * 0.1031);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z);
}

float hash13s(float3 p3)
{
	p3 = frac(p3 * 443.8975);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z);
}

float2 hash22(float2 p)
{
	float3 p3 = frac(p.xyx * float3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return frac((p3.xx+p3.yz)*p3.zy);
}

float2 hash22s(float2 p)
{
	float3 p3 = frac(p.xyx * float3(443.8975, 397.2973, 491.1871));
    p3 += dot(p3, p3.yzx + 33.33);
    return frac((p3.xx+p3.yz)*p3.zy);
}

float2 hash23s(float3 p3)
{
	p3 = frac(p3 * float3(443.8975, 397.2973, 491.1871));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xx + p3.yz) * p3.zy);
}

float2 hash23(float3 p3)
{
	p3 = frac(p3 * float3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return frac((p3.xx + p3.yz) * p3.zy);
}

float3 hash33s(float3 p3)
{
	p3 = frac(p3 * float3(443.8975, 397.2973, 491.1871));
	p3 += dot(p3, p3.yxz + 19.19);
	return frac((p3.xxy + p3.yxx) * p3.zyx);
}

float3 hash33(float3 p3)
{
	p3 = frac(p3 * float3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz + 19.19);
	return frac((p3.xxy + p3.yxx) * p3.zyx);
}

float4 hash41s(float p)
{
	float4 p4 = frac(p * float4(443.8975, 397.2973, 491.1871, 444.129));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

float4 hash41(float p)
{
	float4 p4 = frac(p * float4(0.1031, 0.1030, 0.0973, 0.1099));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

float4 hash42(float2 p)
{
	float4 p4 = frac(p.xyxy * float4(443.8975, 397.2973, 491.1871, 444.129));
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

float4 hash42s(float2 p)
{
	float4 p4 = frac(p.xyxy * float4(0.1031, 0.1030, 0.0973, 0.1099));
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

float4 hash43s(float3 p)
{
	float4 p4 = frac(p.xyzx * float4(443.8975, 397.2973, 491.1871, 444.129));
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

float4 hash44s(float4 p4)
{
	p4 = frac(p4 * float4(443.8975, 397.2973, 491.1871, 444.129));
	p4 += dot(p4, p4.wzxy + 33.33);
	return frac((p4.xxyz + p4.yzzw) * p4.zywx);
}

uint rand_xorshift(uint rng_state)
{
	// Xorshift algorithm from George Marsaglia's paper
	rng_state ^= (rng_state << 13);
	rng_state ^= (rng_state >> 17);
	rng_state ^= (rng_state << 5);
	return rng_state;
}

/*float2 grad(int2 z)  // replace this anything that returns a random vector
{
    // 2D to 1D  (feel free to replace by some other)
    int n = z.x+z.y*11111;

    // Hugo Elias hash (feel free to replace by another one)
    n = (n<<13)^n;
    n = (n*(n*n*15731+789221)+1376312589)>>16;

#if 0
    // simple random vectors
    return float2(cos(float(n)),sin(float(n)));
#else
    // Perlin style vectors
    n &= 7;
    float2 gr = float2(n&1,n>>1)*2.0-1.0;
    return ( n>=6 ) ? float2(0.0, gr.x) : 
           ( n>=4 ) ? float2(gr.x, 0.0) :
                              gr;
#endif                              
}*/

float2 grad(float2 p)
{
	return normalize(hash22s(p) - 0.5);
}

float sqr(float x)
{
	return x*x;
}

float2 sqr(float2 x)
{
	return x*x;
}

float3 sqr(float3 x)
{
	return x*x;
}

float4 sqr(float4 x)
{
	return x*x;
}

float cubic(float x)
{
	return (3.0 - 2.0 * x) * x * x;
}

float2 cubic(float2 x)
{
	return (3.0 - 2.0 * x) * x * x;
}

float3 cubic(float3 x)
{
	return (3.0 - 2.0 * x) * x * x;
}

float4 cubic(float4 x)
{
	return (3.0 - 2.0 * x) * x * x;
}

float mod(float a, float b)
{
	return frac(a / b) * b;
}

float2 mod(float2 a, float2 b)
{
	return frac(a / b) * b;
}

float3 mod(float3 a, float3 b)
{
	return frac(a / b) * b;
}

float4 mod(float4 a, float4 b)
{
	return frac(a / b) * b;
}

float ValueNoise_2D(float2 uv)
{
	float2 tile = floor(uv);
	float2 f = uv - tile;
	f = cubic(f);
	float a = hash12s(tile + float2(0, 0));
	float b = hash12s(tile + float2(1, 0));
	float c = hash12s(tile + float2(0, 1));
	float d = hash12s(tile + float2(1, 1));

	float ab = lerp(a, b, f.x);
	float cd = lerp(c, d, f.x);
	return lerp(ab, cd, f.y);
}

float3 ValueNoise3_3D(float3 x)
{
	float3 p = floor(x);
	float3 f = x - p;
	f = cubic(f);
	float3 a = lerp(hash33(p + float3(0, 0, 0)), hash33(p + float3(1, 0, 0)), f.x);
	float3 b = lerp(hash33(p + float3(0, 1, 0)), hash33(p + float3(1, 1, 0)), f.x);
	float3 c = lerp(hash33(p + float3(0, 0, 1)), hash33(p + float3(1, 0, 1)), f.x);
	float3 d = lerp(hash33(p + float3(0, 1, 1)), hash33(p + float3(1, 1, 1)), f.x);
	float3 ab = lerp(a, b, f.y);
	float3 cd = lerp(c, d, f.y);
	return lerp(ab, cd, f.z);
}

float4 ValueNoise4_2D(float2 uv)
{
	float2 tile = floor(uv);
	float2 f = uv - tile;
	f = cubic(f);
	float4 a = hash42s(tile + float2(0, 0));
	float4 b = hash42s(tile + float2(1, 0));
	float4 c = hash42s(tile + float2(0, 1));
	float4 d = hash42s(tile + float2(1, 1));

	float4 ab = lerp(a, b, f.x);
	float4 cd = lerp(c, d, f.x);
	return lerp(ab, cd, f.y);
}
float4 ValueNoise4_3D(float3 uvw)
{
	float3 p = floor(uvw);
	float3 f = uvw - p;
	f = cubic(f);
	float4 a = lerp(hash43s(p + float3(0, 0, 0)), hash43s(p + float3(1, 0, 0)), f.x);
	float4 b = lerp(hash43s(p + float3(0, 1, 0)), hash43s(p + float3(1, 1, 0)), f.x);
	float4 c = lerp(hash43s(p + float3(0, 0, 1)), hash43s(p + float3(1, 0, 1)), f.x);
	float4 d = lerp(hash43s(p + float3(0, 1, 1)), hash43s(p + float3(1, 1, 1)), f.x);
	float4 ab = lerp(a, b, f.y);
	float4 cd = lerp(c, d, f.y);
	return lerp(ab, cd, f.z);
}

/*float GradientNoise_2D(float2 p)
{
    int2 i = int2(floor(p));
    float2 f = frac(p);
	
	float2 u = cubic(f); // feel free to replace by a quintic smoothstep instead

    return lerp( lerp( dot( grad( i+int2(0, 0) ), f-float2(0.0, 0.0) ), 
                       dot( grad( i+int2(1, 0) ), f-float2(1.0, 0.0) ), u.x),
                 lerp( dot( grad( i+int2(0, 1) ), f-float2(0.0, 1.0) ), 
                       dot( grad( i+int2(1, 1) ), f-float2(1.0, 1.0) ), u.x), u.y);
}*/

float GradientNoise_2D(float2 p)
{
    float2 i = floor(p);
    float2 f = frac(p);
	
	float2 u = cubic(f); // feel free to replace by a quintic smoothstep instead

    return lerp( lerp( dot( grad( i+float2(0, 0) ), f-float2(0.0, 0.0) ), 
                       dot( grad( i+float2(1, 0) ), f-float2(1.0, 0.0) ), u.x),
                 lerp( dot( grad( i+float2(0, 1) ), f-float2(0.0, 1.0) ), 
                       dot( grad( i+float2(1, 1) ), f-float2(1.0, 1.0) ), u.x), u.y);
}

float SimplexNoise_2D(in float2 p)
{
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;

	float2 i = floor(p + (p.x+p.y)*K1);
    float2 a = p - i + (i.x+i.y)*K2;
    float m = step(a.y, a.x); 
    float2 o = float2(m, 1.0-m);
    float2 b = a - o + K2;
	float2 c = a - 1.0 + 2.0*K2;
    float3 h = max(0.0, 0.5-float3(dot(a, a), dot(b, b), dot(c, c) ));
	float3 n = h*h*h*h*float3(dot(a, hash22(i+0.0)), dot(b, hash22(i+o)), dot(c, hash22(i+1.0)));
    return dot(n, 70.0);
}

/* discontinuous pseudorandom uniformly distributed in [-0.5, +0.5]^3 */
float3 random3(float3 c) 
{
	float j = 4096.0*sin(dot(c, float3(17.0, 59.4, 15.0)));
	float3 r;
	r.z = frac(512.0*j);
	j *= 0.125;
	r.x = frac(512.0*j);
	j *= 0.125;
	r.y = frac(512.0*j);
	return r - 0.5;
}

/* 3d simplex noise */
float SimplexNoise_3D(float3 p) 
{

	/* skew constants for 3d simplex functions */
	const float F3 = 0.3333333;
	const float G3 = 0.1666667;

	 /* 1. find current tetrahedron T and it's four vertices */
	 /* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
	 /* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/
	 
	 /* calculate s and x */
	 float3 s = floor(p + dot(p, F3));
	 float3 x = p - s + dot(s, G3);
	 
	 /* calculate i1 and i2 */
	 float3 e = step(0.0, x - x.yzx);
	 float3 i1 = e*(1.0 - e.zxy);
	 float3 i2 = 1.0 - e.zxy*(1.0 - e);
	 	
	 /* x1, x2, x3 */
	 float3 x1 = x - i1 + G3;
	 float3 x2 = x - i2 + 2.0*G3;
	 float3 x3 = x - 1.0 + 3.0*G3;
	 
	 /* 2. find four surflets and store them in d */
	 float4 w, d;
	 
	 /* calculate surflet weights */
	 w.x = dot(x, x);
	 w.y = dot(x1, x1);
	 w.z = dot(x2, x2);
	 w.w = dot(x3, x3);
	 
	 /* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
	 w = max(0.6 - w, 0.0);
	 
	 /* calculate surflet components */
	 d.x = dot(random3(s), x);
	 d.y = dot(random3(s + i1), x1);
	 d.z = dot(random3(s + i2), x2);
	 d.w = dot(random3(s + 1.0), x3);
	 
	 /* multiply d by w^4 */
	 w *= w;
	 w *= w;
	 d *= w;
	 
	 /* 3. return the sum of the four surflets */
	 return dot(d, 52.0);
}

float4 ValueNoiseFBM_2D(float2 uv, int octaves)
{
	const float2x2 m = GetRotationMatrix2D(radians(222.49));
	float4 result = 0;
	float alpha = 0.5;
	for(int i = octaves; i != 0; i--)
	{
		//result += tex2D(_MainTex, uv + _Time.x) * alpha;
		result += ValueNoise_2D(uv) * alpha;
		uv = mul(m, uv) * 2.0;
		alpha *= 0.5;
	}
	return result / (1.0 - exp2(-octaves));
}

float4 ValueNoiseFBM4_2D(float2 uv, int octaves)
{
	const float2x2 m = GetRotationMatrix2D(radians(222.49));
	float4 result = 0;
	float alpha = 0.5;
	for(int i = octaves; i != 0; i--)
	{
		//result += tex2D(_MainTex, uv + _Time.x) * alpha;
		result += ValueNoise4_2D(uv) * alpha;
		uv = mul(m, uv) * 2.0;
		alpha *= 0.5;
	}
	return result / (1.0 - exp2(-octaves));
}

float4 ValueNoiseFBM4_3D(float3 uvw, int octaves)
{
	const float3x3 m = float3x3(0.3400107, 0.9227173, -0.1816193, -0.5374503, 0.03217846, -0.8426814, -0.7717124, 0.3841321, 0.5068557);		
	float4 result = 0;
	float alpha = 0.5;
	for(int i = octaves; i != 0; i--)
	{
		//result += tex2D(_MainTex, uv + _Time.x) * alpha;
		result += ValueNoise4_3D(uvw) * alpha;
		uvw = mul(m, uvw) * 2.0;
		alpha *= 0.5;
	}
	return result / (1.0 - exp2(-octaves));
}

float psin(float a) 
{
	return 0.5 + 0.5*sin(a);
}

/*float tanh_approx(float x) 
{
	float x2 = x*x;
	return clamp(x*(27.0 + x2)/(27.0+9.0*x2), -1.0, 1.0);
}*/

float tanh_approx(float x) 
{
	x = clamp(x, -3.1430774116, 3.1430774116);
	float x2 = x*x;
	float a = 0.0694961;
	float b = 1.4532600;
	float c = 0.5325770;
	float d = 1.4642800;
	return (a * x2 + b) / (c * x2 + d) * x;
}

float onoise(float2 uv) 
{
	uv *= 0.5;
	float a = sin(uv.x);
	float b = sin(uv.y);
	return lerp(a, b, psin(radians(360)*tanh_approx(a*b+a+b)));
}

float wave(float2 uv, float p)
{
	return pow(psin(uv.x), p);
}

void rot(inout float2 p, float a) 
{
	float2x2 m = GetRotationMatrix2D(a);
	p = mul(m, p);
}

float onoiseFBM(float2 p, int octaves)
{
	float2 op = p;
	const float aa = 0.45;
	const float pp = 2.03;
	const float2 oo = -float2(1.23, 1.5);
	const float2x2 rr = GetRotationMatrix2D(1.2);

	float h = 0.0;
	float d = 0.0;
	float a = 1.0;
  
	[loop]
	for (int i = octaves; i; --i) 
	{
		h += a*onoise(p);
		d += a;
		a *= aa;
		p += oo;
		p *= pp;
		p = mul(rr, p);
	}
	h /= d;
	return h * lerp(1.0, -0.5, pow(ValueNoise_2D(0.9*op), 0.25));
}
#endif