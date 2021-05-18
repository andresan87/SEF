namespace sef {

class KeyStateManager
{
	private uint m_pressingElapsedFrameCount = 0;
	private ::KEY_STATE m_currentState = ::KS_UP;

	void update(const bool isPressed)
	{
		if (isPressed)
		{
			m_pressingElapsedFrameCount++;
		}
		else if (m_pressingElapsedFrameCount > 0)
		{
			m_pressingElapsedFrameCount = 0;
			m_currentState = ::KS_RELEASE;
			return;
		}
		else if (m_pressingElapsedFrameCount == 0)
		{
			m_currentState = ::KS_UP;
			return;
		}

		if (m_pressingElapsedFrameCount == 1)
		{
			m_currentState = ::KS_HIT;
			return;
		}
		m_currentState = ::KS_DOWN;
	}

	::KEY_STATE getCurrentState() const
	{
		return m_currentState;
	}
}

} // namespace sef
