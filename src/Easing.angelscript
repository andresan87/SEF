namespace sef {
namespace easing {

funcdef float FUNCTION(const float v);

float linear(const float v) { return v; }

float smoothEnd(const float v)      { return ::sin(v * (::PIb)); }

float smoothBeginning(const float v) { return (1.0f - sef::easing::smoothEnd(1.0f - v)); }

float smoothBothSides(const float v) { return sef::easing::smoothBeginning(sef::easing::smoothEnd(v)); }

float upAndDown(const float v) { return ::sin(v * ::PI); }

float elastic(const float n)
{
	if (n == 0.0f || n == 1.0f)
	{
		return n;
	}
	double p = 0.3f, s = p / 4.0f;
	return ::pow(2.0f, -10.0f * n) * ::sin((n - s) * (2 * ::PI) / p) + 1;
}

float elastic1(const float n)
{
	double t = double(n);
	double ts = t * t;
	double tc = t * ts;
	return float(33 * tc * ts + -106 * ts * ts + 126 * tc + -67 * ts + 15 * t);
}

float elastic2(const float n)
{
	double t = double(n);
	double ts = t * t;
	double tc = ts * t;
	return float((-15*tc*ts + 45*ts*ts + -41*tc + 6*ts + 6*t));
}

float elasticOut(const float n)
{
	return (sef::easing::elastic(sef::easing::smoothEnd(n)));
}

} // namespace easing
} // namespace sef
