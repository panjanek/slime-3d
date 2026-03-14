#version 430

layout(location = 0) in vec3 vColor;
layout(location = 1) in float vFadingAlpha;
layout(location = 2) in float vLighting;

out vec4 outputColor;

float amplify(float x, int pow)
{
    float a = 1;
    for(int i=0; i<pow; i++)
        a = a * (1-x);

    return 1-a;
}

void main()
{
    float light = 0.5 + 0.5 * vLighting;
    vec4 c = vec4(vColor * light * vFadingAlpha, 1.0);
    c.r = amplify(c.r, 2);
    c.g = amplify(c.g, 2);
    c.b = amplify(c.b, 2);
    outputColor = c;
}