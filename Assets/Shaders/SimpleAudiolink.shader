// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleAudiolink"
{
	Properties
	{
		_Band("Band", Int) = 0
		_Color("Color", Color) = (1,1,1,0)
		_MinLight("MinLight", Range( 0 , 10)) = 0
		_Diapason("Diapason", Range( 0 , 10)) = 1
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
			half filler;
		};

		uniform float4 _Color;
		uniform int _Band;
		uniform float _Diapason;
		uniform float _MinLight;


		inline float AudioLinkData3_g4( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			int clampResult5 = clamp( _Band , 0 , 3 );
			int Band3_g4 = clampResult5;
			int Delay3_g4 = 0;
			float localAudioLinkData3_g4 = AudioLinkData3_g4( Band3_g4 , Delay3_g4 );
			o.Emission = ( _Color * ( ( localAudioLinkData3_g4 * _Diapason ) + _MinLight ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-662.9408,273.767;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-977.3403,359.3669;Inherit;False;Property;_Diapason;Diapason;3;0;Create;True;0;0;0;True;0;False;1;0.05;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-692.7283,-146.1731;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;True;0;False;1,1,1,0;0.9843137,0.3276758,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-243.9283,6.626846;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;217,-3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SimpleAudiolink;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-248.7282,284.2269;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-517.5284,363.4269;Inherit;False;Property;_MinLight;MinLight;2;0;Create;True;0;0;0;True;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;-922.6563,199.1535;Inherit;False;4BandAmplitude;-1;;4;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;4;-1348.929,202.2269;Inherit;False;Property;_Band;Band;0;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ClampOpNode;5;-1160.928,149.4268;Inherit;False;3;0;INT;0;False;1;INT;0;False;2;INT;3;False;1;INT;0
WireConnection;10;0;7;0
WireConnection;10;1;11;0
WireConnection;14;0;13;0
WireConnection;14;1;9;0
WireConnection;0;2;14;0
WireConnection;9;0;10;0
WireConnection;9;1;12;0
WireConnection;7;2;5;0
WireConnection;5;0;4;0
ASEEND*/
//CHKSM=1579A8423454CDDC8145F3BF535CB5DAEE12875B