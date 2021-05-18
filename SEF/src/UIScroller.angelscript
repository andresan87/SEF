namespace sef {

class UIScroller
{
	private ::vector2 m_scroll;

	bool isPointInside(const ::vector2 &in p, const ::vector2 &in absoluteMin, const ::vector2 &in absoluteMax) const
	{
		return sef::math::isPointInRect(p, absoluteMin, absoluteMax - absoluteMin, ::vector2(0.0f));
	}

	::vector2 processScroll(const ::vector2 &in scroll)
	{
		::ETHInput@ input = ::GetInputHandle();
		float wheelScroll = input.GetWheelState();
		const float scrollSpeed = UnitsPerSecond(320.0f);
		if (sef::input::global.getUpState()   == ::KS_HIT) wheelScroll += scrollSpeed;
		if (sef::input::global.getDownState() == ::KS_HIT) wheelScroll -= scrollSpeed;
		return ::vector2(0.0f, scroll.y + (wheelScroll * (5.0f)));
	}

	void update(const ::vector2 &in absoluteMin, const ::vector2 &in absoluteMax)
	{
		computeScrolling(absoluteMin, absoluteMax);
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

	private void computeScrolling(const ::vector2 &in absoluteMin, const ::vector2 &in absoluteMax)
	{
		::ETHInput@ input = ::GetInputHandle();
		::vector2 scrollSum;
		for (uint t = 0; t < input.GetMaxTouchCount(); t++)
		{
			const ::KEY_STATE state = input.GetTouchState(t);
			if (state == ::KS_DOWN)
			{
				if (isPointInside(sef::input::global.getLastTouchHit(t), absoluteMin, absoluteMax))
				{
					scrollSum += input.GetTouchMove(t);
				}
			}
		}
		if (scrollSum == vector2(0.0f))
			m_scroll *= ::pow(0.9f, 60.0f / ::GetFPSRate());
		else
			m_scroll = scrollSum;

		m_scroll = processScroll(m_scroll);
	}

	void draw()
	{
	}
}

} // namespace sef
