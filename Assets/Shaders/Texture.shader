Shader "Custom/Colored UV"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags
		{
			"PreviewType" = "Plane"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			    float4 uv : TEXCOORD0; // UV0 data
				float3 nm : NORMAL;    // NORMAL data
			};

			// vertex to fragment
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;  
				float3 nm : NORMAL;		
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.nm = v.nm;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = float4(i.uv.r, i.uv.g, 1, 0);
				return color;
			}

			ENDCG
		}
	}
}