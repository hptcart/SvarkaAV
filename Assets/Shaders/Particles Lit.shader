Shader"Leviant's Shaders/Particles Lit" 
{
	Properties 
	{
		[HDR]_Color ("Tint Color", Color) = (1, 1, 1, 1)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_Lit("Lit", Range(0, 1)) = 0
		[Toggle]_Blend("Anim Blend", Int) = 0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		Pass 
		{
			Tags { "LightMode" = "ForwardBase" }
			Blend One OneMinusSrcAlpha
			Cull Off
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile_vertex _ VERTEXLIGHT_ON
			#pragma shader_feature_local _BLEND_ON
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _Color;
			uniform float _Lit;
			
			struct appdata_t
			{
				float3 vertex : POSITION;
				float4 color : COLOR;
				float4 texcoords : TEXCOORD0;
				float texcoordBlend : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
				float3 light : TEXCOORD2;
				float blend : TEXCOORD3;
				UNITY_FOG_COORDS(4)
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float3 AmbientPointLighting(float3 wpos)
			{
				// to light vectors
				float4 toLightX = unity_4LightPosX0 - wpos.x;
				float4 toLightY = unity_4LightPosY0 - wpos.y;
				float4 toLightZ = unity_4LightPosZ0 - wpos.z;
				// squared lengths
				float4 lengthSq = 0;
				lengthSq += toLightX * toLightX;
				lengthSq += toLightY * toLightY;
				lengthSq += toLightZ * toLightZ;
				// attenuation
				float4 atten = 1.0 / (1.0 + lengthSq * unity_4LightAtten0);
				float3 light = 0;
				light += unity_LightColor[0].rgb * atten.x;
				light += unity_LightColor[1].rgb * atten.y;
				light += unity_LightColor[2].rgb * atten.z;
				light += unity_LightColor[3].rgb * atten.w;
				return light;
			}

			void vert(in appdata_t v, out v2f o)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 worldPos = mul(UNITY_MATRIX_M, float4(v.vertex, 1)).xyz;
				o.vertex = mul(UNITY_MATRIX_VP, float4(worldPos, 1));
				o.color = v.color * _Color;
				o.light = _LightColor0.rgb;
			#ifdef VERTEXLIGHT_ON
				o.light += AmbientPointLighting(worldPos);
			#endif
				//o.light.r += unity_SHAr.w;
				//o.light.g += unity_SHAg.w;
				//o.light.b += unity_SHAb.w;
				o.light.r += sqrt(dot(unity_SHAr, unity_SHAr));
				o.light.g += sqrt(dot(unity_SHAg, unity_SHAg));
				o.light.b += sqrt(dot(unity_SHAb, unity_SHAb));
				o.light = saturate(lerp(1.0, o.light, _Lit));
				o.texcoord = TRANSFORM_TEX(v.texcoords.xy, _MainTex);
				o.texcoord2 = TRANSFORM_TEX(v.texcoords.zw, _MainTex);
				o.blend = v.texcoordBlend;
				UNITY_TRANSFER_FOG(o, o.vertex);
			}
			
			float4 frag(in v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.texcoord);
			#ifdef _BLEND_ON
				float4 colB = tex2D(_MainTex, i.texcoord2);
				color = lerp(color, colB, i.blend);
			#endif
				color *= i.color;
				color.rgb *= i.light;
				UNITY_APPLY_FOG(i.fogCoord, color);
				color.rgb *= color.a;
				return color;
			}
			ENDCG 
		}
	}   
}