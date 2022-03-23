namespace sef {

class UIScroller
{
	private ::vector2 m_scroll;
	private float m_lastWheelScroll = 0.0f;
	private bool m_grabbing = false;
	private float m_elapsedTime = 0.0f;
	private float m_startingScrollLockTime = 100.0f; 

	bool horizontalScroll = false;
	bool enableDpadScroll = true;

	bool isPointInside(const ::vector2 &in p, const ::vector2 &in absoluteMin, const ::vector2 &in absoluteMax) const
	{
		return sef::math::isPointInRect(p, absoluteMin, absoluteMax - absoluteMin, ::vector2(0.0f));
	}

	::vector2 processScroll(::vector2 scroll)
	{
		::ETHInput@ input = ::GetInputHandle();
		m_lastWheelScroll = input.GetWheelState() * 5.0f;
		const float scrollSpeed = UnitsPerSecond(320.0f) * 5.0f;

		if (horizontalScroll)
		{
			scroll.x += m_lastWheelScroll;
			if (enableDpadScroll && sef::input::global.getPriorState() == ::KS_HIT) scroll.x += scrollSpeed;
			if (enableDpadScroll && sef::input::global.getNextState()  == ::KS_HIT) scroll.x -= scrollSpeed;
		}
		else
		{
			scroll.y += m_lastWheelScroll;
			if (enableDpadScroll && sef::input::global.getUpState()    == ::KS_HIT) scroll.y += scrollSpeed;
			if (enableDpadScroll && sef::input::global.getDownState()  == ::KS_HIT) scroll.y -= scrollSpeed;
		}

		return scroll;
	}

	void update(const ::vector2 &in absoluteMin, const ::vector2 &in absoluteMax)
	{
		m_elapsedTime += GetLastFrameElapsedTimeF();

		m_grabbing = false;
		::ETHInput@ input = ::GetInputHandle();
		::vector2 scrollSum;
		for (uint t = 0; t < input.GetMaxTouchCount(); t++)
		{
			const ::KEY_STATE state = input.GetTouchState(t);
			if (state == ::KS_DOWN)
			{
				if (isPointInside(sef::input::global.getLastTouchHit(t), absoluteMin, absoluteMax))
				{
					m_grabbing = true;
					scrollSum += input.GetTouchMove(t);
				}
			}
		}

		if (scrollSum == vector2(0.0f))
			m_scroll *= ::pow(0.9f, 60.0f / ::GetFPSRate());
		else
			m_scroll = scrollSum;

		if (m_elapsedTime > m_startingScrollLockTime)
		{
			m_scroll = processScroll(m_scroll);
		}
	}

	bool isGrabbing() const
	{
		return m_grabbing;
	}

	float getLastWhellScroll() const
	{
		return m_lastWheelScroll;
	}

	::vector2 addToScroll(const ::vector2 &in scroll)
	{
		m_scroll += scroll;
		return m_scroll;
	}

	void setScroll(const ::vector2 &in scroll)
	{
		m_scroll = scroll;
	}

	::vector2 getScroll() const
	{
		return m_scroll;
	}

	::vector2 clampAbsoluteOffsetY(
		::vector2 absoluteOffset,
		const float absoluteMinScrollY,
		const float absoluteMaxScrollY)
	{
		if (absoluteOffset.y < absoluteMinScrollY)
			absoluteOffset.y = sef::math::smoothSlide(absoluteOffset.y, absoluteMinScrollY);
		if (absoluteOffset.y > absoluteMaxScrollY)
			absoluteOffset.y = sef::math::smoothSlide(absoluteOffset.y, absoluteMaxScrollY);
		return absoluteOffset;
	}

	::vector2 clampAbsoluteOffsetX(
		::vector2 absoluteOffset,
		const float absoluteMinScrollX,
		const float absoluteMaxScrollX)
	{
		if (absoluteOffset.x < absoluteMinScrollX)
			absoluteOffset.x = sef::math::smoothSlide(absoluteOffset.x, absoluteMinScrollX);
		if (absoluteOffset.x > absoluteMaxScrollX)
			absoluteOffset.x = sef::math::smoothSlide(absoluteOffset.x, absoluteMaxScrollX);
		return absoluteOffset;
	}

	void draw()
	{
	}
}

class UIScrollOffset
{
	private ::vector2 m_absoluteOffset;

	void setAbsoluteOffset(const ::vector2 &in absoluteOffset)
	{
		m_absoluteOffset = absoluteOffset;
	}

	::vector2 getAbsoluteOffset() const
	{
		return m_absoluteOffset;
	}
}

} // namespace sef
