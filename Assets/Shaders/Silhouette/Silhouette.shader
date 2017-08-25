
Shader "Custom/Silhouette" 
{
	Properties 
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_SilhouetteColor("Outline Color", Color) = (0, 0, 0, 1)
		_MainTex("Texture", 2D) = "white" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	 
	struct appdata 
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	 
	struct v2f 
	{
		float4 pos : POSITION;
		float4 color : COLOR;
	};
	
	uniform float4 _SilhouetteColor;
	 
	v2f vert(appdata v) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.color = _SilhouetteColor;
		return o;
	}

	ENDCG
 
	SubShader 
	{
		Tags { "Queue" = "Transparent" }
 
		Pass 
		{
			Name "SILHOUETTE"
			Cull Off
			ZWrite Off
			ColorMask RGB // Alpha is not used.
			ZTest Always // Allows the silhouette to be seen through other objects.
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			 
			half4 frag(v2f i) : COLOR 
			{
				return i.color;
			}

			ENDCG
		}
 
		Pass 
		{
			Name "BASE"

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata2
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f2
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			
			v2f2 vert(appdata2 v)
			{
				v2f2 o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag(v2f2 i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}

			ENDCG
		}
	}
 
	Fallback "Diffuse"
}
