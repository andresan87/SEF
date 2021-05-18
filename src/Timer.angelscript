namespace sef {

class Timer : sef::GameController
{
	private float m_elapsedTime = 0.0f;

	void update()
	{
		m_elapsedTime += sef::TimeManager.getLastFrameElapsedTimeF();
	}

	void draw() {}

	void reset()
	{
		m_elapsedTime = 0.0f;
	}

	uint getElapsedTime() const
	{
		return uint(m_elapsedTime);
	}

	float getElapsedTimeF() const
	{
		return m_elapsedTime;
	}

	void forceElapsedTime(const float elapsedTime)
	{
		m_elapsedTime = elapsedTime;
	}

	float getBias(const float time) const
	{
		return m_elapsedTime / time;
	}

	float getSaturatedBias(const float time) const
	{
		return ::min(1.0f, getBias(time));
	}

	float getReverseSaturatedBias(const float time) const
	{
		return (1.0f - getSaturatedBias(time));
	}
}

} // namespace sef
