namespace sef {
namespace math {

const float PI2 = ::PI * 2.0f;

int abs(const int value)
{
	return (value < 0) ? -value : value;
}

float dot(const ::vector2 &in a, const ::vector2 &in b)
{
	return ((a.x * b.x) + (a.y * b.y));
}

float dot(const ::vector3 &in a, const ::vector3 &in b)
{
	return ((a.x * b.x) + (a.y * b.y) + (a.z * b.z));
}

float constrainAngle(float x)
{
	x = (x % 360.0f);
	if (x < 0.0f)
		x += 360.0f;
	return x;
}

float constrainAngleB(float x)
{
	x = ((x + 180.0f) % 360.0f);
	if (x < 0.0f)
		x += 360.0f;
	return x - 180.0f;
}

bool isPointInLine(const float p, const float pos, const float len, const float origin)
{	
	const float posRelative = pos - (len * origin);
	return !(p < posRelative || p > posRelative + len);
}

bool isPointInLine(const float p, const float minimum, const float maximum)
{	
	return !(p < minimum || p > maximum);
}

bool isPointInRect(const ::vector2 &in p, const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin)
{	
	const ::vector2 posRelative = ::vector2(pos.x - (size.x * origin.x), pos.y - (size.y * origin.y));
	return !(p.x < posRelative.x || p.x > posRelative.x + size.x || p.y < posRelative.y || p.y > posRelative.y + size.y);
}

bool isPointInArea(const ::vector2 &in p, const ::vector2 &in areaMin, const ::vector2 &in areaMax)
{	
	return !(p.x < areaMin.x || p.x > areaMax.x || p.y < areaMin.y || p.y > areaMax.y);
}

bool isOverlapping(const ::vector2 &in minA, const ::vector2 &in maxA, const ::vector2 &in minB, const ::vector2 &in maxB)
{
	return 
	!(minA.x > maxB.x || maxA.x < minB.x ||
	  minA.y > maxB.y || maxA.y < minB.y);
}

bool areRectsOverlapping(const ::vector2 &in posA, const ::vector2 &in sizeA, const ::vector2 &in posB, const ::vector2 &in sizeB)
{
	const vector2 halfSizeA(sizeA * 0.5f);
	const vector2 halfSizeB(sizeB * 0.5f);
	const vector2 minA(posA - halfSizeA);
	const vector2 maxA(posA + halfSizeA);
	const vector2 minB(posB - halfSizeB);
	const vector2 maxB(posB + halfSizeB);
	return isOverlapping(minA, maxA, minB, maxB);
}

bool isPointInRect(const ::vector2 &in p, const ::vector2 &in pos, const ::vector2 &in size)
{
	return sef::math::isPointInRect(p, pos, size, ::vector2(0));
}

bool isPointInScreen(const ::vector2 &in p)
{
	return (sef::math::isPointInRect(p, ::vector2(0), ::GetScreenSize()));
}

bool isWorldSpacePointInScreen(const ::vector2 &in p)
{
	return (sef::math::isPointInScreen(p - ::GetCameraPos()));
}

bool isPointInScreenWithTolerance(const ::vector2 &in p, const float tolerancePx)
{
	return (sef::math::isPointInScreenWithTolerance(p, ::vector2(tolerancePx, tolerancePx)));
}

bool isPointInScreenWithTolerance(const ::vector2 &in p, const ::vector2 &in tolerancePx)
{
	return (sef::math::isPointInRect(
		p,
		::vector2(-tolerancePx.x, -tolerancePx.y),
		::GetScreenSize() + (::vector2(tolerancePx.x, tolerancePx.y) * 2.0f)));
}

bool isWorldSpacePointInScreenWithTolerance(const ::vector2 &in p, const float tolerancePx)
{
	return (sef::math::isWorldSpacePointInScreenWithTolerance(p, ::vector2(tolerancePx, tolerancePx)));
}

bool isWorldSpacePointInScreenWithTolerance(const ::vector2 &in p, const ::vector2 &in tolerancePx)
{
	return (sef::math::isPointInScreenWithTolerance(p - ::GetCameraPos(), tolerancePx));
}

bool isPointInCircle(const ::vector2 &in p, const ::vector2 &in pos, const float radius)
{
	return (sef::math::squaredDistance(p, pos) < radius * radius);
}

::vector2 reflect(const ::vector2 &in dir, const ::vector2 &in normal)
{
	return (dir - normal * 2.0f * (sef::math::dot(normal, dir)));
}

float distance(const float a, const float b)
{
	return ::abs(a - b);
}

float squaredDistance(const ::vector2 &in a, const ::vector2 &in b)
{
	const ::vector2 diff = a - b;
	return sef::math::dot(diff, diff);
}

float squaredDistance(const ::vector3 &in a, const ::vector3 &in b)
{
	const ::vector3 diff = a - b;
	return sef::math::dot(diff, diff);
}

int clamp(const int val, const int minVal, const int maxVal)
{
	return (val < minVal) ? minVal : ((val > maxVal) ? maxVal : val);
}

float clamp(const float val, const float minVal, const float maxVal)
{
	return (val < minVal) ? minVal : ((val > maxVal) ? maxVal : val);
}

::vector2 clamp(const ::vector2 &in val, const ::vector2 &in minVal, const ::vector2 &in maxVal)
{
	return ::vector2(sef::math::clamp(val.x, minVal.x, maxVal.x), clamp(val.y, minVal.y, maxVal.y));
}

::vector3 clamp(const ::vector3 &in val, const ::vector3 &in minVal, const ::vector3 &in maxVal)
{
	return ::vector3(
		sef::math::clamp(val.x, minVal.x, maxVal.x),
		sef::math::clamp(val.y, minVal.y, maxVal.y),
		sef::math::clamp(val.z, minVal.z, maxVal.z));
}

float smoothSlide(const float currentValue, const float destination, const float slideSpeedFactor = 0.88f)
{
	const float diff = destination - currentValue;
	return currentValue + (diff * (1.0f - ::pow(slideSpeedFactor, 60.0f / ::GetFPSRate())));
}

int minI(const int a, const int b)
{
	return (a < b) ? a : b;
}

int maxI(const int a, const int b)
{
	return (a > b) ? a : b;
}

::vector2 min(const ::vector2 &in a, const ::vector2 &in b)
{
	return ::vector2(::min(a.x, b.x), ::min(a.y, b.y));
}

::vector3 min(const ::vector3 &in a, const ::vector3 &in b)
{
	return ::vector3(::min(a.x, b.x), ::min(a.y, b.y), ::min(a.z, b.z));
}

::vector2 max(const ::vector2 &in a, const ::vector2 &in b)
{
	return ::vector2(::max(a.x, b.x), ::max(a.y, b.y));
}

::vector3 max(const ::vector3 &in a, const ::vector3 &in b)
{
	return ::vector3(::max(a.x, b.x), ::max(a.y, b.y), ::max(a.z, b.z));
}

uint multiplyCeil(const uint v, const float f)
{
	return uint(ceil(float(v) * f));
}

int multiplyCeil(const int v, const float f)
{
	return int(ceil(float(v) * f));
}

uint multiplyFloor(const uint v, const float f)
{
	return uint(floor(float(v) * f));
}

int multiplyFloor(const int v, const float f)
{
	return int(floor(float(v) * f));
}

::vector2 rotate(const ::vector2 &in p, const float angleRad)
{
	return ::vector2(
		p.x * ::cos(angleRad) - p.y * ::sin(angleRad),
		p.x * ::sin(angleRad) + p.y * ::cos(angleRad));
}

float computeReversePercentageFromBias(const float bias)
{
	return sef::math::round((100.0f * bias) - 100.0f);
}

float computePercentageFromBias(const float bias)
{
	return sef::math::round(100.0f * bias);
}

void scaleToSize(::ETHEntity@ entity, const ::vector2 &in size)
{
	const ::vector2 currentSize(entity.GetSize());
	entity.Scale(::vector2(size.x / currentSize.x, size.y / currentSize.y));
}

bool equals(const float a, const float b, const float epsilon)
{
	return (::abs(a - b) < epsilon);
}

bool equals(const vector2 &in a, const vector2 &in b, const float epsilon)
{
	return equals(a.x, b.x, epsilon) && equals(a.y, b.y, epsilon);
}

void scaleToMatchHeight(::ETHEntity@ entity, const float height)
{
	const ::vector2 currentSize(entity.GetSize());
	const float factor = height / currentSize.y;
	entity.Scale(::vector2(factor));
}

void stretchToMatchHeight(::ETHEntity@ entity, const float height)
{
	const ::vector2 currentSize(entity.GetSize());
	const float factor = height / currentSize.y;
	entity.Scale(::vector2(1.0f, factor));
}

void stretchToMatchWidth(::ETHEntity@ entity, const float width)
{
	const ::vector2 currentSize(entity.GetSize());
	const float factor = width / currentSize.x;
	entity.Scale(::vector2(factor, 1.0f));
}

float round(const float v)
{
	const float floor = ::floor(v);
	const float diff = v - floor;
	if (diff < 0.25f)
		return floor;
	else if (diff > 0.75f)
		return ::ceil(v);
	else
		return floor + 0.5f;
}

::vector2 normalizePosition(const ::vector2 &in pos)
{
	const ::vector2 screenSize(::GetScreenSize());
	return ::vector2(pos.x / screenSize.x, pos.y / screenSize.y);
}

float normalizeWidth(const float x)
{
	return x / GetScreenSize().x;
}

float normalizeHeight(const float y)
{
	return y / GetScreenSize().y;
}

::vector2 normalizeCoordinate(const ::vector2 &in pos)
{
	return sef::math::normalizePosition(pos);
}

::vector2 normalizeCoordinate(const float x, const float y)
{
	return sef::math::normalizePosition(::vector2(x, y));
}

::vector2 computeParallaxOffset(const ::vector3 &in pos)
{
	const ::vector2 parallaxOrigin(::GetParallaxOrigin());
	const ::vector2 screenSize(::GetScreenSize());

	if (GetSharedData("com.ethanonengine.usingSuperSimple") == "true")
	{
		return ((::vector2(pos.x, pos.y) - (parallaxOrigin * screenSize)) / screenSize.y) * pos.z * ::GetParallaxIntensity() * 0.55f;
	}
	else
	{
		return ((::vector2(pos.x, pos.y) - (parallaxOrigin * screenSize)) / screenSize.x) * pos.z * ::GetParallaxIntensity();
	}
}

::vector2 computeWorldSpaceParallaxOffset(const ::vector3 &in worldSpacePos)
{
	const vector2 cameraPos(GetCameraPos());
	const vector3 screenSpacePos(worldSpacePos.x - cameraPos.x, worldSpacePos.y - cameraPos.y, worldSpacePos.z);
	const vector2 screenSize(GetScreenSize());
	const vector2 halfScreenSize(screenSize * GetParallaxOrigin());
	return ((vector2(screenSpacePos.x, screenSpacePos.y) - halfScreenSize) / screenSize.y) * GetParallaxIntensity() * worldSpacePos.z;
}

::vector2 applyParallax(const ::vector3 &in pos)
{
	return ::vector2(pos.x, pos.y) + sef::math::computeParallaxOffset(pos);
}

float randValueWithRange(const float value, const float range)
{
	const float halfRange = range * 0.5f;
	return randF(value - halfRange, value + halfRange);
}

uint count(const int[]@ numbers, const int value)
{
	uint r = 0;
	for (uint t = 0; t < numbers.length(); t++)
	{
		if (numbers[t] == value)
			++r;
	}
	return r;
}

int[]@ distribute(const uint count, const int minValue, const int maxValue)
{
	int[] r;
	const float diff = (maxValue + 1) - minValue;
	const float step = diff / float(count);
	float rail = minValue;
	for (uint  t = 0; t < count; t++)
	{
		r.insertLast(int(::floor(rail)));
		rail += step;
	}
	return @r;
}

int[]@ generateUniqueRandomValues(const uint count, const int minValue, const int maxValue)
{
	int[] r;
	int newValue;
	while (r.length() < count)
	{
		if (r.find((newValue = sef::math::random(minValue, maxValue))) < 0)
			r.insertLast(newValue);
	}
	return @r;
}

uint random(uint minValue, uint maxValue)
{
	minValue = ::min(minValue, maxValue);
	maxValue = ::max(minValue, maxValue);

	uint[] values(maxValue - minValue + 1);

	if (values.length() == 0)
		return 0;

	for (uint t = 0; t < values.length(); t++)
	{
		values[t] = ::rand(minValue, maxValue);
	}
	return values[::rand(0, values.length() - 1)];
}

// only works with full IEEE compliance
bool isNaN(const float &in f)
{
	return (f != f);
}

void warnNaN(const float &in f, const ::string &in context)
{
	if (sef::math::isNaN(f))
	{
		sef::io::ErrorMessage(context, "NaN detected!");
	}
}

bool isVersionGreaterOrEqual(const ::string &in a, const ::string &in b, bool &out success)
{
	success = false;
	const ::string[] piecesA = sef::string::split(a, ".");
	const ::string[] piecesB = sef::string::split(b, ".");
	const uint minPieceCount = ::min(piecesA.length(), piecesB.length());

	for (uint i = 0; i < minPieceCount; i++)
	{
		if (!sef::string::isValidNumber(piecesA[i]) || !sef::string::isValidNumber(piecesB[i]))
		{
			return false;
		}

		const int nA = parseUInt(piecesA[i]);
		const int nB = parseUInt(piecesB[i]); 
		if (nA > nB)
		{
			success = true;
			return true;
		}
		else if (nA < nB)
		{
			success = true;
			return false;
		}
	}
	success = true;
	return true;
}

sef::Color desaturate(const sef::Color@ color, const float saturationBias)
{
	const float average = (color.r + color.g + color.b) / 3.0f;
	return sef::interpolator::interpolate(sef::Color(color.a, average, average, average), @color, saturationBias);
}

} // namespace math
} // namespace sef
