Shader "Custom/CelShading" 
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("Ramp", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CelShading

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;
		fixed4 _Color;

		struct Input 
		{
			float2 uv_MainTex;
		};

		UNITY_INSTANCING_CBUFFER_START(Props)
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingCelShading (SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed4 c;
			half NdotL = dot (s.Normal, lightDir);
			NdotL = tex2D (_RampTex, fixed2(NdotL, 0.5));
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
