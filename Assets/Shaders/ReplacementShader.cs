using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShader : MonoBehaviour
{
	public Shader replacementShader;

	void OnEnable()
	{
		if (replacementShader != null)
		{
			// "RenderType"
			GetComponent<Camera>().SetReplacementShader(replacementShader, "");
		}
	}

	void OnDisable()
	{
		GetComponent<Camera>().ResetReplacementShader();
	}
}
