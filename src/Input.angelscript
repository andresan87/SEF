namespace sef {
namespace input {

class UIGlobalInput
{
	::J_KEY enterJKey = ::JK_03;
	::J_KEY backJKey  = ::JK_02;

	UIGlobalInput()
	{
		::ETHInput@ input = ::GetInputHandle();
		m_lastTouchDownPos.resize(input.GetMaxTouchCount());
		m_lastTouchHitPos.resize(input.GetMaxTouchCount());
	}

	void update()
	{
		::ETHInput@ input = ::GetInputHandle();
		sumKeyboard(@input);
		sumJoystick(@input);

		// update touch pos
		const uint len =  ::min(m_lastTouchDownPos.length(), m_lastTouchHitPos.length());
		for (uint t = 0; t < len; t++)
		{
			const ::KEY_STATE state = input.GetTouchState(t);
			if (state == ::KS_DOWN || state == ::KS_HIT)
			{
				const ::vector2 touchPos(input.GetTouchPos(t));
				m_lastTouchDownPos[t] = touchPos;

				if (state == ::KS_HIT)
				{
					m_lastTouchHitPos[t] = touchPos;
				}
			}
		}
	}

	::vector2 getLastTouchDown(const uint t) const
	{
		if (t < m_lastTouchDownPos.length())
			return m_lastTouchDownPos[t];
		else
			return ::vector2(-1.0f);
	}

	::vector2 getLastTouchHit(const uint t) const
	{
		if (t < m_lastTouchHitPos.length())
			return m_lastTouchHitPos[t];
		else
			return ::vector2(-1.0f);
	}

	void resetBackState()
	{
		m_fullBackState = ::KS_UP;
	}

	private void sumKeyboard(::ETHInput@ input)
	{
		m_fullBackState = m_keyboardBackState = sef::input::getKeyboardBackState(@input);

		m_enterState = sef::input::getKeyboardEnterState(@input);

		m_nextState  = sef::input::getKeyboardDpadRightState(@input);
		m_priorState = sef::input::getKeyboardDpadLeftState(@input);
		m_upState    = sef::input::getKeyboardDpadUpState(@input);
		m_downState  = sef::input::getKeyboardDpadDownState(@input);
	}

	private void sumJoystick(::ETHInput@ input)
	{
		for (uint j = 0; j < input.GetMaxJoysticks(); j++)
		{
			if (input.GetJoystickStatus(j) != ::JS_DETECTED)
				continue;
			m_fullBackState = sef::util::sum(m_fullBackState, input.JoyButtonState(j, backJKey));
			m_enterState    = sef::util::sum(m_enterState, input.JoyButtonState(j, enterJKey));
			m_nextState     = sef::util::sum(m_nextState,  sef::input::getJoystickRightState(input, j));
			m_priorState    = sef::util::sum(m_priorState, sef::input::getJoystickLeftState(input, j));
			m_upState       = sef::util::sum(m_upState,    sef::input::getJoystickUpState(input, j));
			m_downState     = sef::util::sum(m_downState,  sef::input::getJoystickDownState(input, j));
		}
	}

	::KEY_STATE getBackState() const { return m_fullBackState; }
	::KEY_STATE getKeyboardOnlyBackState() const { return m_keyboardBackState; }
	::KEY_STATE getEnterState() const { return m_enterState; }
	::KEY_STATE getNextState() const { return m_nextState; }
	::KEY_STATE getPriorState() const { return m_priorState; }
	::KEY_STATE getUpState() const { return m_upState; }
	::KEY_STATE getDownState() const { return m_downState; }

	private ::KEY_STATE m_fullBackState = ::KS_UP;
	private ::KEY_STATE m_keyboardBackState = ::KS_UP;
	private ::KEY_STATE m_enterState = ::KS_UP;
	private ::KEY_STATE m_nextState = ::KS_UP;
	private ::KEY_STATE m_priorState = ::KS_UP;
	private ::KEY_STATE m_upState = ::KS_UP;
	private ::KEY_STATE m_downState = ::KS_UP;

	private ::vector2[] m_lastTouchDownPos;
	private ::vector2[] m_lastTouchHitPos;
}

::KEY_STATE getKeyboardEnterState(::ETHInput@ input)
{
	return input.GetKeyState(::K_RETURN);
}

::KEY_STATE getKeyboardBackState(::ETHInput@ input)
{
	::KEY_STATE state = input.GetKeyState(::K_ESC);
	if (sef::input::g_deviceHasBackButton)
	{
		state = sef::util::sum(state, input.GetKeyState(::K_BACK));
	}
	return state;
}

::KEY_STATE getKeyboardDpadLeftState(::ETHInput@ input)
{
	return input.GetKeyState(::K_LEFT);
}

::KEY_STATE getKeyboardDpadRightState(::ETHInput@ input)
{
	return input.GetKeyState(::K_RIGHT);
}

::KEY_STATE getKeyboardDpadUpState(::ETHInput@ input)
{
	return input.GetKeyState(::K_UP);
}

::KEY_STATE getKeyboardDpadDownState(::ETHInput@ input)
{
	return input.GetKeyState(::K_DOWN);
}

::KEY_STATE getKeyboardWalkLeftState(::ETHInput@ input)
{
	const ::KEY_STATE state = input.GetKeyState(::K_LEFT);
	return sef::util::sum(state, input.GetKeyState(::K_A));
}

::KEY_STATE getKeyboardWalkRightState(::ETHInput@ input)
{
	const ::KEY_STATE state = input.GetKeyState(::K_RIGHT);
	return sef::util::sum(state, input.GetKeyState(::K_D));
}

::KEY_STATE getJoystickLeftState(::ETHInput@ input, const uint j)
{
	return input.JoyButtonState(j, ::JK_LEFT);
}

::KEY_STATE getJoystickRightState(::ETHInput@ input, const uint j)
{
	return input.JoyButtonState(j, ::JK_RIGHT);
}

::KEY_STATE getJoystickUpState(::ETHInput@ input, const uint j)
{
	return input.JoyButtonState(j, ::JK_UP);
}

::KEY_STATE getJoystickDownState(::ETHInput@ input, const uint j)
{
	return input.JoyButtonState(j, ::JK_DOWN);
}

int findFirstDetectedJoystick()
{
	::ETHInput@ input = ::GetInputHandle();
	for (uint t = 0; t < input.GetMaxJoysticks(); t++)
	{
		if (input.GetJoystickStatus(t) == ::JS_DETECTED)
			return int(t);
	}
	return -1;
}

::KEY_STATE getAnyTouch()
{
	::KEY_STATE r = ::KS_UP;
	::ETHInput@ input = ::GetInputHandle();
	for (uint t = 0; t < input.GetMaxTouchCount(); t++)
	{
		r = sef::util::sum(r, input.GetTouchState(t));
	}
	return r;
}

int getAnyTouchRelease()
{
	::ETHInput@ input = ::GetInputHandle();
	for (uint t = 0; t < input.GetMaxTouchCount(); t++)
	{
		if (input.GetTouchState(t) == ::KS_RELEASE)
		{
			return int(t);
		}
	}
	return -1;
}

const ::vector2 NO_TOUCH(-1.0f,-1.0f);

::vector2 getAnyHitPos()
{
	uint idx;
	return sef::input::getAnyHitPos(idx);
}

::vector2 getAnyHitPos(uint &out idx)
{
	::ETHInput@ input = ::GetInputHandle();
	for (uint t = 0; t < input.GetMaxTouchCount(); t++)
	{
		if (input.GetTouchState(t) == ::KS_HIT)
		{
			idx = t;
			return input.GetTouchPos(t);
		}
	}
	return sef::input::NO_TOUCH;
}

::vector2 getAllTouchMoves()
{
	::vector2 r(0.0f);
	::ETHInput@ input = ::GetInputHandle();
	for (uint t = 0; t < input.GetMaxTouchCount(); t++)
	{
		if (input.GetTouchState(t) == ::KS_DOWN)
		{
			r += input.GetTouchMove(t);
		}
	}
	return r;
}

bool hasAnyMouseClick()
{
	ETHInput@ input = GetInputHandle();
	const KEY_STATE m = input.GetKeyState(K_MMOUSE);
	const KEY_STATE l = input.GetKeyState(K_LMOUSE);
	const KEY_STATE r = input.GetKeyState(K_RMOUSE);
	KEY_STATE sum = sef::util::sum(m, l);
	sum = sef::util::sum(sum, r);
	return (sum == KS_HIT || sum == KS_DOWN);
}

int getFirstJoystickButtonPressed(const uint j)
{
	ETHInput@ input = GetInputHandle();
	if (input.GetJoystickStatus(j) == JS_DETECTED)
	{
		for (uint b = 0; b < input.GetNumJoyButtons(j); b++)
		{
			const J_KEY button = indexToButtonKey(b);
			if (input.JoyButtonDown(j, button))
			{
				return int(b);
			}
		}
	}
	return -1;
}

int getFirstJoystickDpadAction()
{
	ETHInput@ input = GetInputHandle();
	for (uint j = 0; j < input.GetMaxJoysticks(); j++)
	{
		if (input.GetJoystickStatus(j) != ::JS_DETECTED)
			continue;
		if (input.GetJoystickXY(j) != ::vector2(0.0f))
			return int(j);
	}
	return -1;
}

J_KEY indexToButtonKey(const uint buttonIndex)
{
	switch (buttonIndex)
	{
		case 0: return JK_01;
		case 1: return JK_02;
		case 2: return JK_03;
		case 3: return JK_04;
		case 4: return JK_05;
		case 5: return JK_06;
		case 6: return JK_07;
		case 7: return JK_08;
		case 8: return JK_09;
		case 9: return JK_10;
		case 10: return JK_11;
		case 11: return JK_12;
		case 12: return JK_13;
		case 13: return JK_14;
		case 14: return JK_15;
		case 15: return JK_16;
		case 16: return JK_17;
		case 17: return JK_18;
		case 18: return JK_19;
		case 19: return JK_20;
		case 20: return JK_21;
		case 21: return JK_22;
		case 22: return JK_23;
		case 23: return JK_24;
		case 24: return JK_25;
		case 25: return JK_26;
		case 26: return JK_27;
		case 27: return JK_28;
		case 28: return JK_29;
		case 29: return JK_30;
		case 30: return JK_31;
		case 31: return JK_32;
	}
	return JK_NONE;
}

uint buttonKeyToIndex(const J_KEY buttonIndex)
{
	switch (buttonIndex)
	{
		case JK_01: return 0;
		case JK_02: return 1;
		case JK_03: return 2;
		case JK_04: return 3;
		case JK_05: return 4;
		case JK_06: return 5;
		case JK_07: return 6;
		case JK_08: return 7;
		case JK_09: return 8;
		case JK_10: return 9;
		case JK_11: return 10;
		case JK_12: return 11;
		case JK_13: return 12;
		case JK_14: return 13;
		case JK_15: return 14;
		case JK_16: return 15;
		case JK_17: return 16;
		case JK_18: return 17;
		case JK_19: return 18;
		case JK_20: return 19;
		case JK_21: return 20;
		case JK_22: return 21;
		case JK_23: return 22;
		case JK_24: return 23;
		case JK_25: return 24;
		case JK_26: return 25;
		case JK_27: return 26;
		case JK_28: return 27;
		case JK_29: return 28;
		case JK_30: return 29;
		case JK_31: return 30;
		case JK_32: return 31;
	}
	return 0;
}

void init()
{
	g_deviceHasBackButton = (GetPlatformName() == "android");
}

void update()
{
	sef::input::global.update();
}

sef::input::UIGlobalInput global;
bool g_deviceHasBackButton = false;

} // namespace sef
} // namespace input
