namespace sef {

class FollowerAsymptotic : sef::GameController
{
	private float m_stepBias;
	private bool m_dontPause;
	private ::vector3 m_destPos;
	private ::vector3 m_currentPos;

	private void FollowerAsymptoticConstructor(const ::vector3 pos, const float stepBias, const bool dontPause)
	{
		m_stepBias = stepBias;
		m_dontPause = dontPause;
		m_destPos = pos;
		m_currentPos = pos;
	}

	FollowerAsymptotic(const ::vector2 pos, const float stepBias, const bool dontPause = false)
	{
		FollowerAsymptoticConstructor(::vector3(pos, 0.0f), stepBias, dontPause);
	}

	FollowerAsymptotic(const ::vector3 pos, const float stepBias, const bool dontPause = false)
	{
		FollowerAsymptoticConstructor(pos, stepBias, dontPause);
	}

	void setDestinationPos(const ::vector2 &in destPos)
	{
		setDestinationPos(::vector3(destPos, 0.0f));
	}

	void setDestinationPos(const ::vector3 &in destPos)
	{
		m_destPos = destPos;
	}

	void forcePosition(const ::vector3 &in pos)
	{
		m_currentPos = pos;
		m_destPos = pos;
	}

	void forcePosition(const ::vector2 &in pos)
	{
		forcePosition(::vector3(pos, 0.0f));
	}

	float getStepBias() const
	{
		return m_stepBias;
	}

	void setStepBias(const float bias)
	{
		m_stepBias = bias;
	}

	::vector2 getPos() const
	{
		return ::vector2(m_currentPos.x, m_currentPos.y);
	}

	::vector3 getPos3D() const
	{
		return m_currentPos;
	}

	bool hasReachedDestination() const
	{
		return (m_currentPos == m_destPos);
	}

	void draw() override { }

	void update() override
	{
		const float bias = sef::computeManagedAsymptoticTimeBias(m_stepBias, !m_dontPause);
		m_currentPos = sef::asymptoticMove(m_currentPos, m_destPos, bias);
	}
}

float computeManagedAsymptoticTimeBias(const float bias, const bool pausable = true)
{
	const float fpsBias = 60.0f / ::max(::GetFPSRate(), 10.0f);
	return bias * fpsBias * (pausable ? sef::TimeManager.getFactor() : 1.0f);
}

float asymptoticMove(float current, const float dest, const float bias)
{
	const float delta = (dest - current);
	const float step = (delta * bias);

	if ((step * step) < (delta * delta))
	{
		current += step;
	}
	else
	{
		current = dest;
	}
	return current;
}

float asymptoticMove(float current, const float dest, const float bias, const float floor)
{
	if (::abs(dest - current) <= floor)
		return dest;
	else
		return asymptoticMove(current, dest, bias);
}

::vector2 asymptoticMove(const ::vector2 &in current, const ::vector2 &in dest, const float bias)
{
	return ::vector2(
		sef::asymptoticMove(current.x, dest.x, bias),
		sef::asymptoticMove(current.y, dest.y, bias)
	);
}

::vector3 asymptoticMove(const ::vector3 &in current, const ::vector3 &in dest, const float bias)
{
	return ::vector3(
		sef::asymptoticMove(current.x, dest.x, bias),
		sef::asymptoticMove(current.y, dest.y, bias),
		sef::asymptoticMove(current.z, dest.z, bias)
	);
}

} // namespace sef
