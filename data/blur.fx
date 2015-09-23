const float4 gauss[8];
const int size;
const float lod;

texture blur_tex;
sampler tex = sampler_state {
	Texture = (blur_tex);
	MipFilter = POINT;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	AddressU = CLAMP;
	AddressV = CLAMP;
	sRGBTexture = FALSE;
};

struct VS_OUTPUT {
	float4 pos  : POSITION;
	float2 tex  : TEXCOORD0;
};

VS_OUTPUT vertex(float4 pos : POSITION, float2 tex : TEXCOORD0)
{
	VS_OUTPUT o;
	o.pos = pos;
	o.tex = tex;
	return o;
}

float4 pixel(VS_OUTPUT In) : COLOR
{
	float4 c = tex2D(tex, In.tex) * gauss[0].z;
	for (int i = 1; i < size; i++) {
		c += tex2Dlod(tex, float4(In.tex + gauss[i].xy, 0.0, lod)) * gauss[i].z;
		c += tex2Dlod(tex, float4(In.tex - gauss[i].xy, 0.0, lod)) * gauss[i].z;
	}
	return c;
}

technique blur {
	pass P0 {
		VertexShader = compile vs_3_0 vertex();
		PixelShader  = compile ps_3_0 pixel();
	}
}
