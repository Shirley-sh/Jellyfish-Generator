// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH/JellyfishGuts"
{
	Properties
	{
		_MainColor("Main Color", Color) = (1,1,1,1)
		_PatternColor("Pattern Color", Color) = (0.406,0.406,0.406,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldNormal;
			half ASEVFace : VFACE;
			float3 viewDir;
		};

		uniform float4 _MainColor;
		uniform float4 _PatternColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult81 = lerp( _MainColor , _PatternColor , 0);
			o.Emission = lerpResult81.rgb;
			float lerpResult77 = lerp( _MainColor.a , _PatternColor.a , 0);
			float3 ase_worldNormal = i.worldNormal;
			float3 switchResult69 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float dotResult71 = dot( switchResult69 , i.viewDir );
			float smoothstepResult76 = smoothstep( 0.0 , 3.0 , ( 1.0 - dotResult71 ));
			float clampResult80 = clamp( ( lerpResult77 + smoothstepResult76 ) , 0.0 , 1.0 );
			o.Alpha = clampResult80;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16600
163;589;1043;635;-1457.502;1014.658;2.826118;True;False
Node;AmplifyShaderEditor.WorldNormalVector;67;1981.512,-607.569;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;68;2251.816,-549.4387;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;70;2468.902,-416.7668;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwitchByFaceNode;69;2466.778,-555.4749;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;71;2731.427,-546.2637;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;2560.545,-1213.04;Float;False;Property;_MainColor;Main Color;0;0;Create;True;0;0;False;0;1,1,1,1;0.832,0.832,0.832,0.1411765;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;74;2567.882,-1032.625;Float;False;Property;_PatternColor;Pattern Color;1;0;Create;True;0;0;False;0;0.406,0.406,0.406,1;1,1,1,0.2431373;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;73;2957.646,-540.5964;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;2567.09,-869.2673;Float;True;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;76;3159.405,-591.7035;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;3460.323,-891.8463;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;3515.582,-644.3464;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;2824.8,-886.5798;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;865.3036,34.39606;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;1223.574,-279.1955;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;636.3512,-408.6147;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;79;3008.118,-895.6362;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-123.1272,-421.6181;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;2352.617,-246.3605;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.36;False;2;FLOAT;0.57;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;33;-530.2191,-335.8095;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;1462.13,-210.06;Float;True;Simplex2D;1;0;FLOAT2;0.11231,0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;55;1680.168,-223.0272;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-854.2482,-431.1116;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;44;145.4576,-421.0822;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;394.2614,-427.3492;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;60;2122.243,-243.577;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;80;3718.74,-650.9711;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;968.2268,-151.3121;Float;False;1;0;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;2941.621,-231.8573;Float;False;pattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;1748.852,10.26438;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-261.5684,-423.2446;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;66;972.8565,-230.7531;Float;False;Constant;_PatternFactor;Pattern Factor;0;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;42;399.726,-341.4922;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;7;9.011411,-421.2441;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;53;1337.955,33.48813;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;49;1121.113,34.35045;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-396.9383,-426.1253;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;2591.395,-245.6853;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;3466.978,-1107.989;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;56;1878.333,-218.1938;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;32;-530.6469,-421.853;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;83;4136.655,-616.8943;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH/JellyfishGuts;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;67;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;71;0;69;0
WireConnection;71;1;70;0
WireConnection;73;0;71;0
WireConnection;76;0;73;0
WireConnection;77;0;72;4
WireConnection;77;1;74;4
WireConnection;77;2;75;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;82;0;74;4
WireConnection;82;1;75;0
WireConnection;48;0;45;0
WireConnection;48;1;66;0
WireConnection;45;0;42;0
WireConnection;45;1;43;0
WireConnection;79;0;72;4
WireConnection;79;1;82;0
WireConnection;3;0;4;0
WireConnection;65;0;60;0
WireConnection;33;0;2;1
WireConnection;33;1;2;2
WireConnection;46;0;48;0
WireConnection;55;0;46;0
WireConnection;44;0;7;0
WireConnection;43;0;44;0
WireConnection;43;1;44;1
WireConnection;60;0;55;0
WireConnection;60;1;56;0
WireConnection;80;0;78;0
WireConnection;84;0;52;0
WireConnection;54;0;53;0
WireConnection;4;0;34;0
WireConnection;42;0;44;0
WireConnection;42;1;44;1
WireConnection;7;0;3;0
WireConnection;53;0;49;0
WireConnection;49;0;51;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;52;0;65;0
WireConnection;52;1;54;0
WireConnection;81;0;72;0
WireConnection;81;1;74;0
WireConnection;81;2;75;0
WireConnection;56;0;55;0
WireConnection;32;0;2;1
WireConnection;32;1;2;2
WireConnection;83;2;81;0
WireConnection;83;9;80;0
ASEEND*/
//CHKSM=45D0D654C8AFF4E68E2E51592F0468714A4FF294