#version 320 es
precision highp float;

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	
	vec2 resolution;
	vec4 trailColor;
	vec2 stepPx;
	float decay;
	vec2 textSize;
	vec2 padding;
} ubuf;

layout(binding = 1) uniform sampler2D source;

void main() {
	// Adjust texture coordinates to account for expanded canvas
	vec2 uv = (qt_TexCoord0 * ubuf.resolution - ubuf.padding) / ubuf.textSize;
	
	vec2 pixelStep = ubuf.stepPx / ubuf.textSize;
	
	vec4 result = vec4(0.0);

	for (int i = 1; i < 4; i++) {
		vec2 offset = pixelStep * float(i);
		vec2 samplePos = uv + offset;

		vec4 s = texture(source, samplePos);
		float opacity = pow(ubuf.decay, float(i));

		result += s * opacity * ubuf.trailColor;
	}

	// add the base/main clock timestamp to result
	vec4 baseText = texture(source, uv);
	result += baseText;

	fragColor = result * ubuf.qt_Opacity;
}
