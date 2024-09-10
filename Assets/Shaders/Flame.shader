// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Flame"
{
	Properties
	{
		_ScreenNoise("ScreenNoise", 2D) = "white" {}
		_UVNoise("UVNoise", 2D) = "white" {}
		_SpeedScaleScreen("SpeedScaleScreen", Float) = 1
		_SpeedScaleUV("SpeedScaleUV", Float) = 1
		_FlameColor("Flame Color", Color) = (1,1,1,0)
		_EmiPower("EmiPower", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _EmiPower;
		uniform float4 _FlameColor;
		uniform sampler2D _ScreenNoise;
		uniform float _SpeedScaleScreen;
		uniform sampler2D _UVNoise;
		uniform float _SpeedScaleUV;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float mulTime6 = _Time.y * _SpeedScaleScreen;
			float4 appendResult5 = (float4(ase_screenPosNorm.x , ( ase_screenPosNorm.y + mulTime6 ) , 0.0 , 0.0));
			float mulTime16 = _Time.y * _SpeedScaleUV;
			float4 appendResult18 = (float4(i.uv_texcoord.x , ( i.uv_texcoord.y + mulTime16 ) , 0.0 , 0.0));
			float4 temp_output_8_0 = ( _FlameColor * ( tex2D( _ScreenNoise, appendResult5.xy ) * tex2D( _UVNoise, appendResult18.xy ) ) );
			o.Emission = ( _EmiPower * temp_output_8_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.RangedFloatNode;14;-1012.208,530.998;Float;False;Property;_SpeedScaleUV;SpeedScaleUV;3;0;Create;True;0;0;0;True;0;False;1;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1112.744,127.2612;Float;False;Property;_SpeedScaleScreen;SpeedScaleScreen;2;0;Create;True;0;0;0;True;0;False;1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-933.7443,84.2612;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-856.1093,230.9319;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-819.2086,470.998;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-1122.744,-115.7388;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-757.7443,1.261184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-643.2086,387.998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-499.2086,267.998;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-613.7444,-118.7388;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;12;-280,117.7;Inherit;True;Property;_UVNoise;UVNoise;1;0;Create;True;0;0;0;False;0;False;-1;None;0467a7f717ce9e74a8769245e32adbd7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-287.1046,-133.4308;Inherit;True;Property;_ScreenNoise;ScreenNoise;0;0;Create;True;0;0;0;False;0;False;-1;None;24274d033b3cc914595b8ca67e5391cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;181.493,-1.249893;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;84,-304.3;Float;False;Property;_FlameColor;Flame Color;4;0;Create;True;0;0;0;True;0;False;1,1,1,0;1,0.4763548,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;19;706.3987,-469.4459;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;372,-197.3;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;641,-180.3;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;924,-280;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Flame;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;0;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;11;452,-325.3;Float;False;Property;_EmiPower;EmiPower;5;0;Create;True;0;0;0;True;0;False;1;39.76;0;0;0;1;FLOAT;0
WireConnection;6;0;7;0
WireConnection;16;0;14;0
WireConnection;4;0;2;2
WireConnection;4;1;6;0
WireConnection;17;0;3;2
WireConnection;17;1;16;0
WireConnection;18;0;3;1
WireConnection;18;1;17;0
WireConnection;5;0;2;1
WireConnection;5;1;4;0
WireConnection;12;1;18;0
WireConnection;1;1;5;0
WireConnection;13;0;1;0
WireConnection;13;1;12;0
WireConnection;19;0;8;0
WireConnection;19;1;11;0
WireConnection;8;0;9;0
WireConnection;8;1;13;0
WireConnection;10;0;11;0
WireConnection;10;1;8;0
WireConnection;0;2;10;0
ASEEND*/
//CHKSM=589536BE06FCEE4964AC113986D7C9CF15B31210