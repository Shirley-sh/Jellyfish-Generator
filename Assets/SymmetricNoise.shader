// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH/SymmetricNoise"
{
	Properties
	{
		
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

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
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue =  float3(0,0,0) ;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv02 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult34 = (float2(min( uv02.x , uv02.y ) , max( uv02.x , uv02.y )));
				float2 break44 = abs( ( ( appendResult34 * float2( 2,2 ) ) + float2( -1,-1 ) ) );
				float2 appendResult45 = (float2(min( break44.x , break44.y ) , max( break44.x , break44.y )));
				float mulTime47 = _Time.y * -1.0;
				float simplePerlin2D46 = snoise( ( appendResult45 + mulTime47 ) );
				float4 temp_cast_0 = (simplePerlin2D46).xxxx;
				
				
				finalColor = temp_cast_0;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16600
157;160;1398;739;-607.6377;478.6282;1.190878;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-854.2482,-431.1116;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;33;-530.2191,-335.8095;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;32;-530.6469,-421.853;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-396.9383,-426.1253;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-263.5231,-423.2446;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-123.1272,-421.6181;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;7;9.011411,-421.2441;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;44;145.4576,-421.0822;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;394.2614,-427.3492;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;42;399.726,-341.4922;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;1083.329,-127.8842;Float;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;636.3512,-408.6147;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;1297.932,-191.5955;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;53;1337.955,33.48813;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;49;1121.113,34.35045;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;865.3036,34.39606;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;1753.947,-138.8493;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;1574.631,48.93085;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;1462.13,-210.06;Float;False;Simplex2D;1;0;FLOAT2;0.11231,0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;2091.079,-175.4932;Float;False;True;2;Float;ASEMaterialInspector;0;1;SH/test;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;33;0;2;1
WireConnection;33;1;2;2
WireConnection;32;0;2;1
WireConnection;32;1;2;2
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;4;0;34;0
WireConnection;3;0;4;0
WireConnection;7;0;3;0
WireConnection;44;0;7;0
WireConnection;43;0;44;0
WireConnection;43;1;44;1
WireConnection;42;0;44;0
WireConnection;42;1;44;1
WireConnection;45;0;42;0
WireConnection;45;1;43;0
WireConnection;48;0;45;0
WireConnection;48;1;47;0
WireConnection;53;0;49;0
WireConnection;49;0;51;0
WireConnection;52;0;46;0
WireConnection;52;1;54;0
WireConnection;54;0;53;0
WireConnection;46;0;48;0
WireConnection;1;0;46;0
ASEEND*/
//CHKSM=015F445509DF8B01C6F2F492C1D93B1FD42A52DB