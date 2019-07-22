Shader "MyShaders/Checkerboard"
{
    Properties
    {
        _Scale ("Scale", Range(0.1, 10)) = 1
        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 200
        Pass {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float _Scale;
            float4 _Color1;
            float4 _Color2;

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(appdata v) {
                v2f o;

                o.position = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                float3 scaledWorldPos = floor(i.worldPos / _Scale);
                float chessboard = scaledWorldPos.x + scaledWorldPos.y + scaledWorldPos.z;

                chessboard = frac(chessboard * 0.5);

                chessboard *= 2;

                float4 color = lerp(_Color1, _Color2, chessboard);
                return color;
            }

            
            ENDCG
        }
        
    }
    FallBack "Diffuse"
}
