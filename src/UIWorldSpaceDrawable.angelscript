namespace sef {

class UISworldSpaceDrawable : sef::UIDrawable
{
	::vector3 m_worldSpacePos;

	UISworldSpaceDrawable(
		const ::string &in spriteName,
		const ::vector3 &in worldSpacePos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_worldSpacePos = worldSpacePos;
		super(spriteName, computeButtonNormPos(), origin, scale);
	}

	UISworldSpaceDrawable(
		const ::string &in elementName,
		const ::string &in spriteName,
		const ::vector3 &in worldSpacePos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_worldSpacePos = worldSpacePos;
		super(elementName, spriteName, computeButtonNormPos(), origin, scale);
	}

	UISworldSpaceDrawable(
		const ::string &in spriteName,
		const ::vector3 &in worldSpacePos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_worldSpacePos = worldSpacePos;
		super(spriteName, computeButtonNormPos(), @beginningAnimation, origin, scale);
	}

	UISworldSpaceDrawable(
		const ::string &in elementName,
		sef::Drawable@ drawable,
		const ::vector3 &in worldSpacePos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_worldSpacePos = worldSpacePos;
		super(elementName, @drawable, computeButtonNormPos(), @beginningAnimation, origin, scale);
	}

	UISworldSpaceDrawable(
		sef::Drawable@ drawable,
		const ::vector3 &in worldSpacePos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_worldSpacePos = worldSpacePos;
		super(@drawable, computeButtonNormPos(), @beginningAnimation, origin, scale);
	}

	::vector2 computeButtonNormPos() const
	{
		return sef::math::normalizePosition(sef::math::applyParallax(m_worldSpacePos - ::vector3(::GetCameraPos(), 0.0f)));
	}

	void update() override
	{
		UIDrawable::update();
	}

	void draw() override
	{
		setNormPos(computeButtonNormPos());
		updateCurrentPos(getCurrentWaypoint());
		UIDrawable::draw();
	}
}

} // namespace sef
