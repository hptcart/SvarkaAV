Shader "Leviant's Shaders/Procedural Noise"
{
	Properties
	{
		_Multiplier("Multiplier", Float) = 1.0
		_Lift("Lift", Float) = 0.0

		[Enum(Linear, 0, Spherical, 1)]Gradient_Mode("Gradient Mode", Int) = 0
		_GradientRotation("Gradient Rotation", Range(-180, 180)) = 0.0
		_GradientOffset("Gradient Offset", Vector) = (0.5, 0.5, 0, 0)
		_GradientWidth("Gradient Width", Float) = 1.0

		[Header(Noise)]
		_NoiseScale("Scale", Float) = 1.0
		_Noise("Amplitude", Float) = 1.0
		[IntRange] _NoiseOctaves("Octaves", Range(1, 8)) = 1.0

		[Header(Distirtion)]
		_DistorsionScale("Scale", Float) = 1.0
		_Distorsion("Amplitude", Float) = 1.0
		[IntRange] _DistorsionOctaves("Octaves", Range(1, 8)) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		ZWrite Off
		ZTest Off
		Pass
		{
			Name "Main"
			CGPROGRAM
			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityCustomRenderTexture.cginc"
			#include "NoiseFunctions.hlsl"

			const int GRADIENT_LINEAR = 0;
			const int GRADIENT_SPHERICAL = 1;

			uniform float _Multiplier;
			uniform float _Lift;

			uniform float2 _GradientOffset;
			uniform int Gradient_Mode;
			uniform float _GradientRotation;
			uniform float _GradientWidth;

			uniform float _NoiseScale;
			uniform float _Noise;
			uniform int _NoiseOctaves;

			uniform float _DistorsionScale;
			uniform float _Distorsion;
			uniform int _DistorsionOctaves;

			float Gradient(float2 uv)
			{
				float value = 0;
				uv += _GradientOffset;
				if(Gradient_Mode == GRADIENT_LINEAR)
				{
					float angle = radians(_GradientRotation);
					value = dot(uv, float2(cos(angle), sin(angle)));
					value = value / _GradientWidth;
				}
				else //if(Gradient_Mode == GRADIENT_SPHERICAL)
				{
					value = 1.0 - length(uv) / _GradientWidth;
				}
				return value;
			}

			float4 frag (v2f_customrendertexture i) : SV_Target
			{
				float2 uv = i.globalTexcoord;
				float4 color = Gradient(uv);
				float distortionOffset = 1.0 - exp2(-_DistorsionOctaves);
				float noiseOffset = 1.0 - exp2(-_NoiseOctaves);
				uv += _Distorsion * (ValueNoiseFBM4_2D(uv * _DistorsionScale, _DistorsionOctaves) - distortionOffset);
				color += _Noise * (ValueNoiseFBM4_2D(uv * _NoiseScale, _NoiseOctaves) - noiseOffset);
				return color * _Multiplier + _Lift;
			}
			ENDCG
		}
	}
}
