// Made with Amplify Shader Editor v1.9.9.11
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NewWaterfall"
{
	Properties
	{
		_WaterfallStartNoise( "Waterfall Start Noise", 2D ) = "white" {}
		_WaterfallStartNoiseSpeed( "Waterfall Start Noise Speed", Float ) = 0.2842633
		_WaterfallStartNoisePosition( "Waterfall Start Noise Position", Range( 0, 1 ) ) = 0.22
		_WaterfallStartNoiseOpacity( "Waterfall Start Noise Opacity", Range( 0, 1 ) ) = 0.22
		_WaterfallStartNoiseExtend( "Waterfall Start Noise Extend", Range( 0, 1 ) ) = 0.22
		_WaterfallStartNoisePow( "Waterfall Start Noise Pow", Range( 0, 1 ) ) = 1
		_CloudNoiseSpeed( "Cloud Noise Speed", Float ) = -0.1
		_CloudNoise( "Cloud Noise", 2D ) = "white" {}
		_WaterfallStartNoiseDistortion( "Waterfall Start Noise Distortion", Range( 0, 0.3 ) ) = 0.037
		_WaterfallStartNoiseDepth( "Waterfall Start Noise Depth", Range( 0, 1 ) ) = 0.037
		_ColorVariationSpeed( "Color Variation Speed", Float ) = -0.1
		_ColorVariationTexture( "Color Variation Texture", 2D ) = "white" {}
		_ColorVariationDepth( "Color Variation Depth", Range( 0, 1 ) ) = 0.054
		_Color1( "Color 1", Color ) = ( 0, 0.8273995, 1, 0 )
		_Color3( "Color 3", Color ) = ( 0, 0.5989819, 0.8867924, 0 )
		_Color4( "Color 4", Color ) = ( 0, 0.5989819, 0.8867924, 0 )
		_Color2( "Color 2", Color ) = ( 0, 0.5989819, 0.8867924, 0 )
		_ColorVariationContrast( "Color Variation Contrast", Float ) = 1
		_WaterfallEdgeSpeed( "Waterfall Edge Speed", Float ) = 0.2
		_WaterfallEdge( "Waterfall Edge", 2D ) = "white" {}
		_WaterfallEdgeFoamOpacity( "Waterfall Edge Foam Opacity", Range( 0, 1 ) ) = 0.5
		_TopVoronoi( "Top Voronoi", 2D ) = "white" {}
		_SmallDots1Scale( "Small Dots 1 Scale", Vector ) = ( 1, 1, 0, 0 )
		_SmallDots2Scale( "Small Dots 2 Scale", Vector ) = ( 1, 1, 0, 0 )
		_SmallDots2Speed( "Small Dots 2 Speed", Float ) = -0.1
		_SmallDots1Speed( "Small Dots 1 Speed", Float ) = -0.1
		_SmallDots1Step( "Small Dots 1 Step", Range( 0, 1 ) ) = 0.8
		_SmallDots2Step( "Small Dots 2 Step", Range( 0, 1 ) ) = 0.8
		_SmallDots1Opacity( "Small Dots 1 Opacity", Range( 0, 1 ) ) = 0.8
		_SmallDots2Opacity( "Small Dots 2 Opacity", Range( 0, 1 ) ) = 0.8
		_SmallDots1Distortion( "Small Dots 1 Distortion", Range( 0, 0.2 ) ) = 0.045
		_SmallDots2Distortion( "Small Dots 2 Distortion", Range( 0, 0.2 ) ) = 0.045
		_NoiseLinesPow( "Noise Lines Pow", Float ) = 1
		_NoiseLinesOpacity( "Noise Lines Opacity", Float ) = 0.8
		_NoiseLinesReveal( "Noise Lines Reveal", Float ) = 0.8
		_NoiseLinesDistortion( "Noise Lines Distortion", Range( 0, 0.3 ) ) = 0.042
		_NoiseLinesSpeed( "Noise Lines Speed", Float ) = -0.2
		_NoiseLines( "Noise Lines", 2D ) = "white" {}
		_BottomFoamSpeed( "Bottom Foam Speed", Float ) = -0.1
		_BottomFoamWidthPow( "Bottom Foam Width Pow", Float ) = 0
		_BottomFoamExtendMin( "Bottom Foam Extend Min", Float ) = 0
		_BottomFoamExtendMax( "Bottom Foam Extend Max", Range( 0, 1 ) ) = 0.15
		_BottomFoamStep( "Bottom Foam Step", Range( 0, 1 ) ) = 0.5
		_BottomFoamDistortion( "Bottom Foam Distortion", Range( 0, 0.3 ) ) = 0.05
		_StartNoiseHarshTiling( "Start Noise Harsh Tiling", Vector ) = ( 1, 1, 0, 0 )
		_StartNoiseHarshSpeed( "Start Noise Harsh Speed", Float ) = -1
		_StartNoiseHarshDistortion( "Start Noise Harsh Distortion", Range( 0, 0.2 ) ) = 0.026
		_StartNoiseharshTopPosition( "Start Noise harsh Top Position", Range( 0, 1 ) ) = 0.24
		_StartNoiseharshBottomPosition( "Start Noise harsh Bottom Position", Range( 0, 1 ) ) = 0.4435484
		_StartNoiseharshTopBlend( "Start Noise harsh Top Blend", Range( 0, 0.5 ) ) = 0.07522548
		_StartNoiseharshBottomBlend( "Start Noise harsh Bottom Blend", Range( 0, 0.5 ) ) = 0.07522548
		_StartNoiseHarshStep( "Start Noise Harsh Step", Range( 0, 1 ) ) = 0.51
		_InitialOpacityGradience( "Initial Opacity Gradience", Float ) = 10
		_BottomOpacityCutout( "Bottom Opacity Cutout", Range( 0, 1 ) ) = 0.9
		_Smoothness( "Smoothness", Range( 0, 1 ) ) = 0
		_NormalStrength( "Normal Strength", Float ) = 1
		[Toggle( _DEBUG_ON )] _DEBUG( "DEBUG", Float ) = 0
		_DebugWaterColor( "DebugWaterColor", Range( 0, 1 ) ) = 0
		_DebugNormals( "DebugNormals", Range( 0, 1 ) ) = 0
		_DebugCloudNoise( "Debug Cloud Noise", Range( 0, 1 ) ) = 0
		_EdgeFoamDistance( "Edge Foam Distance", Float ) = 1
		_EdgeFoamOpacity( "Edge Foam Opacity", Float ) = 1
		_EdgeFoamStep( "Edge Foam Step", Range( 0, 1 ) ) = 0.1


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		//_InstancedTerrainNormals("Instanced Terrain Normals", Float) = 1.0

		[ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[ToggleOff] _ScreenSpaceReflections("Screen Space Reflections", Float) = 1.0
		[ToggleOff] _ScreenSpaceReflectionsContributeTransparent("Screen Space Reflections Contribute Transparent", Float) = 1.0
		[HideInInspector][ToggleUI] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

		//[HideInInspector][ToggleUI] _AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 1
		//[HideInInspector] _XRMotionVectorsPass("_XRMotionVectorsPass", Float) = 1

		//[HideInInspector] _AlphaClip("__clip", Float) = 0.0
	}

	SubShader
	{
		PackageRequirements
		{
			"com.unity.render-pipelines.universal": "[17.0,18.0]"
		}

		

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "UniversalMaterialType"="Lit" }

	LOD 0

		Cull Back
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#define ASE_ADJUST_CLIP_POSITION( x ) x

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#if ( UNITY_VERSION >= 60010000 )
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#endif

			#if defined(UNITY_PLATFORM_META_QUEST) && ( UNITY_VERSION >= 60050000 )
            #pragma multi_compile _ META_QUEST_LIGHTUNROLL
            #endif

			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#if ( UNITY_VERSION >= 60030000 )
			#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
			#endif
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#if ( UNITY_VERSION >= 60010000 )
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#else
			#pragma multi_compile _ _FORWARD_PLUS
			#endif

            #if defined(UNITY_PLATFORM_META_QUEST) && ( UNITY_VERSION >= 60050000 )
            #pragma multi_compile _ META_QUEST_ORTHO_PROJ
            #pragma multi_compile _ META_QUEST_NO_SPOTLIGHTS_LIGHT_LOOP
            #endif

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#if ( UNITY_VERSION >= 60010000 )
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#endif
			#if ( UNITY_VERSION >= 60030000 )
			#pragma multi_compile_fragment _ REFLECTION_PROBE_ROTATION
			#endif
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_FORWARD

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#if ( UNITY_VERSION >= 60010000 )
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
			#else
			#pragma multi_compile_fog
			#endif
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			#if ( UNITY_VERSION < 60010000 )
				#define USE_CLUSTER_LIGHT_LOOP USE_FORWARD_PLUS
				#define CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _ColorVariationTexture;
			sampler2D _NoiseLines;
			sampler2D _CloudNoise;
			sampler2D _WaterfallStartNoise;
			sampler2D _WaterfallEdge;
			sampler2D _TopVoronoi;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			void CalculateUVsSmooth46_g2( float2 UV, float4 TexelSize, out float2 UV0, out float2 UV1, out float2 UV2, out float2 UV3, out float2 UV4, out float2 UV5, out float2 UV6, out float2 UV7, out float2 UV8 )
			{
				{
				    float3 pos = float3( TexelSize.xy, 0 );
				    float3 neg = float3( -pos.xy, 0 );
				    UV0 = UV + neg.xy;
				    UV1 = UV + neg.zy;
				    UV2 = UV + float2( pos.x, neg.y );
				    UV3 = UV + neg.xz;
				    UV4 = UV;
				    UV5 = UV + pos.xz;
				    UV6 = UV + float2( neg.x, pos.y );
				    UV7 = UV + pos.zy;
				    UV8 = UV + pos.xy;
				    return;
				}
			}
			
			float3 CombineSamplesSmooth58_g2( float Strength, float S0, float S1, float S2, float S3, float S4, float S5, float S6, float S7, float S8 )
			{
				{
				    float3 normal;
				    normal.x = Strength * ( S0 - S2 + 2 * S3 - 2 * S5 + S6 - S8 );
				    normal.y = Strength * ( S0 + 2 * S1 + S2 - S6 - 2 * S7 - S8 );
				    normal.z = 1.0;
				    return normalize( normal );
				}
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord7.xy = input.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord7.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif
				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				#ifdef ASE_CUSTOM_MOTION_VECTOR
					// Declared so the Motion Vector output port surfaces on the master node; only consumed by the motion vector passes.
					float3 aseCustomMotionVector = float3(0, 0, 0);
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						output.fogFactorAndVertexLight.x = ComputeFogFactor(vertexInput.positionCS.z);
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag ( PackedVaryings input
						#if defined( ASE_WRITE_DEPTH )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						#if ( UNITY_VERSION >= 60020000 )
						, out uint outRenderingLayers : SV_Target1
						#else
						, out float4 outRenderingLayers : SV_Target1
						#endif
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined( _SURFACE_TYPE_TRANSPARENT )
					const bool isTransparent = true;
				#else
					const bool isTransparent = false;
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float2 uv_ColorVariationTexture = input.ase_texcoord7.xy * _ColorVariationTexture_ST.xy + _ColorVariationTexture_ST.zw;
				float mulTime52 = _TimeParameters.x * _ColorVariationSpeed;
				float2 appendResult54 = (float2(0.0 , mulTime52));
				float2 temp_output_55_0 = ( uv_ColorVariationTexture + appendResult54 );
				float4 tex2DNode48 = tex2D( _ColorVariationTexture, temp_output_55_0 );
				float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
				float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
				float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
				float3 normalizeResult59 = normalize( ase_viewVectorTS );
				float2 paralaxOffset47 = ParallaxOffset( tex2DNode48.g , _ColorVariationDepth , normalizeResult59 );
				float4 tex2DNode57 = tex2D( _ColorVariationTexture, ( paralaxOffset47 + temp_output_55_0 ) );
				float4 lerpResult62 = lerp( _Color2 , _Color1 , pow( tex2DNode57.g , _ColorVariationContrast ));
				float2 uv_NoiseLines = input.ase_texcoord7.xy * _NoiseLines_ST.xy + _NoiseLines_ST.zw;
				float mulTime188 = _TimeParameters.x * _NoiseLinesSpeed;
				float2 appendResult190 = (float2(0.0 , mulTime188));
				float2 uv_CloudNoise = input.ase_texcoord7.xy * _CloudNoise_ST.xy + _CloudNoise_ST.zw;
				float mulTime32 = _TimeParameters.x * _CloudNoiseSpeed;
				float2 appendResult33 = (float2(mulTime32 , 0.0));
				float4 Cloud_Noise37 = tex2D( _CloudNoise, ( uv_CloudNoise + appendResult33 ) );
				float4 lerpResult199 = lerp( lerpResult62 , _Color3 , pow( saturate( ( tex2D( _NoiseLines, ( uv_NoiseLines + appendResult190 + ( (Cloud_Noise37).rg * _NoiseLinesDistortion ) ) ).g * _NoiseLinesOpacity * pow( tex2DNode48.g , _NoiseLinesReveal ) ) ) , _NoiseLinesPow ));
				float2 uv_WaterfallStartNoise = input.ase_texcoord7.xy * _WaterfallStartNoise_ST.xy + _WaterfallStartNoise_ST.zw;
				float mulTime3 = _TimeParameters.x * _WaterfallStartNoiseSpeed;
				float2 appendResult5 = (float2(0.0 , mulTime3));
				float2 temp_output_6_0 = ( uv_WaterfallStartNoise + appendResult5 + ( (Cloud_Noise37).rg * _WaterfallStartNoiseDistortion ) );
				float3 normalizeResult236 = normalize( ase_viewVectorTS );
				float2 paralaxOffset234 = ParallaxOffset( tex2D( _WaterfallStartNoise, temp_output_6_0 ).g , _WaterfallStartNoiseDepth , normalizeResult236 );
				float2 texCoord17 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult19 = smoothstep( _WaterfallStartNoiseExtend , _WaterfallStartNoisePow , abs( ( texCoord17.y - _WaterfallStartNoisePosition ) ));
				float4 lerpResult238 = lerp( lerpResult199 , float4( _Color4.rgb , 0.0 ) , saturate( ( tex2D( _WaterfallStartNoise, ( temp_output_6_0 + paralaxOffset234 ) ).g * ( smoothstepResult19 * _WaterfallStartNoiseOpacity ) ) ));
				float4 Water_Color73 = lerpResult238;
				float mulTime252 = _TimeParameters.x * _BottomFoamSpeed;
				float2 appendResult254 = (float2(0.0 , mulTime252));
				float2 texCoord257 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult258 = smoothstep( _BottomFoamExtendMax , _BottomFoamExtendMin , ( 1.0 - texCoord257.y ));
				float Bottom_Foam264 = step( _BottomFoamStep , ( tex2D( _WaterfallStartNoise, ( uv_WaterfallStartNoise + appendResult254 + ( (Cloud_Noise37).rg * _BottomFoamDistortion ) ) ).g * smoothstepResult258 * pow( ( 1.0 - ( abs( ( texCoord257.x - 0.5 ) ) * 2.0 ) ) , _BottomFoamWidthPow ) ) );
				float2 uv_WaterfallEdge = input.ase_texcoord7.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Watefal_Edge87 = ( step( 0.6 , tex2DNode83.r ) * _WaterfallEdgeFoamOpacity );
				float2 texCoord129 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime133 = _TimeParameters.x * _SmallDots1Speed;
				float2 appendResult134 = (float2(0.0 , mulTime133));
				float Small_Dots_1139 = ( step( _SmallDots1Step , tex2D( _TopVoronoi, ( ( texCoord129 * _SmallDots1Scale ) + appendResult134 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots1Distortion ) + float2( 0.32,0.27 ) ) ).g ) * _SmallDots1Opacity );
				float2 texCoord290 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime295 = _TimeParameters.x * _StartNoiseHarshSpeed;
				float2 appendResult296 = (float2(0.0 , mulTime295));
				float smoothstepResult303 = smoothstep( _StartNoiseharshTopPosition , ( _StartNoiseharshTopPosition + _StartNoiseharshTopBlend ) , texCoord290.y);
				float smoothstepResult304 = smoothstep( _StartNoiseharshBottomPosition , ( _StartNoiseharshBottomPosition + _StartNoiseharshBottomBlend ) , texCoord290.y);
				float Start_Noise_Harsh316 = step( _StartNoiseHarshStep , ( tex2D( _WaterfallStartNoise, ( ( texCoord290 * _StartNoiseHarshTiling ) + appendResult296 + ( (Cloud_Noise37).rg * _StartNoiseHarshDistortion ) ) ).g * ( smoothstepResult303 * ( 1.0 - smoothstepResult304 ) ) ) );
				float2 texCoord154 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime156 = _TimeParameters.x * _SmallDots2Speed;
				float2 appendResult161 = (float2(0.0 , mulTime156));
				float Small_Dots_2168 = ( step( _SmallDots2Step , tex2D( _TopVoronoi, ( ( texCoord154 * _SmallDots2Scale ) + appendResult161 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots2Distortion ) ) ).g ) * _SmallDots2Opacity );
				float depthLinearEye370 = LinearEyeDepth( SHADERGRAPH_SAMPLE_SCENE_DEPTH( ScreenPosNorm.xy ), _ZBufferParams );
				float Scene_Depth372 = ( depthLinearEye370 - ScreenPos.w );
				float Edge_Foam382 = ( step( _EdgeFoamStep , saturate( ( saturate( ( ( ( Scene_Depth372 - _EdgeFoamDistance ) / _EdgeFoamDistance ) * -1.0 ) ) * tex2DNode57.g ) ) ) * _EdgeFoamOpacity );
				float Foam_Mask71 = max( max( max( Bottom_Foam264, Watefal_Edge87 ), Small_Dots_1139 ), max( max( Start_Noise_Harsh316, Small_Dots_2168 ), Edge_Foam382 ) );
				float4 lerpResult67 = lerp( Water_Color73 , float4( 1,1,1,0 ) , Foam_Mask71);
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch358 = temp_cast_1;
				#else
				float4 staticSwitch358 = lerpResult67;
				#endif
				
				float temp_output_91_0_g2 = _NormalStrength;
				float Strength58_g2 = temp_output_91_0_g2;
				float localCalculateUVsSmooth46_g2 = ( 0.0 );
				float2 temp_output_85_0_g2 = temp_output_55_0;
				float2 UV46_g2 = temp_output_85_0_g2;
				float4 TexelSize46_g2 = _ColorVariationTexture_TexelSize;
				float2 UV046_g2 = float2( 0,0 );
				float2 UV146_g2 = float2( 0,0 );
				float2 UV246_g2 = float2( 0,0 );
				float2 UV346_g2 = float2( 0,0 );
				float2 UV446_g2 = float2( 0,0 );
				float2 UV546_g2 = float2( 0,0 );
				float2 UV646_g2 = float2( 0,0 );
				float2 UV746_g2 = float2( 0,0 );
				float2 UV846_g2 = float2( 0,0 );
				CalculateUVsSmooth46_g2( UV46_g2 , TexelSize46_g2 , UV046_g2 , UV146_g2 , UV246_g2 , UV346_g2 , UV446_g2 , UV546_g2 , UV646_g2 , UV746_g2 , UV846_g2 );
				float4 break140_g2 = tex2D( _ColorVariationTexture, UV046_g2 );
				float S058_g2 = break140_g2.g;
				float4 break142_g2 = tex2D( _ColorVariationTexture, UV146_g2 );
				float S158_g2 = break142_g2.g;
				float4 break146_g2 = tex2D( _ColorVariationTexture, UV246_g2 );
				float S258_g2 = break146_g2.g;
				float4 break148_g2 = tex2D( _ColorVariationTexture, UV346_g2 );
				float S358_g2 = break148_g2.g;
				float4 break150_g2 = tex2D( _ColorVariationTexture, UV446_g2 );
				float S458_g2 = break150_g2.g;
				float4 break152_g2 = tex2D( _ColorVariationTexture, UV546_g2 );
				float S558_g2 = break152_g2.g;
				float4 break154_g2 = tex2D( _ColorVariationTexture, UV646_g2 );
				float S658_g2 = break154_g2.g;
				float4 break156_g2 = tex2D( _ColorVariationTexture, UV746_g2 );
				float S758_g2 = break156_g2.g;
				float4 break158_g2 = tex2D( _ColorVariationTexture, UV846_g2 );
				float S858_g2 = break158_g2.g;
				float3 localCombineSamplesSmooth58_g2 = CombineSamplesSmooth58_g2( Strength58_g2 , S058_g2 , S158_g2 , S258_g2 , S358_g2 , S458_g2 , S558_g2 , S658_g2 , S758_g2 , S858_g2 );
				float3 Normals366 = localCombineSamplesSmooth58_g2;
				#ifdef _DEBUG_ON
				float3 staticSwitch364 = float3( 0, 0, 1 );
				#else
				float3 staticSwitch364 = Normals366;
				#endif
				
				#ifdef _DEBUG_ON
				float staticSwitch362 = 0.0;
				#else
				float staticSwitch362 = _Smoothness;
				#endif
				
				float4 temp_cast_3 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch357 = ( ( Water_Color73 * _DebugWaterColor ) + float4( ( Normals366 * _DebugNormals ) , 0.0 ) + ( Cloud_Noise37 * _DebugCloudNoise ) );
				#else
				float4 staticSwitch357 = temp_cast_3;
				#endif
				
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float3 BaseColor = staticSwitch358.rgb;
				float3 Normal = staticSwitch364;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = staticSwitch362;
				float Occlusion = 1;
				float3 Emission = staticSwitch357.rgb;
				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.viewDirectionWS = ViewDirWS;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = NormalWS;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = InitializeInputDataFog(float4(inputData.positionWS, 1.0), input.fogFactorAndVertexLight.x);
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(_SCREEN_SPACE_IRRADIANCE) && ( UNITY_VERSION >= 60030000 )
					#if ( UNITY_VERSION >= 60060000 )
						inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy, inputData.normalWS));
					#else
						inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy);
					#endif
				#elif defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI( SH, GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask );
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToSurfaceData(input.positionCS, surfaceData, inputData);
				#endif

				#ifdef ASE_LIGHTING_SIMPLE
					half4 color = UniversalFragmentBlinnPhong( inputData, surfaceData);
				#else
					half4 color = UniversalFragmentPBR( inputData, surfaceData);
				#endif

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( NormalWS,0 ) ).xyz * ( 1.0 - dot( NormalWS, ViewDirWS ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3(0,0,0), inputData.fogCoord);
					#else
						color.rgb = MixFog(color.rgb, inputData.fogCoord);
					#endif
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					#if ( UNITY_VERSION >= 60020000 )
					outRenderingLayers = EncodeMeshRenderingLayer();
					#else
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
					#endif
				#endif

				#if defined( ASE_OPAQUE_KEEP_ALPHA )
					return half4( color.rgb, color.a );
				#else
					return half4( color.rgb, OutputAlpha( color.a, isTransparent ) );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW // @diogo: removed _vertex for POM node

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _WaterfallEdge;


			float3 _LightDirection;
			float3 _LightPosition;

			
			PackedVaryings VertexFunction( Attributes input )
			{
				PackedVaryings output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				float3 positionWS = TransformObjectToWorld( input.positionOS.xyz );
				float3 normalWS = TransformObjectToWorldDir(input.normalOS);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 positionCS = ASE_ADJUST_CLIP_POSITION( TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS)) );

				//code for UNITY_REVERSED_Z is moved into Shadows.hlsl from 6000.0.22 and or higher
				positionCS = ApplyShadowClamping(positionCS);

				output.positionCS = positionCS;
				output.positionWS = positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_WRITE_DEPTH )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				float2 uv_WaterfallEdge = input.ase_texcoord1.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					#if defined( _ALPHATEST_SHADOW_ON )
						AlphaDiscard( Alpha, AlphaClipThresholdShadow );
					#else
						AlphaDiscard( Alpha, AlphaClipThreshold );
					#endif
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _WaterfallEdge;


			
			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_WRITE_DEPTH )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				float2 uv_WaterfallEdge = input.ase_texcoord1.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma shader_feature EDITOR_VISUALIZATION

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD1;
					float4 LightCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _ColorVariationTexture;
			sampler2D _NoiseLines;
			sampler2D _CloudNoise;
			sampler2D _WaterfallStartNoise;
			sampler2D _WaterfallEdge;
			sampler2D _TopVoronoi;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			void CalculateUVsSmooth46_g2( float2 UV, float4 TexelSize, out float2 UV0, out float2 UV1, out float2 UV2, out float2 UV3, out float2 UV4, out float2 UV5, out float2 UV6, out float2 UV7, out float2 UV8 )
			{
				{
				    float3 pos = float3( TexelSize.xy, 0 );
				    float3 neg = float3( -pos.xy, 0 );
				    UV0 = UV + neg.xy;
				    UV1 = UV + neg.zy;
				    UV2 = UV + float2( pos.x, neg.y );
				    UV3 = UV + neg.xz;
				    UV4 = UV;
				    UV5 = UV + pos.xz;
				    UV6 = UV + float2( neg.x, pos.y );
				    UV7 = UV + pos.zy;
				    UV8 = UV + pos.xy;
				    return;
				}
			}
			
			float3 CombineSamplesSmooth58_g2( float Strength, float S0, float S1, float S2, float S3, float S4, float S5, float S6, float S7, float S8 )
			{
				{
				    float3 normal;
				    normal.x = Strength * ( S0 - S2 + 2 * S3 - 2 * S5 + S6 - S8 );
				    normal.y = Strength * ( S0 + 2 * S1 + S2 - S6 - 2 * S7 - S8 );
				    normal.z = 1.0;
				    return normalize( normal );
				}
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				float3 ase_tangentWS = TransformObjectToWorldDir( input.tangentOS.xyz );
				output.ase_texcoord4.xyz = ase_tangentWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( input.normalOS );
				output.ase_texcoord5.xyz = ase_normalWS;
				float ase_tangentSign = input.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				output.ase_texcoord6.xyz = ase_bitangentWS;
				float4 ase_positionCS = TransformObjectToHClip( ( input.positionOS ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				output.ase_texcoord7 = screenPos;
				
				output.ase_texcoord3.xy = input.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord3.zw = 0;
				output.ase_texcoord4.w = 0;
				output.ase_texcoord5.w = 0;
				output.ase_texcoord6.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(input.positionOS.xyz, input.texcoord.xy, input.texcoord1.xy, input.texcoord2.xy, VizUV, LightCoord);
					output.VizUV = float4(VizUV, 0, 0);
					output.LightCoord = LightCoord;
				#endif

				output.positionCS = MetaVertexPosition( input.positionOS, input.texcoord1.xy, input.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				output.positionWS = TransformObjectToWorld( input.positionOS.xyz );
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				output.texcoord1 = input.texcoord1;
				output.texcoord2 = input.texcoord2;
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float2 uv_ColorVariationTexture = input.ase_texcoord3.xy * _ColorVariationTexture_ST.xy + _ColorVariationTexture_ST.zw;
				float mulTime52 = _TimeParameters.x * _ColorVariationSpeed;
				float2 appendResult54 = (float2(0.0 , mulTime52));
				float2 temp_output_55_0 = ( uv_ColorVariationTexture + appendResult54 );
				float4 tex2DNode48 = tex2D( _ColorVariationTexture, temp_output_55_0 );
				float3 ase_tangentWS = input.ase_texcoord4.xyz;
				float3 ase_normalWS = input.ase_texcoord5.xyz;
				float3 ase_bitangentWS = input.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
				float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
				float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
				float3 normalizeResult59 = normalize( ase_viewVectorTS );
				float2 paralaxOffset47 = ParallaxOffset( tex2DNode48.g , _ColorVariationDepth , normalizeResult59 );
				float4 tex2DNode57 = tex2D( _ColorVariationTexture, ( paralaxOffset47 + temp_output_55_0 ) );
				float4 lerpResult62 = lerp( _Color2 , _Color1 , pow( tex2DNode57.g , _ColorVariationContrast ));
				float2 uv_NoiseLines = input.ase_texcoord3.xy * _NoiseLines_ST.xy + _NoiseLines_ST.zw;
				float mulTime188 = _TimeParameters.x * _NoiseLinesSpeed;
				float2 appendResult190 = (float2(0.0 , mulTime188));
				float2 uv_CloudNoise = input.ase_texcoord3.xy * _CloudNoise_ST.xy + _CloudNoise_ST.zw;
				float mulTime32 = _TimeParameters.x * _CloudNoiseSpeed;
				float2 appendResult33 = (float2(mulTime32 , 0.0));
				float4 Cloud_Noise37 = tex2D( _CloudNoise, ( uv_CloudNoise + appendResult33 ) );
				float4 lerpResult199 = lerp( lerpResult62 , _Color3 , pow( saturate( ( tex2D( _NoiseLines, ( uv_NoiseLines + appendResult190 + ( (Cloud_Noise37).rg * _NoiseLinesDistortion ) ) ).g * _NoiseLinesOpacity * pow( tex2DNode48.g , _NoiseLinesReveal ) ) ) , _NoiseLinesPow ));
				float2 uv_WaterfallStartNoise = input.ase_texcoord3.xy * _WaterfallStartNoise_ST.xy + _WaterfallStartNoise_ST.zw;
				float mulTime3 = _TimeParameters.x * _WaterfallStartNoiseSpeed;
				float2 appendResult5 = (float2(0.0 , mulTime3));
				float2 temp_output_6_0 = ( uv_WaterfallStartNoise + appendResult5 + ( (Cloud_Noise37).rg * _WaterfallStartNoiseDistortion ) );
				float3 normalizeResult236 = normalize( ase_viewVectorTS );
				float2 paralaxOffset234 = ParallaxOffset( tex2D( _WaterfallStartNoise, temp_output_6_0 ).g , _WaterfallStartNoiseDepth , normalizeResult236 );
				float2 texCoord17 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult19 = smoothstep( _WaterfallStartNoiseExtend , _WaterfallStartNoisePow , abs( ( texCoord17.y - _WaterfallStartNoisePosition ) ));
				float4 lerpResult238 = lerp( lerpResult199 , float4( _Color4.rgb , 0.0 ) , saturate( ( tex2D( _WaterfallStartNoise, ( temp_output_6_0 + paralaxOffset234 ) ).g * ( smoothstepResult19 * _WaterfallStartNoiseOpacity ) ) ));
				float4 Water_Color73 = lerpResult238;
				float mulTime252 = _TimeParameters.x * _BottomFoamSpeed;
				float2 appendResult254 = (float2(0.0 , mulTime252));
				float2 texCoord257 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult258 = smoothstep( _BottomFoamExtendMax , _BottomFoamExtendMin , ( 1.0 - texCoord257.y ));
				float Bottom_Foam264 = step( _BottomFoamStep , ( tex2D( _WaterfallStartNoise, ( uv_WaterfallStartNoise + appendResult254 + ( (Cloud_Noise37).rg * _BottomFoamDistortion ) ) ).g * smoothstepResult258 * pow( ( 1.0 - ( abs( ( texCoord257.x - 0.5 ) ) * 2.0 ) ) , _BottomFoamWidthPow ) ) );
				float2 uv_WaterfallEdge = input.ase_texcoord3.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Watefal_Edge87 = ( step( 0.6 , tex2DNode83.r ) * _WaterfallEdgeFoamOpacity );
				float2 texCoord129 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime133 = _TimeParameters.x * _SmallDots1Speed;
				float2 appendResult134 = (float2(0.0 , mulTime133));
				float Small_Dots_1139 = ( step( _SmallDots1Step , tex2D( _TopVoronoi, ( ( texCoord129 * _SmallDots1Scale ) + appendResult134 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots1Distortion ) + float2( 0.32,0.27 ) ) ).g ) * _SmallDots1Opacity );
				float2 texCoord290 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime295 = _TimeParameters.x * _StartNoiseHarshSpeed;
				float2 appendResult296 = (float2(0.0 , mulTime295));
				float smoothstepResult303 = smoothstep( _StartNoiseharshTopPosition , ( _StartNoiseharshTopPosition + _StartNoiseharshTopBlend ) , texCoord290.y);
				float smoothstepResult304 = smoothstep( _StartNoiseharshBottomPosition , ( _StartNoiseharshBottomPosition + _StartNoiseharshBottomBlend ) , texCoord290.y);
				float Start_Noise_Harsh316 = step( _StartNoiseHarshStep , ( tex2D( _WaterfallStartNoise, ( ( texCoord290 * _StartNoiseHarshTiling ) + appendResult296 + ( (Cloud_Noise37).rg * _StartNoiseHarshDistortion ) ) ).g * ( smoothstepResult303 * ( 1.0 - smoothstepResult304 ) ) ) );
				float2 texCoord154 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime156 = _TimeParameters.x * _SmallDots2Speed;
				float2 appendResult161 = (float2(0.0 , mulTime156));
				float Small_Dots_2168 = ( step( _SmallDots2Step , tex2D( _TopVoronoi, ( ( texCoord154 * _SmallDots2Scale ) + appendResult161 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots2Distortion ) ) ).g ) * _SmallDots2Opacity );
				float4 screenPos = input.ase_texcoord7;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float depthLinearEye370 = LinearEyeDepth( SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ), _ZBufferParams );
				float Scene_Depth372 = ( depthLinearEye370 - screenPos.w );
				float Edge_Foam382 = ( step( _EdgeFoamStep , saturate( ( saturate( ( ( ( Scene_Depth372 - _EdgeFoamDistance ) / _EdgeFoamDistance ) * -1.0 ) ) * tex2DNode57.g ) ) ) * _EdgeFoamOpacity );
				float Foam_Mask71 = max( max( max( Bottom_Foam264, Watefal_Edge87 ), Small_Dots_1139 ), max( max( Start_Noise_Harsh316, Small_Dots_2168 ), Edge_Foam382 ) );
				float4 lerpResult67 = lerp( Water_Color73 , float4( 1,1,1,0 ) , Foam_Mask71);
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch358 = temp_cast_1;
				#else
				float4 staticSwitch358 = lerpResult67;
				#endif
				
				float4 temp_cast_3 = (0.0).xxxx;
				float temp_output_91_0_g2 = _NormalStrength;
				float Strength58_g2 = temp_output_91_0_g2;
				float localCalculateUVsSmooth46_g2 = ( 0.0 );
				float2 temp_output_85_0_g2 = temp_output_55_0;
				float2 UV46_g2 = temp_output_85_0_g2;
				float4 TexelSize46_g2 = _ColorVariationTexture_TexelSize;
				float2 UV046_g2 = float2( 0,0 );
				float2 UV146_g2 = float2( 0,0 );
				float2 UV246_g2 = float2( 0,0 );
				float2 UV346_g2 = float2( 0,0 );
				float2 UV446_g2 = float2( 0,0 );
				float2 UV546_g2 = float2( 0,0 );
				float2 UV646_g2 = float2( 0,0 );
				float2 UV746_g2 = float2( 0,0 );
				float2 UV846_g2 = float2( 0,0 );
				CalculateUVsSmooth46_g2( UV46_g2 , TexelSize46_g2 , UV046_g2 , UV146_g2 , UV246_g2 , UV346_g2 , UV446_g2 , UV546_g2 , UV646_g2 , UV746_g2 , UV846_g2 );
				float4 break140_g2 = tex2D( _ColorVariationTexture, UV046_g2 );
				float S058_g2 = break140_g2.g;
				float4 break142_g2 = tex2D( _ColorVariationTexture, UV146_g2 );
				float S158_g2 = break142_g2.g;
				float4 break146_g2 = tex2D( _ColorVariationTexture, UV246_g2 );
				float S258_g2 = break146_g2.g;
				float4 break148_g2 = tex2D( _ColorVariationTexture, UV346_g2 );
				float S358_g2 = break148_g2.g;
				float4 break150_g2 = tex2D( _ColorVariationTexture, UV446_g2 );
				float S458_g2 = break150_g2.g;
				float4 break152_g2 = tex2D( _ColorVariationTexture, UV546_g2 );
				float S558_g2 = break152_g2.g;
				float4 break154_g2 = tex2D( _ColorVariationTexture, UV646_g2 );
				float S658_g2 = break154_g2.g;
				float4 break156_g2 = tex2D( _ColorVariationTexture, UV746_g2 );
				float S758_g2 = break156_g2.g;
				float4 break158_g2 = tex2D( _ColorVariationTexture, UV846_g2 );
				float S858_g2 = break158_g2.g;
				float3 localCombineSamplesSmooth58_g2 = CombineSamplesSmooth58_g2( Strength58_g2 , S058_g2 , S158_g2 , S258_g2 , S358_g2 , S458_g2 , S558_g2 , S658_g2 , S758_g2 , S858_g2 );
				float3 Normals366 = localCombineSamplesSmooth58_g2;
				#ifdef _DEBUG_ON
				float4 staticSwitch357 = ( ( Water_Color73 * _DebugWaterColor ) + float4( ( Normals366 * _DebugNormals ) , 0.0 ) + ( Cloud_Noise37 * _DebugCloudNoise ) );
				#else
				float4 staticSwitch357 = temp_cast_3;
				#endif
				
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float3 BaseColor = staticSwitch358.rgb;
				float3 Emission = staticSwitch357.rgb;
				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = input.VizUV.xy;
					metaInput.LightCoord = input.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300
			#define REQUIRE_DEPTH_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _ColorVariationTexture;
			sampler2D _NoiseLines;
			sampler2D _CloudNoise;
			sampler2D _WaterfallStartNoise;
			sampler2D _WaterfallEdge;
			sampler2D _TopVoronoi;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_TRANSFER_INSTANCE_ID( input, output );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				float3 ase_tangentWS = TransformObjectToWorldDir( input.tangentOS.xyz );
				output.ase_texcoord2.xyz = ase_tangentWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( input.normalOS );
				output.ase_texcoord3.xyz = ase_normalWS;
				float ase_tangentSign = input.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				output.ase_texcoord4.xyz = ase_bitangentWS;
				float4 ase_positionCS = TransformObjectToHClip( ( input.positionOS ).xyz );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				output.ase_texcoord5 = screenPos;
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;
				output.ase_texcoord2.w = 0;
				output.ase_texcoord3.w = 0;
				output.ase_texcoord4.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float2 uv_ColorVariationTexture = input.ase_texcoord1.xy * _ColorVariationTexture_ST.xy + _ColorVariationTexture_ST.zw;
				float mulTime52 = _TimeParameters.x * _ColorVariationSpeed;
				float2 appendResult54 = (float2(0.0 , mulTime52));
				float2 temp_output_55_0 = ( uv_ColorVariationTexture + appendResult54 );
				float4 tex2DNode48 = tex2D( _ColorVariationTexture, temp_output_55_0 );
				float3 ase_tangentWS = input.ase_texcoord2.xyz;
				float3 ase_normalWS = input.ase_texcoord3.xyz;
				float3 ase_bitangentWS = input.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
				float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
				float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
				float3 normalizeResult59 = normalize( ase_viewVectorTS );
				float2 paralaxOffset47 = ParallaxOffset( tex2DNode48.g , _ColorVariationDepth , normalizeResult59 );
				float4 tex2DNode57 = tex2D( _ColorVariationTexture, ( paralaxOffset47 + temp_output_55_0 ) );
				float4 lerpResult62 = lerp( _Color2 , _Color1 , pow( tex2DNode57.g , _ColorVariationContrast ));
				float2 uv_NoiseLines = input.ase_texcoord1.xy * _NoiseLines_ST.xy + _NoiseLines_ST.zw;
				float mulTime188 = _TimeParameters.x * _NoiseLinesSpeed;
				float2 appendResult190 = (float2(0.0 , mulTime188));
				float2 uv_CloudNoise = input.ase_texcoord1.xy * _CloudNoise_ST.xy + _CloudNoise_ST.zw;
				float mulTime32 = _TimeParameters.x * _CloudNoiseSpeed;
				float2 appendResult33 = (float2(mulTime32 , 0.0));
				float4 Cloud_Noise37 = tex2D( _CloudNoise, ( uv_CloudNoise + appendResult33 ) );
				float4 lerpResult199 = lerp( lerpResult62 , _Color3 , pow( saturate( ( tex2D( _NoiseLines, ( uv_NoiseLines + appendResult190 + ( (Cloud_Noise37).rg * _NoiseLinesDistortion ) ) ).g * _NoiseLinesOpacity * pow( tex2DNode48.g , _NoiseLinesReveal ) ) ) , _NoiseLinesPow ));
				float2 uv_WaterfallStartNoise = input.ase_texcoord1.xy * _WaterfallStartNoise_ST.xy + _WaterfallStartNoise_ST.zw;
				float mulTime3 = _TimeParameters.x * _WaterfallStartNoiseSpeed;
				float2 appendResult5 = (float2(0.0 , mulTime3));
				float2 temp_output_6_0 = ( uv_WaterfallStartNoise + appendResult5 + ( (Cloud_Noise37).rg * _WaterfallStartNoiseDistortion ) );
				float3 normalizeResult236 = normalize( ase_viewVectorTS );
				float2 paralaxOffset234 = ParallaxOffset( tex2D( _WaterfallStartNoise, temp_output_6_0 ).g , _WaterfallStartNoiseDepth , normalizeResult236 );
				float2 texCoord17 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult19 = smoothstep( _WaterfallStartNoiseExtend , _WaterfallStartNoisePow , abs( ( texCoord17.y - _WaterfallStartNoisePosition ) ));
				float4 lerpResult238 = lerp( lerpResult199 , float4( _Color4.rgb , 0.0 ) , saturate( ( tex2D( _WaterfallStartNoise, ( temp_output_6_0 + paralaxOffset234 ) ).g * ( smoothstepResult19 * _WaterfallStartNoiseOpacity ) ) ));
				float4 Water_Color73 = lerpResult238;
				float mulTime252 = _TimeParameters.x * _BottomFoamSpeed;
				float2 appendResult254 = (float2(0.0 , mulTime252));
				float2 texCoord257 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult258 = smoothstep( _BottomFoamExtendMax , _BottomFoamExtendMin , ( 1.0 - texCoord257.y ));
				float Bottom_Foam264 = step( _BottomFoamStep , ( tex2D( _WaterfallStartNoise, ( uv_WaterfallStartNoise + appendResult254 + ( (Cloud_Noise37).rg * _BottomFoamDistortion ) ) ).g * smoothstepResult258 * pow( ( 1.0 - ( abs( ( texCoord257.x - 0.5 ) ) * 2.0 ) ) , _BottomFoamWidthPow ) ) );
				float2 uv_WaterfallEdge = input.ase_texcoord1.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Watefal_Edge87 = ( step( 0.6 , tex2DNode83.r ) * _WaterfallEdgeFoamOpacity );
				float2 texCoord129 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime133 = _TimeParameters.x * _SmallDots1Speed;
				float2 appendResult134 = (float2(0.0 , mulTime133));
				float Small_Dots_1139 = ( step( _SmallDots1Step , tex2D( _TopVoronoi, ( ( texCoord129 * _SmallDots1Scale ) + appendResult134 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots1Distortion ) + float2( 0.32,0.27 ) ) ).g ) * _SmallDots1Opacity );
				float2 texCoord290 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime295 = _TimeParameters.x * _StartNoiseHarshSpeed;
				float2 appendResult296 = (float2(0.0 , mulTime295));
				float smoothstepResult303 = smoothstep( _StartNoiseharshTopPosition , ( _StartNoiseharshTopPosition + _StartNoiseharshTopBlend ) , texCoord290.y);
				float smoothstepResult304 = smoothstep( _StartNoiseharshBottomPosition , ( _StartNoiseharshBottomPosition + _StartNoiseharshBottomBlend ) , texCoord290.y);
				float Start_Noise_Harsh316 = step( _StartNoiseHarshStep , ( tex2D( _WaterfallStartNoise, ( ( texCoord290 * _StartNoiseHarshTiling ) + appendResult296 + ( (Cloud_Noise37).rg * _StartNoiseHarshDistortion ) ) ).g * ( smoothstepResult303 * ( 1.0 - smoothstepResult304 ) ) ) );
				float2 texCoord154 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime156 = _TimeParameters.x * _SmallDots2Speed;
				float2 appendResult161 = (float2(0.0 , mulTime156));
				float Small_Dots_2168 = ( step( _SmallDots2Step , tex2D( _TopVoronoi, ( ( texCoord154 * _SmallDots2Scale ) + appendResult161 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots2Distortion ) ) ).g ) * _SmallDots2Opacity );
				float4 screenPos = input.ase_texcoord5;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float depthLinearEye370 = LinearEyeDepth( SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_positionSSNorm.xy ), _ZBufferParams );
				float Scene_Depth372 = ( depthLinearEye370 - screenPos.w );
				float Edge_Foam382 = ( step( _EdgeFoamStep , saturate( ( saturate( ( ( ( Scene_Depth372 - _EdgeFoamDistance ) / _EdgeFoamDistance ) * -1.0 ) ) * tex2DNode57.g ) ) ) * _EdgeFoamOpacity );
				float Foam_Mask71 = max( max( max( Bottom_Foam264, Watefal_Edge87 ), Small_Dots_1139 ), max( max( Start_Noise_Harsh316, Small_Dots_2168 ), Edge_Foam382 ) );
				float4 lerpResult67 = lerp( Water_Color73 , float4( 1,1,1,0 ) , Foam_Mask71);
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch358 = temp_cast_1;
				#else
				float4 staticSwitch358 = lerpResult67;
				#endif
				
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float3 BaseColor = staticSwitch358.rgb;
				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				half4 color = half4(BaseColor, Alpha );

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
			//#define SHADERPASS SHADERPASS_DEPTHNORMALS

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				half4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _ColorVariationTexture;
			sampler2D _WaterfallEdge;


			void CalculateUVsSmooth46_g2( float2 UV, float4 TexelSize, out float2 UV0, out float2 UV1, out float2 UV2, out float2 UV3, out float2 UV4, out float2 UV5, out float2 UV6, out float2 UV7, out float2 UV8 )
			{
				{
				    float3 pos = float3( TexelSize.xy, 0 );
				    float3 neg = float3( -pos.xy, 0 );
				    UV0 = UV + neg.xy;
				    UV1 = UV + neg.zy;
				    UV2 = UV + float2( pos.x, neg.y );
				    UV3 = UV + neg.xz;
				    UV4 = UV;
				    UV5 = UV + pos.xz;
				    UV6 = UV + float2( neg.x, pos.y );
				    UV7 = UV + pos.zy;
				    UV8 = UV + pos.xy;
				    return;
				}
			}
			
			float3 CombineSamplesSmooth58_g2( float Strength, float S0, float S1, float S2, float S3, float S4, float S5, float S6, float S7, float S8 )
			{
				{
				    float3 normal;
				    normal.x = Strength * ( S0 - S2 + 2 * S3 - 2 * S5 + S6 - S8 );
				    normal.y = Strength * ( S0 + 2 * S1 + S2 - S6 - 2 * S7 - S8 );
				    normal.z = 1.0;
				    return normalize( normal );
				}
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord3.xy = input.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			void frag(	PackedVaryings input
						, out half4 outNormalWS : SV_Target0
						#if defined( ASE_WRITE_DEPTH )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						#if ( UNITY_VERSION >= 60020000 )
						, out uint outRenderingLayers : SV_Target1
						#else
						, out float4 outRenderingLayers : SV_Target1
						#endif
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float temp_output_91_0_g2 = _NormalStrength;
				float Strength58_g2 = temp_output_91_0_g2;
				float localCalculateUVsSmooth46_g2 = ( 0.0 );
				float2 uv_ColorVariationTexture = input.ase_texcoord3.xy * _ColorVariationTexture_ST.xy + _ColorVariationTexture_ST.zw;
				float mulTime52 = _TimeParameters.x * _ColorVariationSpeed;
				float2 appendResult54 = (float2(0.0 , mulTime52));
				float2 temp_output_55_0 = ( uv_ColorVariationTexture + appendResult54 );
				float2 temp_output_85_0_g2 = temp_output_55_0;
				float2 UV46_g2 = temp_output_85_0_g2;
				float4 TexelSize46_g2 = _ColorVariationTexture_TexelSize;
				float2 UV046_g2 = float2( 0,0 );
				float2 UV146_g2 = float2( 0,0 );
				float2 UV246_g2 = float2( 0,0 );
				float2 UV346_g2 = float2( 0,0 );
				float2 UV446_g2 = float2( 0,0 );
				float2 UV546_g2 = float2( 0,0 );
				float2 UV646_g2 = float2( 0,0 );
				float2 UV746_g2 = float2( 0,0 );
				float2 UV846_g2 = float2( 0,0 );
				CalculateUVsSmooth46_g2( UV46_g2 , TexelSize46_g2 , UV046_g2 , UV146_g2 , UV246_g2 , UV346_g2 , UV446_g2 , UV546_g2 , UV646_g2 , UV746_g2 , UV846_g2 );
				float4 break140_g2 = tex2D( _ColorVariationTexture, UV046_g2 );
				float S058_g2 = break140_g2.g;
				float4 break142_g2 = tex2D( _ColorVariationTexture, UV146_g2 );
				float S158_g2 = break142_g2.g;
				float4 break146_g2 = tex2D( _ColorVariationTexture, UV246_g2 );
				float S258_g2 = break146_g2.g;
				float4 break148_g2 = tex2D( _ColorVariationTexture, UV346_g2 );
				float S358_g2 = break148_g2.g;
				float4 break150_g2 = tex2D( _ColorVariationTexture, UV446_g2 );
				float S458_g2 = break150_g2.g;
				float4 break152_g2 = tex2D( _ColorVariationTexture, UV546_g2 );
				float S558_g2 = break152_g2.g;
				float4 break154_g2 = tex2D( _ColorVariationTexture, UV646_g2 );
				float S658_g2 = break154_g2.g;
				float4 break156_g2 = tex2D( _ColorVariationTexture, UV746_g2 );
				float S758_g2 = break156_g2.g;
				float4 break158_g2 = tex2D( _ColorVariationTexture, UV846_g2 );
				float S858_g2 = break158_g2.g;
				float3 localCombineSamplesSmooth58_g2 = CombineSamplesSmooth58_g2( Strength58_g2 , S058_g2 , S158_g2 , S258_g2 , S358_g2 , S458_g2 , S558_g2 , S658_g2 , S758_g2 , S858_g2 );
				float3 Normals366 = localCombineSamplesSmooth58_g2;
				#ifdef _DEBUG_ON
				float3 staticSwitch364 = float3( 0, 0, 1 );
				#else
				float3 staticSwitch364 = Normals366;
				#endif
				
				float2 uv_WaterfallEdge = input.ase_texcoord3.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float3 Normal = staticSwitch364;
				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(NormalWS);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = NormalWS;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					#if ( UNITY_VERSION >= 60020000 )
					outRenderingLayers = EncodeMeshRenderingLayer();
					#else
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
					#endif
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300
			#define REQUIRE_DEPTH_TEXTURE 1


			// Deferred Rendering Path does not support the OpenGL-based graphics API:
			// Desktop OpenGL, OpenGL ES 3.0, WebGL 2.0.
			#pragma exclude_renderers glcore gles3 

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#if ( UNITY_VERSION >= 60000058 )
			#pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
			#endif
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#if ( UNITY_VERSION >= 60030000 )
			#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
			#endif
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#if ( UNITY_VERSION >= 60010000 )
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#endif

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
			#pragma multi_compile _ LIGHTMAP_ON
			#if ( UNITY_VERSION >= 60010000 )
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#endif
			#if ( UNITY_VERSION >= 60030000 )
			#pragma multi_compile_fragment _ REFLECTION_PROBE_ROTATION
			#endif
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_GBUFFER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if ( UNITY_VERSION >= 60030016 && UNITY_VERSION < 60040000 ) || ( UNITY_VERSION >= 60040010 )
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutputFormat.hlsl"
			#endif

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _ColorVariationTexture;
			sampler2D _NoiseLines;
			sampler2D _CloudNoise;
			sampler2D _WaterfallStartNoise;
			sampler2D _WaterfallEdge;
			sampler2D _TopVoronoi;


			#if ( UNITY_VERSION >= 60010000 )
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
			#else
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			#endif

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			void CalculateUVsSmooth46_g2( float2 UV, float4 TexelSize, out float2 UV0, out float2 UV1, out float2 UV2, out float2 UV3, out float2 UV4, out float2 UV5, out float2 UV6, out float2 UV7, out float2 UV8 )
			{
				{
				    float3 pos = float3( TexelSize.xy, 0 );
				    float3 neg = float3( -pos.xy, 0 );
				    UV0 = UV + neg.xy;
				    UV1 = UV + neg.zy;
				    UV2 = UV + float2( pos.x, neg.y );
				    UV3 = UV + neg.xz;
				    UV4 = UV;
				    UV5 = UV + pos.xz;
				    UV6 = UV + float2( neg.x, pos.y );
				    UV7 = UV + pos.zy;
				    UV8 = UV + pos.xy;
				    return;
				}
			}
			
			float3 CombineSamplesSmooth58_g2( float Strength, float S0, float S1, float S2, float S3, float S4, float S5, float S6, float S7, float S8 )
			{
				{
				    float3 normal;
				    normal.x = Strength * ( S0 - S2 + 2 * S3 - 2 * S5 + S6 - S8 );
				    normal.y = Strength * ( S0 + 2 * S1 + S2 - S6 - 2 * S7 - S8 );
				    normal.z = 1.0;
				    return normalize( normal );
				}
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord7.xy = input.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = input.tangentOS;

				#ifdef ASE_CUSTOM_MOTION_VECTOR
					// Declared so the Motion Vector output port surfaces on the master node; only consumed by the motion vector passes.
					float3 aseCustomMotionVector = float3(0, 0, 0);
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						// @diogo: no fog applied in GBuffer
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

		#if ( UNITY_VERSION >= 60010000 )
			GBufferFragOutput frag ( PackedVaryings input
		#else
			FragmentOutput frag ( PackedVaryings input
		#endif
								#if defined( ASE_WRITE_DEPTH )
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float2 uv_ColorVariationTexture = input.ase_texcoord7.xy * _ColorVariationTexture_ST.xy + _ColorVariationTexture_ST.zw;
				float mulTime52 = _TimeParameters.x * _ColorVariationSpeed;
				float2 appendResult54 = (float2(0.0 , mulTime52));
				float2 temp_output_55_0 = ( uv_ColorVariationTexture + appendResult54 );
				float4 tex2DNode48 = tex2D( _ColorVariationTexture, temp_output_55_0 );
				float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
				float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
				float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).x + tanToWorld1 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).y  + tanToWorld2 * ( ( unity_OrthoParams.w == 0 ) ? _WorldSpaceCameraPos - PositionWS : UNITY_MATRIX_V[ 2 ].xyz ).z;
				float3 normalizeResult59 = normalize( ase_viewVectorTS );
				float2 paralaxOffset47 = ParallaxOffset( tex2DNode48.g , _ColorVariationDepth , normalizeResult59 );
				float4 tex2DNode57 = tex2D( _ColorVariationTexture, ( paralaxOffset47 + temp_output_55_0 ) );
				float4 lerpResult62 = lerp( _Color2 , _Color1 , pow( tex2DNode57.g , _ColorVariationContrast ));
				float2 uv_NoiseLines = input.ase_texcoord7.xy * _NoiseLines_ST.xy + _NoiseLines_ST.zw;
				float mulTime188 = _TimeParameters.x * _NoiseLinesSpeed;
				float2 appendResult190 = (float2(0.0 , mulTime188));
				float2 uv_CloudNoise = input.ase_texcoord7.xy * _CloudNoise_ST.xy + _CloudNoise_ST.zw;
				float mulTime32 = _TimeParameters.x * _CloudNoiseSpeed;
				float2 appendResult33 = (float2(mulTime32 , 0.0));
				float4 Cloud_Noise37 = tex2D( _CloudNoise, ( uv_CloudNoise + appendResult33 ) );
				float4 lerpResult199 = lerp( lerpResult62 , _Color3 , pow( saturate( ( tex2D( _NoiseLines, ( uv_NoiseLines + appendResult190 + ( (Cloud_Noise37).rg * _NoiseLinesDistortion ) ) ).g * _NoiseLinesOpacity * pow( tex2DNode48.g , _NoiseLinesReveal ) ) ) , _NoiseLinesPow ));
				float2 uv_WaterfallStartNoise = input.ase_texcoord7.xy * _WaterfallStartNoise_ST.xy + _WaterfallStartNoise_ST.zw;
				float mulTime3 = _TimeParameters.x * _WaterfallStartNoiseSpeed;
				float2 appendResult5 = (float2(0.0 , mulTime3));
				float2 temp_output_6_0 = ( uv_WaterfallStartNoise + appendResult5 + ( (Cloud_Noise37).rg * _WaterfallStartNoiseDistortion ) );
				float3 normalizeResult236 = normalize( ase_viewVectorTS );
				float2 paralaxOffset234 = ParallaxOffset( tex2D( _WaterfallStartNoise, temp_output_6_0 ).g , _WaterfallStartNoiseDepth , normalizeResult236 );
				float2 texCoord17 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult19 = smoothstep( _WaterfallStartNoiseExtend , _WaterfallStartNoisePow , abs( ( texCoord17.y - _WaterfallStartNoisePosition ) ));
				float4 lerpResult238 = lerp( lerpResult199 , float4( _Color4.rgb , 0.0 ) , saturate( ( tex2D( _WaterfallStartNoise, ( temp_output_6_0 + paralaxOffset234 ) ).g * ( smoothstepResult19 * _WaterfallStartNoiseOpacity ) ) ));
				float4 Water_Color73 = lerpResult238;
				float mulTime252 = _TimeParameters.x * _BottomFoamSpeed;
				float2 appendResult254 = (float2(0.0 , mulTime252));
				float2 texCoord257 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult258 = smoothstep( _BottomFoamExtendMax , _BottomFoamExtendMin , ( 1.0 - texCoord257.y ));
				float Bottom_Foam264 = step( _BottomFoamStep , ( tex2D( _WaterfallStartNoise, ( uv_WaterfallStartNoise + appendResult254 + ( (Cloud_Noise37).rg * _BottomFoamDistortion ) ) ).g * smoothstepResult258 * pow( ( 1.0 - ( abs( ( texCoord257.x - 0.5 ) ) * 2.0 ) ) , _BottomFoamWidthPow ) ) );
				float2 uv_WaterfallEdge = input.ase_texcoord7.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Watefal_Edge87 = ( step( 0.6 , tex2DNode83.r ) * _WaterfallEdgeFoamOpacity );
				float2 texCoord129 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime133 = _TimeParameters.x * _SmallDots1Speed;
				float2 appendResult134 = (float2(0.0 , mulTime133));
				float Small_Dots_1139 = ( step( _SmallDots1Step , tex2D( _TopVoronoi, ( ( texCoord129 * _SmallDots1Scale ) + appendResult134 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots1Distortion ) + float2( 0.32,0.27 ) ) ).g ) * _SmallDots1Opacity );
				float2 texCoord290 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime295 = _TimeParameters.x * _StartNoiseHarshSpeed;
				float2 appendResult296 = (float2(0.0 , mulTime295));
				float smoothstepResult303 = smoothstep( _StartNoiseharshTopPosition , ( _StartNoiseharshTopPosition + _StartNoiseharshTopBlend ) , texCoord290.y);
				float smoothstepResult304 = smoothstep( _StartNoiseharshBottomPosition , ( _StartNoiseharshBottomPosition + _StartNoiseharshBottomBlend ) , texCoord290.y);
				float Start_Noise_Harsh316 = step( _StartNoiseHarshStep , ( tex2D( _WaterfallStartNoise, ( ( texCoord290 * _StartNoiseHarshTiling ) + appendResult296 + ( (Cloud_Noise37).rg * _StartNoiseHarshDistortion ) ) ).g * ( smoothstepResult303 * ( 1.0 - smoothstepResult304 ) ) ) );
				float2 texCoord154 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime156 = _TimeParameters.x * _SmallDots2Speed;
				float2 appendResult161 = (float2(0.0 , mulTime156));
				float Small_Dots_2168 = ( step( _SmallDots2Step , tex2D( _TopVoronoi, ( ( texCoord154 * _SmallDots2Scale ) + appendResult161 + ( ( (Cloud_Noise37).rg - float2( 0.5,0.5 ) ) * _SmallDots2Distortion ) ) ).g ) * _SmallDots2Opacity );
				float depthLinearEye370 = LinearEyeDepth( SHADERGRAPH_SAMPLE_SCENE_DEPTH( ScreenPosNorm.xy ), _ZBufferParams );
				float Scene_Depth372 = ( depthLinearEye370 - ScreenPos.w );
				float Edge_Foam382 = ( step( _EdgeFoamStep , saturate( ( saturate( ( ( ( Scene_Depth372 - _EdgeFoamDistance ) / _EdgeFoamDistance ) * -1.0 ) ) * tex2DNode57.g ) ) ) * _EdgeFoamOpacity );
				float Foam_Mask71 = max( max( max( Bottom_Foam264, Watefal_Edge87 ), Small_Dots_1139 ), max( max( Start_Noise_Harsh316, Small_Dots_2168 ), Edge_Foam382 ) );
				float4 lerpResult67 = lerp( Water_Color73 , float4( 1,1,1,0 ) , Foam_Mask71);
				float4 temp_cast_1 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch358 = temp_cast_1;
				#else
				float4 staticSwitch358 = lerpResult67;
				#endif
				
				float temp_output_91_0_g2 = _NormalStrength;
				float Strength58_g2 = temp_output_91_0_g2;
				float localCalculateUVsSmooth46_g2 = ( 0.0 );
				float2 temp_output_85_0_g2 = temp_output_55_0;
				float2 UV46_g2 = temp_output_85_0_g2;
				float4 TexelSize46_g2 = _ColorVariationTexture_TexelSize;
				float2 UV046_g2 = float2( 0,0 );
				float2 UV146_g2 = float2( 0,0 );
				float2 UV246_g2 = float2( 0,0 );
				float2 UV346_g2 = float2( 0,0 );
				float2 UV446_g2 = float2( 0,0 );
				float2 UV546_g2 = float2( 0,0 );
				float2 UV646_g2 = float2( 0,0 );
				float2 UV746_g2 = float2( 0,0 );
				float2 UV846_g2 = float2( 0,0 );
				CalculateUVsSmooth46_g2( UV46_g2 , TexelSize46_g2 , UV046_g2 , UV146_g2 , UV246_g2 , UV346_g2 , UV446_g2 , UV546_g2 , UV646_g2 , UV746_g2 , UV846_g2 );
				float4 break140_g2 = tex2D( _ColorVariationTexture, UV046_g2 );
				float S058_g2 = break140_g2.g;
				float4 break142_g2 = tex2D( _ColorVariationTexture, UV146_g2 );
				float S158_g2 = break142_g2.g;
				float4 break146_g2 = tex2D( _ColorVariationTexture, UV246_g2 );
				float S258_g2 = break146_g2.g;
				float4 break148_g2 = tex2D( _ColorVariationTexture, UV346_g2 );
				float S358_g2 = break148_g2.g;
				float4 break150_g2 = tex2D( _ColorVariationTexture, UV446_g2 );
				float S458_g2 = break150_g2.g;
				float4 break152_g2 = tex2D( _ColorVariationTexture, UV546_g2 );
				float S558_g2 = break152_g2.g;
				float4 break154_g2 = tex2D( _ColorVariationTexture, UV646_g2 );
				float S658_g2 = break154_g2.g;
				float4 break156_g2 = tex2D( _ColorVariationTexture, UV746_g2 );
				float S758_g2 = break156_g2.g;
				float4 break158_g2 = tex2D( _ColorVariationTexture, UV846_g2 );
				float S858_g2 = break158_g2.g;
				float3 localCombineSamplesSmooth58_g2 = CombineSamplesSmooth58_g2( Strength58_g2 , S058_g2 , S158_g2 , S258_g2 , S358_g2 , S458_g2 , S558_g2 , S658_g2 , S758_g2 , S858_g2 );
				float3 Normals366 = localCombineSamplesSmooth58_g2;
				#ifdef _DEBUG_ON
				float3 staticSwitch364 = float3( 0, 0, 1 );
				#else
				float3 staticSwitch364 = Normals366;
				#endif
				
				#ifdef _DEBUG_ON
				float staticSwitch362 = 0.0;
				#else
				float staticSwitch362 = _Smoothness;
				#endif
				
				float4 temp_cast_3 = (0.0).xxxx;
				#ifdef _DEBUG_ON
				float4 staticSwitch357 = ( ( Water_Color73 * _DebugWaterColor ) + float4( ( Normals366 * _DebugNormals ) , 0.0 ) + ( Cloud_Noise37 * _DebugCloudNoise ) );
				#else
				float4 staticSwitch357 = temp_cast_3;
				#endif
				
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float3 BaseColor = staticSwitch358.rgb;
				float3 Normal = staticSwitch364;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = staticSwitch362;
				float Occlusion = 1;
				float3 Emission = staticSwitch357.rgb;
				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( TangentWS, BitangentWS, NormalWS ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = NormalWS;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( ViewDirWS );

				#ifdef ASE_FOG
					// @diogo: no fog applied in GBuffer
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(_SCREEN_SPACE_IRRADIANCE) && ( UNITY_VERSION >= 60030000 )
					#if ( UNITY_VERSION >= 60060000 )
						inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy, inputData.normalWS));
					#else
						inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy);
					#endif
				#elif defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI(SH,
						GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(input.positionCS,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);

			#if ( UNITY_VERSION >= 60010000 )
				color.rgb = GlobalIllumination(brdfData, (BRDFData)0, 0,
                              inputData.bakedGI, Occlusion, inputData.positionWS,
                              inputData.normalWS, inputData.viewDirectionWS, inputData.normalizedScreenSpaceUV);
			#else
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
			#endif

				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

			#if ( UNITY_VERSION >= 60010000 )
				return PackGBuffersBRDFData(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			#else
				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _WaterfallEdge;


			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction(Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_WRITE_DEPTH )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_WaterfallEdge = input.ase_texcoord1.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				surfaceDescription.Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				return half4( _ObjectId, _PassValue, 1.0, 1.0 );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _WaterfallEdge;


			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = ASE_ADJUST_CLIP_POSITION( vertexInput.positionCS );
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_WRITE_DEPTH )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_WaterfallEdge = input.ase_texcoord1.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				surfaceDescription.Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				return unity_SelectionID;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "MotionVectors"
			Tags { "LightMode"="MotionVectors" }

			ColorMask RG

			HLSLPROGRAM

			#define ASE_GEOMETRY
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_TIME_BASED_MOTION_VECTORS
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_VERSION 19911
			#define ASE_SRP_VERSION 170300


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

            #define SHADERPASS SHADERPASS_MOTION_VECTORS

            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
				#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			#endif

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MotionVectorsCommon.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#pragma shader_feature_local _DEBUG_ON


			#if defined(ASE_WRITE_DEPTH_CONSERVATIVE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			#if ( UNITY_VERSION < 60010000 )
				#define APPLICATION_SPACE_WARP_MOTION APLICATION_SPACE_WARP_MOTION
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 positionOld : TEXCOORD4;
				#if _ADD_PRECOMPUTED_VELOCITY
					float3 alembicMotionVector : TEXCOORD5;
				#endif
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 positionCSNoJitter : TEXCOORD0;
				float4 previousPositionCSNoJitter : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Color2;
			float4 _ColorVariationTexture_TexelSize;
			float4 _WaterfallStartNoise_ST;
			float4 _Color4;
			float4 _CloudNoise_ST;
			float4 _NoiseLines_ST;
			float4 _WaterfallEdge_ST;
			float4 _Color3;
			float4 _ColorVariationTexture_ST;
			float4 _Color1;
			float2 _StartNoiseHarshTiling;
			float2 _SmallDots2Scale;
			float2 _SmallDots1Scale;
			float _NormalStrength;
			float _SmallDots1Distortion;
			float _SmallDots1Opacity;
			float _StartNoiseHarshStep;
			float _DebugCloudNoise;
			float _StartNoiseHarshSpeed;
			float _StartNoiseHarshDistortion;
			float _StartNoiseharshTopPosition;
			float _StartNoiseharshTopBlend;
			float _StartNoiseharshBottomPosition;
			float _StartNoiseharshBottomBlend;
			float _SmallDots2Step;
			float _DebugNormals;
			float _SmallDots1Speed;
			float _SmallDots2Distortion;
			float _SmallDots2Opacity;
			float _EdgeFoamStep;
			float _DebugWaterColor;
			float _EdgeFoamDistance;
			float _EdgeFoamOpacity;
			float _Smoothness;
			float _SmallDots2Speed;
			float _ColorVariationContrast;
			float _WaterfallEdgeFoamOpacity;
			float _NoiseLinesSpeed;
			float _ColorVariationDepth;
			float _CloudNoiseSpeed;
			float _NoiseLinesDistortion;
			float _NoiseLinesOpacity;
			float _NoiseLinesReveal;
			float _NoiseLinesPow;
			float _ColorVariationSpeed;
			float _WaterfallStartNoiseSpeed;
			float _WaterfallStartNoiseDistortion;
			float _WaterfallStartNoiseDepth;
			float _WaterfallStartNoiseExtend;
			float _WaterfallStartNoisePow;
			float _WaterfallStartNoisePosition;
			float _WaterfallStartNoiseOpacity;
			float _BottomFoamStep;
			float _BottomFoamSpeed;
			float _BottomFoamDistortion;
			float _BottomFoamExtendMax;
			float _BottomFoamExtendMin;
			float _BottomFoamWidthPow;
			float _InitialOpacityGradience;
			float _WaterfallEdgeSpeed;
			float _SmallDots1Step;
			float _BottomOpacityCutout;
			float _AlphaClip;
			float _Cutoff;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _WaterfallEdge;


			
			// Applies the graph's vertex stage at a given time so the motion vector pass can
			// evaluate the current frame and re-evaluate the previous frame (procedural / time-based animation).
			Attributes ASEApplyVertexModification( Attributes input, float3 timeParameters, inout PackedVaryings output, out float3 customMotionVector  )
			{
				float3 currentTimeParameters = _TimeParameters.xyz;
				_TimeParameters.xyz = timeParameters;

				output.ase_texcoord3.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				customMotionVector = float3(0, 0, 0);

				_TimeParameters.xyz = currentTimeParameters;
				return input;
			}

			PackedVaryings VertexFunction( Attributes input )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				Attributes defaultInput = input;
				float3 currentMotionVector;
				input = ASEApplyVertexModification( input, _TimeParameters.xyz, output, currentMotionVector );

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					float4 positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
					float4 positionCS = positionCSNoJitter;
				#else
					float4 positionCS = vertexInput.positionCS;
					float4 positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
				#endif

				// Custom output and automatic time-based motion are mutually exclusive.
				#if defined(ASE_CUSTOM_MOTION_VECTOR)
					float3 prevPositionOS = ( unity_MotionVectorsParams.x == 1 ) ? input.positionOld : input.positionOS.xyz;
					prevPositionOS -= currentMotionVector;
				#else
					float3 prevPositionOS = ( unity_MotionVectorsParams.x == 1 ) ? input.positionOld : defaultInput.positionOS.xyz;
					#ifdef ASE_TIME_BASED_MOTION_VECTORS
						Attributes prevInput = defaultInput;
						prevInput.positionOS.xyz = prevPositionOS;
						PackedVaryings prevOutput = (PackedVaryings)0;
						float3 prevMotionVector;
						prevInput = ASEApplyVertexModification( prevInput, _LastTimeParameters.xyz, prevOutput, prevMotionVector );
						prevPositionOS = prevInput.positionOS.xyz;
					#endif
				#endif
				#if _ADD_PRECOMPUTED_VELOCITY
					prevPositionOS -= input.alembicMotionVector;
				#endif
				float4 previousPositionCSNoJitter = mul( _PrevViewProjMatrix, mul( UNITY_PREV_MATRIX_M, float4( prevPositionOS, 1 ) ) );

				output.positionCS = ASE_ADJUST_CLIP_POSITION( positionCS );
				output.positionCSNoJitter = ASE_ADJUST_CLIP_POSITION( positionCSNoJitter );
				output.previousPositionCSNoJitter = ASE_ADJUST_CLIP_POSITION( previousPositionCSNoJitter );
				output.positionWS = vertexInput.positionWS;

				return output;
			}

			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}

			half4 frag(	PackedVaryings input
				#if defined( ASE_WRITE_DEPTH )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_WaterfallEdge = input.ase_texcoord3.xy * _WaterfallEdge_ST.xy + _WaterfallEdge_ST.zw;
				float mulTime79 = _TimeParameters.x * -_WaterfallEdgeSpeed;
				float2 appendResult81 = (float2(0.0 , mulTime79));
				float4 tex2DNode83 = tex2D( _WaterfallEdge, ( uv_WaterfallEdge + appendResult81 ) );
				float Opacity93 = step( 0.1 , tex2DNode83.r );
				float2 texCoord317 = input.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _DEBUG_ON
				float staticSwitch360 = 1.0;
				#else
				float staticSwitch360 = ( Opacity93 * saturate( ( texCoord317.y * _InitialOpacityGradience ) ) * ( 1.0 - step( _BottomOpacityCutout , texCoord317.y ) ) );
				#endif
				

				float Alpha = staticSwitch360;
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = _Cutoff;
				#endif

				#if defined( ASE_WRITE_DEPTH )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#if defined(ASE_CHANGES_WORLD_POS)
					float3 positionOS = mul( GetWorldToObjectMatrix(),  float4( PositionWS, 1.0 ) ).xyz;
					float3 previousPositionWS = mul( GetPrevObjectToWorldMatrix(),  float4( positionOS, 1.0 ) ).xyz;
					input.positionCSNoJitter = mul( _NonJitteredViewProjMatrix, float4( PositionWS, 1.0 ) );
					input.previousPositionCSNoJitter = mul( _PrevViewProjMatrix, float4( previousPositionWS, 1.0 ) );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_WRITE_DEPTH )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					return float4( CalcAswNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 1 );
				#else
					return float4( CalcNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 0, 0 );
				#endif
			}
			ENDHLSL
		}

	
	}
	

	

	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19911
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":77,"pos":[-4064,3136],"params":["Inherit","False","Property","_WaterfallEdgeSpeed","Waterfall Edge Speed","18","0","Create","True","0","0","0","False","0","False","Object","-1","","0.2","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.NegateNode, AmplifyShaderEditor","id":78,"pos":[-3808,3136],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":91,"pos":[-4176,2848],"params":["Inherit","True","Property","_WaterfallEdge","Waterfall Edge","19","0","Create","True","0","0","0","False","0","False","","None","None","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":79,"pos":[-3680,3136],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":80,"pos":[-3888,2960],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":81,"pos":[-3472,3136],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":82,"pos":[-3296,3104],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":83,"pos":[-3216,2848],"params":["Inherit","True","Property","_T_WaterfalEdgeOpacity","T_WaterfalEdgeOpacity","14","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":84,"pos":[-2848,2944],"params":["Inherit","False","2","0","FLOAT","0.1","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":317,"pos":[-1120,-128],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":325,"pos":[-1216,96],"params":["Inherit","False","Property","_BottomOpacityCutout","Bottom Opacity Cutout","53","0","Create","True","0","0","0","False","0","False","Object","-1","","0.9","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":321,"pos":[-1184,0],"params":["Inherit","False","Property","_InitialOpacityGradience","Initial Opacity Gradience","52","0","Create","True","0","0","0","False","0","False","Object","-1","","10","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":93,"pos":[-2704,2944],"params":["Inherit","False","Opacity","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":319,"pos":[-864,-96],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":323,"pos":[-832,16],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":320,"pos":[-704,-96],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":324,"pos":[-704,16],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":94,"pos":[-736,-192],"params":["Inherit","False","93","Opacity","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor","id":368,"pos":[-6945.269,-2405.87],"params":["Inherit","False","692","339","Scene Depth","4","372","371","370","369","","1,1,1,1","0","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":318,"pos":[-528,-128],"params":["Inherit","False","3","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":361,"pos":[-384,-64],"params":["Inherit","False","Constant","_Float1","Float 1","72","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":34,"pos":[-1376,-2000],"params":["Inherit","False","Property","_CloudNoiseSpeed","Cloud Noise Speed","6","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.1","-0.1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ScreenPosInputsNode, AmplifyShaderEditor","id":369,"pos":[-6895.269,-2275.87],"params":["Float","False","1","False","0","5","FLOAT4","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.ScreenDepthNode, AmplifyShaderEditor","id":370,"pos":[-6895.269,-2355.87],"params":["Inherit","False","0","1","0","FLOAT4","0,0,0,0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":26,"pos":[-1408,-2272],"params":["Inherit","True","Property","_CloudNoise","Cloud Noise","7","0","Create","True","0","0","0","False","0","False","","None","None","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":32,"pos":[-1152,-2000],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":371,"pos":[-6639.269,-2291.87],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":28,"pos":[-1168,-2144],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":33,"pos":[-960,-2032],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":372,"pos":[-6495.269,-2291.87],"params":["Inherit","False","Scene Depth","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":29,"pos":[-784,-2144],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":373,"pos":[-2608,-1664],"params":["Inherit","False","372","Scene Depth","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":375,"pos":[-2608,-1568],"params":["Inherit","False","Property","_EdgeFoamDistance","Edge Foam Distance","60","0","Create","True","0","0","0","False","0","False","Object","-1","","1","1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":151,"pos":[-7552,96],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":257,"pos":[-3520,-1088],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":56,"pos":[-4016,2016],"params":["Inherit","False","Property","_ColorVariationSpeed","Color Variation Speed","10","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.1","-0.1","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":27,"pos":[-656,-2272],"params":["Inherit","True","Property","_TextureSample1","Texture Sample 1","7","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","3","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":142,"pos":[-7504,-560],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":374,"pos":[-2368,-1664],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.WireNode, AmplifyShaderEditor","id":377,"pos":[-2256,-1536],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":253,"pos":[-4096,-1328],"params":["Inherit","False","Property","_BottomFoamSpeed","Bottom Foam Speed","38","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":286,"pos":[-4080,-1232],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":298,"pos":[-4288,-1936],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":297,"pos":[-4160,-2032],"params":["Inherit","False","Property","_StartNoiseHarshSpeed","Start Noise Harsh Speed","45","0","Create","True","0","0","0","False","0","False","Object","-1","","-1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":153,"pos":[-7376,96],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":152,"pos":[-7424,-16],"params":["Inherit","False","Property","_SmallDots2Speed","Small Dots 2 Speed","24","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":268,"pos":[-3248,-1056],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0.5","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":311,"pos":[-3552,-1632],"params":["Inherit","False","Property","_StartNoiseharshBottomBlend","Start Noise harsh Bottom Blend","50","0","Create","True","0","0","0","False","0","False","Object","-1","","0.07522548","0","0","0.5","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":52,"pos":[-3776,2016],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":49,"pos":[-4096,1648],"params":["Inherit","True","Property","_ColorVariationTexture","Color Variation Texture","11","0","Create","True","0","0","0","False","0","False","","None","None","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":37,"pos":[-368,-2272],"params":["Inherit","False","Cloud Noise","-1","True","1","0","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":309,"pos":[-3585.854,-1749.999],"params":["Inherit","False","Property","_StartNoiseharshBottomPosition","Start Noise harsh Bottom Position","48","0","Create","True","0","0","0","False","0","False","Object","-1","","0.4435484","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":132,"pos":[-7376,-672],"params":["Inherit","False","Property","_SmallDots1Speed","Small Dots 1 Speed","25","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":143,"pos":[-7328,-560],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor","id":376,"pos":[-2160,-1664],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":252,"pos":[-3872,-1328],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":287,"pos":[-3904,-1232],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":285,"pos":[-3968,-1168],"params":["Inherit","False","Property","_BottomFoamDistortion","Bottom Foam Distortion","43","0","Create","True","0","0","0","False","0","False","Object","-1","","0.05","0","0","0.3","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":290,"pos":[-3920,-2304],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":299,"pos":[-4096,-1936],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":301,"pos":[-4160,-1856],"params":["Inherit","False","Property","_StartNoiseHarshDistortion","Start Noise Harsh Distortion","46","0","Create","True","0","0","0","False","0","False","Object","-1","","0.026","0","0","0.2","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":293,"pos":[-3952,-2176],"params":["Inherit","False","Property","_StartNoiseHarshTiling","Start Noise Harsh Tiling","44","0","Create","True","0","0","0","False","0","False","Object","-1","","1,1","1,1","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":295,"pos":[-3904,-2032],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":158,"pos":[-7440,192],"params":["Inherit","False","Property","_SmallDots2Distortion","Small Dots 2 Distortion","31","0","Create","True","0","0","0","False","0","False","Object","-1","","0.045","0","0","0.2","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":156,"pos":[-7200,-16],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":157,"pos":[-7248,-144],"params":["Inherit","False","Property","_SmallDots2Scale","Small Dots 2 Scale","23","0","Create","True","0","0","0","False","0","False","Object","-1","","1,1","0,0","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":159,"pos":[-7168,96],"params":["Inherit","False","2","0","FLOAT2","0,0","False","1","FLOAT2","0.5,0.5","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":154,"pos":[-7264,-272],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor","id":282,"pos":[-3104,-1056],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":310,"pos":[-3270.854,-1680.999],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":306,"pos":[-3664,-1856],"params":["Inherit","False","Property","_StartNoiseharshTopBlend","Start Noise harsh Top Blend","49","0","Create","True","0","0","0","False","0","False","Object","-1","","0.07522548","0","0","0.5","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":50,"pos":[-3840,1856],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":54,"pos":[-3584,1984],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":189,"pos":[-3888,1024],"params":["Inherit","False","Property","_NoiseLinesSpeed","Noise Lines Speed","36","0","Create","True","0","0","0","False","0","False","Object","-1","","-0.2","-0.2","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":191,"pos":[-3888,1168],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":305,"pos":[-3536,-1984],"params":["Inherit","False","Property","_StartNoiseharshTopPosition","Start Noise harsh Top Position","47","0","Create","True","0","0","0","False","0","False","Object","-1","","0.24","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":133,"pos":[-7152,-672],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":128,"pos":[-7200,-800],"params":["Inherit","False","Property","_SmallDots1Scale","Small Dots 1 Scale","22","0","Create","True","0","0","0","False","0","False","Object","-1","","1,1","0,0","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":141,"pos":[-7392,-464],"params":["Inherit","False","Property","_SmallDots1Distortion","Small Dots 1 Distortion","30","0","Create","True","0","0","0","False","0","False","Object","-1","","0.045","0","0","0.2","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":146,"pos":[-7120,-560],"params":["Inherit","False","2","0","FLOAT2","0,0","False","1","FLOAT2","0.5,0.5","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":129,"pos":[-7216,-928],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":378,"pos":[-2016,-1664],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","-1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":246,"pos":[-4096,-1472],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":288,"pos":[-3680,-1232],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":254,"pos":[-3696,-1360],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":300,"pos":[-3888,-1936],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":291,"pos":[-3664,-2304],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":296,"pos":[-3712,-2048],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":160,"pos":[-7024,-272],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":162,"pos":[-7008,96],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":161,"pos":[-7024,-32],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":329,"pos":[-2992,-1056],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","2","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor","id":304,"pos":[-3168,-1760],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":307,"pos":[-3296,-1920],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":55,"pos":[-3392,1856],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.ViewVectorNode, AmplifyShaderEditor","id":58,"pos":[-3296,1984],"params":["Inherit","False","Tangent","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":1,"pos":[-4304,-352],"params":["Inherit","False","Property","_WaterfallStartNoiseSpeed","Waterfall Start Noise Speed","1","0","Create","True","0","0","0","False","0","False","Object","-1","","0.2842633","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":39,"pos":[-4304,-224],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":195,"pos":[-3968,624],"params":["Inherit","True","Property","_NoiseLines","Noise Lines","37","0","Create","True","0","0","0","False","0","False","","None","None","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":188,"pos":[-3680,1040],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":192,"pos":[-3712,1168],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":194,"pos":[-3744,1248],"params":["Inherit","False","Property","_NoiseLinesDistortion","Noise Lines Distortion","35","0","Create","True","0","0","0","False","0","False","Object","-1","","0.042","0","0","0.3","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":127,"pos":[-6976,-928],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":145,"pos":[-6960,-560],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor","id":202,"pos":[-6992,-448],"params":["Inherit","False","Constant","_Vector7","Vector 7","45","0","Create","True","0","0","0","False","0","False","Object","-1","","0.32,0.27","0,0","0","3","FLOAT2","0","FLOAT","1","FLOAT","2"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":134,"pos":[-6976,-688],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":379,"pos":[-1856,-1664],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":251,"pos":[-3488,-1456],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":294,"pos":[-3472,-2176],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":163,"pos":[-6832,-144],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":259,"pos":[-2608,-896],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":260,"pos":[-2704,-816],"params":["Inherit","False","Property","_BottomFoamExtendMin","Bottom Foam Extend Min","40","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":261,"pos":[-2736,-736],"params":["Inherit","False","Property","_BottomFoamExtendMax","Bottom Foam Extend Max","41","0","Create","True","0","0","0","False","0","False","Object","-1","","0.15","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":281,"pos":[-2832,-1056],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":283,"pos":[-3072,-944],"params":["Inherit","False","Property","_BottomFoamWidthPow","Bottom Foam Width Pow","39","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor","id":303,"pos":[-3168,-1984],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor","id":308,"pos":[-2976,-1760],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":48,"pos":[-3264,1648],"params":["Inherit","True","Property","_TextureSample2","Texture Sample 2","8","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":61,"pos":[-3248,1872],"params":["Inherit","False","Property","_ColorVariationDepth","Color Variation Depth","12","0","Create","True","0","0","0","False","0","False","Object","-1","","0.054","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor","id":59,"pos":[-3104,1984],"params":["Inherit","False","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":2,"pos":[-4448,-624],"params":["Inherit","True","Property","_WaterfallStartNoise","Waterfall Start Noise","0","0","Create","True","0","0","0","False","0","False","","5592d5353472a1840880192b0a423e4c","5592d5353472a1840880192b0a423e4c","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":43,"pos":[-4192,-128],"params":["Inherit","False","Property","_WaterfallStartNoiseDistortion","Waterfall Start Noise Distortion","8","0","Create","True","0","0","0","False","0","False","Object","-1","","0.037","0","0","0.3","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor","id":3,"pos":[-4032,-352],"params":["Inherit","False","1","0","FLOAT","1","False","5","FLOAT","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor","id":41,"pos":[-4128,-224],"params":["Inherit","False","True","True","False","False","1","0","COLOR","0,0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor","id":95,"pos":[-7488,-912],"params":["Inherit","True","Property","_TopVoronoi","Top Voronoi","21","0","Create","True","0","0","0","False","0","False","","None","None","False","white","Auto","Texture2D","False","-1","0","2","SAMPLER2D","0","SAMPLERSTATE","1"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":184,"pos":[-3712,752],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":190,"pos":[-3488,1024],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":193,"pos":[-3488,1184],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.ViewVectorNode, AmplifyShaderEditor","id":235,"pos":[-3728,-96],"params":["Inherit","False","Tangent","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":17,"pos":[-3712,96],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":18,"pos":[-3776,224],"params":["Inherit","False","Property","_WaterfallStartNoisePosition","Waterfall Start Noise Position","2","0","Create","True","0","0","0","False","0","False","Object","-1","","0.22","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":131,"pos":[-6784,-800],"params":["Inherit","False","4","4","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","3","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":380,"pos":[-1680,-1664],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":247,"pos":[-3200,-1440],"params":["Inherit","True","Property","_TextureSample9","Texture Sample 9","48","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":289,"pos":[-3248,-2192],"params":["Inherit","True","Property","_TextureSample10","Texture Sample 10","55","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":150,"pos":[-6512,-400],"params":["Inherit","True","Property","_TextureSample6","Texture Sample 5","26","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor","id":258,"pos":[-2432,-896],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.PowerNode, AmplifyShaderEditor","id":330,"pos":[-2672,-1056],"params":["Inherit","False","False","2","0","FLOAT","0","False","1","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":164,"pos":[-6224,-384],"params":["Inherit","False","Property","_SmallDots2Step","Small Dots 2 Step","27","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":312,"pos":[-2848,-1888],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ParallaxOffsetHlpNode, AmplifyShaderEditor","id":47,"pos":[-2928,1760],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT3","0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor","id":4,"pos":[-4112,-496],"params":["Inherit","False","0","-1","2","3","2","SAMPLER2D","","False","0","FLOAT2","1,1","False","1","FLOAT2","0,0","False","5","FLOAT2","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4"]}
{"type":"AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor","id":5,"pos":[-3856,-352],"params":["Inherit","False","FLOAT2","4","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":42,"pos":[-3904,-224],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT","0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":187,"pos":[-3280,848],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":7,"pos":[-3216,-624],"params":["Inherit","True","Property","_TextureSample0","Texture Sample 0","0","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor","id":236,"pos":[-3536,-96],"params":["Inherit","False","False","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":237,"pos":[-3632,-208],"params":["Inherit","False","Property","_WaterfallStartNoiseDepth","Waterfall Start Noise Depth","9","0","Create","True","0","0","0","False","0","False","Object","-1","","0.037","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor","id":15,"pos":[-3424,160],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":205,"pos":[-3195.621,1182.456],"params":["Inherit","False","Property","_NoiseLinesReveal","Noise Lines Reveal","34","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":125,"pos":[-6528,-880],"params":["Inherit","True","Property","_TextureSample5","Texture Sample 5","26","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":137,"pos":[-6224,-896],"params":["Inherit","False","Property","_SmallDots1Step","Small Dots 1 Step","26","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":85,"pos":[-2848,2784],"params":["Inherit","False","2","0","FLOAT","0.6","False","1","FLOAT","0.9","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":92,"pos":[-2720,2848],"params":["Inherit","False","Property","_WaterfallEdgeFoamOpacity","Waterfall Edge Foam Opacity","20","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":279,"pos":[-2224,-1104],"params":["Inherit","False","3","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":263,"pos":[-2352,-1216],"params":["Inherit","False","Property","_BottomFoamStep","Bottom Foam Step","42","0","Create","True","0","0","0","False","0","False","Object","-1","","0.5","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":165,"pos":[-5936,-352],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":166,"pos":[-6064,-240],"params":["Inherit","False","Property","_SmallDots2Opacity","Small Dots 2 Opacity","29","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":313,"pos":[-2658.065,-2068.372],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":315,"pos":[-2767.15,-2251.955],"params":["Inherit","False","Property","_StartNoiseHarshStep","Start Noise Harsh Step","51","0","Create","True","0","0","0","False","0","False","Object","-1","","0.51","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":387,"pos":[-1584,-1824],"params":["Inherit","False","Property","_EdgeFoamStep","Edge Foam Step","62","0","Create","True","0","0","0","False","0","False","Object","-1","","0.1","0.1","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":385,"pos":[-1536,-1664],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":60,"pos":[-2672,1840],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":6,"pos":[-3520,-384],"params":["Inherit","False","3","3","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","2","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":182,"pos":[-3120,624],"params":["Inherit","True","Property","_TextureSample7","Texture Sample 7","39","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.ParallaxOffsetHlpNode, AmplifyShaderEditor","id":234,"pos":[-3344,-208],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT3","0,0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.PowerNode, AmplifyShaderEditor","id":204,"pos":[-2944,1088],"params":["Inherit","False","False","2","0","FLOAT","0","False","1","FLOAT","0.5","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":178,"pos":[-3008,976],"params":["Inherit","False","Property","_NoiseLinesOpacity","Noise Lines Opacity","33","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor","id":16,"pos":[-3264,160],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":25,"pos":[-3424,352],"params":["Inherit","False","Property","_WaterfallStartNoisePow","Waterfall Start Noise Pow","5","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":22,"pos":[-3424,272],"params":["Inherit","False","Property","_WaterfallStartNoiseExtend","Waterfall Start Noise Extend","4","0","Create","True","0","0","0","False","0","False","Object","-1","","0.22","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":136,"pos":[-5936,-864],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":138,"pos":[-6064,-752],"params":["Inherit","False","Property","_SmallDots1Opacity","Small Dots 1 Opacity","28","0","Create","True","0","0","0","False","0","False","Object","-1","","0.8","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":86,"pos":[-2432,2784],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0.5","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":262,"pos":[-2048,-1168],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":167,"pos":[-5792,-352],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":314,"pos":[-2464,-2144],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor","id":386,"pos":[-1312,-1744],"params":["Inherit","False","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":381,"pos":[-1408,-1632],"params":["Inherit","False","Property","_EdgeFoamOpacity","Edge Foam Opacity","61","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":57,"pos":[-2512,1680],"params":["Inherit","True","Property","_TextureSample3","Texture Sample 3","9","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":243,"pos":[-3112.361,-374.8425],"params":["Inherit","False","2","2","0","FLOAT2","0,0","False","1","FLOAT2","0,0","False","1","FLOAT2","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":177,"pos":[-2704,896],"params":["Inherit","False","3","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":76,"pos":[-2480,1888],"params":["Inherit","False","Property","_ColorVariationContrast","Color Variation Contrast","17","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor","id":19,"pos":[-3104,160],"params":["Inherit","False","3","0","FLOAT","0","False","1","FLOAT","0","False","2","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":327,"pos":[-3056,304],"params":["Inherit","False","Property","_WaterfallStartNoiseOpacity","Waterfall Start Noise Opacity","3","0","Create","True","0","0","0","False","0","False","Object","-1","","0.22","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":135,"pos":[-5792,-864],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":87,"pos":[-2256,2784],"params":["Inherit","False","Watefal Edge","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":264,"pos":[-1936,-1168],"params":["Inherit","False","Bottom Foam","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":168,"pos":[-5632,-352],"params":["Inherit","False","Small Dots 2","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":316,"pos":[-2304,-2144],"params":["Inherit","False","Start Noise Harsh","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":388,"pos":[-1184,-1712],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor","id":233,"pos":[-2912,-320],"params":["Inherit","True","Property","_TextureSample8","Texture Sample 8","46","0","Create","True","0","0","0","False","0","False","","-1","None","None","True","0","False","white","Auto","False","Object","-1","Auto","Texture2D","False","8","0","SAMPLER2D","","False","1","FLOAT2","0,0","False","2","FLOAT","0","False","3","FLOAT2","0,0","False","4","FLOAT2","0,0","False","5","FLOAT","1","False","6","FLOAT","0","False","7","SAMPLERSTATE","","False","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":198,"pos":[-2544,896],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":197,"pos":[-2640,1008],"params":["Inherit","False","Property","_NoiseLinesPow","Noise Lines Pow","32","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.PowerNode, AmplifyShaderEditor","id":75,"pos":[-2208,1760],"params":["Inherit","False","False","2","0","FLOAT","0","False","1","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":328,"pos":[-2768,192],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":65,"pos":[-2448,1472],"params":["Inherit","False","Property","_Color1","Color 1","13","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0.8273995,1,0","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":66,"pos":[-2448,1248],"params":["Inherit","False","Property","_Color2","Color 2","16","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0.5989819,0.8867924,0","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":139,"pos":[-5632,-864],"params":["Inherit","False","Small Dots 1","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":69,"pos":[-912,-1472],"params":["Inherit","False","264","Bottom Foam","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":88,"pos":[-912,-1376],"params":["Inherit","False","87","Watefal Edge","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":180,"pos":[-928,-1120],"params":["Inherit","False","316","Start Noise Harsh","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":382,"pos":[-1024,-1712],"params":["Inherit","False","Edge Foam","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":171,"pos":[-928,-1024],"params":["Inherit","False","168","Small Dots 2","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":245,"pos":[-2549.641,49.97424],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":62,"pos":[-2096,1408],"params":["Inherit","False","3","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","2","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.PowerNode, AmplifyShaderEditor","id":196,"pos":[-2368,896],"params":["Inherit","False","False","2","0","FLOAT","0","False","1","FLOAT","1","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":201,"pos":[-2448,1040],"params":["Inherit","False","Property","_Color3","Color 3","14","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0.5989819,0.8867924,0","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":140,"pos":[-912,-1200],"params":["Inherit","False","139","Small Dots 1","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":147,"pos":[-656,-1424],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":169,"pos":[-656,-1120],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":384,"pos":[-928,-936],"params":["Inherit","False","382","Edge Foam","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.ColorNode, AmplifyShaderEditor","id":239,"pos":[-2320,320],"params":["Inherit","False","Property","_Color4","Color 4","15","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0.5989819,0.8867924,0","0,0,0,0","True","True","0","6","COLOR","0","FLOAT","1","FLOAT","2","FLOAT","3","FLOAT","4","FLOAT3","5"]}
{"type":"AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor","id":242,"pos":[-2336,48],"params":["Inherit","False","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":199,"pos":[-2001.13,1112.294],"params":["Inherit","False","3","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","2","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":149,"pos":[-520,-1224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":383,"pos":[-520,-1120],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":333,"pos":[-1520,512],"params":["Inherit","False","Property","_NormalStrength","Normal Strength","55","0","Create","True","0","0","0","False","0","False","Object","-1","","1","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":238,"pos":[-1968,256],"params":["Inherit","False","3","0","COLOR","0,0,0,0","False","1","COLOR","0,0,0,0","False","2","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor","id":181,"pos":[-368,-1224],"params":["Inherit","False","2","2","0","FLOAT","0","False","1","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":334,"pos":[-1152,576],"params":["Inherit","False","Normal From Texture","-1","","2","9728ee98a55193249b513caf9a0f1676","13,149,1,147,1,143,1,141,1,139,1,151,1,137,1,153,1,159,1,157,1,155,1,135,1,108,1","4","87","SAMPLER2D","0","False","85","FLOAT2","0,0","False","74","SAMPLERSTATE","0","False","91","FLOAT","1.5","False","2","FLOAT3","40","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":73,"pos":[-1808,256],"params":["Inherit","False","Water Color","-1","True","1","0","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":337,"pos":[-960,1584],"params":["Inherit","False","73","Water Color","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":338,"pos":[-1056,1664],"params":["Inherit","False","Property","_DebugWaterColor","DebugWaterColor","57","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":339,"pos":[-1056,1824],"params":["Inherit","False","Property","_DebugNormals","DebugNormals","58","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":340,"pos":[-960,1744],"params":["Inherit","False","366","Normals","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":347,"pos":[-960,1904],"params":["Inherit","False","37","Cloud Noise","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":348,"pos":[-1056,1984],"params":["Inherit","False","Property","_DebugCloudNoise","Debug Cloud Noise","59","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":71,"pos":[-248,-1224],"params":["Inherit","False","Foam Mask","-1","True","1","0","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor","id":366,"pos":[-848,576],"params":["Inherit","False","Normals","-1","True","1","0","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":349,"pos":[-768,1584],"params":["Inherit","False","2","2","0","COLOR","0,0,0,0","False","1","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":350,"pos":[-768,1744],"params":["Inherit","False","2","2","0","FLOAT3","0,0,0","False","1","FLOAT","0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor","id":354,"pos":[-768,1904],"params":["Inherit","False","2","2","0","COLOR","0,0,0,0","False","1","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":74,"pos":[-592,-848],"params":["Inherit","False","73","Water Color","1","0","OBJECT","","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":72,"pos":[-568,-656],"params":["Inherit","False","71","Foam Mask","1","0","OBJECT","","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":331,"pos":[-592,-544],"params":["Inherit","False","Property","_Smoothness","Smoothness","54","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","1","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor","id":355,"pos":[-496.6146,1684.933],"params":["Inherit","False","3","3","0","COLOR","0,0,0,0","False","1","FLOAT3","0,0,0","False","2","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":356,"pos":[-384.6146,1396.933],"params":["Inherit","False","Constant","_Float2","Float 2","71","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":363,"pos":[-480,-416],"params":["Inherit","False","Constant","_Float3","Float 3","73","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor","id":365,"pos":[-256,-352],"params":["Inherit","False","Constant","_Vector0","Vector 0","74","0","Create","True","0","0","0","False","0","False","Object","-1","","0,0,1","0,0,0","0","4","FLOAT3","0","FLOAT","1","FLOAT","2","FLOAT","3"]}
{"type":"AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor","id":367,"pos":[-256,-416],"params":["Inherit","False","366","Normals","1","0","OBJECT","","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.LerpOp, AmplifyShaderEditor","id":67,"pos":[-256,-768],"params":["Inherit","False","3","0","COLOR","0,0,0,0","False","1","COLOR","1,1,1,0","False","2","FLOAT","0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor","id":359,"pos":[-256,-648],"params":["Inherit","False","Constant","_Float0","Float 0","71","0","Create","True","0","0","0","False","0","False","Object","-1","","0","0","0","0","0","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor","id":332,"pos":[-1136,416],"params":["Inherit","False","Normal From Height","-1","","3","1942fe2c5f1a1f94881a33d532e4afeb","0","2","20","FLOAT","0","False","110","FLOAT","1","False","2","FLOAT3","40","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":357,"pos":[-224.6146,1412.933],"params":["Inherit","False","Property","_DEBUG5","DEBUG","56","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","358","True","True","All","9","1","COLOR","0,0,0,0","False","0","COLOR","0,0,0,0","False","2","COLOR","0,0,0,0","False","3","COLOR","0,0,0,0","False","4","COLOR","0,0,0,0","False","5","COLOR","0,0,0,0","False","6","COLOR","0,0,0,0","False","7","COLOR","0,0,0,0","False","8","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":362,"pos":[-192,-512],"params":["Inherit","False","Property","_DEBUG7","DEBUG","56","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","358","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":364,"pos":[-48,-384],"params":["Inherit","False","Property","_DEBUG8","DEBUG","56","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","358","True","True","All","9","1","FLOAT3","0,0,0","False","0","FLOAT3","0,0,0","False","2","FLOAT3","0,0,0","False","3","FLOAT3","0,0,0","False","4","FLOAT3","0,0,0","False","5","FLOAT3","0,0,0","False","6","FLOAT3","0,0,0","False","7","FLOAT3","0,0,0","False","8","FLOAT3","0,0,0","False","1","FLOAT3","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":360,"pos":[-224,-128],"params":["Inherit","False","Property","_DEBUG6","DEBUG","56","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Reference","358","True","True","All","9","1","FLOAT","0","False","0","FLOAT","0","False","2","FLOAT","0","False","3","FLOAT","0","False","4","FLOAT","0","False","5","FLOAT","0","False","6","FLOAT","0","False","7","FLOAT","0","False","8","FLOAT","0","False","1","FLOAT","0"]}
{"type":"AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor","id":358,"pos":[-32,-768],"params":["Inherit","False","Property","_DEBUG","DEBUG","56","0","Create","True","0","0","0","False","0","False","","0","0","0","True","","Toggle","2","Key0","Key1","Create","True","True","All","9","1","COLOR","0,0,0,0","False","0","COLOR","0,0,0,0","False","2","COLOR","0,0,0,0","False","3","COLOR","0,0,0,0","False","4","COLOR","0,0,0,0","False","5","COLOR","0,0,0,0","False","6","COLOR","0,0,0,0","False","7","COLOR","0,0,0,0","False","8","COLOR","0,0,0,0","False","1","COLOR","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":389,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","ExtraPrePass","0","0","ExtraPrePass","6","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","True","1","1","False","","0","False","","0","1","False","","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","0","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":390,"pos":[424,-776],"params":["Float","False","True","-1","3","UnityEditor.ShaderGraphLitGUI","0","15","NewWaterfall","94348b07e5e8bab40bd6c8a1e3df54cd","True","Forward","0","1","Forward","22","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","2","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Transparent=RenderType","Queue=Transparent=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","True","1","5","False","","10","False","","1","1","False","","10","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=UniversalForward","False","False","0","","0","0","Standard","52","Category","0","0","  Instanced Terrain Normals","1","0","Lighting Model","0","0","Workflow","1","0","Surface","1","639197170273362172","  Keep Alpha","0","0","  Refraction Model","0","0","  Blend","0","0","Two Sided","1","0","Alpha Clipping","0","0","  Use Shadow Threshold","0","0","Fragment Normal Space","0","0","Forward Only","0","0","Transmission","0","0","  Transmission Shadow","0.5,False,","0","Translucency","0","0","  Translucency Strength","1,False,","0","  Normal Distortion","0.5,False,","0","  Scattering","2,False,","0","  Direct","0.9,False,","0","  Ambient","0.1,False,","0","  Shadow","0.5,False,","0","Cast Shadows","1","0","Receive Shadows","2","0","Specular Highlights","2","0","Environment Reflections","2","0","Receive SSAO","1","0","Motion Vectors","1","0","  Additional Motion Vectors","1","0","  Alembic Motion Vectors","0","0","  XR Motion Vectors","0","0","GPU Instancing","1","0","LOD CrossFade","1","0","Built-in Fog","1","0","_FinalColorxAlpha","0","0","Meta Pass","1","0","Override Baked GI","0","0","Extra Pre Pass","0","0","Tessellation","0","0","  Phong","0","0","  Strength","0.5,False,","0","  Type","0","0","  Tess","16,False,","0","  Min","10,False,","0","  Max","25,False,","0","  Edge Length","16,False,","0","  Max Displacement","25,False,","0","Write Depth","0","0","  Conservative","0","0","Vertex Position","1","0","Debug Display","1","0","Clear Coat","0","0","0","12","False","True","True","True","True","True","True","True","True","True","True","False","False","","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":391,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","ShadowCaster","0","2","ShadowCaster","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","False","False","True","False","False","False","False","0","False","","False","False","False","False","False","False","False","False","False","True","1","False","","True","3","False","","False","False","True","1","LightMode=ShadowCaster","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":392,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","DepthOnly","0","3","DepthOnly","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","False","False","True","True","False","False","False","0","False","","False","False","False","False","False","False","False","False","False","True","1","False","","False","False","False","True","1","LightMode=DepthOnly","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":393,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","Meta","0","4","Meta","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","2","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=Meta","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":394,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","Universal2D","0","5","Universal2D","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","True","1","5","False","","10","False","","1","1","False","","10","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","False","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=Universal2D","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":395,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","DepthNormals","0","6","DepthNormals","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","True","1","1","False","","0","False","","0","1","False","","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","False","","True","3","False","","False","False","True","1","LightMode=DepthNormals","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":396,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","GBuffer","0","7","GBuffer","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","True","1","5","False","","10","False","","1","1","False","","10","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","1","LightMode=UniversalGBuffer","False","True","12","d3d11","gles","metal","vulkan","xboxone","xboxseries","playstation","ps4","ps5","switch","switch2","webgpu","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":397,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","SceneSelectionPass","0","8","SceneSelectionPass","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","2","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=SceneSelectionPass","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":398,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","ScenePickingPass","0","9","ScenePickingPass","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=Picking","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":399,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","MotionVectors","0","10","MotionVectors","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","True","False","False","0","False","","False","False","False","False","False","False","False","False","False","False","False","False","False","True","1","LightMode=MotionVectors","False","False","0","","0","0","Standard","0","False","0"]}
{"type":"AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor","id":400,"pos":[424,-776],"params":["Float","False","False","-1","3","UnityEditor.ShaderGraphLitGUI","0","1","New Amplify Shader","94348b07e5e8bab40bd6c8a1e3df54cd","True","XRMotionVectors","0","11","XRMotionVectors","0","False","False","False","False","False","False","False","False","False","False","False","False","True","0","False","","False","True","0","False","","False","False","False","False","False","False","False","False","False","True","False","0","False","","255","False","","255","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","True","1","False","","True","3","False","","True","True","0","False","","0","False","","False","True","4","RenderPipeline=UniversalPipeline","RenderType=Opaque=RenderType","Queue=Geometry=Queue=0","UniversalMaterialType=Lit","True","5","True","14","all","0","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","False","True","True","True","True","True","0","False","","False","False","False","False","False","False","False","True","True","1","False","","255","False","","1","False","","7","False","","3","False","","0","False","","0","False","","0","False","","0","False","","0","False","","0","False","","False","False","False","False","False","True","1","LightMode=XRMotionVectors","False","False","0","","0","0","Standard","0","False","0"]}
{"wire":[78,0,77,0]}
{"wire":[79,0,78,0]}
{"wire":[80,2,91,0]}
{"wire":[81,1,79,0]}
{"wire":[82,0,80,0]}
{"wire":[82,1,81,0]}
{"wire":[83,0,91,0]}
{"wire":[83,1,82,0]}
{"wire":[83,7,91,1]}
{"wire":[84,1,83,1]}
{"wire":[93,0,84,0]}
{"wire":[319,0,317,2]}
{"wire":[319,1,321,0]}
{"wire":[323,0,325,0]}
{"wire":[323,1,317,2]}
{"wire":[320,0,319,0]}
{"wire":[324,0,323,0]}
{"wire":[318,0,94,0]}
{"wire":[318,1,320,0]}
{"wire":[318,2,324,0]}
{"wire":[32,0,34,0]}
{"wire":[371,0,370,0]}
{"wire":[371,1,369,4]}
{"wire":[28,2,26,0]}
{"wire":[33,0,32,0]}
{"wire":[372,0,371,0]}
{"wire":[29,0,28,0]}
{"wire":[29,1,33,0]}
{"wire":[27,0,26,0]}
{"wire":[27,1,29,0]}
{"wire":[27,7,26,1]}
{"wire":[374,0,373,0]}
{"wire":[374,1,375,0]}
{"wire":[377,0,375,0]}
{"wire":[153,0,151,0]}
{"wire":[268,0,257,1]}
{"wire":[52,0,56,0]}
{"wire":[37,0,27,0]}
{"wire":[143,0,142,0]}
{"wire":[376,0,374,0]}
{"wire":[376,1,377,0]}
{"wire":[252,0,253,0]}
{"wire":[287,0,286,0]}
{"wire":[299,0,298,0]}
{"wire":[295,0,297,0]}
{"wire":[156,0,152,0]}
{"wire":[159,0,153,0]}
{"wire":[282,0,268,0]}
{"wire":[310,0,309,0]}
{"wire":[310,1,311,0]}
{"wire":[50,2,49,0]}
{"wire":[54,1,52,0]}
{"wire":[133,0,132,0]}
{"wire":[146,0,143,0]}
{"wire":[378,0,376,0]}
{"wire":[246,2,2,0]}
{"wire":[288,0,287,0]}
{"wire":[288,1,285,0]}
{"wire":[254,1,252,0]}
{"wire":[300,0,299,0]}
{"wire":[300,1,301,0]}
{"wire":[291,0,290,0]}
{"wire":[291,1,293,0]}
{"wire":[296,1,295,0]}
{"wire":[160,0,154,0]}
{"wire":[160,1,157,0]}
{"wire":[162,0,159,0]}
{"wire":[162,1,158,0]}
{"wire":[161,1,156,0]}
{"wire":[329,0,282,0]}
{"wire":[304,0,290,2]}
{"wire":[304,1,309,0]}
{"wire":[304,2,310,0]}
{"wire":[307,0,305,0]}
{"wire":[307,1,306,0]}
{"wire":[55,0,50,0]}
{"wire":[55,1,54,0]}
{"wire":[188,0,189,0]}
{"wire":[192,0,191,0]}
{"wire":[127,0,129,0]}
{"wire":[127,1,128,0]}
{"wire":[145,0,146,0]}
{"wire":[145,1,141,0]}
{"wire":[134,1,133,0]}
{"wire":[379,0,378,0]}
{"wire":[251,0,246,0]}
{"wire":[251,1,254,0]}
{"wire":[251,2,288,0]}
{"wire":[294,0,291,0]}
{"wire":[294,1,296,0]}
{"wire":[294,2,300,0]}
{"wire":[163,0,160,0]}
{"wire":[163,1,161,0]}
{"wire":[163,2,162,0]}
{"wire":[259,0,257,2]}
{"wire":[281,0,329,0]}
{"wire":[303,0,290,2]}
{"wire":[303,1,305,0]}
{"wire":[303,2,307,0]}
{"wire":[308,0,304,0]}
{"wire":[48,0,49,0]}
{"wire":[48,1,55,0]}
{"wire":[48,7,49,1]}
{"wire":[59,0,58,0]}
{"wire":[3,0,1,0]}
{"wire":[41,0,39,0]}
{"wire":[184,2,195,0]}
{"wire":[190,1,188,0]}
{"wire":[193,0,192,0]}
{"wire":[193,1,194,0]}
{"wire":[131,0,127,0]}
{"wire":[131,1,134,0]}
{"wire":[131,2,145,0]}
{"wire":[131,3,202,0]}
{"wire":[380,0,379,0]}
{"wire":[380,1,57,2]}
{"wire":[247,0,2,0]}
{"wire":[247,1,251,0]}
{"wire":[247,7,2,1]}
{"wire":[289,0,2,0]}
{"wire":[289,1,294,0]}
{"wire":[150,0,95,0]}
{"wire":[150,1,163,0]}
{"wire":[150,7,95,1]}
{"wire":[258,0,259,0]}
{"wire":[258,1,261,0]}
{"wire":[258,2,260,0]}
{"wire":[330,0,281,0]}
{"wire":[330,1,283,0]}
{"wire":[312,0,303,0]}
{"wire":[312,1,308,0]}
{"wire":[47,0,48,2]}
{"wire":[47,1,61,0]}
{"wire":[47,2,59,0]}
{"wire":[4,2,2,0]}
{"wire":[5,1,3,0]}
{"wire":[42,0,41,0]}
{"wire":[42,1,43,0]}
{"wire":[187,0,184,0]}
{"wire":[187,1,190,0]}
{"wire":[187,2,193,0]}
{"wire":[7,0,2,0]}
{"wire":[7,1,6,0]}
{"wire":[7,7,2,1]}
{"wire":[236,0,235,0]}
{"wire":[15,0,17,2]}
{"wire":[15,1,18,0]}
{"wire":[125,0,95,0]}
{"wire":[125,1,131,0]}
{"wire":[125,7,95,1]}
{"wire":[85,1,83,1]}
{"wire":[279,0,247,2]}
{"wire":[279,1,258,0]}
{"wire":[279,2,330,0]}
{"wire":[165,0,164,0]}
{"wire":[165,1,150,2]}
{"wire":[313,0,289,2]}
{"wire":[313,1,312,0]}
{"wire":[385,0,380,0]}
{"wire":[60,0,47,0]}
{"wire":[60,1,55,0]}
{"wire":[6,0,4,0]}
{"wire":[6,1,5,0]}
{"wire":[6,2,42,0]}
{"wire":[182,0,195,0]}
{"wire":[182,1,187,0]}
{"wire":[182,7,195,1]}
{"wire":[234,0,7,2]}
{"wire":[234,1,237,0]}
{"wire":[234,2,236,0]}
{"wire":[204,0,48,2]}
{"wire":[204,1,205,0]}
{"wire":[16,0,15,0]}
{"wire":[136,0,137,0]}
{"wire":[136,1,125,2]}
{"wire":[86,0,85,0]}
{"wire":[86,1,92,0]}
{"wire":[262,0,263,0]}
{"wire":[262,1,279,0]}
{"wire":[167,0,165,0]}
{"wire":[167,1,166,0]}
{"wire":[314,0,315,0]}
{"wire":[314,1,313,0]}
{"wire":[386,0,387,0]}
{"wire":[386,1,385,0]}
{"wire":[57,0,49,0]}
{"wire":[57,1,60,0]}
{"wire":[57,7,49,1]}
{"wire":[243,0,6,0]}
{"wire":[243,1,234,0]}
{"wire":[177,0,182,2]}
{"wire":[177,1,178,0]}
{"wire":[177,2,204,0]}
{"wire":[19,0,16,0]}
{"wire":[19,1,22,0]}
{"wire":[19,2,25,0]}
{"wire":[135,0,136,0]}
{"wire":[135,1,138,0]}
{"wire":[87,0,86,0]}
{"wire":[264,0,262,0]}
{"wire":[168,0,167,0]}
{"wire":[316,0,314,0]}
{"wire":[388,0,386,0]}
{"wire":[388,1,381,0]}
{"wire":[233,0,2,0]}
{"wire":[233,1,243,0]}
{"wire":[233,7,2,1]}
{"wire":[198,0,177,0]}
{"wire":[75,0,57,2]}
{"wire":[75,1,76,0]}
{"wire":[328,0,19,0]}
{"wire":[328,1,327,0]}
{"wire":[139,0,135,0]}
{"wire":[382,0,388,0]}
{"wire":[245,0,233,2]}
{"wire":[245,1,328,0]}
{"wire":[62,0,66,0]}
{"wire":[62,1,65,0]}
{"wire":[62,2,75,0]}
{"wire":[196,0,198,0]}
{"wire":[196,1,197,0]}
{"wire":[147,0,69,0]}
{"wire":[147,1,88,0]}
{"wire":[169,0,180,0]}
{"wire":[169,1,171,0]}
{"wire":[242,0,245,0]}
{"wire":[199,0,62,0]}
{"wire":[199,1,201,0]}
{"wire":[199,2,196,0]}
{"wire":[149,0,147,0]}
{"wire":[149,1,140,0]}
{"wire":[383,0,169,0]}
{"wire":[383,1,384,0]}
{"wire":[238,0,199,0]}
{"wire":[238,1,239,5]}
{"wire":[238,2,242,0]}
{"wire":[181,0,149,0]}
{"wire":[181,1,383,0]}
{"wire":[334,87,49,0]}
{"wire":[334,85,55,0]}
{"wire":[334,74,49,1]}
{"wire":[334,91,333,0]}
{"wire":[73,0,238,0]}
{"wire":[71,0,181,0]}
{"wire":[366,0,334,40]}
{"wire":[349,0,337,0]}
{"wire":[349,1,338,0]}
{"wire":[350,0,340,0]}
{"wire":[350,1,339,0]}
{"wire":[354,0,347,0]}
{"wire":[354,1,348,0]}
{"wire":[355,0,349,0]}
{"wire":[355,1,350,0]}
{"wire":[355,2,354,0]}
{"wire":[67,0,74,0]}
{"wire":[67,2,72,0]}
{"wire":[332,20,57,2]}
{"wire":[332,110,333,0]}
{"wire":[357,1,356,0]}
{"wire":[357,0,355,0]}
{"wire":[362,1,331,0]}
{"wire":[362,0,363,0]}
{"wire":[364,1,367,0]}
{"wire":[364,0,365,0]}
{"wire":[360,1,318,0]}
{"wire":[360,0,361,0]}
{"wire":[358,1,67,0]}
{"wire":[358,0,359,0]}
{"wire":[390,0,358,0]}
{"wire":[390,1,364,0]}
{"wire":[390,4,362,0]}
{"wire":[390,2,357,0]}
{"wire":[390,6,360,0]}
ASEEND*/
//CHKSM=BBC3169447AB19C68BE1918937DBD9B76DAAF5AC