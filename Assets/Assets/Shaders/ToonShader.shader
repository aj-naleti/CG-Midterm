Shader "Custom/ToonShader+Rim"
{
    Properties
        //basic properties needed for the shader
    {
        _Color("Color", Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "white" {}
        _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower("Rim Power", Range(0.5,8.0)) = 3.0
    }
        SubShader
        {
            //setting the light model
            CGPROGRAM
            #pragma surface surf ToonRamp

            struct Input
            {
                float3 viewDir;
                float2 uv_MainTex;
            };
            
            //setting the needed information and making it modifiable
            float4 _Color;
            float4 _RimColor;
            float _RimPower;
            sampler2D _RampTex;

            float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
            {
                float diff = dot(s.Normal, lightDir);
                float h = diff * 0.5 + 0.5;
                float2 rh = h;
                float3 ramp = tex2D(_RampTex, rh).rgb;

                float4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
                c.a = s.Alpha;
                return c;
            }

            //setting the output of the toon shader and emission for rim
            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Color.rgb;

                half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            }
            ENDCG
        }
            FallBack "Diffuse"
}
