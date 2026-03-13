#version 430

struct Particle
{
   vec4 position;
   vec4 velocity;
   int species;
   int flags;
   int  cellIndex;
   float xzAngle;
   float yAngle;
   int _pad0;
   int _pad1;
   int _pad2;
   vec4 direction;
};

layout(std430, binding = 2) buffer OutputBuffer {
    Particle points[];
};

uniform mat4 view;
uniform mat4 projection;
uniform float paricleSize;
uniform float fogDensity;
uniform vec4 torusOffset;

layout(location = 0) out vec3 vColor;
layout(location = 1) out float vFadingAlpha;
layout(location = 2) out float vLighting;

vec3 tetraVerts[4] = vec3[](
    vec3(0.0, 0.0, 3.0),     // tip
    vec3(-1.0, -1.0, -1.0),
    vec3( 1.0, -1.0, -1.0),
    vec3( 0.0,  1.0, -1.0)
);

int indices[12] = int[](
    0,1,2,
    0,2,3,
    0,3,1,
    1,3,2
);

void main()
{
    vec3 lightDir = vec3(1,1,-1);
    uint particleID = gl_InstanceID;
    Particle p = points[particleID];

    vec3 pos = p.position.xyz + torusOffset.xyz;
    vec3 dir = normalize(p.direction.xyz);

    vec3 helper = abs(dir.y) > 0.99 ? vec3(1,0,0) : vec3(0,1,0);
    vec3 right = normalize(cross(helper, dir));
    vec3 up = cross(dir, right);

    mat3 rot = mat3(right, up, dir);

    int tri = gl_VertexID / 3;
    int triVertex = gl_VertexID % 3;

    int i0 = indices[tri*3 + 0];
    int i1 = indices[tri*3 + 1];
    int i2 = indices[tri*3 + 2];

    vec3 v0 = rot * tetraVerts[i0] * paricleSize;
    vec3 v1 = rot * tetraVerts[i1] * paricleSize;
    vec3 v2 = rot * tetraVerts[i2] * paricleSize;

    vec3 normal = normalize(cross(v1 - v0, v2 - v0));

    float lighting = max(dot(normal, normalize(lightDir)), 0.0);

    vec3 local;
    if(triVertex == 0) local = v0;
    if(triVertex == 1) local = v1;
    if(triVertex == 2) local = v2;

    vec3 worldPos = pos + local;

    vec4 viewPos = view * vec4(worldPos,1.0);
    gl_Position = projection * viewPos;

    float distance = max(-viewPos.z, 0.001);

    const vec3 colors[] = vec3[](
        vec3(0.0, 1.0, 0.0), // green
        vec3(0.0, 0.0, 1.0), // blue
        vec3(1.0, 0.2, 0.2), // red
        vec3(1.0, 0.2, 1.0), // magenta
        vec3(1.0, 1.0, 0.2), // yellow     
        vec3(0.2, 1.0, 1.0), // cyan
        vec3(1.0, 1.0, 1.0), // white
        vec3(0.5, 0.5, 0.5)  // gray
    );

    vColor = colors[tri % 8];
    vFadingAlpha = exp(-fogDensity * distance);
    
    //float viewTerm = clamp(dot(normalize(-viewPos.xyz), normal),0,1);
    //lighting *= 0.7 + 0.3 * viewTerm; //optional
    vLighting = lighting;
}