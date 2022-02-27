// Toony Colors Pro+Mobile 2
// (c) 2014-2021 Jean Moreno

Shader "TestShader ShaderGen2"
{
	Properties
	{
		[TCP2HeaderHelp(Base)]
		_BaseColor ("Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (0.75,0.75,0.75,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.2,0.2,0.2,1)
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow HSV", Float) = 0
		_Shadow_HSV_H ("Hue", Range(-180,180)) = 0
		_Shadow_HSV_S ("Saturation", Range(-1,1)) = 0
		_Shadow_HSV_V ("Value", Range(-1,1)) = 0
		[HideInInspector] __EndGroup ("Shadow HSV", Float) = 0
		_BaseMap ("Albedo", 2D) = "white" {}
		
		[HideInInspector] __BeginGroup_HSV_albedo ("Albedo HSV", Float) = 0
		_albedo_hue ("Hue", Range(-180,180)) = 0
		_albedo_sat ("Saturation", Range(-2,2)) = 0.0
		_albedo_val ("Value", Range(-2,2)) = 0
		[HideInInspector] __EndGroup ("Albedo HSV", Float) = 0
		[TCP2Separator]

		[TCP2Header(Ramp Shading)]
		
		[TCP2Vector3FloatsDrawer(R,G,B,0,1,0,1,0,1)] _RampThresholdRGB ("Threshold (RGB)", Vector) = (0.5,0.5,0.5,1)
		[TCP2Vector3FloatsDrawer(R,G,B,0,1,0,1,0,1)] _RampSmoothingRGB ("Smoothing (RGB)", Vector) = (0.1,0.1,0.1,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Specular)]
		[TCP2Gradient] _SpecularRamp ("Specular Ramp (RGB)", 2D) = "gray" {}
		[TCP2ColorNoAlpha] _SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		[TCP2Separator]

		[TCP2HeaderHelp(Emission)]
		[TCP2ColorNoAlpha] [HDR] _Emission ("Emission Color", Color) = (0,0,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Rim Lighting)]
		[TCP2ColorNoAlpha] _RimColor ("Rim Color", Color) = (0.8,0.8,0.8,0.5)
		_RimMin ("Rim Min", Range(0,2)) = 0.5
		_RimMax ("Rim Max", Range(0,2)) = 1
		[TCP2Separator]
		
		[TCP2HeaderHelp(Subsurface Scattering)]
		_SubsurfaceDistortion ("Distortion", Range(0,2)) = 0.2
		_SubsurfacePower ("Power", Range(0.1,16)) = 3
		_SubsurfaceScale ("Scale", Float) = 1
		[TCP2ColorNoAlpha] _SubsurfaceColor ("Color", Color) = (0.5,0.5,0.5,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(MatCap)]
		[NoScaleOffset] _MatCapTex ("MatCap (RGB)", 2D) = "black" {}
		[TCP2ColorNoAlpha] _MatCapColor ("MatCap Color", Color) = (1,1,1,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Normal Mapping)]
		[NoScaleOffset] _BumpMap ("Normal Map", 2D) = "bump" {}
		[TCP2Separator]
		[HideInInspector] __BeginGroup_ShadowHSV ("Shadow Line", Float) = 0
		_ShadowLineThreshold ("Threshold", Range(0,1)) = 0.5
		_ShadowLineSmoothing ("Smoothing", Range(0.001,0.1)) = 0.015
		_ShadowLineStrength ("Strength", Float) = 1
		_ShadowLineColor ("Color (RGB) Opacity (A)", Color) = (0,0,0,1)
		[HideInInspector] __EndGroup ("Shadow Line", Float) = 0
		
		_StylizedThreshold ("Stylized Threshold", 2D) = "gray" {}
		[TCP2Separator]
		
		[TCP2ColorNoAlpha] _DiffuseTint ("Diffuse Tint", Color) = (1,0.5,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Sketch)]
		[Toggle(TCP2_SKETCH)] _UseSketch ("Enable Sketch Effect", Float) = 0
		_ProgressiveSketchTexture ("Progressive Texture", 2D) = "black" {}
		_ProgressiveSketchSmoothness ("Progressive Smoothness", Range(0.005,0.5)) = 0.1
		[TCP2Separator]
		
		[TCP2HeaderHelp(Dissolve)]
		_DissolveMap ("Map", 2D) = "gray" {}
		[TCP2UVScrolling] _DissolveMap_SC ("Map UV Scrolling", Vector) = (1,1,0,0)
		[HDR] _DissolveGradientTexture ("Gradient Texture", Color) = (1,1,1,1)
		_DissolveGradientWidth ("Ramp Width", Range(0,1)) = 0.2
		[TCP2Separator]
		
		[TCP2Vector4Floats(Contrast X,Contrast Y,Contrast Z,Smoothing,1,16,1,16,1,16,0.05,10)] _TriplanarSamplingStrength ("Triplanar Sampling Parameters", Vector) = (8,8,8,0.5)
		// Custom Material Properties
		 _DissolveValue ("Dissolve Value", Range(0,1)) = 0.5

		[ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadowsOff ("Receive Shadows", Float) = 1

		// Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="AlphaTest"
		}

		HLSLINCLUDE
		#define fixed half
		#define fixed2 half2
		#define fixed3 half3
		#define fixed4 half4

		#if UNITY_VERSION >= 202020
			#define URP_10_OR_NEWER
		#endif

		// Texture/Sampler abstraction
		#define TCP2_TEX2D_WITH_SAMPLER(tex)						TEXTURE2D(tex); SAMPLER(sampler##tex)
		#define TCP2_TEX2D_NO_SAMPLER(tex)							TEXTURE2D(tex)
		#define TCP2_TEX2D_SAMPLE(tex, samplertex, coord)			SAMPLE_TEXTURE2D(tex, sampler##samplertex, coord)
		#define TCP2_TEX2D_SAMPLE_LOD(tex, samplertex, coord, lod)	SAMPLE_TEXTURE2D_LOD(tex, sampler##samplertex, coord, lod)

		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

		// Uniforms

		// Custom Material Properties

		// Shader Properties
		TCP2_TEX2D_WITH_SAMPLER(_BumpMap);
		TCP2_TEX2D_WITH_SAMPLER(_BaseMap);
		TCP2_TEX2D_WITH_SAMPLER(_DissolveMap);
		TCP2_TEX2D_WITH_SAMPLER(_StylizedThreshold);
		TCP2_TEX2D_WITH_SAMPLER(_ProgressiveSketchTexture);

		CBUFFER_START(UnityPerMaterial)
			
			// Custom Material Properties
			float _DissolveValue;

			// Shader Properties
			float4 _BaseMap_ST;
			float _albedo_hue;
			float _albedo_sat;
			float _albedo_val;
			float4 _DissolveMap_ST;
			half4 _DissolveMap_SC;
			float _DissolveGradientWidth;
			half4 _DissolveGradientTexture;
			fixed4 _BaseColor;
			half4 _Emission;
			fixed4 _MatCapColor;
			float4 _StylizedThreshold_ST;
			float4 _RampThresholdRGB;
			float4 _RampSmoothingRGB;
			fixed4 _DiffuseTint;
			float _ShadowLineThreshold;
			float _ShadowLineStrength;
			float _ShadowLineSmoothing;
			fixed4 _ShadowLineColor;
			float _RimMin;
			float _RimMax;
			fixed4 _RimColor;
			fixed4 _SpecularColor;
			float _SubsurfaceDistortion;
			float _SubsurfacePower;
			float _SubsurfaceScale;
			fixed4 _SubsurfaceColor;
			float _Shadow_HSV_H;
			float _Shadow_HSV_S;
			float _Shadow_HSV_V;
			float4 _ProgressiveSketchTexture_ST;
			float _ProgressiveSketchSmoothness;
			fixed4 _SColor;
			fixed4 _HColor;
			float4 _TriplanarSamplingStrength;
			sampler2D _SpecularRamp;
			sampler2D _MatCapTex;
		CBUFFER_END

		// Texture sampling with triplanar UVs
		float4 tex2D_triplanar(sampler2D samp, float4 tiling_offset, float3 worldPos, float3 worldNormal)
		{
			half4 sample_y = ( tex2D(samp, worldPos.xz * tiling_offset.xy + tiling_offset.zw).rgba );
			fixed4 sample_x = ( tex2D(samp, worldPos.zy * tiling_offset.xy + tiling_offset.zw).rgba );
			fixed4 sample_z = ( tex2D(samp, worldPos.xy * tiling_offset.xy + tiling_offset.zw).rgba );
			
			// blending
			half3 blendWeights = pow(abs(worldNormal), _TriplanarSamplingStrength.xyz / _TriplanarSamplingStrength.w);
			blendWeights = blendWeights / (blendWeights.x + abs(blendWeights.y) + blendWeights.z);
			half4 triplanar = sample_x * blendWeights.x + sample_y * blendWeights.y + sample_z * blendWeights.z;
			
			return triplanar;
		}
			
		// Version with separate texture and sampler
		#define TCP2_TEX2D_SAMPLE_TRIPLANAR(tex, samplertex, tiling, positionWS, normalWS) tex2D_triplanar(tex, sampler##samplertex, tiling, positionWS, normalWS)
		float4 tex2D_triplanar(Texture2D tex, SamplerState samp, float4 tiling_offset, float3 worldPos, float3 worldNormal)
		{
			half4 sample_y = ( tex.Sample(samp, worldPos.xz * tiling_offset.xy + tiling_offset.zw).rgba );
			fixed4 sample_x = ( tex.Sample(samp, worldPos.zy * tiling_offset.xy + tiling_offset.zw).rgba );
			fixed4 sample_z = ( tex.Sample(samp, worldPos.xy * tiling_offset.xy + tiling_offset.zw).rgba );
			
			// blending
			half3 blendWeights = pow(abs(worldNormal), _TriplanarSamplingStrength.xyz / _TriplanarSamplingStrength.w);
			blendWeights = blendWeights / (blendWeights.x + abs(blendWeights.y) + blendWeights.z);
			half4 triplanar = sample_x * blendWeights.x + sample_y * blendWeights.y + sample_z * blendWeights.z;
			
			return triplanar;
		}
		
		//--------------------------------
		// HSV HELPERS
		// source: http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
		
		float3 rgb2hsv(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
			float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
		
			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}
		
		float3 hsv2rgb(float3 c)
		{
			c.g = max(c.g, 0.0); //make sure that saturation value is positive
			float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
		}
		
		float3 ApplyHSV_3(float3 color, float h, float s, float v)
		{
			float3 hsv = rgb2hsv(color.rgb);
			hsv += float3(h/360,s,v);
			return hsv2rgb(hsv);
		}
		float3 ApplyHSV_3(float color, float h, float s, float v) { return ApplyHSV_3(color.xxx, h, s ,v); }
		
		float4 ApplyHSV_4(float4 color, float h, float s, float v)
		{
			float3 hsv = rgb2hsv(color.rgb);
			hsv += float3(h/360,s,v);
			return float4(hsv2rgb(hsv), color.a);
		}
		float4 ApplyHSV_4(float color, float h, float s, float v) { return ApplyHSV_4(color.xxxx, h, s, v); }
		
		// Cubic pulse function
		// Adapted from: http://www.iquilezles.org/www/articles/functions/functions.htm (c) 2017 - Inigo Quilez - MIT License
		float linearPulse(float c, float w, float x)
		{
			x = abs(x - c);
			if (x > w)
			{
				return 0;
			}
			x /= w;
			return 1 - x;
		}
		
		// Built-in renderer (CG) to SRP (HLSL) bindings
		#define UnityObjectToClipPos TransformObjectToHClip
		#define _WorldSpaceLightPos0 _MainLightPosition
		
		ENDHLSL

		Pass
		{
			Name "Main"
			Tags
			{
				"LightMode"="UniversalForward"
			}

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard SRP library
			// All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 3.0

			// -------------------------------------
			// Material keywords
			#pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF

			// -------------------------------------
			// Universal Render Pipeline keywords
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK

			// -------------------------------------

			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing

			#pragma vertex Vertex
			#pragma fragment Fragment

			//--------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local_fragment TCP2_SKETCH

			// vertex input
			struct Attributes
			{
				float4 vertex       : POSITION;
				float3 normal       : NORMAL;
				float4 tangent      : TANGENT;
				float4 texcoord0 : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			// vertex output / fragment input
			struct Varyings
			{
				float4 positionCS     : SV_POSITION;
				float3 normal         : NORMAL;
				float4 worldPosAndFog : TEXCOORD0;
			#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord    : TEXCOORD1; // compute shadow coord per-vertex for the main light
			#endif
			#ifdef _ADDITIONAL_LIGHTS_VERTEX
				half3 vertexLights : TEXCOORD2;
			#endif
				float4 screenPosition : TEXCOORD3;
				float3 pack1 : TEXCOORD4; /* pack1.xyz = objPos */
				float3 pack2 : TEXCOORD5; /* pack2.xyz = objNormal */
				float3 pack3 : TEXCOORD6; /* pack3.xyz = tangent */
				float3 pack4 : TEXCOORD7; /* pack4.xyz = bitangent */
				float4 pack5 : TEXCOORD8; /* pack5.xy = texcoord0  pack5.zw = matcap */
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings Vertex(Attributes input)
			{
				Varyings output = (Varyings)0;

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				// Texture Coordinates
				output.pack5.xy.xy = input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;

				float3 worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
				output.pack1.xyz = input.vertex.xyz;
				output.pack2.xyz = input.normal.xyz;
				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.vertex.xyz);
			#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				output.shadowCoord = GetShadowCoord(vertexInput);
			#endif
				float4 clipPos = vertexInput.positionCS;

				float4 screenPos = ComputeScreenPos(clipPos);
				output.screenPosition.xyzw = screenPos;

				VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normal, input.tangent);
			#ifdef _ADDITIONAL_LIGHTS_VERTEX
				// Vertex lighting
				output.vertexLights = VertexLighting(vertexInput.positionWS, vertexNormalInput.normalWS);
			#endif

				// world position
				output.worldPosAndFog = float4(vertexInput.positionWS.xyz, 0);

				// normal
				output.normal = normalize(vertexNormalInput.normalWS);

				// tangent
				output.pack3.xyz = vertexNormalInput.tangentWS;
				output.pack4.xyz = vertexNormalInput.bitangentWS;

				// clip position
				output.positionCS = vertexInput.positionCS;

				//MatCap
				float3 worldNorm = normalize(unity_WorldToObject[0].xyz * input.normal.x + unity_WorldToObject[1].xyz * input.normal.y + unity_WorldToObject[2].xyz * input.normal.z);
				worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
				output.pack5.zw = worldNorm.xy * 0.5 + 0.5;

				return output;
			}

			half4 Fragment(Varyings input) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				float3 positionWS = input.worldPosAndFog.xyz;
				float3 normalWS = normalize(input.normal);
				half3 viewDirWS = SafeNormalize(GetCameraPositionWS() - positionWS);
				half3 tangentWS = input.pack3.xyz;
				half3 bitangentWS = input.pack4.xyz;
				half3x3 tangentToWorldMatrix = half3x3(tangentWS.xyz, bitangentWS.xyz, normalWS.xyz);

				//Screen Space UV
				float2 screenUV = input.screenPosition.xyzw.xy / input.screenPosition.xyzw.w;
				
				// Shader Properties Sampling
				float4 __normalMap = ( TCP2_TEX2D_SAMPLE(_BumpMap, _BumpMap, input.pack5.xy).rgba );
				float4 __albedo = ( ApplyHSV_4(TCP2_TEX2D_SAMPLE(_BaseMap, _BaseMap, input.pack5.xy).rgba, _albedo_hue, _albedo_sat, _albedo_val) );
				float4 __mainColor = ( _BaseColor.rgba );
				float __alpha = ( __albedo.a * __mainColor.a );
				float __dissolveMap = ( TCP2_TEX2D_SAMPLE_TRIPLANAR(_DissolveMap, _DissolveMap, float4(float2(1, 1) * _DissolveMap_ST.xy, _DissolveMap_ST.zw + frac(_Time.yy * _DissolveMap_SC.xy)), input.pack1.xyz, input.pack2.xyz).r );
				float __dissolveValue = ( _DissolveValue.x );
				float __dissolveGradientWidth = ( _DissolveGradientWidth );
				float __dissolveGradientStrength = ( 2.0 );
				float __ambientIntensity = ( 1.0 );
				float3 __emission = ( _Emission.rgb );
				float3 __matcapColor = ( _MatCapColor.rgb );
				float __stylizedThreshold = ( TCP2_TEX2D_SAMPLE(_StylizedThreshold, _StylizedThreshold, input.pack5.xy * _StylizedThreshold_ST.xy + _StylizedThreshold_ST.zw).a );
				float __stylizedThresholdScale = ( 1.0 );
				float3 __rampThresholdRgb = ( _RampThresholdRGB.xyz );
				float3 __rampSmoothingRgb = ( _RampSmoothingRGB.xyz );
				float3 __diffuseTint = ( _DiffuseTint.rgb );
				float __shadowLineThreshold = ( _ShadowLineThreshold );
				float __shadowLineStrength = ( _ShadowLineStrength );
				float __shadowLineSmoothing = ( _ShadowLineSmoothing );
				float4 __shadowLineColor = ( _ShadowLineColor.rgba );
				float __rimMin = ( _RimMin );
				float __rimMax = ( _RimMax );
				float3 __rimColor = ( _RimColor.rgb );
				float __rimStrength = ( 1.0 );
				float3 __specularColor = ( _SpecularColor.rgb );
				float __subsurfaceDistortion = ( _SubsurfaceDistortion );
				float __subsurfacePower = ( _SubsurfacePower );
				float __subsurfaceScale = ( _SubsurfaceScale );
				float3 __subsurfaceColor = ( _SubsurfaceColor.rgb );
				float __shadowHue = ( _Shadow_HSV_H );
				float __shadowSaturation = ( _Shadow_HSV_S );
				float __shadowValue = ( _Shadow_HSV_V );
				float4 __progressiveSketchTexture = ( TCP2_TEX2D_SAMPLE(_ProgressiveSketchTexture, _ProgressiveSketchTexture, screenUV * _ScreenParams.zw * _ProgressiveSketchTexture_ST.xy + _ProgressiveSketchTexture_ST.zw).rgba );
				float __progressiveSketchSmoothness = ( _ProgressiveSketchSmoothness );
				float3 __shadowColor = ( _SColor.rgb );
				float3 __highlightColor = ( _HColor.rgb );

				half4 normalMap = __normalMap;
				half3 normalTS = UnpackNormal(normalMap);
				normalWS = normalize( mul(normalTS, tangentToWorldMatrix) );

				half ndv = abs(dot(viewDirWS, normalWS));
				half ndvRaw = ndv;

				// main texture
				half3 albedo = __albedo.rgb;
				half alpha = __alpha;

				half3 emission = half3(0,0,0);
				
				//Dissolve
				half dissolveMap = __dissolveMap;
				half dissolveValue = __dissolveValue;
				half gradientWidth = __dissolveGradientWidth;
				float dissValue = dissolveValue*(1+2*gradientWidth) - gradientWidth;
				float dissolveUV = smoothstep(dissolveMap - gradientWidth, dissolveMap + gradientWidth, dissValue);
				clip((1-dissolveUV) - 0.001);
				half4 dissolveColor = ( _DissolveGradientTexture.rgba );
				dissolveColor *= __dissolveGradientStrength * dissolveUV;
				emission += dissolveColor.rgb;
				
				albedo *= __mainColor.rgb;

				// main light: direction, color, distanceAttenuation, shadowAttenuation
			#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord = input.shadowCoord;
			#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
				float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
			#else
				float4 shadowCoord = float4(0, 0, 0, 0);
			#endif

			#if defined(URP_10_OR_NEWER)
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
					half4 shadowMask = SAMPLE_SHADOWMASK(input.uvLM);
				#elif !defined (LIGHTMAP_ON)
					half4 shadowMask = unity_ProbesOcclusion;
				#else
					half4 shadowMask = half4(1, 1, 1, 1);
				#endif

				Light mainLight = GetMainLight(shadowCoord, positionWS, shadowMask);
			#else
				Light mainLight = GetMainLight(shadowCoord);
			#endif

				// ambient or lightmap
				// Samples SH fully per-pixel. SampleSHVertex and SampleSHPixel functions
				// are also defined in case you want to sample some terms per-vertex.
				half3 bakedGI = SampleSH(normalWS);
				half occlusion = 1;

				half3 indirectDiffuse = bakedGI;
				indirectDiffuse *= occlusion * albedo * __ambientIntensity;
				emission += __emission;

				//MatCap
				fixed3 matcap = tex2D(_MatCapTex, input.pack5.zw).rgb * __matcapColor;
				emission += matcap;

				half3 lightDir = mainLight.direction;
				half3 lightColor = mainLight.color.rgb;

				half atten = mainLight.shadowAttenuation * mainLight.distanceAttenuation;

				half ndl = dot(normalWS, lightDir);
				float stylizedThreshold = __stylizedThreshold;
				stylizedThreshold -= 0.5;
				stylizedThreshold *= __stylizedThresholdScale;
				ndl += stylizedThreshold;
				// apply attenuation
				ndl *= atten;
				half3 ramp;
				
				half3 rampThreshold = 1 - __rampThresholdRgb;
				half3 rampSmooth = __rampSmoothingRgb * 0.5;
				ndl = saturate(ndl);
				ramp = smoothstep(rampThreshold - rampSmooth, rampThreshold + rampSmooth, ndl);

				// Diffuse Tint
				half3 diffuseTint = saturate(__diffuseTint + ndl);
				ramp *= diffuseTint;
				
				//Shadow Line
				float ndlAtten = ndl * atten;
				float shadowLineThreshold = __shadowLineThreshold;
				float shadowLineStrength = __shadowLineStrength;
				float shadowLineSmoothing = __shadowLineSmoothing;
				float shadowLine = min(linearPulse(ndlAtten, shadowLineSmoothing, shadowLineThreshold) * shadowLineStrength, 1.0);
				half4 shadowLineColor = __shadowLineColor;
				ramp = lerp(ramp.rgb, shadowLineColor.rgb, shadowLine * shadowLineColor.a);
				half3 color = half3(0,0,0);
				// Rim Lighting
				half rim = 1 - ndvRaw;
				rim = ( rim );
				half rimMin = __rimMin;
				half rimMax = __rimMax;
				rim = smoothstep(rimMin, rimMax, rim);
				half3 rimColor = __rimColor;
				half rimStrength = __rimStrength;
				emission.rgb += rim * rimColor * rimStrength;
				half3 accumulatedRamp = ramp * max(lightColor.r, max(lightColor.g, lightColor.b));
				half3 accumulatedColors = ramp * lightColor.rgb;

				//Blinn-Phong Specular
				half3 h = normalize(lightDir + viewDirWS);
				float ndh = max(0, dot (normalWS, h));
				float3 spec = tex2D(_SpecularRamp, (ndh*ndh).xx).rgb;
				spec *= ndl;
				spec *= atten;
				
				//Apply specular
				emission.rgb += spec * lightColor.rgb * __specularColor;

				// Additional lights loop
			#ifdef _ADDITIONAL_LIGHTS
				uint additionalLightsCount = GetAdditionalLightsCount();
				for (uint lightIndex = 0u; lightIndex < additionalLightsCount; ++lightIndex)
				{
					#if defined(URP_10_OR_NEWER)
						Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask);
					#else
						Light light = GetAdditionalLight(lightIndex, positionWS);
					#endif
					half atten = light.shadowAttenuation * light.distanceAttenuation;
					half3 lightDir = light.direction;
					half3 lightColor = light.color.rgb;

					half ndl = dot(normalWS, lightDir);
					float stylizedThreshold = __stylizedThreshold;
					stylizedThreshold -= 0.5;
					stylizedThreshold *= __stylizedThresholdScale;
					ndl += stylizedThreshold;
					// apply attenuation (shadowmaps & point/spot lights attenuation)
					ndl *= atten;
					half3 ramp;
					
					ndl = saturate(ndl);
					ramp = smoothstep(rampThreshold - rampSmooth, rampThreshold + rampSmooth, ndl);

					// Diffuse Tint
					half3 diffuseTint = saturate(__diffuseTint + ndl);
					ramp *= diffuseTint;
					
					//Shadow Line
					float ndlAtten = ndl * atten;
					float shadowLineThreshold = __shadowLineThreshold;
					float shadowLineStrength = __shadowLineStrength;
					float shadowLineSmoothing = __shadowLineSmoothing;
					float shadowLine = min(linearPulse(ndlAtten, shadowLineSmoothing, shadowLineThreshold) * shadowLineStrength, 1.0);
					half4 shadowLineColor = __shadowLineColor;
					ramp = lerp(ramp.rgb, shadowLineColor.rgb, shadowLine * shadowLineColor.a);
					accumulatedRamp += ramp * max(lightColor.r, max(lightColor.g, lightColor.b));
					accumulatedColors += ramp * lightColor.rgb;

					//Blinn-Phong Specular
					half3 h = normalize(lightDir + viewDirWS);
					float ndh = max(0, dot (normalWS, h));
					float3 spec = tex2D(_SpecularRamp, (ndh*ndh).xx).rgb;
					spec *= ndl;
					spec *= atten;
					
					//Apply specular
					emission.rgb += spec * lightColor.rgb * __specularColor;
					
					//Subsurface Scattering for additional lights
					half3 ssLight = lightDir + normalWS * __subsurfaceDistortion;
					half ssDot = pow(saturate(dot(viewDirWS, -ssLight)), __subsurfacePower) * __subsurfaceScale;
					half3 ssColor = (ssDot * __subsurfaceColor);
					ssColor *= atten;
					ssColor *= lightColor;
					color.rgb += albedo * ssColor;
				}
			#endif
			#ifdef _ADDITIONAL_LIGHTS_VERTEX
				color += input.vertexLights * albedo;
			#endif

				accumulatedRamp = saturate(accumulatedRamp);
				
				//Shadow HSV
				float3 albedoShadowHSV = ApplyHSV_3(albedo, __shadowHue, __shadowSaturation, __shadowValue);
				albedo = lerp(albedoShadowHSV, albedo, accumulatedRamp);
				
				// Sketch
				#if defined(TCP2_SKETCH)
				half4 sketch = __progressiveSketchTexture;
				half4 sketchWeights = half4(0,0,0,0);
				half sketchStep = 1.0 / 5.0;
				half sketchSmooth = __progressiveSketchSmoothness;
				sketchWeights.a = smoothstep(sketchStep + sketchSmooth, sketchStep - sketchSmooth, accumulatedRamp);
				sketchWeights.b = smoothstep(sketchStep*2 + sketchSmooth, sketchStep*2 - sketchSmooth, accumulatedRamp) - sketchWeights.a;
				sketchWeights.g = smoothstep(sketchStep*3 + sketchSmooth, sketchStep*3 - sketchSmooth, accumulatedRamp) - sketchWeights.a - sketchWeights.b;
				sketchWeights.r = smoothstep(sketchStep*4 + sketchSmooth, sketchStep*4 - sketchSmooth, accumulatedRamp) - sketchWeights.a - sketchWeights.b - sketchWeights.g;
				half combinedSketch = 1.0 - dot(sketch, sketchWeights);
				
				#endif
				half3 shadowColor = (1 - accumulatedRamp.rgb) * __shadowColor;
				accumulatedRamp = accumulatedColors.rgb * __highlightColor + shadowColor;
				color += albedo * accumulatedRamp;
				#if defined(TCP2_SKETCH)
				color.rgb *= combinedSketch;
				#endif

				// apply ambient
				color += indirectDiffuse;

				color += emission;

				return half4(color, alpha);
			}
			ENDHLSL
		}

		// Depth & Shadow Caster Passes
		HLSLINCLUDE

		#if defined(SHADOW_CASTER_PASS) || defined(DEPTH_ONLY_PASS)

			#define fixed half
			#define fixed2 half2
			#define fixed3 half3
			#define fixed4 half4

			float3 _LightDirection;
			float3 _LightPosition;

			struct Attributes
			{
				float4 vertex   : POSITION;
				float3 normal   : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float4 positionCS     : SV_POSITION;
				float3 normal         : NORMAL;
				float3 pack0 : TEXCOORD1; /* pack0.xyz = positionWS */
				float3 pack1 : TEXCOORD2; /* pack1.xyz = objPos */
				float3 pack2 : TEXCOORD3; /* pack2.xyz = objNormal */
				float4 pack3 : TEXCOORD4; /* pack3.xy = texcoord0  pack3.zw = matcap */
			#if defined(DEPTH_ONLY_PASS)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			#endif
			};

			float4 GetShadowPositionHClip(Attributes input)
			{
				float3 positionWS = TransformObjectToWorld(input.vertex.xyz);
				float3 normalWS = TransformObjectToWorldNormal(input.normal);

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

				#if UNITY_REVERSED_Z
					positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
				#else
					positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				return positionCS;
			}

			Varyings ShadowDepthPassVertex(Attributes input)
			{
				Varyings output = (Varyings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				#if defined(DEPTH_ONLY_PASS)
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
				#endif

				float3 worldNormalUv = mul(unity_ObjectToWorld, float4(input.normal, 1.0)).xyz;

				// Texture Coordinates
				output.pack3.xy.xy = input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;

				float3 worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.vertex.xyz);
				output.normal = normalize(worldNormalUv);
				output.pack0.xyz = vertexInput.positionWS;
				output.pack1.xyz = input.vertex.xyz;
				output.pack2.xyz = input.normal.xyz;

				#if defined(DEPTH_ONLY_PASS)
					output.positionCS = TransformObjectToHClip(input.vertex.xyz);
				#elif defined(SHADOW_CASTER_PASS)
					output.positionCS = GetShadowPositionHClip(input);
				#else
					output.positionCS = float4(0,0,0,0);
				#endif

				return output;
			}

			half4 ShadowDepthPassFragment(Varyings input) : SV_TARGET
			{
				#if defined(DEPTH_ONLY_PASS)
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
				#endif

				float3 positionWS = input.pack0.xyz;
				float3 normalWS = normalize(input.normal);

				// Shader Properties Sampling
				float4 __albedo = ( ApplyHSV_4(TCP2_TEX2D_SAMPLE(_BaseMap, _BaseMap, input.pack3.xy).rgba, _albedo_hue, _albedo_sat, _albedo_val) );
				float4 __mainColor = ( _BaseColor.rgba );
				float __alpha = ( __albedo.a * __mainColor.a );
				float __dissolveMap = ( TCP2_TEX2D_SAMPLE_TRIPLANAR(_DissolveMap, _DissolveMap, float4(float2(1, 1) * _DissolveMap_ST.xy, _DissolveMap_ST.zw + frac(_Time.yy * _DissolveMap_SC.xy)), input.pack1.xyz, input.pack2.xyz).r );
				float __dissolveValue = ( _DissolveValue.x );
				float __dissolveGradientWidth = ( _DissolveGradientWidth );
				float __dissolveGradientStrength = ( 2.0 );

				half3 viewDirWS = SafeNormalize(GetCameraPositionWS() - positionWS);
				half ndv = abs(dot(viewDirWS, normalWS));
				half ndvRaw = ndv;

				half3 albedo = half3(1,1,1);
				half alpha = __alpha;
				half3 emission = half3(0,0,0);
				
				//Dissolve
				half dissolveMap = __dissolveMap;
				half dissolveValue = __dissolveValue;
				half gradientWidth = __dissolveGradientWidth;
				float dissValue = dissolveValue*(1+2*gradientWidth) - gradientWidth;
				float dissolveUV = smoothstep(dissolveMap - gradientWidth, dissolveMap + gradientWidth, dissValue);
				clip((1-dissolveUV) - 0.001);
				half4 dissolveColor = ( _DissolveGradientTexture.rgba );
				dissolveColor *= __dissolveGradientStrength * dissolveUV;
				emission += dissolveColor.rgb;

				return 0;
			}

		#endif
		ENDHLSL

		Pass
		{
			Name "ShadowCaster"
			Tags
			{
				"LightMode" = "ShadowCaster"
			}

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			// using simple #define doesn't work, we have to use this instead
			#pragma multi_compile SHADOW_CASTER_PASS

			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing

			#pragma vertex ShadowDepthPassVertex
			#pragma fragment ShadowDepthPassFragment

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

			ENDHLSL
		}

		Pass
		{
			Name "DepthOnly"
			Tags
			{
				"LightMode" = "DepthOnly"
			}

			ZWrite On
			ColorMask 0

			HLSLPROGRAM

			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing

			// using simple #define doesn't work, we have to use this instead
			#pragma multi_compile DEPTH_ONLY_PASS

			#pragma vertex ShadowDepthPassVertex
			#pragma fragment ShadowDepthPassFragment

			ENDHLSL
		}

	}

	FallBack "Hidden/InternalErrorShader"
	CustomEditor "ToonyColorsPro.ShaderGenerator.MaterialInspector_SG2"
}

/* TCP_DATA u config(unity:"2020.3.23f1";ver:"2.5.2";tmplt:"SG2_Template_URP";features:list["UNITY_5_4","UNITY_5_5","UNITY_5_6","UNITY_2017_1","UNITY_2018_1","UNITY_2018_2","UNITY_2018_3","DISSOLVE","UNITY_2019_1","UNITY_2019_2","UNITY_2019_3","UNITY_2019_4","UNITY_2020_1","SHADOW_HSV","ALBEDO_HSV_GRAYSCALE","BUMP","SHADOW_LINE","SKETCH_AMBIENT","SKETCH_SHADER_FEATURE","OUTLINE_URP_FEATURE","RGB_RAMP","ATTEN_AT_NDL","SPEC_LEGACY","SPECULAR","SPECULAR_RAMP","EMISSION","RIM","SUBSURFACE_SCATTERING","MATCAP","MATCAP_ADD","BLEND_TEX1","BLEND_TEX2","BLEND_TEX3","BLEND_TEX4","TEXTURED_THRESHOLD","DIFFUSE_TINT","SKETCH_PROGRESSIVE","SKETCH_PROGRESSIVE_SMOOTH","DISSOLVE_CLIP","DISSOLVE_GRADIENT","TEMPLATE_LWRP"];flags:list["addshadow"];flags_extra:dict[];keywords:dict[RENDER_TYPE="Opaque",RampTextureDrawer="[TCP2Gradient]",RampTextureLabel="Ramp Texture",SHADER_TARGET="3.0",BASEGEN_ALBEDO_DOWNSCALE="1",BASEGEN_MASKTEX_DOWNSCALE="1/2",BASEGEN_METALLIC_DOWNSCALE="1/4",BASEGEN_SPECULAR_DOWNSCALE="1/4",BASEGEN_DIFFUSEREMAPMIN_DOWNSCALE="1/4",BASEGEN_MASKMAPREMAPMIN_DOWNSCALE="1/4",RIM_LABEL="Rim Lighting",BLEND_TEX1_CHNL="r",BLEND_TEX2_CHNL="g",BLEND_TEX3_CHNL="b",BLEND_TEX4_CHNL="a"];shaderProperties:list[sp(name:"Albedo";imps:list[imp_mp_texture(uto:True;tov:"";tov_lbl:"";gto:True;sbt:False;scr:False;scv:"";scv_lbl:"";gsc:False;roff:False;goff:False;sin_anm:False;sin_anmv:"";sin_anmv_lbl:"";gsin:False;notile:False;triplanar_local:False;def:"white";locked_uv:False;uv:0;cc:4;chan:"RGBA";mip:-1;mipprop:False;ssuv_vert:False;ssuv_obj:False;uv_type:Texcoord;uv_chan:"XZ";tpln_scale:1;uv_shaderproperty:__NULL__;uv_cmp:__NULL__;sep_sampler:__NULL__;prop:"_BaseMap";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"b1175f54-8e29-429f-a586-e809d2b9d82e";op:Multiply;lbl:"Albedo";gpu_inst:False;locked:False;impl_index:0),imp_hsv(type:FullOffset;chue:False;csat:False;cval:False;guid:"794b8da7-52a2-405e-8663-9fdb2cfaa9ec";op:Multiply;lbl:"Albedo";gpu_inst:False;locked:False;impl_index:-1)];layers:list[];unlocked:list[];clones:dict[];isClone:False),,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,sp(name:"Dissolve Map";imps:list[imp_mp_texture(uto:True;tov:"";tov_lbl:"";gto:False;sbt:False;scr:True;scv:"";scv_lbl:"";gsc:False;roff:False;goff:False;sin_anm:False;sin_anmv:"";sin_anmv_lbl:"";gsin:False;notile:False;triplanar_local:True;def:"gray";locked_uv:False;uv:6;cc:1;chan:"R";mip:-1;mipprop:False;ssuv_vert:False;ssuv_obj:True;uv_type:Triplanar;uv_chan:"XZ";tpln_scale:1;uv_shaderproperty:__NULL__;uv_cmp:__NULL__;sep_sampler:__NULL__;prop:"_DissolveMap";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"1bce4e69-5aa9-4194-8383-1f8da882010d";op:Multiply;lbl:"Map";gpu_inst:False;locked:False;impl_index:0)];layers:list[];unlocked:list[];clones:dict[];isClone:False),sp(name:"Dissolve Value";imps:list[imp_ct(lct:"_DissolveValue";cc:1;chan:"X";avchan:"X";guid:"60d36b91-8298-42c4-b1a6-116eb6e231f4";op:Multiply;lbl:"Value";gpu_inst:False;locked:False;impl_index:-1)];layers:list[];unlocked:list[];clones:dict[];isClone:False),sp(name:"Dissolve Gradient Texture";imps:list[imp_mp_color(def:RGBA(1, 1, 1, 1);hdr:True;cc:4;chan:"RGBA";prop:"_DissolveGradientTexture";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"9cb5f671-20e0-4192-bfb3-38a15cbe6b6e";op:Multiply;lbl:"Gradient Texture";gpu_inst:False;locked:False;impl_index:-1)];layers:list[];unlocked:list[];clones:dict[];isClone:False)];customTextures:list[ct(cimp:imp_mp_range(def:0.5;min:0;max:1;prop:"_DissolveValue";md:"";gbv:False;custom:True;refs:"Dissolve Value";pnlock:False;guid:"d25d99c3-bceb-4a5b-a3d0-8d46322040aa";op:Multiply;lbl:"Dissolve Value";gpu_inst:False;locked:False;impl_index:-1);exp:True;uv_exp:False;imp_lbl:"Range")];codeInjection:codeInjection(injectedFiles:list[];mark:False);matLayers:list[ml(uid:"987bd7";name:"Material Layer";src:sp(name:"layer_987bd7";imps:list[imp_mp_texture(uto:False;tov:"";tov_lbl:"";gto:False;sbt:False;scr:False;scv:"";scv_lbl:"";gsc:False;roff:False;goff:False;sin_anm:False;sin_anmv:"";sin_anmv_lbl:"";gsin:False;notile:False;triplanar_local:False;def:"white";locked_uv:False;uv:0;cc:1;chan:"R";mip:-1;mipprop:False;ssuv_vert:False;ssuv_obj:False;uv_type:Texcoord;uv_chan:"XZ";tpln_scale:1;uv_shaderproperty:__NULL__;uv_cmp:__NULL__;sep_sampler:__NULL__;prop:"_layer_987bd7";md:"";gbv:False;custom:False;refs:"";pnlock:False;guid:"2322d8f4-6cfe-41ed-b77a-362d04bae582";op:Multiply;lbl:"Source Texture";gpu_inst:False;locked:False;impl_index:-1)];layers:list[];unlocked:list[];clones:dict[];isClone:False);use_contrast:False;ctrst:__NULL__;use_noise:False;noise:__NULL__)]) */
/* TCP_HASH 49d75c04dd2161a5606fbc62099238a8 */
