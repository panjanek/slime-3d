#version 430

in vec3 worldPos;

uniform vec3 cameraPos;
uniform float fieldSize;

out vec4 outputColor;

void main()
{
    vec3 groundColor = vec3(0.18,0.25,0.18);
    vec3 skyColor = vec3(0.15f, 0.25f, 0.35f);

    vec2 diff = worldPos.xz - cameraPos.xz;
    float dist = length(diff);

    float horizonFade = smoothstep(fieldSize * 1.2,
                                   fieldSize * 10.0,
                                   dist);

    vec3 color = mix(groundColor, skyColor, horizonFade);

    outputColor = vec4(color,horizonFade);
}