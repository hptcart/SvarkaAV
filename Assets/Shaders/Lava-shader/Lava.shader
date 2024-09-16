Shader "Leviant's Shaders/Lava"
{
	Properties
	{
		[HDR] _Color("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0, 1)) = 0.5
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0.0

		[Header(Liquid Metal)]
		[HDR] _LiquidMetalColor("Metal Color", Color) = (0.9, 0.9, 0.9, 1)
		_LiquidMetalUVScale("UV Scale", Float) = 2.0
		_Temperature("Temperature", Range(0,1)) = 1.0
		[HDR] _EmissionTint("Emission Tint", Color) = (8, 8, 8, 1)
		[KeywordEnum(Low, High)] Quality("Normals Quality", int) = 1
		_CustomTime ("Custom Time", Float) = 0.0
		_TimeScale("Auto time speed", Float) = 0.5

		[Header(Fake Reflections)]
		[NoScaleOffset] _LightEnvTex("Cubemap Mask (RGB)", Cube) = "black" {}
		[HDR] _LightEnvColorR("Color R", Color) = (1, 0, 1, 1)
		[HDR] _LightEnvColorG("Color G", Color) = (0, 1, 0, 1)
		[HDR] _LightEnvColorB("Color B", Color) = (0, 1, 1, 1)

		[Header(Height Map)]
		[NoScaleOffset] _HeightMap("Texture", 2D) = "white" {}
		_Fill ("Fill", Float) = 0.5
		_FillWidth ("Fill Width", Range(0.001, 1)) = 0.05
		_Parallax("Height", Range(0.001, 1)) = 0.01
		[IntRange] _MinimumSteps("Minimum Iteration steps", Range(1, 64)) = 1
		[IntRange] _Steps("Iteration steps", Range(1, 64)) = 32
		[IntRange] _BinSteps("Binary search steps", Range(1, 16)) = 8
	}
	HLSLINCLUDE
	#pragma shader_feature_local MODE_LIQUID_METAL MODE_LAVA MODE_LAVA2 MODE_TEST
	#pragma shader_feature_local QUALITY_LOW QUALITY_HIGH
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 4.5
	#define LIGHTPROBE_SH 1
	#define VERTEXLIGHT_ON 1
	#include "HLSLSupport.cginc"
	#include "UnityShaderVariables.cginc"
	#include "UnityShaderUtilities.cginc"
	#include "UnityCG.cginc"
	#include "Lighting.cginc"
	#include "UnityPBSLighting.cginc"
	#include "AutoLight.cginc"
	#include "NoiseFunctions.hlsl"

	uniform sampler2D _MainTex;
	uniform float4 _MainTex_ST;
	uniform sampler2D _HeightMap;
	uniform samplerCUBE _LightEnvTex;
	uniform float3 _Color;
	uniform float _Parallax;
	uniform float3 _EmissionTint;
	uniform int _MinimumSteps;
	uniform float3 _LiquidMetalColor;
	uniform int _Steps;
	uniform float3 _LightEnvColorR;
	uniform int _BinSteps;
	uniform float3 _LightEnvColorG;
	uniform float _LiquidMetalUVScale;
	uniform float3 _LightEnvColorB;
	uniform float _CustomTime;
	uniform float _Fill;
	uniform float _FillWidth;
	uniform float _Temperature;
	uniform float _Glossiness;
	uniform float _Metallic;
	uniform float _TimeScale;

	#define TEMPERATURE 1800.0
	#define INTERNAL_DATA

	// ---- Spot light shadows
	#if defined (SHADOWS_DEPTH) && defined (SPOT)
	#undef TRANSFER_SHADOW
	#define TRANSFER_SHADOW(a) a._ShadowCoord = mul (unity_WorldToShadow[0], float4(worldPos, 1));
	#endif

	// ---- Point light shadows
	#if defined (SHADOWS_CUBE)
	#undef TRANSFER_SHADOW
	#define TRANSFER_SHADOW(a) a._ShadowCoord.xyz = worldPos.xyz - _LightPositionRange.xyz;
	#endif

	struct appdata
	{
		float3 vertex : POSITION;
	#ifndef UNITY_PASS_SHADOWCASTER
		float3 normal : NORMAL;
		float4 tangent : TANGENT;
		float2 texcoord : TEXCOORD0;
	#endif
		UNITY_VERTEX_INPUT_INSTANCE_ID
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
#ifndef UNITY_PASS_SHADOWCASTER
		UNITY_SHADOW_COORDS(0)
		float2 texcoord : TEXCOORD1;
		float4 worldTangent : TEXCOORD2;
		float4 worldBinormal : TEXCOORD3;
		float4 worldNormal : TEXCOORD4;
	#if UNITY_SHOULD_SAMPLE_SH
		float3 sh : TEXCOORD5;
	#endif
		UNITY_FOG_COORDS(6)
#endif
		UNITY_VERTEX_INPUT_INSTANCE_ID
		UNITY_VERTEX_OUTPUT_STEREO
	};

	struct Input
	{
		float2 texcoord;
		float3 worldPos;
		float3 worldNormal;
		float3 texView;
		INTERNAL_DATA
	};

	static float4 dUV;
	static float3 worldPos;
	static float3 worldViewDir;
	static float3x3 TBN;
	static float time = _CustomTime + _TimeScale * _Time.y;

	float3 WorldReflectionVector(Input data, float3 normal)
	{
		return reflect(-worldViewDir, mul(TBN, normal));
	}
	float3 WorldNormalVector(Input data, float3 normal) 
	{
		return mul(TBN, normal);
	}

	float SampleHeight(float2 uv)
	{
		float height = tex2Dgrad(_HeightMap, uv, dUV.xy, dUV.zw).r;
		height += _FillWidth - _Fill;
		height = saturate(height / _FillWidth);
		height = 1.0 - height * height;
		return height;
	}

	float2 ParallaxMapping(sampler2D reliefmap, float2 p, float3 viewDir, float depthScale, out float resultHeight) 
	{
		float depth = 0;
		float3 worldDir = normalize(_WorldSpaceCameraPos - worldPos);
		float complexity = saturate(abs(viewDir.z)/dot(UNITY_MATRIX_V[2], worldDir));
		_Steps = lerp(_Steps, _MinimumSteps, complexity);
		float deltaDepth = 1.0 / _Steps;
		float2 dP = depthScale * deltaDepth * viewDir.xy;
		float layerDepth = 1;
		
		for(int i = _Steps; i; i--) 
		{
			depth = SampleHeight(p);
			if(depth < layerDepth)
			{
				p -= dP;
				layerDepth -= deltaDepth;
			}
		}

		dP *= 0.5;
		deltaDepth *= 0.5;
		p += dP;
		layerDepth += deltaDepth;
		for (i = _BinSteps; i; i--) 
		{
			float depth = SampleHeight(p);
			dP *= 0.5;
			deltaDepth *= 0.5;
			if (depth < layerDepth) 
			{
				p -= dP;
				layerDepth -= deltaDepth;
			}
			else 
			{
				p += dP;
				layerDepth += deltaDepth;
			}
		}
		resultHeight = layerDepth;
		return p;
	}

	float3 blackbody(float t)
	{
		float u = ( 0.860117757 + 1.54118254e-4 * t + 1.28641212e-7 * t*t ) 
				/ ( 1.0 + 8.42420235e-4 * t + 7.08145163e-7 * t*t );
	
		float v = ( 0.317398726 + 4.22806245e-5 * t + 4.20481691e-8 * t*t ) 
				/ ( 1.0 - 2.89741816e-5 * t + 1.61456053e-7 * t*t );

		float x = 3.0*u / (2.0*u - 8.0*v + 4.0);
		float y = 2.0*v / (2.0*u - 8.0*v + 4.0);
		float z = 1.0 - x - y;
	
		float Y = 1.0;
		float X = Y / y * x;
		float Z = Y / y * z;

		float3x3 XYZtoRGB = float3x3(3.2404542, -1.5371385, -0.4985314,
									-0.9692660,  1.8760108,  0.0415560,
									 0.0556434, -0.2040259,  1.0572252);

		return max(0.0, (mul(XYZtoRGB, float3(X, Y, Z))) * pow(t * 0.0004, 4.0));
	}

	void vert (in appdata v, out v2f o) 
	{
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_OUTPUT(v2f, o);
		UNITY_TRANSFER_INSTANCE_ID(v, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

		worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0)).xyz;
		o.pos = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0));
#ifdef UNITY_PASS_SHADOWCASTER
		o.pos = UnityApplyLinearShadowBias(o.pos);
#else
		float3 worldNormal = UnityObjectToWorldNormal(v.normal);
		float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		float tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		float3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.worldTangent.xyz = worldTangent;
		o.worldBinormal.xyz = worldBinormal;
		o.worldNormal.xyz = worldNormal;

		o.worldTangent.w  = worldPos.x;
		o.worldBinormal.w = worldPos.y;
		o.worldNormal.w   = worldPos.z;

		o.texcoord = v.texcoord;
		UNITY_TRANSFER_FOG(o, o.pos);

	#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
		o.sh = 0;
		// Approximated illumination from non-important point lights
		#ifdef VERTEXLIGHT_ON
			o.sh += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, worldPos, worldNormal);
		#endif
		o.sh = ShadeSHPerVertex(worldNormal, o.sh);
	#endif
#endif
		
	}

	// Licence CC0: Liquid Metal
	// Some experimenting with warped FBM and very very fake lighting turned out ok 

	float warp(float2 p)
	{
		float2 v = float2(onoiseFBM(p, 5), onoiseFBM(p+0.7, 5));
  
		rot(v, 1.0 + time*1.8);
  
		float2 vv = float2(onoiseFBM(p + 3.7*v, 7), onoiseFBM(p + -2.7*v.yx+0.7, 7));

		rot(vv, -1.0 + time*0.8);
	
		return onoiseFBM(p + 9.0*vv, 3);
	}

	float liquidMetalHeight(float2 p) 
	{
		float a = 0.045*time;
		p += 9.0*float2(cos(a), sin(a));
		float h = warp(p * 2.0 + 13.0);
		float rs = 3.0;
		return tanh_approx(rs*h) * 0.35/rs;
	}

	float3 liquidMetalNormal(float2 p, float2 dx, float2 dy, out float height)
	{
		//const float eps = -2.0 / iResolution.y;
		//const float eps = 1.0 / 2048.0;
		const float eps = 1.5;
		const float s = sqrt(3.0) / 2.0;

		float3 p0 = eps * float3(1.0, 0.0, 0.0);
		float3 p1 = eps * float3(-0.5, 0.0, s);
		float3 p2 = eps * float3(-0.5, 0.0, -s);
		//p0.xz = p0.x * dx + p0.z * dy;
		//p1.xz = p1.x * dx + p1.z * dy;
		//p2.xz = p2.x * dx + p2.z * dy;
		
		p0 = 0.0;
		p1.xz = dx * 1.5;
		p2.xz = dy * 1.5;
		
		p0.y = liquidMetalHeight(p + p0.xz);
		p1.y = liquidMetalHeight(p + p1.xz);
		p2.y = liquidMetalHeight(p + p2.xz);

		height = p0.y;

		float3 n = cross(p1 - p0, p2 - p0);

		return normalize(n);
	}

	void liquidMetal(Input IN, inout SurfaceOutputStandard o, float alpha) 
	{
		const float level0 = 0.0;
		const float level1 = 0.125;

		float2 p = _LiquidMetalUVScale * IN.texcoord;
		float h = liquidMetalHeight(p);
		float3 dx = ddx(float3(p, h));
		float3 dy = ddy(float3(p, h));
	#ifdef QUALITY_LOW
		float3 n = normalize(cross(dy, dx)).xzy;
	#elif defined(QUALITY_HIGH)
		float3 n = liquidMetalNormal(p, dx, dy, h);
	#endif
		float t = alpha * saturate(2.0 * _Temperature - h * 0.5 - 0.5);
		float occlusion = saturate(h * 2.0 + 1.0);
		o.Albedo = lerp(o.Albedo, _LiquidMetalColor.rgb, alpha);
		o.Occlusion = lerp(o.Occlusion, occlusion, alpha);
		o.Smoothness = lerp(o.Smoothness, 0.9, alpha);
		o.Metallic = lerp(o.Metallic, 1.0, alpha);
		o.Normal = lerp(o.Normal, n.xzy, alpha);
		o.Emission = blackbody(t * TEMPERATURE) * _EmissionTint.rgb;
	}

	void surf (Input IN, inout SurfaceOutputStandard o)
	{
		worldPos = IN.worldPos;
		float2 uv = IN.texcoord;
		float3 texViewDir = normalize(IN.texView);
		float2 uv2 = IN.texcoord - texViewDir.xy * _Parallax;
		dUV = float4(ddx(uv2.xy), ddy(uv2.xy));
		texViewDir.xy /= texViewDir.z;
		
		float2 mainTexUV = uv - texViewDir.xy * _Parallax;
		mainTexUV = TRANSFORM_TEX(mainTexUV, _MainTex);
		o.Albedo = _Color.rgb * tex2Dgrad(_MainTex, mainTexUV, dUV.xy, dUV.zw).rgb;
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;

		float resultHeight;
		IN.texcoord.xy = ParallaxMapping(_HeightMap, IN.texcoord, texViewDir, _Parallax, resultHeight);
		float t = saturate(resultHeight * 10.0);
		float top = smoothstep(0.9, 1.0, resultHeight);

		liquidMetal(IN, o, t);

		float3 uvw = WorldReflectionVector(IN, o.Normal);
		float3 mask = texCUBElod(_LightEnvTex, float4(uvw, 0));
		float3 fakeLight = 0;
		fakeLight += mask.r * _LightEnvColorR.rgb;
		fakeLight += mask.g * _LightEnvColorG.rgb;
		fakeLight += mask.b * _LightEnvColorB.rgb;
		o.Emission +=fakeLight * _LiquidMetalColor.rgb * o.Metallic;
	}
#ifdef UNITY_PASS_SHADOWCASTER
	void frag() {}
#else
	void frag(in v2f IN, out float4 color : SV_Target)
	{
		UNITY_SETUP_INSTANCE_ID(IN);
		UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);
		UNITY_EXTRACT_FOG(IN);
		
		float3 worldPos;
		worldPos.x = IN.worldTangent.w;
		worldPos.y = IN.worldBinormal.w;
		worldPos.z = IN.worldNormal.w;
		worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
		float3 tangent = normalize(IN.worldTangent.xyz);
		float3 bitangent = normalize(IN.worldBinormal.xyz);
		float3 normal = normalize(IN.worldNormal.xyz);
		TBN = transpose(float3x3(tangent, bitangent, normal));

		Input surfIN;
		UNITY_INITIALIZE_OUTPUT(Input, surfIN);
		surfIN.texcoord = IN.texcoord;
		surfIN.texView = mul(worldViewDir, TBN);
		surfIN.worldPos = worldPos;
		surfIN.worldNormal = normal;

#ifndef USING_DIRECTIONAL_LIGHT
		float3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
#else
		float3 lightDir = _WorldSpaceLightPos0.xyz;
#endif

		SurfaceOutputStandard o;
		UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, o);
		o.Occlusion = 1.0;
		// Default normal vector in tangent space
		o.Normal = float3(0, 0, 1); 

		// call surface function
		surf(surfIN, o);

		// Convert back to world space
		o.Normal = mul(TBN, o.Normal);

		// compute lighting & shadowing factor
		UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)

		// Setup lighting environment
		UnityGI gi;
		UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
		gi.indirect.diffuse = 0;
		gi.indirect.specular = 0;
		gi.light.color = _LightColor0.rgb;
		gi.light.dir = lightDir;
#ifdef UNITY_PASS_FORWARDBASE
		// Call GI (lightmaps/SH/reflections) lighting function
		UnityGIInput giInput;
		UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
		giInput.light = gi.light;
		giInput.worldPos = worldPos;
		giInput.worldViewDir = worldViewDir;
		giInput.atten = atten;
		giInput.lightmapUV = 0.0;
#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
		giInput.ambient = IN.sh;
#else
		giInput.ambient.rgb = 0.0;
#endif
		giInput.probeHDR[0] = unity_SpecCube0_HDR;
		giInput.probeHDR[1] = unity_SpecCube1_HDR;
#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
		giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
#endif
#ifdef UNITY_SPECCUBE_BOX_PROJECTION
		giInput.boxMax[0] = unity_SpecCube0_BoxMax;
		giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
		giInput.boxMax[1] = unity_SpecCube1_BoxMax;
		giInput.boxMin[1] = unity_SpecCube1_BoxMin;
		giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
#endif
		LightingStandard_GI(o, giInput, gi);
#else //!UNITY_PASS_FORWARDBASE
		gi.light.color *= atten;
#endif
		color = LightingStandard(o, worldViewDir, gi);
		color.rgb += o.Emission;
		UNITY_APPLY_FOG(_unity_fogCoord, color);
		UNITY_OPAQUE_ALPHA(color.a);
	}
#endif
	ENDHLSL
	SubShader
	{
		Tags { "Queue" = "Geometry+455" "RenderType"="Opaque" }
		Cull Off
		Pass
		{
			Tags { "LightMode"="ForwardBase" }
			HLSLPROGRAM
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#pragma skip_variants LIGHTPROBE_SH
			ENDHLSL
		}
		/*Pass
		{
			Tags { "LightMode"="ForwardAdd" }
			Blend One One
			ZWrite Off
			HLSLPROGRAM
			#pragma multi_compile_fog
			#pragma multi_compile_fwdadd_fullshadows
			#pragma skip_variants SHADOWS_SOFT DIRECTIONAL DIRECTIONAL_COOKIE POINT_COOKIE
			ENDHLSL
		}*/
		Pass
		{
			Tags { "LightMode"="ShadowCaster" }
			HLSLPROGRAM
			#pragma multi_compile_shadowcaster
			ENDHLSL
		}
	}
}
