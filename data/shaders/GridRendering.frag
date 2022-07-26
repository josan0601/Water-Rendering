#version 400

out vec4 FragColor;
  
uniform sampler2D foam;
uniform float WaveHeight;
uniform float ColorModifier;
uniform bool WireFrame;
uniform vec3 viewPos;
uniform vec3 LightDir;

in vec2 UV;
in vec3 PosW;
in float Height;

void main()
{    

	vec4 foamVal = texture(foam, UV);

	float Interp =  Height;

	vec4 Color = mix(vec4(0.04, 0.45, 0.92, 1.0), foamVal, Interp);

	vec3 diffuse = vec3(0.75);
	vec3 specular = vec3(1.0);
	vec3 normal = normalize(cross(dFdx(PosW), dFdy(PosW)));
	vec3 viewDir = normalize(viewPos - PosW);
	
  vec3 fragToLightDir = normalize(-LightDir);

  float shininess = 512;

  float diff = max(dot(fragToLightDir, normal), 0.0);
  vec3 halfwayDir = normalize(fragToLightDir + viewDir);
  float specAngle = max(dot(halfwayDir, normal), 0.0);
  float spec = pow(specAngle, shininess);

  vec3 ambient = vec3(0.15) * Color.rgb;
  diffuse = diffuse * Color.rgb * diff;
  specular = specular * spec;


	if(WireFrame)
		FragColor = vec4(1.0);
	else
		FragColor = vec4((ambient + diffuse + specular) * ColorModifier, 1.0); 
}  
