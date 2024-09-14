Shader "Unlit/FasterUnlit+AlphaTex"
{
    Properties{
    _MainTex("Base (RGB)", 2D) = "white" {}
    _AlphaTex("Alpha (RGB)", 2D) = "white" {}
    _Cutoff("Alpha cutoff", Range(0,1)) = 0.5
    _Color("Color Tint", Color) = (1,1,1,1)
    _TilingAlpha("Alpha tile", Range(0,100)) = 8
    }
        SubShader{
            Tags {"Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout"}
            LOD 100

            Lighting Off
            Cull Off

            Pass {
                CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma target 2.0
                    #pragma multi_compile_fog

                    #include "UnityCG.cginc"

                    struct appdata_t {
                        float4 vertex : POSITION;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                    };

                    struct v2f {
                        float4 vertex : SV_POSITION;
                        float2 texcoord : TEXCOORD0;
                        UNITY_FOG_COORDS(1)
                        UNITY_VERTEX_OUTPUT_STEREO
                    };

                    sampler2D _MainTex;
                    float4 _MainTex_ST;
                    fixed _Cutoff;
                    fixed _TilingAlpha;
                    float4 _Color;
                    sampler2D _AlphaTex;
                    float4 _AlphaTex_ST;

                    v2f vert(appdata_t v)
                    {
                        v2f o;
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                        o.vertex = UnityObjectToClipPos(v.vertex);
                        o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                        UNITY_TRANSFER_FOG(o,o.vertex);
                        return o;
                    }

                   fixed4 frag(v2f i) : SV_Target
                    {
                    
                    fixed4 col = tex2D(_MainTex, i.texcoord);
                   i.texcoord = i.texcoord * _TilingAlpha;
                    fixed4 col2 = tex2D(_AlphaTex, i.texcoord);

                        clip(col2.a - _Cutoff);
                        col.a = col2.a;

                        col *= _Color;
                        //UNITY_APPLY_FOG(i.fogCoord, col);
                        return col;
                               col2;
                    }
                ENDCG
            }
    }
}
