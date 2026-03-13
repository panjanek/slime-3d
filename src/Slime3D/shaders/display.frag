#version 430

layout(location = 0) in vec3 vColor;
layout(location = 1) in float vFadingAlpha;
layout(location = 2) in float vLighting;

out vec4 outputColor;

void main()
{
    float light = 0.5 + 0.5 * vLighting;
    outputColor = vec4(vColor * light * vFadingAlpha, 1.0);
}