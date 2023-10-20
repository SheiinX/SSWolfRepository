#ifndef LIGHTING_INFO
#define LIGHTING_INFO

//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

void GetMainLight_float(float3 PositionWS, out float3 LightDirectionWS, out float3 LightColor)
{
    LightDirectionWS = float3(1,1,-1);
    LightColor = 1;
#ifdef UNIVERSAL_LIGHTING_INCLUDED
    //Creanme
    float4 shadowCoord = TransformWorldToShadowCoord(PositionWS);
    //Creanme
    
    Light mainLight = GetMainLight(shadowCoord);

    LightDirectionWS = mainLight.direction;
    LightColor = mainLight.color;
#endif
}



void GetMainLight_half(float3 PositionWS, out half3 LightDirectionWS, out half3 LightColor)
{
    LightDirectionWS = float3(1,1,-1);
    LightColor = 1;
    #ifdef UNIVERSAL_LIGHTING_INCLUDED
    //Creanme
    float4 shadowCoord = TransformWorldToShadowCoord(PositionWS);
    //Creanme
    
    Light mainLight = GetMainLight(shadowCoord);

    LightDirectionWS = mainLight.direction;
    LightColor = mainLight.color;
    #endif
}

void GetAdditionalLight_float(int LightIndex, float3 PositionWS, out float3 LightDirectionWS, out float3 LightColor, out float ShadowAttenuation, out float DistanceAttenuation)
{
    LightDirectionWS = float3(1, 1, -1);
    LightColor = 1;
    ShadowAttenuation = 1;
    DistanceAttenuation = 1;

#ifdef UNIVERSAL_LIGHTING_INCLUDED
    Light light = GetAdditionalLight(LightIndex, PositionWS);
    LightDirectionWS = light.direction;
    LightColor = light.color;
    ShadowAttenuation = light.shadowAttenuation;
    DistanceAttenuation = light.distanceAttenuation;
#endif
}

void GetHalfLambertForAdditionalLights_float(float3 PositionWS, float3 NormalWS, out float3 HalfLambert)
{
    HalfLambert = 0;

#ifdef UNIVERSAL_LIGHTING_INCLUDED
    const int lightCount = GetAdditionalLightsCount();
    Light currentLight;
    
    [unroll(8)]
    for(int i = 0; lightCount; i++)
    {
        currentLight = GetAdditionalLight(i, PositionWS);
        float3 lighting = dot(normalize(currentLight.direction), NormalWS) * 0.5 + 0.5;
        lighting *= currentLight.color;
        lighting *= currentLight.distanceAttenuation;
        lighting *= currentLight.shadowAttenuation;
        HalfLambert += lighting;
    }
#endif
}

#endif