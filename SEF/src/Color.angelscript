namespace sef {

const ::string WHITE_COLOR_CODE = ::AssembleColorCode(0xFFFFFFFF);

class Color
{
	Color()
	{
		 a = r = g = b = 1.0f;
	}

	Color(const float r, const float g, const float b)
	{
		this.a = 1.0f;
		this.r = r;
		this.g = g;
		this.b = b;
	}

	Color(const sef::Color &in color)
	{
		this.a = color.a;
		this.r = color.r;
		this.g = color.g;
		this.b = color.b;
	}

	Color(const float a, const float r, const float g, const float b)
	{
		this.a = a;
		this.r = r;
		this.g = g;
		this.b = b;
	}

	Color(const ::vector3 &in color)
	{
		a = 1.0f;
		r = color.x;
		g = color.y;
		b = color.z;
	}

	Color(const float _a, const ::vector3 &in color)
	{
		a = _a;
		r = color.x;
		g = color.y;
		b = color.z;
	}

	Color(uint color)
	{
		uint _a, _r, _g, _b;
		_a = (0xFF000000 & color) >> 24;
		_r = (0x00FF0000 & color) >> 16;
		_g = (0x0000FF00 & color) >> 8;
		_b = (0x000000FF & color);
		a = float(_a) / 255.0f;
		r = float(_r) / 255.0f;
		g = float(_g) / 255.0f;
		b = float(_b) / 255.0f;
	}

	Color(const float _a, uint color)
	{
		uint _r, _g, _b;
		_r = (0x00FF0000 & color) >> 16;
		_g = (0x0000FF00 & color) >> 8;
		_b = (0x000000FF & color);
		a = _a;
		r = float(_r) / 255.0f;
		g = float(_g) / 255.0f;
		b = float(_b) / 255.0f;
	}

	void setColor(const ::vector3 &in color)
	{
		r = color.x;
		g = color.y;
		b = color.z;
	}

	::vector3 getVector3() const
	{
		return ::vector3(r, g, b);
	}

	float getAlpha() const
	{
		return a;
	}

	uint getUInt() const
	{
		return ::ARGB(uint(a * 255.0f), uint(r * 255.0f), uint(g * 255.0f), uint(b * 255.0f));
	}

	sef::Color opMul(sef::Color color) const
	{
		return sef::Color(color.a * a, ::vector3(color.r * r, color.g * g, color.b * b));
	}

	sef::Color opMul(const float value) const
	{
		return sef::Color(value * a, ::vector3(value * r, value * g, value * b));
	}

	float a;
	float r;
	float g;
	float b;
}

} // namespace sef

string AssembleColorCode(const sef::Color@ color)
{
	return AssembleColorCode(color.getUInt());
}
