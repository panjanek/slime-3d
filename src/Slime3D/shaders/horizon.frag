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
                                   fieldSize * 5.0,
                                   dist);
    
    // ----- GRID -----
    float gridScale = 30.0;
    vec2 grid = fract(worldPos.xz / gridScale);
    float gridSize = 0.03;
    float lineX = step(grid.x, gridSize) + step(1.0 - grid.x, gridSize);
    float lineZ = step(grid.y, gridSize) + step(1.0 - grid.y, gridSize);
    float line = clamp(lineX + lineZ, 0.0, 1.0);


    groundColor = mix(groundColor, vec3(0.05,0.1,0.05), line);
    
    vec3 color = mix(groundColor, skyColor, horizonFade);

    outputColor = vec4(color,1.0);
}