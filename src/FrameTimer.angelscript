namespace sef {

class FrameTimer
{
	private uint m_currentStride;
	private float m_time;
	private uint m_currentFirst;
	private uint m_currentLast;
	private uint m_currentFrame;
	private bool m_finished;
	private bool m_pausable = true;

	FrameTimer()
	{
		m_currentFrame = m_currentFirst = m_currentLast = 0;
		m_time = 0.0f;
		m_finished = false;
	}

	void setPausable(const bool pausable)
	{
		m_pausable = pausable;
	}

	uint get() const
	{
		return m_currentFrame;
	}
	
	void setCurrentFrame(const uint currentFrame)
	{
		m_currentFrame = currentFrame;
		m_time = 0.0f;
	}
	
	void reset()
	{
		m_currentStride = 0;
		m_currentFrame = m_currentFirst;
		m_time = 0.0f;
		m_finished = false;
	}

	bool isFinished() const
	{
		return m_finished;
	}

	void setCurrentStride(const uint stride)
	{
		m_currentStride = stride;
	}

	uint set(const uint first, const uint last, const uint stride, const bool loop = true)
	{
		const float strideF = float(stride);
		m_currentStride = stride;

		if (m_pausable)
			m_time += sef::TimeManager.getLastFrameElapsedTimeF();
		else
			m_time += ::GetLastFrameElapsedTimeF();

		if (first != m_currentFirst || last != m_currentLast)
		{
			m_currentFrame = first;
			m_currentFirst = first;
			m_currentLast  = last;
			m_time = 0.0f;
			return m_currentFrame;
		}

		if (m_time >= strideF)
		{
			m_currentFrame++;
			m_time -= strideF;

			if (m_currentFrame > last)
			{
				if (loop)
				{
					m_currentFrame = first;
				}
				else
				{
					m_currentFrame = last;
					m_time = strideF;
				}
			}
		}

		m_finished = (m_currentFrame == m_currentLast && m_time >= strideF);
		return m_currentFrame;
	}

	bool isLastFrame() const
	{
		return m_currentFrame == m_currentLast;
	}

	float getBias() const
	{
		return sef::math::clamp((float(::min(m_time, float(m_currentStride))) / ::max(1.0f, float(m_currentStride))), 0.0f, 1.0f);
	}

	uint getCurrentFirstFrame() const
	{
		return m_currentFirst;
	}

	uint getCurrentLastFrame() const
	{
		return m_currentLast;
	}
}

} // namespace sef
