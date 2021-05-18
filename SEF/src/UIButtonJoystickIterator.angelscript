namespace sef {

class UIButtonJoystickIterator : sef::UIButtonDpadIterator
{
	private uint m_index;

	UIButtonJoystickIterator(
		sef::UILayer@ layer,
		const ::string &in first,
		const uint index)
	{
		super(@layer, first);
		m_index = index;
		m_elementName = "joystickControlledCursor" + index;
	}

	::KEY_STATE getEnterState() override
	{
		::ETHInput@ input = ::GetInputHandle();
		if (input.GetJoystickStatus(m_index) == JS_DETECTED)
		{
			return input.JoyButtonState(m_index, ::JK_03);
		}
		else
		{
			return ::KS_UP;
		}
	}

 	::KEY_STATE getBackRequestState() const override
	{
		::ETHInput@ input = ::GetInputHandle();
		return input.JoyButtonState(m_index, ::JK_02);
	}

	::vector2 findMoveDirection() const override
	{
		::vector2 r(0.0f);

		::ETHInput@ input = ::GetInputHandle();
		if (input.GetJoystickStatus(m_index) != JS_DETECTED)
			return r;

		if (input.JoyButtonState(m_index, ::JK_RIGHT) == ::KS_HIT)
			r = (::vector2(1,0));
		if (input.JoyButtonState(m_index, ::JK_LEFT) == ::KS_HIT)
			r = (::vector2(-1,0));
		if (input.JoyButtonState(m_index, ::JK_UP) == ::KS_HIT)
			r = (::vector2(0,-1));
		if (input.JoyButtonState(m_index, ::JK_DOWN) == ::KS_HIT)
			r = (::vector2(0,1));
		return r;
	}
}

} // namespace sef
