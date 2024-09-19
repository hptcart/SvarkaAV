// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomAudioLink"
{
	Properties
	{
		_Band("Band", Int) = 0
		_Color("Color", Color) = (1,1,1,0)
		_MinLight("MinLight", Range( 0 , 10)) = 0
		_Diapason("Diapason", Range( 0 , 10)) = 1
		_Diff("Diff", 2D) = "white" {}
		_Emissive("Emissive", 2D) = "white" {}
		_NM("NM", 2D) = "bump" {}
		_Ro("Ro", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_Tamed("Tamed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NM;
		uniform float4 _NM_ST;
		uniform sampler2D _Diff;
		uniform float4 _Diff_ST;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float4 _Color;
		uniform int _Band;
		uniform float _Diapason;
		uniform float _MinLight;
		uniform float _Tamed;
		uniform sampler2D _Ro;
		uniform float4 _Ro_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;


		inline float AudioLinkData3_g1( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NM = i.uv_texcoord * _NM_ST.xy + _NM_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NM, uv_NM ) );
			float2 uv_Diff = i.uv_texcoord * _Diff_ST.xy + _Diff_ST.zw;
			o.Albedo = tex2D( _Diff, uv_Diff ).rgb;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			int clampResult4 = clamp( _Band , 0 , 3 );
			int Band3_g1 = clampResult4;
			int Delay3_g1 = 0;
			float localAudioLinkData3_g1 = AudioLinkData3_g1( Band3_g1 , Delay3_g1 );
			o.Emission = ( tex2D( _Emissive, uv_Emissive ) * ( _Color * ( ( ( localAudioLinkData3_g1 * _Diapason ) + _MinLight ) + _Tamed ) ) ).rgb;
			float2 uv_Ro = i.uv_texcoord * _Ro_ST.xy + _Ro_ST.zw;
			o.Smoothness = tex2D( _Ro, uv_Ro ).r;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			o.Occlusion = tex2D( _AO, uv_AO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;1031,-0.600071;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CustomAudioLink;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;18;633.6265,370.9118;Inherit;True;Property;_AO;AO;8;0;Create;True;0;0;0;False;0;False;-1;None;58b8dabac9f57704d8776731e910ba40;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;302.6265,292.9118;Inherit;True;Property;_Ro;Ro;7;0;Create;True;0;0;0;False;0;False;-1;None;f0161783aad5b96468718ff4dffea05e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;512.1418,-309.0657;Inherit;True;Property;_Diff;Diff;4;0;Create;True;0;0;0;False;0;False;-1;None;f61d68403babec04a998d19e2f6b1986;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;303.6265,-127.0882;Inherit;True;Property;_NM;NM;6;0;Create;True;0;0;0;False;0;False;-1;None;9706c39f082e83f47bf0692bde1e9a54;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;3;-1563.435,58.64151;Inherit;False;Property;_Band;Band;0;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;4;-1375.434,5.841419;Inherit;False;3;0;INT;0;False;1;INT;0;False;2;INT;3;False;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;1;-1148.162,80.56812;Inherit;False;4BandAmplitude;-1;;1;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-432.2339,346.6415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-846.4465,336.1816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-876.234,-83.75848;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;True;0;False;1,1,1,0;1,0.3918693,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1160.846,421.7815;Inherit;False;Property;_Diapason;Diapason;3;0;Create;True;0;0;0;True;0;False;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-701.0341,425.8415;Inherit;False;Property;_MinLight;MinLight;2;0;Create;True;0;0;0;True;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-427.434,69.04144;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-127.3737,72.90947;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-426.8582,-231.0657;Inherit;True;Property;_Emissive;Emissive;5;0;Create;True;0;0;0;False;0;False;-1;None;303e6b1f89ab4bb40b2a7be507970513;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;134.1853,180.0018;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-235.6332,398.675;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-431.1694,452.1053;Inherit;False;Property;_Tamed;Tamed;9;0;Create;True;0;0;0;True;0;False;0;30.03;0;0;0;1;FLOAT;0
WireConnection;11;0;12;0
WireConnection;11;1;15;0
WireConnection;11;2;14;0
WireConnection;11;4;16;0
WireConnection;11;5;18;0
WireConnection;4;0;3;0
WireConnection;1;2;4;0
WireConnection;8;0;9;0
WireConnection;8;1;7;0
WireConnection;9;0;1;0
WireConnection;9;1;10;0
WireConnection;5;0;6;0
WireConnection;5;1;20;0
WireConnection;14;0;13;0
WireConnection;14;1;5;0
WireConnection;20;0;8;0
WireConnection;20;1;19;0
ASEEND*/
//CHKSM=28447311B194628943731E1C097A33F718AB7373