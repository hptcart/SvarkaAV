// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HorseMetal"
{
	Properties
	{
		_Met("Met", Range( 0 , 1)) = 0
		_Smooth("Smooth", Range( 0 , 1)) = 0
		[HDR]_Color("Color", Color) = (1,1,1,0)
		_UNICORNPEGAZUS_NRM("UNICORN&PEGAZUS_NRM", 2D) = "bump" {}
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _UNICORNPEGAZUS_NRM;
		uniform float4 _UNICORNPEGAZUS_NRM_ST;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _Color;
		uniform float _Met;
		uniform float _Smooth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_UNICORNPEGAZUS_NRM = i.uv_texcoord * _UNICORNPEGAZUS_NRM_ST.xy + _UNICORNPEGAZUS_NRM_ST.zw;
			o.Normal = UnpackNormal( tex2D( _UNICORNPEGAZUS_NRM, uv_UNICORNPEGAZUS_NRM ) );
			float3 temp_output_22_0 = float3(0.56,0.57,0.58);
			o.Albedo = temp_output_22_0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV24 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode24 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV24, _Power ) );
			o.Emission = ( fresnelNode24 * _Color ).rgb;
			o.Metallic = _Met;
			o.Smoothness = _Smooth;
			o.Alpha = fresnelNode24;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;2;-919,233.5;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;fd9e756da40bdef44bca9d23283b0f82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;9;-505,327.5;Inherit;False;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;5;-556,591.5;Inherit;True;Property;_UNICORNPEGAZUS_Smoothness;UNICORN&PEGAZUS_Smoothness;5;0;Create;True;0;0;0;False;0;False;-1;73ed774d77652164fad11684421fea9a;73ed774d77652164fad11684421fea9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-480,-72.5;Inherit;True;Property;_Albedo;Albedo;0;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;73ed774d77652164fad11684421fea9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-47,355.5;Inherit;False;Property;_Smooth;Smooth;4;0;Create;True;0;0;0;True;0;False;0;0.915;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-96,205.5;Inherit;False;Property;_Met;Met;3;0;Create;True;0;0;0;True;0;False;0;0.819;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;567,72.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;22;237.5697,-37.11652;Inherit;False;Metal Reflectance;-1;;3;55ea54ba7a9d52c4a8bf7b3e01e6ae77;1,38,0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;23;318.4697,384.6836;Inherit;True;Property;_UNICORNPEGAZUS_NRM;UNICORN&PEGAZUS_NRM;7;0;Create;True;0;0;0;False;0;False;-1;9f6c0013c6b4d314b923d1becd30bb23;9f6c0013c6b4d314b923d1becd30bb23;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-78.50001,-59.59997;Inherit;False;Property;_Color;Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0.5415316,1,1.014704;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;24;420.3755,-298.5646;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;112.6499,-374.1712;Inherit;False;Property;_Bias;Bias;8;0;Create;True;0;0;0;True;0;False;0;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;123.6499,-282.1713;Inherit;False;Property;_Scale;Scale;9;0;Create;True;0;0;0;True;0;False;1;2.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;114.6499,-201.1712;Inherit;False;Property;_Power;Power;10;0;Create;True;0;0;0;True;0;False;5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;737.5123,-80.30029;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1131.014,110.777;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HorseMetal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;20;2;0
WireConnection;13;0;22;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;24;3;27;0
WireConnection;28;0;24;0
WireConnection;28;1;12;0
WireConnection;0;0;22;0
WireConnection;0;1;23;0
WireConnection;0;2;28;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;9;24;0
ASEEND*/
//CHKSM=B56F207A4134BB83B7AF5DC5A7C7AA2D1C8F649B