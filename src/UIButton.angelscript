namespace sef {

class UIButton : UIDrawable
{
	private bool[] m_lastTouchInButton;
	private ::vector2[] m_lastDownPos;

	private bool m_pressed = false;
	private bool m_justHit = false;
	private bool m_beingHeld = false;
	private bool m_justReleased = false;

	private sef::WaypointManager@ m_buttonPressEffect;
	private float m_currentPressEffectScale;
	private sef::Color m_pressColor = sef::Color(0xFFAAAAAA);

	private uint m_holdTime = 0;

	private ::KEY_STATE m_forceState = ::KS_UP;

	private ::vector2 m_pressingRelativeAbsPosition;

	sef::Color cursorColorMultiplier;

	bool inactiveWhenInvisible = false;
	bool iterable = true;
	sef::UIButtonIterationListener@ iterationListener;
	bool capacitive = false;
	::string hitSoundEffect = "";
	::string releaseSoundEffect = "";
	::vector2 clickableAreaScale = ::vector2(1);
	::vector2 clickableAreaMinAdd = ::vector2(0.0f);
	::vector2 clickableAreaMaxAdd = ::vector2(0.0f);

	private void UIButtonConstructor()
	{
		@m_buttonPressEffect = null;
		m_currentPressEffectScale = 1.0f;
		cursorColorMultiplier = sef::Color(0xFFFFFFFF);

		const uint touchCount = ::GetInputHandle().GetMaxTouchCount();
		m_lastTouchInButton.resize(touchCount);
		m_lastDownPos.resize(touchCount);
		for (uint t = 0; t < touchCount; t++)
		{
			m_lastTouchInButton[t] = false;
			m_lastDownPos[t] = ::vector2(-1,-1);
		}
	}

	UIButton(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, origin, scale);
		UIButtonConstructor();
	}

	UIButton(
		const ::string &in elementName,
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(elementName, spriteName, normPos, origin, scale);
		UIButtonConstructor();
	}

	UIButton(
		const ::string &in elementName,
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(elementName, @drawable, normPos, @beginningAnimation, origin, scale);
		UIButtonConstructor();
	}

	UIButton(
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(@drawable, normPos, @beginningAnimation, origin, scale);
		UIButtonConstructor();
	}

	UIButton(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, @beginningAnimation, origin, scale);
		UIButtonConstructor();
	}


	UIButton(
		const ::string &in frameSprite,
		const ::vector2 &in frameSize,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f,
		const bool highQuality = true,
		const bool borderOutside = false)
	{
		sef::FrameDrawable frameDrawable(
			frameSprite,
			frameSize,
			borderOutside,
			highQuality);

		super(@frameDrawable, normPos, @beginningAnimation, origin, scale);
		UIButtonConstructor();
	}

	bool isPressed() const
	{
		return m_pressed;
	}

	bool isJustHit() const
	{
		return m_justHit;
	}

	bool isBeingHeld() const
	{
		return m_beingHeld;
	}

	::vector2 getPressingRelativeAbsPosition() const
	{
		return m_pressingRelativeAbsPosition;
	}

	::KEY_STATE getState() const
	{
		if (isJustHit())
			return ::KS_HIT;
		else if (isBeingHeld())
			return ::KS_DOWN;
		else if (m_justReleased)
			return ::KS_RELEASE;
		else
			return ::KS_UP;
	}

	void forceState(const ::KEY_STATE  ks)
	{
		m_forceState = ks;
	}

	void update() override
	{
		UIDrawable::update();

		m_pressed = false;
		m_justHit = false;
		m_beingHeld = false;
		m_justReleased = false;

		if (isDismissed() || (inactiveWhenInvisible && m_currentColor.a == 0.0f))
			return;

		applyPressingEffects();

		::ETHInput@ input = ::GetInputHandle();
		const uint touchCount = input.GetMaxTouchCount();

		for (uint t = 0; t < touchCount; t++)
		{
			const ::KEY_STATE state = sef::internal::holder.getState(t);

			// TO-DO refactor all of it... unify state manager
			if (state == ::KS_HIT || m_forceState == ::KS_HIT)
			{
				m_lastTouchInButton[t] = true;
				m_lastDownPos[t] = input.GetTouchPos(t);
				if (isPointInside(input.GetTouchPos(t)) || m_forceState == ::KS_HIT)
				{
					m_lastTouchInButton[t] = true;
					m_justHit = true;
					sef::internal::holder.cancelState(t);
				}
				else
				{
					m_lastTouchInButton[t] = false;
				}
			}
			else if (state == ::KS_RELEASE || m_forceState == ::KS_RELEASE)
			{		
				if ((isPointInside(m_lastDownPos[t]) && m_lastTouchInButton[t]) || m_forceState == ::KS_RELEASE)
				{
					m_pressingRelativeAbsPosition = m_lastDownPos[t] - (::GetScreenSize() * m_currentNormPos);
					m_pressed = true;
					m_justReleased = true;
				}
				if (m_lastTouchInButton[t])
				{
					@m_buttonPressEffect = sef::uieffects::createButtonReleaseEffect(m_currentPressEffectScale, m_currentColor);
				}
				m_lastTouchInButton[t] = false;
			}
			else if (state == ::KS_DOWN)
			{
				m_lastDownPos[t] = input.GetTouchPos(t);
				if (capacitive)
				{
					// do capacitive button checking (indirect tapping checking)
					if (isPointInside(m_lastDownPos[t]))
					{
						m_pressed = true;
						m_beingHeld = true;
					}
				}
				else
				{
					// if last touch was in but the touch position is way too far, cancel it
					if (m_lastTouchInButton[t])
					{
						m_beingHeld = true;
						if (processState(state, m_lastDownPos[t]) == ::KS_UP)
						{
							cancelTouch(t);
						}
					}
				}
			}

			if (m_lastTouchInButton[t])
				break;
		}

		m_forceState = ::KS_UP;

		// apply effects
		if (m_justReleased)
		{
			sef::util::playSample(releaseSoundEffect);
		}

		if (m_justHit)
		{
			sef::util::playSample(hitSoundEffect);
			@m_buttonPressEffect = sef::uieffects::createButtonPressEffect(m_currentPressEffectScale, m_currentColor, m_pressColor);
		}

		computeHoldTime();
	}

	void cancelTouch(const uint t)
	{
		@m_buttonPressEffect = sef::uieffects::createButtonReleaseEffect(m_currentPressEffectScale, m_currentColor);
		m_lastTouchInButton[t] = false;
		m_beingHeld = false;
	}

	void getMinMaxPoints(const bool includeClickableArea, vector2 &out minO, vector2 &out maxO, vector2 &out size)
	{
		size = (m_scale * m_drawable.getSize() * (includeClickableArea ? clickableAreaScale : vector2(1.0f)));
		const vector2 pos(GetScreenSize() * getNormPos());
		const vector2 posRelative = vector2(pos.x - (size.x * m_origin.x), pos.y - (size.y * m_origin.y));

		if (includeClickableArea)
		{
			minO = vector2(posRelative.x + clickableAreaMinAdd.x, posRelative.y + clickableAreaMinAdd.y);
			maxO = vector2(posRelative.x + size.x + clickableAreaMaxAdd.x, posRelative.y + size.y + clickableAreaMaxAdd.y);
		}
		else
		{
			minO = posRelative;
			maxO = posRelative + size;
		}
	}

	private ::KEY_STATE processState(
		const ::KEY_STATE state,
		const ::vector2 &in touchPos)
	{
		::KEY_STATE r = state;
		if (!isPointInside(touchPos, 128.0f))
		{
			r = ::KS_UP;
		}
		return r;
	}

	private void computeHoldTime()
	{
		if (isBeingHeld())
			m_holdTime += ::GetLastFrameElapsedTime();
		else
			m_holdTime = 0;
	}

	uint getHoldTime() const
	{
		return m_holdTime;
	}

	bool isPointInside(const ::vector2 &in p, const float tolerance = 0.0f) const
	{
		const ::vector2 pos(::GetScreenSize() * m_currentNormPos);
		const ::vector2 size(m_currentScale * m_drawable.getSize() * clickableAreaScale);
		const ::vector2 posRelative = ::vector2(pos.x - (size.x * m_origin.x), pos.y - (size.y * m_origin.y));
		if ((p.x < (posRelative.x + clickableAreaMinAdd.x - tolerance)) ||
			(p.x > (posRelative.x + size.x + clickableAreaMaxAdd.x + tolerance)) ||
			(p.y < (posRelative.y + clickableAreaMinAdd.y - tolerance)) ||
			(p.y > (posRelative.y + size.y + clickableAreaMaxAdd.y + tolerance)))
			return false;
		else
			return true;
	}

	bool isPointInsideDrawableArea(const ::vector2 &in p) const
	{
		const ::vector2 pos(::GetScreenSize() * m_currentNormPos);
		const ::vector2 size(m_currentScale * m_drawable.getSize());
		const ::vector2 posRelative = ::vector2(pos.x - (size.x * m_origin.x), pos.y - (size.y * m_origin.y));
		if ((p.x < (posRelative.x)) ||
			(p.x > (posRelative.x + size.x)) ||
			(p.y < (posRelative.y)) ||
			(p.y > (posRelative.y + size.y)))
			return false;
		else
			return true;
	}

	void setPressColor(sef::Color@ pressColor)
	{
		m_pressColor = pressColor;
	}

	private void applyPressingEffects()
	{
		if (m_buttonPressEffect !is null)
		{
			m_buttonPressEffect.update();
			sef::Waypoint p = m_buttonPressEffect.getCurrentPoint();
			m_currentPressEffectScale = p.scale;

			if (scaleOnlyAddings)
			{
				sef::FrameDrawable@ frameDrawable = cast<sef::FrameDrawable>(getDrawable());
				if (frameDrawable !is null)
				{
					frameDrawable.addingScale *= m_currentPressEffectScale;
				}
			}
			else
			{
				m_currentScale *= m_currentPressEffectScale;
			}

			m_currentColor = m_currentColor * p.color;
		}
	}
}

namespace internal {
class TouchStateHolder
{
	TouchStateHolder()
	{
		::ETHInput@ input = ::GetInputHandle();
		touchStates.resize(input.GetMaxTouchCount());
	}

	void update()
	{
		::ETHInput@ input = ::GetInputHandle();
		for (uint t = 0; t < touchStates.length(); t++)
		{
			touchStates[t] = input.GetTouchState(t);
		}
	}

	void cancelState(const uint t)
	{
		touchStates[t] = ::KS_UP;
	}

	::KEY_STATE getState(const uint t) const
	{
		return touchStates[t];
	}

	private ::KEY_STATE[] touchStates;
}

sef::internal::TouchStateHolder holder;

} // namespace internal

} // namespace sef
