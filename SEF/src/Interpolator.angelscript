namespace sef {
namespace interpolator {

float interpolate(const float a, const float b, const float bias)
{
	return a + ((b - a) * bias);
}

::vector2 interpolate(const ::vector2 &in a, const ::vector2 &in b, const float bias)
{
	return a + ((b - a) * bias);
}

::vector3 interpolate(const ::vector3 &in a, const ::vector3 &in b, const float bias)
{
	return a + ((b - a) * bias);
}

sef::Color interpolate(const sef::Color@ a, const sef::Color@ b, const float bias)
{
	return sef::Color(sef::interpolator::interpolate(a.getAlpha(),   b.getAlpha(),   bias),
					  sef::interpolator::interpolate(a.getVector3(), b.getVector3(), bias));
}

class InterpolationTimer
{
	InterpolationTimer(const uint _millisecs, const bool dontPause)
	{
		reset(_millisecs);
		@m_filter = @sef::easing::smoothEnd;
		m_dontPause = dontPause;
	}
	
	void update()
	{
		if (m_dontPause)
			m_elapsedTime += ::GetLastFrameElapsedTime();
		else
			m_elapsedTime += sef::TimeManager.getLastFrameElapsedTime();
	}

	float getBias() const
	{
		return (!isOver()) ? m_filter(getUnfilteredBias()) : 1.0f;
	}

	float getUnfilteredBias() const
	{
		if (m_time == 0)
		{
			return 1.0f;
		}
		return (!isOver()) ? (::min(::max(float(m_elapsedTime) / float(m_time), 0.0f), 1.0f)) : 1.0f;
	}

	void reset(const uint _millisecs)
	{
		m_time = _millisecs;
		m_elapsedTime = 0;
	}

	bool isOver() const
	{
		return (m_elapsedTime > m_time);
	}

	void setFilter(sef::easing::FUNCTION@ filter)
	{
		@m_filter = @filter;
	}

	uint m_elapsedTime;
	uint m_time;
	sef::easing::FUNCTION@ m_filter;
	bool m_dontPause;
}

class Interpolator : sef::interpolator::InterpolationTimer
{
	private float m_a;
	private float m_b;

	Interpolator()
	{
		super(0, false);
	}

	Interpolator(const float _a, const float _b, const uint _millisecs, const bool dontPause = false)
	{
		super(_millisecs, dontPause);
		reset(_a, _b, _millisecs);
	}

	void reset(const float _a, const float _b, const uint _millisecs)
	{
		InterpolationTimer::reset(_millisecs);
		m_a = _a;
		m_b = _b;
	}

	void forcePointA(const float a)
	{
		m_a = a;
	}

	void forcePointB(const float b)
	{
		m_b = b;
	}

	float getCurrent() const
	{
		if (m_elapsedTime > m_time)
		{
			return m_b;
		}
		else
		{
			const float bias = getBias();
			return sef::interpolator::interpolate(m_a, m_b, bias);
		}
	}
}

class PositionInterpolator : sef::interpolator::InterpolationTimer
{
	private ::vector3 m_a;
	private ::vector3 m_b;

	PositionInterpolator()
	{
		super(0, false);
	}

	PositionInterpolator(const ::vector3 &in _a, const ::vector3 &in _b, const uint _millisecs, const bool dontPause = false)
	{
		super(_millisecs, dontPause);
		reset(_a, _b, _millisecs);
	}

	PositionInterpolator(const ::vector2 &in _a, const ::vector2 &in _b, const uint _millisecs, const bool dontPause = false)
	{
		super(_millisecs, dontPause);
		reset(_a, _b, _millisecs);
	}

	void reset(const ::vector2 &in _a, const ::vector2 &in _b, const uint _millisecs)
	{
		reset(::vector3(_a, 0.0f), ::vector3(_b, 0.0f), _millisecs);
	}

	void reset(const ::vector3 &in _a, const ::vector3 &in _b, const uint _millisecs)
	{
		InterpolationTimer::reset(_millisecs);
		m_a = _a;
		m_b = _b;
	}

	void forcePointA(const ::vector3 &in a)
	{
		m_a = a;
	}

	void forcePointB(const ::vector3 &in b)
	{
		m_b = b;
	}

	void forcePointA(const ::vector2 &in a)
	{
		forcePointA(::vector3(a, 0.0f));
	}

	void forcePointB(const ::vector2 &in b)
	{
		forcePointB(::vector3(b, 0.0f));
	}

	::vector2 getCurrentPos() const
	{
		const ::vector3 r(getCurrentPos3D());
		return ::vector2(r.x, r.y);
	}

	::vector3 getCurrentPos3D() const
	{
		if (m_elapsedTime > m_time)
		{
			return m_b;
		}
		else
		{
			const float bias = getBias();
			return sef::interpolator::interpolate(m_a, m_b, bias);
		}
	}
}

} // namespace interpolator
} // namespace sef
