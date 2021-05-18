namespace sef {

class Follower : sef::GameController
{
	private uint m_interpStride;
	private uint m_updateRate;
	private ::vector3 m_destPos;
	private sef::interpolator::PositionInterpolator@ m_interp;
	private uint m_switchTime;

	private void FollowerConstructor(const ::vector3 &in pos, const bool dontPause, const uint interpStride, const uint updateRate)
	{
		m_interpStride = interpStride;
		m_updateRate = updateRate;

		@m_interp = sef::interpolator::PositionInterpolator(pos, pos, m_interpStride, dontPause);
		@(m_interp.m_filter) = @sef::easing::smoothEnd;
		m_switchTime = 0;
	}

	Follower(const ::vector2 &in pos, const bool dontPause = false, const uint interpStride = 600, const uint updateRate = 100)
	{
		FollowerConstructor(::vector3(pos, 0.0f), dontPause, interpStride, updateRate);
	}

	Follower(const ::vector3 &in pos, const bool dontPause = false, const uint interpStride = 600, const uint updateRate = 100)
	{
		FollowerConstructor(pos, dontPause, interpStride, updateRate);
	}

	void setFilter(sef::easing::FUNCTION@ func)
	{
		@(m_interp.m_filter) = @func;
	}

	void setInterpStride(const uint interpStride)
	{
		m_interpStride = interpStride;
	}

	void setDestinationPos(const ::vector2 &in destPos)
	{
		setDestinationPos(::vector3(destPos, 0.0f));
	}

	void setDestinationPos(const ::vector3 &in destPos)
	{
		m_destPos = destPos;
	}

	void forcePosition(const ::vector2 &in pos)
	{
		forcePosition(::vector3(pos, 0.0f));
	}

	float getBias() const
	{
		return m_interp.getBias();
	}

	void forcePosition(const ::vector3 &in pos)
	{
		m_interp.forcePointA(pos);
		m_interp.forcePointB(pos);
	}

	::vector2 getPos() const
	{
		return m_interp.getCurrentPos();
	}

	::vector3 getPos3D() const
	{
		return m_interp.getCurrentPos3D();
	}

	uint getInterpStride() const
	{
		return m_interpStride;
	}

	void reset(const ::vector2 &in pos)
	{
		reset(::vector3(pos, 0.0f));
	}

	void reset(const ::vector3 &in pos)
	{
		m_interp.reset(pos, m_destPos, m_interpStride);
	}

	bool hasReachedDestination() const
	{
		return (m_interp.getCurrentPos3D() == m_destPos);
	}

	void draw() { }
	void update()
	{
		if (!hasReachedDestination() && m_switchTime > m_updateRate)
		{
			reset(m_interp.getCurrentPos3D());
			m_switchTime = 0;
		}
		m_switchTime += ::GetLastFrameElapsedTime();
		m_interp.update();
	}
}

class TrembleFollower : sef::Follower
{
	private sef::Timer m_trembleTime;
	private uint m_nextTrembleUpdate;
	uint m_minTrembleTime;
	uint m_maxTrembleTime;
	float m_unscaledTrembleOffset;

	TrembleFollower(
		const bool dontPause = false,
		const uint minTrembleTime = 0,
		const uint maxTrembleTime = 1000,
		const float unscaledTrembleOffset = 32.0f)
	{
		m_nextTrembleUpdate = (minTrembleTime + maxTrembleTime) / 2;
		m_minTrembleTime = minTrembleTime;
		m_maxTrembleTime = maxTrembleTime;
		m_unscaledTrembleOffset = unscaledTrembleOffset;

		super(::vector2(0.0f), dontPause, m_nextTrembleUpdate, 12);
	}

	void update() override
	{
		updateTremble();
	}

	private void updateTremble()
	{
		Follower::update();

		m_trembleTime.update();
		if (m_trembleTime.getElapsedTime() > m_nextTrembleUpdate)
		{
			m_nextTrembleUpdate = (::rand(m_minTrembleTime, m_maxTrembleTime));
			setInterpStride(m_nextTrembleUpdate);

			const float trembleLength = (m_unscaledTrembleOffset);
			m_trembleTime.reset();
			setDestinationPos(sef::math::rotate(::vector2(0, trembleLength), ::randF(::PI * 2)));
		}
	}
}

} // namespace sef
