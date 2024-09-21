// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tower"
{
	Properties
	{
		_Met("Met", Float) = 0
		_NoiseScale("NoiseScale", Float) = 1
		[HDR]_Spec("Spec", Color) = (1,1,1,0)
		[HDR]_Albedo("Albedo", Color) = (1,1,1,0)
		_ColorDiapason("ColorDiapason", Range( 0 , 1)) = 1
		_ColorShift("ColorShift", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _Albedo;
		uniform float4 _Spec;
		uniform float _NoiseScale;
		uniform float _ColorDiapason;
		uniform float _ColorShift;
		uniform float _Met;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
		{
			float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
			UV = frac( sin(mul(UV, m) ) * 46839.32 );
			return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
		}
		
		//x - Out y - Cells
		float3 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity, inout float2 mr )
		{
			float2 g = floor( UV * CellDensity );
			float2 f = frac( UV * CellDensity );
			float t = 8.0;
			float3 res = float3( 8.0, 0.0, 0.0 );
		
			for( int y = -1; y <= 1; y++ )
			{
				for( int x = -1; x <= 1; x++ )
				{
					float2 lattice = float2( x, y );
					float2 offset = UnityVoronoiRandomVector( lattice + g, AngleOffset );
					float d = distance( lattice + offset, f );
		
					if( d < res.x )
					{
						mr = f - lattice - offset;
						res = float3( d, offset.x, offset.y );
					}
				}
			}
			return res;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Albedo = _Albedo.rgb;
			float3 hsvTorgb8 = RGBToHSV( _Spec.rgb );
			float3 ase_worldPos = i.worldPos;
			float3 break16 = ase_worldPos;
			float4 appendResult18 = (float4(( break16.x + _SinTime.x ) , ( break16.y + _SinTime.y ) , 0.0 , 0.0));
			float2 uv2 = 0;
			float3 unityVoronoy2 = UnityVoronoi(appendResult18.xy,( break16.z + _SinTime.z ),_NoiseScale,uv2);
			float3 hsvTorgb5 = HSVToRGB( float3(( hsvTorgb8.x + ( ( unityVoronoy2.x * _ColorDiapason ) + _ColorShift ) ),hsvTorgb8.y,hsvTorgb8.z) );
			o.Specular = hsvTorgb5;
			o.Smoothness = _Met;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;605.6,-23.2;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Tower;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;7;107.5996,-385;Inherit;False;Property;_Albedo;Albedo;3;1;[HDR];Create;True;0;0;0;True;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-427.6005,-232.5999;Inherit;False;Property;_Spec;Spec;2;1;[HDR];Create;True;0;0;0;True;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;339.6,363.0001;Inherit;False;Property;_Met;Met;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-57.60046,194.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;5;156.3996,90.20006;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RGBToHSVNode;8;-246.6212,-18.74434;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;11;-766.3642,464.4241;Inherit;False;Property;_ColorDiapason;ColorDiapason;4;0;Create;True;0;0;0;True;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-404.7597,470.5507;Inherit;False;Property;_ColorShift;ColorShift;5;0;Create;True;0;0;0;True;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-594.7794,323.0192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-237.0775,307.8724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;14;-1043.444,563.4199;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2;-857.1544,260.6423;Inherit;False;0;0;1;0;1;False;1;True;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1573.554,225.4423;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-1357.444,214.4199;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;18;-984.4438,98.41992;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1141.444,101.4199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1134.444,206.4199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1127.444,304.4199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;15;-1495.444,521.4199;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-930.1548,489.6422;Inherit;False;Property;_NoiseScale;NoiseScale;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
WireConnection;0;0;7;0
WireConnection;0;3;5;0
WireConnection;0;4;1;0
WireConnection;9;0;8;1
WireConnection;9;1;13;0
WireConnection;5;0;9;0
WireConnection;5;1;8;2
WireConnection;5;2;8;3
WireConnection;8;0;6;0
WireConnection;10;0;2;0
WireConnection;10;1;11;0
WireConnection;13;0;10;0
WireConnection;13;1;12;0
WireConnection;2;0;18;0
WireConnection;2;1;20;0
WireConnection;2;2;4;0
WireConnection;16;0;3;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;17;0;16;0
WireConnection;17;1;15;1
WireConnection;19;0;16;1
WireConnection;19;1;15;2
WireConnection;20;0;16;2
WireConnection;20;1;15;3
ASEEND*/
//CHKSM=B5FA4D50FE87DEE99EC69DEBB4A356F997700B46