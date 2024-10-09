Shader "Custom/Toon"
{
    Properties
    {
        //basic properties needed for the shader
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
    }
    SubShader
    {
        //setting the light model and ramp
        CGPROGRAM
        #pragma surface surf ToonRamp

        //setting the needed information and making the color modifiable
        float4 _Color;
        sampler2D _RampTex;

        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float diff = dot (s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        //setting output as base color modified by the texture ramp
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
