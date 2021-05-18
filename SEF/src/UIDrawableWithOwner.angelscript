namespace sef {

class UIDrawableWithOwner : sef::UIDrawable
{
	sef::UIDrawable@ m_owner;

	UIDrawableWithOwner(
		sef::UIDrawable@ owner,
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(@drawable, normPos, @beginningAnimation, origin, scale);
		@m_owner = owner;
	}

	void update() override
	{
		UIDrawable::update();
		if (m_owner.isDismissed())
		{
			setName(getName() + "_dismissed");
			dismiss();
		}
	}
}

class UIButtonWithOwner : sef::UIButton
{
	sef::UIDrawable@ m_owner;

	UIButtonWithOwner(
		sef::UIDrawable@ owner,
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(@drawable, normPos, @beginningAnimation, origin, scale);
		@m_owner = owner;
	}

	void update() override
	{
		UIButton::update();
		if (m_owner.isDismissed())
		{
			setName(getName() + "_dismissed");
			dismiss();
		}
	}
}

class UIWorldSpaceButtonWithOwner : sef::UIWorldSpaceButton
{
	sef::UIDrawable@ m_owner;

	UIWorldSpaceButtonWithOwner(
		sef::UIDrawable@ owner,
		sef::Drawable@ drawable,
		const ::vector3 &in worldSpacePos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(@drawable, worldSpacePos, @beginningAnimation, origin, scale);
		@m_owner = owner;
	}

	void update() override
	{
		UIButton::update();
		if (m_owner.isDismissed())
		{
			setName(getName() + "_dismissed");
			dismiss();
		}
	}
}

} // namespace sef
