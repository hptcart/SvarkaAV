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
		_NM("NM", 2D) = "white" {}
		_Ro("Ro", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
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

		uniform int _Band;
		uniform float4 _Color;
		uniform float _Diapason;
		uniform float _MinLight;
		uniform sampler2D _NM;
		uniform float4 _NM_ST;
		uniform sampler2D _Diff;
		uniform float4 _Diff_ST;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
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
			o.Emission = ( tex2D( _Emissive, uv_Emissive ) * ( _Color * ( ( localAudioLinkData3_g1 * _Diapason ) + _MinLight ) ) ).rgb;
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
Node;AmplifyShaderEditor.IntNode;3;-1092.073,93.37341;Inherit;False;Property;_Band;Band;0;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;4;-904.0725,40.57333;Inherit;False;3;0;INT;0;False;1;INT;0;False;2;INT;3;False;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;72.72766,66.97336;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1;-676.8001,115.3;Inherit;False;4BandAmplitude;-1;;1;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;39.12775,381.3734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-375.0847,370.9135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-404.8722,-49.02658;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;True;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-689.4847,456.5134;Inherit;False;Property;_Diapason;Diapason;3;0;Create;True;0;0;0;True;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-229.6723,460.5734;Inherit;False;Property;_MinLight;MinLight;2;0;Create;True;0;0;0;True;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;274.5243,125.0074;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;1031,-0.600071;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CustomAudioLink;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;18;633.6265,370.9118;Inherit;True;Property;_AO;AO;8;0;Create;True;0;0;0;False;0;False;-1;None;134496f84bdd03b488a09bd1cc34e1f9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;302.6265,292.9118;Inherit;True;Property;_Ro;Ro;7;0;Create;True;0;0;0;False;0;False;-1;None;134496f84bdd03b488a09bd1cc34e1f9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;512.1418,-309.0657;Inherit;True;Property;_Diff;Diff;4;0;Create;True;0;0;0;False;0;False;-1;None;d2b85a6b835f1f141acabd7fe8761c4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-200.8582,-206.0657;Inherit;True;Property;_Emissive;Emissive;5;0;Create;True;0;0;0;False;0;False;-1;None;b63bde841168a9042aad1862d76cad4e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;303.6265,-127.0882;Inherit;True;Property;_NM;NM;6;0;Create;True;0;0;0;False;0;False;-1;None;5d44d588a60159d4bbbc5c1da51b95ef;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;4;0;3;0
WireConnection;5;0;6;0
WireConnection;5;1;8;0
WireConnection;1;2;4;0
WireConnection;8;0;9;0
WireConnection;8;1;7;0
WireConnection;9;0;1;0
WireConnection;9;1;10;0
WireConnection;14;0;13;0
WireConnection;14;1;5;0
WireConnection;11;0;12;0
WireConnection;11;1;15;0
WireConnection;11;2;14;0
WireConnection;11;4;16;0
WireConnection;11;5;18;0
ASEEND*/
//CHKSM=E41AD2D6606F8B699BCE857D8F71B81DA917BBA8