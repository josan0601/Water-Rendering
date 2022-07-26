#version 400

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vUV;

uniform mat4 Perspective;
uniform mat4 Model;
uniform mat4 View;

uniform sampler2D HeightMap1;
uniform sampler2D HeightMap2;
uniform sampler2D waves;
uniform sampler2D waves2;
uniform float wavesOffset;
uniform float interpolateFactor;
uniform float WaveSpeed;
uniform float WaveSpeed2;
uniform float WaveHeight;
uniform float WhichWave;
uniform float HeightOrWave;

out vec2 UV;
out vec3 PosW;
out float Height;

void main()
{   
   vec4 TempVec4 = vec4(vPosition, 1.0);

   UV = vec2(vUV.x, vUV.z);



   float wavesHeight = texture(waves, vec2(UV.x, UV.y + wavesOffset / WaveSpeed)).r * WaveHeight;
   float wavesHeight2 = texture(waves2, vec2(UV.x, UV.y - wavesOffset / WaveSpeed2)).r * WaveHeight;

   wavesHeight = mix(wavesHeight, wavesHeight2, WhichWave);
   
   float Sampled = texture(HeightMap1, UV).r;
   float Sampled2 = texture(HeightMap2, UV).r;
   float height = mix(Sampled, Sampled2, interpolateFactor);
   height = mix(height, wavesHeight, HeightOrWave);
   height *= 0.11f;

   TempVec4.y = height;
   Height = height;

   PosW = vec3(  Model * TempVec4).rgb;



   gl_Position = Perspective * View * Model * TempVec4; 

}