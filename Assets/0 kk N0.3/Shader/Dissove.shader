Shader "Unlit/Dissove"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
        _Clip("Clip",Range(0,1)) = 0
        _DissolveTex("DissolveTex",2D) = "white"{}
        _RampTex("RampTex",2D) = "white"{}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DissolveTex;
            sampler2D _RampTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Clip;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex,i.uv);

                fixed4 dissolveTex = tex2D(_DissolveTex,i.uv);
                clip(dissolveTex - _Clip);
                fixed dissolvevalue = saturate(dissolveTex - _Clip) / (_Clip + 0.1 - _Clip);
                fixed4 ramptex = tex2D(_RampTex,dissolvevalue);
                fixed4 c = tex * _Color + ramptex;
                return c;
            }
            ENDCG
        }
    
	}
}
