#version 320 es
precision highp float;

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    // Qt provides this (and expects it to exist in the uniform buffer)
    mat4 qt_Matrix;
    float qt_Opacity;

    // Your custom uniforms (names match QML properties)
    vec4 leftColor;
    vec4 rightColor;
    vec2 resolution;
} ubuf;

// noise
const float grainAmount = 9.7;
const float grainSize = 1.25;
const float grainRoughness = 1.0;

// gradient
const vec2 centerOfCircle = vec2(650.0, -300.0);
const float radius = 1500.0;
const float midPoint = 1.1;

float hash(vec2 p) {
	return (fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123) - 0.5) * 2.0;
}

void main() {
    // Horizontal gradient (left -> right)
	vec2 pixel = qt_TexCoord0 * ubuf.resolution;
	vec2 p = floor(pixel / grainSize);

	float nFine = hash(p) * 0.6 + hash(p * 2.0) * 0.3 + hash(p * 4.0) * 0.1 - 0.5;

	float nCoarse = hash(floor(p / 3.0)) - 0.5;
	float grain = nFine * (1.0 + grainRoughness * 1.5 *nCoarse);

	float d = length(p - centerOfCircle);
	float t = clamp(d / radius, 0.0, 1.0);
	t = pow(t, midPoint);
	vec4 gradient = mix(ubuf.leftColor, ubuf.rightColor, t) * ubuf.qt_Opacity;

	float lum = dot(gradient.xyz, vec3(0.299, 0.587, 0.114));
	float midtone = smoothstep(0.15, 0.85, lum) * (1.0 - smoothstep(0.85, 1.0, lum));

	float strength = grainAmount * mix(0.004, 0.02, midtone);

	vec3 rgb = gradient.xyz * (1.0 + grain * strength);

	vec4 finalColor = vec4(clamp(rgb, 0.0, 1.0), gradient.z);

	fragColor = finalColor;
}

