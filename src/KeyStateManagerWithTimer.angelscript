namespace sef {

class KeyStateManagerWithTimer : sef::KeyStateManager
{
	private float m_pressElapsedTime = 0.0f;

	void update(const bool isPressed) override
	{
		KeyStateManager::update(isPressed);
		const KEY_STATE state = getCurrentState();
		if (state == KS_HIT || state == KS_DOWN)
		{
			m_pressElapsedTime += sef::TimeManager.getLastFrameElapsedTimeF();
		}
		else
		{
			m_pressElapsedTime = 0.0f;
		}
	}

	float getPressElapsedTime() const
	{
		return m_pressElapsedTime;
	}
}

} // namespace sef
