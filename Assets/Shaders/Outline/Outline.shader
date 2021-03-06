﻿// Based on http://wiki.unity3d.com/index.php/Silhouette-Outlined_Diffuse
		
Shader "Custom/Outline" 
{
	Properties 
	{
		_Color("Main Color", Color) = (1, 1, 1, 1)
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_Outline("Outline Width", Range (0.0, 5)) = 0.2
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
	 
	uniform float _Outline;
	uniform float4 _OutlineColor;
	 
	v2f vert(appdata v) 
	{
		v2f o;
		
		// Create a copy of the vertex data scaled along the normals.
		/*
		o.pos = UnityObjectToClipPos(v.vertex);
		float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
		float2 offset = TransformViewToProjection(norm.xy);
		o.pos.xy += offset * o.pos.z * _Outline;
		*/

		// Alternately, create a copy of the vertex data scaled by increasing size in all directions.
		v.vertex.xyz *= (_Outline + 1);
		o.pos = UnityObjectToClipPos(v.vertex);

		o.color = _OutlineColor;
		return o;
	}

	ENDCG
 
	SubShader 
	{
		Tags { "Queue" = "Transparent" }
 
		Pass 
		{
			Name "OUTLINE"
			Cull Off
			ZWrite Off
			ColorMask RGB // Alpha is not used.

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
