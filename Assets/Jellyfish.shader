// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Jellyfish"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
		_Emission("Emission", 2D) = "white" {}
		_DeformAmount("DeformAmount", Float) = 1
		_VertexFreq("VertexFreq", Float) = 1
		_Speed("Speed", Float) = 1
		_SpreadAmount("SpreadAmount", Float) = 1
		_HighlightColor("Highlight Color", Color) = (0,0,0,0)
		_HighlightEmission("Highlight Emission", Color) = (0,0,0,0)
		_HighlightIntensity("Highlight Intensity", Float) = 1
		_HighlightFreq("Highlight Freq", Float) = 1
		[Toggle(_FOWARD_ON)] _Foward("Foward", Float) = 1
		_Color("Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha , One OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _FOWARD_ON
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			half ASEVFace : VFACE;
			float3 viewDir;
		};

		uniform float _DeformAmount;
		uniform float _Speed;
		uniform float _VertexFreq;
		uniform float _SpreadAmount;
		uniform float4 _Color;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _HighlightIntensity;
		uniform float _HighlightFreq;
		uniform float4 _HighlightColor;
		uniform float4 _HighlightEmission;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			#ifdef _FOWARD_ON
				float staticSwitch47 = (float)1;
			#else
				float staticSwitch47 = (float)-1;
			#endif
			float temp_output_12_0 = ( _DeformAmount * sin( ( ( ( ase_objectScale.y + _Time.y + ase_objectScale.z + ase_objectScale.x ) * _Speed ) + ( ase_vertex3Pos.y * ( _VertexFreq * staticSwitch47 ) ) ) ) );
			float smoothstepResult30 = smoothstep( 0.0 , 1.0 , temp_output_12_0);
			float3 ase_vertexNormal = v.normal.xyz;
			float clampResult37 = clamp( -ase_vertex3Pos.y , 0.0 , 100.0 );
			float4 appendResult4 = (float4(( smoothstepResult30 * ase_vertexNormal.x * _SpreadAmount ) , ( temp_output_12_0 * clampResult37 * smoothstepResult30 * _SpreadAmount ) , ( smoothstepResult30 * ase_vertexNormal.z * _SpreadAmount ) , 0.0));
			v.vertex.xyz += appendResult4.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float temp_output_72_0 = ( ( _HighlightIntensity * sin( ( ( _Time.y * _HighlightFreq ) + 0.0 ) ) ) * ( 1.0 - distance( i.uv_texcoord , float2( 0.5,0.5 ) ) ) );
			float smoothstepResult73 = smoothstep( 0.0 , 0.3 , temp_output_72_0);
			float smoothstepResult75 = smoothstep( 0.2 , 0.3 , temp_output_72_0);
			float4 temp_output_74_0 = ( tex2D( _Emission, uv_Emission ) * ( smoothstepResult73 - smoothstepResult75 ) * _HighlightColor );
			o.Emission = ( temp_output_74_0 + _HighlightEmission ).rgb;
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float3 ase_worldNormal = i.worldNormal;
			float3 switchResult49 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float dotResult52 = dot( switchResult49 , i.viewDir );
			float4 clampResult59 = clamp( ( tex2D( _Texture, uv_Texture ).a + ( _Color.a * ( 1.0 - dotResult52 ) ) + temp_output_74_0 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			o.Alpha = clampResult59.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16600
633;541;1209;799;294.823;602.7427;1.850269;True;False
Node;AmplifyShaderEditor.CommentaryNode;61;-843.9488,-1385.377;Float;False;2747.269;1563.915;Comment;30;59;49;51;50;41;52;54;55;79;80;57;74;58;76;78;60;53;73;75;72;65;71;70;64;63;69;62;68;67;66;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;67;-640.2299,-1335.377;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-633.869,-1271.759;Float;False;Property;_HighlightFreq;Highlight Freq;9;0;Create;True;0;0;False;0;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-795.0713,364.2266;Float;False;2166.797;786.7824;Comment;25;3;10;1;9;17;38;11;2;12;36;30;37;22;27;35;23;26;4;16;15;43;47;45;48;81;Vertex Deform;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-392.3549,-1317.554;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;45;-740.7124,1028.738;Float;False;Constant;_Forward;Forward;5;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;48;-747.2913,963.9201;Float;False;Constant;_Backward;Backward;5;0;Create;True;0;0;False;0;-1;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-679.4759,477.5447;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-514.926,865.2708;Float;False;Property;_VertexFreq;VertexFreq;3;0;Create;True;0;0;False;0;1;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;83;-764.2339,340.6445;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-459.658,-967.5112;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;47;-518.092,993.2206;Float;False;Property;_Foward;Foward;10;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-123.9109,-1245.118;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-506.3341,402.6465;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-335.0328,856.4968;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-601.8544,544.2444;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;70;-140.184,-916.0082;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;17.16929,-1326.432;Float;False;Property;_HighlightIntensity;Highlight Intensity;8;0;Create;True;0;0;False;0;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;63;-6.058888,-1249.369;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-745.0713,601.6641;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;41;-144.9279,-266.4415;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;50;125.3754,-208.3112;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-143.4631,655.6727;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-343.4768,432.0494;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;109.0342,-929.1251;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;170.9299,-1320.761;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;49;340.3369,-214.3474;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;51;342.4607,-75.63927;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-75.03283,504.4852;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;400.8556,-973.7219;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;73;673.0021,-1039.675;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;52;604.9872,-205.1362;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;66.04727,423.1711;Float;False;Property;_DeformAmount;DeformAmount;2;0;Create;True;0;0;False;0;1;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;2;42.819,500.2344;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;75;673.6184,-833.3986;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;109.8407,686.1645;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;598.1141,-1265.585;Float;True;Property;_Emission;Emission;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;36;378.0899,697.6444;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;827.0922,-214.2956;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;219.8082,428.8422;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;938.3361,-988.1544;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;781.5646,-409.6465;Float;False;Property;_Color;Color;11;0;Create;True;0;0;False;0;1,1,1,1;0,0.4576774,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;78;1065.717,-731.3827;Float;False;Property;_HighlightColor;Highlight Color;6;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.1333332,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;534.7314,984.1534;Float;False;Property;_SpreadAmount;SpreadAmount;5;0;Create;True;0;0;False;0;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;600.183,664.9284;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;22;118.0943,880.4602;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;1296.73,-1062.383;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;55;1138.161,-34.44916;Float;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;30;480.5693,539.2174;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1296.863,-221.8127;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;875.4424,898.509;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;878.0801,432.6057;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;878.556,665.813;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;1553.146,-939.3918;Float;False;Property;_HighlightEmission;Highlight Emission;7;0;Create;True;0;0;False;0;0,0,0,0;0.6226415,0.6226415,0.6226415,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;1601.036,-94.12801;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;1897.453,-1032.163;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;59;1765.809,-78.24577;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;1208.727,498.6804;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2414.94,-341.0323;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Jellyfish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;12;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;67;0
WireConnection;68;1;66;0
WireConnection;47;1;48;0
WireConnection;47;0;45;0
WireConnection;62;0;68;0
WireConnection;81;0;83;2
WireConnection;81;1;3;0
WireConnection;81;2;83;3
WireConnection;81;3;83;1
WireConnection;43;0;15;0
WireConnection;43;1;47;0
WireConnection;70;0;69;0
WireConnection;63;0;62;0
WireConnection;50;0;41;0
WireConnection;16;0;1;2
WireConnection;16;1;43;0
WireConnection;9;0;81;0
WireConnection;9;1;10;0
WireConnection;71;0;70;0
WireConnection;65;0;64;0
WireConnection;65;1;63;0
WireConnection;49;0;41;0
WireConnection;49;1;50;0
WireConnection;17;0;9;0
WireConnection;17;1;16;0
WireConnection;72;0;65;0
WireConnection;72;1;71;0
WireConnection;73;0;72;0
WireConnection;52;0;49;0
WireConnection;52;1;51;0
WireConnection;2;0;17;0
WireConnection;75;0;72;0
WireConnection;36;0;38;2
WireConnection;54;0;52;0
WireConnection;12;0;11;0
WireConnection;12;1;2;0
WireConnection;76;0;73;0
WireConnection;76;1;75;0
WireConnection;37;0;36;0
WireConnection;74;0;60;0
WireConnection;74;1;76;0
WireConnection;74;2;78;0
WireConnection;30;0;12;0
WireConnection;57;0;53;4
WireConnection;57;1;54;0
WireConnection;26;0;30;0
WireConnection;26;1;22;3
WireConnection;26;2;27;0
WireConnection;35;0;12;0
WireConnection;35;1;37;0
WireConnection;35;2;30;0
WireConnection;35;3;27;0
WireConnection;23;0;30;0
WireConnection;23;1;22;1
WireConnection;23;2;27;0
WireConnection;58;0;55;4
WireConnection;58;1;57;0
WireConnection;58;2;74;0
WireConnection;80;0;74;0
WireConnection;80;1;79;0
WireConnection;59;0;58;0
WireConnection;4;0;23;0
WireConnection;4;1;35;0
WireConnection;4;2;26;0
WireConnection;0;0;53;0
WireConnection;0;2;80;0
WireConnection;0;9;59;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=4EDA6843BBC6A8751304043B9F10F94D8BF59EB4