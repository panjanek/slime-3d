#version 430

layout(location = 0) in vec3 vColor;
layout(location = 1) in float vFadingAlpha;

out vec4 outputColor;

void main()
{
    float alpha = vFadingAlpha;
    outputColor = vec4(vColor * alpha, alpha);
}