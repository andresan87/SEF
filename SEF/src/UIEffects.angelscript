namespace sef {
namespace uieffects {

void initUIPredefinedEffects()
{
}

sef::WaypointManager@ createFloatingEffect(const uint stride, const float scale, const float angle = 0.0f)
{
	const bool repeat = true;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	const ::vector2 dir(::multiply(::vector2(0, scale), ::rotateZ(::degreeToRadian(angle))));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride / 2, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(dir,             stride,     sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(dir * -1.0f,     stride / 2, sef::Color(0xFFFFFFFF), @sef::easing::smoothBeginning, 0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createFloatingEffect(const uint stride, const float scale, const uint repeats, const float angle)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	const ::vector2 dir(::multiply(::vector2(0, scale), ::rotateZ(::degreeToRadian(angle))));

	for (uint t = 0; t < repeats; t++)
	{
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride / 2, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
		r.addWaypoint(sef::Waypoint(dir,             stride,     sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, 1.0f));
		r.addWaypoint(sef::Waypoint(dir * -1.0f,     stride / 2, sef::Color(0xFFFFFFFF), @sef::easing::smoothBeginning, 0.0f, 1.0f));
	}

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), 0, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createBlinkingEffect(const uint stride, const sef::Color@ invisibleColor)
{
	const bool repeat = true;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBeginning, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, invisibleColor,         @sef::easing::smoothEnd,       0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createSingleBounceEffect(const uint stride, const float scaleB, const uint delay = 0)
{

	return sef::uieffects::createSingleBounceEffect(stride, 1.0f, scaleB, delay);
}

sef::WaypointManager@ createSingleBounceEffect(const uint stride, const float scaleA, const float scaleB, const uint delay)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, scaleA));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd,       0.0f, scaleA));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, scaleB));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),     50, sef::Color(0xFFFFFFFF), @sef::easing::linear,          0.0f, scaleA));
	return @r;
}

sef::WaypointManager@ createBounceEffect(const uint stride, const float scale, const uint delay = 0, const uint repeats = 1)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, scale));

	for (uint t = 1; t < repeats; t++)
	{
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, scale));
	}

	r.addWaypoint(sef::Waypoint(::vector2(0.0f),     50, sef::Color(0xFFFFFFFF), @sef::easing::linear,   0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createBounceAppearEffect(const uint stride, const float scale, const uint delay = 0, const uint repeats = 1)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0x00FFFFFF), @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0x00FFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, scale));

	for (uint t = 1; t < repeats; t++)
	{
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, scale));
	}

	r.addWaypoint(sef::Waypoint(::vector2(0.0f),     50, sef::Color(0xFFFFFFFF), @sef::easing::linear,   0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createTrembleEffect(
	const uint stride,
	const float scale,
	const uint repeats,
	const bool soft = false,
	const uint delay = 0)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd));

	for (uint t = 0; t < repeats; t++)
	{
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, 1.0f));

		const float currentScale = scale + ((scale - 1.0f) * (soft ? (1.0f / float(t + 1)) : 1.0f));
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides, 0.0f, currentScale));
	}
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), 50, sef::Color(0xFFFFFFFF), @sef::easing::linear, 0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createBumpingEffect(const uint stride, const float scale)
{
	const bool repeat = true;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), stride, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, scale));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),      0, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createZoomEffect(
	const float scaleDiff,
	sef::Color@ colorA,
	sef::Color@ colorB,
	const uint delay,
	const bool zoomIn,
	const bool fadeIn,
	const uint effectDuration = 400,
	const bool elastic = false,
	const float scale = 1.0f,
	const float angleA = 0.0f,
	const float angleB = 0.0f)
{
	float scaleA = 1.0f, scaleB = 1.0f;
	if (fadeIn && zoomIn)
	{
		scaleA -= scaleDiff;
	}
	else if (fadeIn && !zoomIn)
	{
		scaleA += scaleDiff;
	}
	else if (!fadeIn && zoomIn)
	{
		scaleB += scaleDiff;
	}
	else
	{
		scaleB -= scaleDiff;
	}

	scaleA *= scale;
	scaleB *= scale;

	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	sef::easing::FUNCTION@ easing;
	if (elastic)
		@easing = @sef::easing::elastic2;
	else
		@easing = @sef::easing::smoothBothSides;

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, colorA, @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), effectDuration, colorA, @easing,              angleA, scaleA));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),             12, colorB, @sef::easing::linear, angleB, scaleB));
	return @r;
}

sef::WaypointManager@ createColorBlendEffect(sef::Color@ colorA, sef::Color@ colorB, const uint effectDuration = 400)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), effectDuration, colorA, @sef::easing::smoothBothSides));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),             12, colorB, @sef::easing::linear));
	return @r;
}

sef::WaypointManager@ createSlideEffect(
	const ::vector2 &in direction,
	sef::Color@ colorA,
	sef::Color@ colorB,
	const uint delay,
	const bool slideIn,
	const uint effectDuration = 400,
	const bool elastic = false,
	const bool fullLengthDirectionVector = false,
	const float scaleA = 1.0f,
	const float scaleB = 1.0f)
{
	const ::vector2 normFullLengthVector(direction.x / ::GetScreenSize().x, direction.y / ::GetScreenSize().y);
	const ::vector2 slidePos(fullLengthDirectionVector ? normFullLengthVector : (direction * 0.15f));

	const ::vector2 posA( slideIn ? slidePos : ::vector2(0.0f));
	const ::vector2 posB(!slideIn ? slidePos : ::vector2(0.0f));

	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	sef::easing::FUNCTION@ easing;
	if (elastic)
		@easing = @sef::easing::elastic2;
	else
		@easing = @sef::easing::smoothBothSides;

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(posA, delay, colorA, @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(posA, effectDuration, colorA, @easing,              0.0f, scaleA));
	r.addWaypoint(sef::Waypoint(posB,             12, colorB, @sef::easing::linear, 0.0f, scaleB));
	return @r;
}

sef::WaypointManager@ createSlideFromEdgeEffect(
	const ::vector2 &in normPos,
	const uint delay = 0,
	const uint effectDuration = 700,
	const bool elastic = false)
{
	const ::vector2 startPos((::normalize(normPos - ::vector2(0.5f)) * 0.15f));

	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	sef::easing::FUNCTION@ easing;
	if (elastic)
		@easing = @sef::easing::elastic;
	else
		@easing = @sef::easing::smoothBothSides;

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(startPos, delay, sef::Color(0x00FFFFFF), @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(startPos,        effectDuration, sef::Color(0x00FFFFFF), @easing));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),             12, sef::Color(0xFFFFFFFF), @sef::easing::linear));
	return @r;
}

sef::WaypointManager@ createSlideOutEffect(const ::vector2 &in normPos, const uint delay = 0, const uint effectDuration = 300)
{
	const ::vector2 startPos((::normalize(normPos - ::vector2(0.5f)) * 0.10f));

	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd));

	r.addWaypoint(sef::Waypoint(::vector2(0.0f), effectDuration, sef::Color(0xFFFFFFFF), @sef::easing::smoothBothSides));
	r.addWaypoint(sef::Waypoint(startPos,                    12, sef::Color(0x00FFFFFF), @sef::easing::linear));
	return @r;
}

sef::WaypointManager@ createButtonPressEffect(const float currentScale, sef::Color currentColor, sef::Color@ pressColor)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), 100, sef::Color(1.0f, currentColor.getVector3()), @sef::easing::smoothBothSides, 0.0f, currentScale));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),  12, pressColor,               @sef::easing::linear, 0.0f, 0.95f));
	return @r;
}

sef::WaypointManager@ createButtonReleaseEffect(const float currentScale, sef::Color currentColor)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), 100, sef::Color(1.0f, currentColor.getVector3()), @sef::easing::smoothBothSides, 0.0f, currentScale));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),  12, sef::Color(0xFFFFFFFF),   @sef::easing::linear, 0.0f, 1.0f));
	return @r;
}

sef::WaypointManager@ createFadeOutEffect(const uint time, const float scaleA, const float scaleB, const uint finalColor)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);
	r.setPausable(false);
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), time, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd, 0.0f, scaleA));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),   12, sef::Color(finalColor), @sef::easing::smoothEnd, 0.0f, scaleB));
	return @r;
}

sef::WaypointManager@ createFadeOutEffect(const uint time, const uint delay = 0)
{
	const bool repeat = false;
	sef::WaypointManager r(repeat);

	if (delay > 0)
		r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd));

	r.setPausable(false);
	r.addWaypoint(sef::Waypoint(::vector2(0.0f), time, sef::Color(0xFFFFFFFF), @sef::easing::smoothEnd));
	r.addWaypoint(sef::Waypoint(::vector2(0.0f),   12, sef::Color(0x00FFFFFF), @sef::easing::smoothEnd));
	return @r;
}

} // namespace uieffects
} // namespace sef
