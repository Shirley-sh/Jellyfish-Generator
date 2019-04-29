// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH/JellyfishBell"
{
	Properties
	{
		_PatternFactor("Pattern Factor", Range( -10 , 0)) = 0
		_MainColor("Main Color", Color) = (1,1,1,1)
		_PatternColor("Pattern Color", Color) = (0.406,0.406,0.406,1)
		_DeformAmount("DeformAmount", Float) = 0.1
		_VertexFreq("VertexFreq", Float) = 4.5
		_Speed("Speed", Float) = 5
		_SpreadAmount("SpreadAmount", Float) = 1
		_VertexFreqOffset("VertexFreqOffset", Range( -10 , 10)) = 5
		[Toggle(_FOWARD_ON)] _Foward("Foward", Float) = 1
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
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _FOWARD_ON
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
		uniform float _VertexFreqOffset;
		uniform float _SpreadAmount;
		uniform float4 _MainColor;
		uniform float4 _PatternColor;
		uniform float _PatternFactor;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float2 RotateUV110( float2 uv , float angle )
		{
			float rad = radians(angle);
			float sinX = sin ( rad);
			float cosX = cos ( rad);
			uv-=0.5;
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul (  rotationMatrix, uv )+0.5;
		}


		float2 RotateUV70( float2 uv , float angle )
		{
			float rad = radians(angle);
			float sinX = sin ( rad);
			float cosX = cos ( rad);
			uv-=0.5;
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul (  rotationMatrix, uv )+0.5;
		}


		float2 RotateUV111( float2 uv , float angle )
		{
			float rad = radians(angle);
			float sinX = sin ( rad);
			float cosX = cos ( rad);
			uv-=0.5;
			float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX);
			return mul (  rotationMatrix, uv )+0.5;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime153 = _Time.y * _Speed;
			float3 ase_vertex3Pos = v.vertex.xyz;
			#ifdef _FOWARD_ON
				float staticSwitch154 = (float)1;
			#else
				float staticSwitch154 = (float)-1;
			#endif
			float temp_output_212_0 = abs( ase_vertex3Pos.y );
			float temp_output_214_0 = ( temp_output_212_0 * _VertexFreqOffset );
			float temp_output_187_0 = ( ( _DeformAmount * sin( ( mulTime153 + ( ase_vertex3Pos.y * ( _VertexFreq * staticSwitch154 * temp_output_212_0 ) ) + temp_output_214_0 ) ) ) * ( 1.0 - (0.0 + (abs( ( ase_vertex3Pos.y + 0.5 ) ) - 0.0) * (0.5 - 0.0) / (1.0 - 0.0)) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			float4 appendResult174 = (float4(( temp_output_187_0 * ase_vertexNormal.x * _SpreadAmount ) , temp_output_187_0 , ( temp_output_187_0 * ase_vertexNormal.z * _SpreadAmount ) , 0.0));
			v.vertex.xyz += appendResult174.xyz;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult34 = (float2(min( i.uv_texcoord.x , i.uv_texcoord.y ) , max( i.uv_texcoord.x , i.uv_texcoord.y )));
			float2 break44 = abs( ( ( appendResult34 * float2( 2,2 ) ) + float2( -1,-1 ) ) );
			float2 appendResult45 = (float2(min( break44.x , break44.y ) , max( break44.x , break44.y )));
			float2 uv110 = appendResult45;
			float angle110 = 45.0;
			float2 localRotateUV110 = RotateUV110( uv110 , angle110 );
			float simplePerlin2D46 = snoise( ( localRotateUV110 + _PatternFactor ) );
			float2 uv70 = i.uv_texcoord;
			float angle70 = 45.0;
			float2 localRotateUV70 = RotateUV70( uv70 , angle70 );
			float2 break93 = localRotateUV70;
			float2 appendResult79 = (float2(min( break93.x , break93.y ) , max( break93.x , break93.y )));
			float2 break83 = abs( ( ( appendResult79 * float2( 2,2 ) ) + float2( -1,-1 ) ) );
			float2 appendResult86 = (float2(min( break83.x , break83.y ) , max( break83.x , break83.y )));
			float2 uv111 = appendResult86;
			float angle111 = 45.0;
			float2 localRotateUV111 = RotateUV111( uv111 , angle111 );
			float simplePerlin2D101 = snoise( ( localRotateUV111 + ( _PatternFactor + 0.05 ) ) );
			float temp_output_55_0 = abs( max( simplePerlin2D46 , simplePerlin2D101 ) );
			float smoothstepResult65 = smoothstep( 0.36 , 0.57 , min( temp_output_55_0 , ( 1.0 - temp_output_55_0 ) ));
			float smoothstepResult53 = smoothstep( 0.2 , 0.6 , distance( i.uv_texcoord , float2( 0.5,0.5 ) ));
			float pattern117 = ( smoothstepResult65 * ( 1.0 - smoothstepResult53 ) );
			float4 lerpResult140 = lerp( _MainColor , _PatternColor , pattern117);
			o.Emission = lerpResult140.rgb;
			float lerpResult203 = lerp( _MainColor.a , _PatternColor.a , pattern117);
			float3 ase_worldNormal = i.worldNormal;
			float3 switchResult195 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float dotResult196 = dot( switchResult195 , i.viewDir );
			float smoothstepResult200 = smoothstep( 0.0 , 3.0 , ( 1.0 - dotResult196 ));
			float clampResult202 = clamp( ( lerpResult203 + smoothstepResult200 ) , 0.0 , 1.0 );
			o.Alpha = clampResult202;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16600
647;653;1209;799;-3415.642;-803.6422;1.240439;True;False
Node;AmplifyShaderEditor.CommentaryNode;115;-1301.461,-545.8363;Float;False;4983.612;959.1045;Comment;27;2;70;75;76;93;69;114;111;110;89;48;101;46;95;55;56;60;65;97;112;113;52;49;53;54;51;117;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1251.461,-438.457;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;70;-950.502,-156.7988;Float;False;float rad = radians(angle)@$float sinX = sin ( rad)@$float cosX = cos ( rad)@$uv-=0.5@$float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX)@$return mul (  rotationMatrix, uv )+0.5@;2;False;2;True;uv;FLOAT2;0,0;In;;Float;True;angle;FLOAT;45;In;;Float;RotateUV;True;False;0;2;0;FLOAT2;0,0;False;1;FLOAT;45;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;75;-530.5051,-495.8363;Float;False;1345.516;303;Comment;10;33;32;34;4;3;7;44;43;42;45;base symmetry;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-524.6486,-117.1968;Float;False;1345.516;303;Comment;10;86;85;84;83;82;81;80;79;78;77;additional symmetry;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;93;-797.8583,46.85851;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;32;-480.5051,-416.4807;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;77;-474.2208,48.20226;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;78;-474.6486,-37.84124;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;33;-480.0773,-330.4372;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-340.9399,-42.11355;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-346.7965,-420.753;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-211.4267,-417.8723;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-205.5702,-39.23284;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-67.12891,-37.60635;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-72.98548,-416.2458;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;7;59.15314,-415.8718;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;82;65.00968,-37.23235;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;83;201.4558,-37.07046;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;44;195.5993,-415.7099;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMinOpNode;42;449.8678,-336.1199;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;444.4032,-421.9769;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;84;450.2599,-43.33746;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;85;455.7245,42.51958;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;719.6128,-173.6051;Float;False;Property;_PatternFactor;Pattern Factor;0;0;Create;True;0;0;False;0;0;-9.27;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;581.0107,-445.8363;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;586.8675,-67.19682;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;110;898.8893,-450.4963;Float;False;float rad = radians(angle)@$float sinX = sin ( rad)@$float cosX = cos ( rad)@$uv-=0.5@$float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX)@$return mul (  rotationMatrix, uv )+0.5@;2;False;2;True;uv;FLOAT2;0,0;In;;Float;True;angle;FLOAT;45;In;;Float;RotateUV;True;False;0;2;0;FLOAT2;0,0;False;1;FLOAT;45;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;111;898.8891,-29.64282;Float;False;float rad = radians(angle)@$float sinX = sin ( rad)@$float cosX = cos ( rad)@$uv-=0.5@$float2x2 rotationMatrix = float2x2( cosX, -sinX, sinX, cosX)@$return mul (  rotationMatrix, uv )+0.5@;2;False;2;True;uv;FLOAT2;0,0;In;;Float;True;angle;FLOAT;45;In;;Float;RotateUV;True;False;0;2;0;FLOAT2;0,0;False;1;FLOAT;45;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;1106.514,-74.23278;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;1271.167,127.9793;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;1231.574,-279.1955;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;101;1577.114,155.2682;Float;True;Simplex2D;1;0;FLOAT2;0.11231,0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;1612.134,-281.5175;Float;True;Simplex2D;1;0;FLOAT2;0.11231,0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;148;3847.253,788.5293;Float;False;2166.797;786.7824;Comment;30;173;171;169;168;165;164;162;161;159;158;157;155;154;153;151;150;149;183;187;212;213;214;215;216;217;218;219;220;222;221;Vertex Deform;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;95;1926.988,-243.8334;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;55;2225.598,-305.2986;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;150;3901.612,1453.041;Float;False;Constant;_Forward;Forward;5;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.PosVertexDataNode;157;3831.256,1048.286;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;2174.47,-19.10964;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;149;3895.033,1388.223;Float;False;Constant;_Backward;Backward;5;0;Create;True;0;0;False;0;-1;0;0;1;INT;0
Node;AmplifyShaderEditor.AbsOpNode;212;4050.39,1139.307;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;56;2423.762,-300.4653;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;3887.563,1273.957;Float;False;Property;_VertexFreq;VertexFreq;5;0;Create;True;0;0;False;0;4.5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;49;2510.219,15.1043;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;154;4050.305,1386.989;Float;False;Property;_Foward;Foward;9;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;193;4376.422,344.06;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;216;3852.647,994.6492;Float;False;Property;_VertexFreqOffset;VertexFreqOffset;8;0;Create;True;0;0;False;0;5;-1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;4088.508,902.0269;Float;False;Property;_Speed;Speed;6;0;Create;True;0;0;False;0;5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;183;4596.416,1174.725;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;53;2727.06,14.24199;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;4247.83,1253.48;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;60;2667.672,-325.8484;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;4237.014,1049.928;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;153;4247.153,898.3043;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;4881.89,1367.944;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;3137.958,-8.981709;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;194;4646.725,402.1903;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;2925.64,-306.0139;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.36;False;2;FLOAT;0.57;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;4391.299,1078.338;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;220;4933.592,1136.037;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;3278.096,-300.5751;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;198;4863.811,534.8622;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwitchByFaceNode;195;4861.687,396.1541;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;4583.165,922.4597;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;196;5126.337,405.3653;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;4617.653,824.6952;Float;False;Property;_DeformAmount;DeformAmount;4;0;Create;True;0;0;False;0;0.1;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;3492.237,-312.2067;Float;False;pattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;164;4748.759,896.9572;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;219;5039.985,1132.29;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;4961.999,82.36171;Float;False;117;pattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;4962.791,-80.99571;Float;False;Property;_PatternColor;Pattern Color;3;0;Create;True;0;0;False;0;0.406,0.406,0.406,1;1,0.8205301,0.804,0.2588235;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;221;5201.323,1131.217;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;197;5352.555,411.0325;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;4955.454,-261.4109;Float;False;Property;_MainColor;Main Color;1;0;Create;True;0;0;False;0;1,1,1,1;1,0.7019145,0.6745098,0.04705882;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;4928.685,849.6422;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;5317.099,962.1652;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;5163.021,1437.874;Float;False;Property;_SpreadAmount;SpreadAmount;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;203;5855.233,59.78264;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;200;5554.314,359.9255;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;169;5153.162,1288.751;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;201;5910.491,307.2826;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;5572.407,1081.529;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;5586.469,1295.332;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;174;6122.419,787.8407;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;218;5029.759,1329.652;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;1157.12,-32.66293;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;217;4794.727,1338.156;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;97;-952.1859,241.2068;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0.34;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;202;6113.65,300.6579;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;5219.709,65.04918;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;140;5861.887,-156.3598;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;141;5403.028,55.99274;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;4404.532,972.0806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;112;970.9598,-247.7415;Float;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;213;4318.153,1004.741;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;137;6659.297,319.3056;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH/JellyfishBell;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0.18;1,1,1,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;2;0
WireConnection;93;0;70;0
WireConnection;32;0;2;1
WireConnection;32;1;2;2
WireConnection;77;0;93;0
WireConnection;77;1;93;1
WireConnection;78;0;93;0
WireConnection;78;1;93;1
WireConnection;33;0;2;1
WireConnection;33;1;2;2
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;4;0;34;0
WireConnection;80;0;79;0
WireConnection;81;0;80;0
WireConnection;3;0;4;0
WireConnection;7;0;3;0
WireConnection;82;0;81;0
WireConnection;83;0;82;0
WireConnection;44;0;7;0
WireConnection;42;0;44;0
WireConnection;42;1;44;1
WireConnection;43;0;44;0
WireConnection;43;1;44;1
WireConnection;84;0;83;0
WireConnection;84;1;83;1
WireConnection;85;0;83;0
WireConnection;85;1;83;1
WireConnection;45;0;42;0
WireConnection;45;1;43;0
WireConnection;86;0;85;0
WireConnection;86;1;84;0
WireConnection;110;0;45;0
WireConnection;111;0;86;0
WireConnection;114;0;69;0
WireConnection;89;0;111;0
WireConnection;89;1;114;0
WireConnection;48;0;110;0
WireConnection;48;1;69;0
WireConnection;101;0;89;0
WireConnection;46;0;48;0
WireConnection;95;0;46;0
WireConnection;95;1;101;0
WireConnection;55;0;95;0
WireConnection;212;0;157;2
WireConnection;56;0;55;0
WireConnection;49;0;51;0
WireConnection;154;1;149;0
WireConnection;154;0;150;0
WireConnection;53;0;49;0
WireConnection;158;0;151;0
WireConnection;158;1;154;0
WireConnection;158;2;212;0
WireConnection;60;0;55;0
WireConnection;60;1;56;0
WireConnection;214;0;212;0
WireConnection;214;1;216;0
WireConnection;153;0;155;0
WireConnection;222;0;183;2
WireConnection;54;0;53;0
WireConnection;194;0;193;0
WireConnection;65;0;60;0
WireConnection;159;0;157;2
WireConnection;159;1;158;0
WireConnection;220;0;222;0
WireConnection;52;0;65;0
WireConnection;52;1;54;0
WireConnection;195;0;193;0
WireConnection;195;1;194;0
WireConnection;161;0;153;0
WireConnection;161;1;159;0
WireConnection;161;2;214;0
WireConnection;196;0;195;0
WireConnection;196;1;198;0
WireConnection;117;0;52;0
WireConnection;164;0;161;0
WireConnection;219;0;220;0
WireConnection;221;0;219;0
WireConnection;197;0;196;0
WireConnection;165;0;162;0
WireConnection;165;1;164;0
WireConnection;187;0;165;0
WireConnection;187;1;221;0
WireConnection;203;0;139;4
WireConnection;203;1;138;4
WireConnection;203;2;116;0
WireConnection;200;0;197;0
WireConnection;201;0;203;0
WireConnection;201;1;200;0
WireConnection;173;0;187;0
WireConnection;173;1;169;1
WireConnection;173;2;168;0
WireConnection;171;0;187;0
WireConnection;171;1;169;3
WireConnection;171;2;168;0
WireConnection;174;0;173;0
WireConnection;174;1;187;0
WireConnection;174;2;171;0
WireConnection;218;0;217;0
WireConnection;113;0;69;0
WireConnection;217;0;183;2
WireConnection;97;0;2;0
WireConnection;202;0;201;0
WireConnection;142;0;138;4
WireConnection;142;1;116;0
WireConnection;140;0;139;0
WireConnection;140;1;138;0
WireConnection;140;2;116;0
WireConnection;141;0;139;4
WireConnection;141;1;142;0
WireConnection;215;0;153;0
WireConnection;215;1;213;0
WireConnection;213;0;214;0
WireConnection;137;2;140;0
WireConnection;137;9;202;0
WireConnection;137;11;174;0
ASEEND*/
//CHKSM=340FD3EE043C5307BD5C8A4BD5D4E72FA61B4487