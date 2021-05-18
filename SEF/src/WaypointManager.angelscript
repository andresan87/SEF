namespace sef {

class Waypoint
{
	Waypoint()
	{
		time = 0;
		angle = 0.0f;
		scale = 1.0f;
		z = 0.0f;
		@filter = @sef::easing::smoothEnd;
	}

	Waypoint(
		const ::vector2 &in pos,
		const uint time,
		sef::Color color,
		sef::easing::FUNCTION@ filter,
		const float angle = 0.0f,
		const float scale = 1.0f,
		const float z = 0.0f)
	{
		this.pos = pos;
		this.time = time;
		this.color = color;
		@this.filter = @filter;
		this.angle = angle;
		this.scale = scale;
		this.z = z;
	}

	Waypoint(
		const ::vector3 &in pos3,
		const uint time,
		sef::Color color,
		sef::easing::FUNCTION@ filter,
		const float angle = 0.0f,
		const float scale = 1.0f)
	{
		this.pos = ::vector2(pos3.x, pos3.y);
		this.z = pos3.z;
		this.time = time;
		this.color = color;
		@this.filter = @filter;
		this.angle = angle;
		this.scale = scale;
	}

	::vector2 getPos() const
	{
		return pos;
	}

	::vector2 pos;
	float z;
	sef::Color color;
	uint time;
	float angle;
	float scale;
	sef::easing::FUNCTION@ filter;
}

class ScreenSpaceWaypoint : sef::Waypoint
{
	::vector2 startPos;

	ScreenSpaceWaypoint(
		const ::vector3 &in pos3,
		const ::vector2 &in startPos,
		const uint time,
		sef::Color color,
		sef::easing::FUNCTION@ filter = @sef::easing::smoothEnd,
		const float angle = 0.0f,
		const float scale = 1.0f)
	{
		super(pos3, time, color, @filter, angle, scale);
		this.startPos = startPos;
	}

	::vector2 getPos() const
	{
		return (pos + ::GetCameraPos() - startPos);
	}
}

class WaypointManager : sef::GameController
{
	private sef::FrameTimer m_timer;
	private sef::Waypoint@[]@ m_waypoints;
	private bool m_repeat;
	private bool m_isPredefined = false;
	private bool m_hasStarted = false;

	WaypointManager(const bool repeat, sef::Waypoint@[]@ preDefined = null)
	{
		if (preDefined is null)
		{
			@m_waypoints = ::array<sef::Waypoint@>();
		}
		else
		{
			m_isPredefined = true;
			@m_waypoints = @preDefined;
		}

		m_repeat = repeat;
		m_timer.set(0,0,0,repeat);
	}

	sef::Waypoint@[]@ getWaypoints()
	{
		return @m_waypoints;
	}

	sef::Waypoint getLastWaypoint() const
	{
		const uint len = m_waypoints.length();
		if (len > 0)
		{
			const uint last = len - 1;
			if (m_waypoints[last] !is null)
				return m_waypoints[last];
		}
		return sef::Waypoint();
	}

	void append(sef::WaypointManager@ other)
	{
		for (uint t = 0; t < other.m_waypoints.length(); t++)
		{
			sef::Waypoint new = other.m_waypoints[t];
			if (m_waypoints.length() > 0)
			{
				new.pos += m_waypoints[m_waypoints.length() - 1].pos;
				new.z += m_waypoints[m_waypoints.length() - 1].z;
			}
			m_waypoints.insertLast(@new);
		}
	}

	void addWaypoint(sef::Waypoint@ waypoint)
	{
		if (!m_isPredefined)
		{
			m_waypoints.insertLast(@waypoint);
		}
		else
		{
			sef::io::ErrorMessage("WaypointManager::addWaypoint", "Can't modify predefined waypoints");
		}
	}

	void addWaypoints(sef::Waypoint@[]@ waypoints)
	{
		for (uint t = 0; t < waypoints.length(); t++)
		{
			addWaypoint(@(waypoints[t]));
		}
	}

	void reset()
	{
		m_timer.reset();
	}

	uint getFrame() const
	{
		return m_timer.get();
	}

	float getBias() const
	{
		return m_timer.getBias();
	}

	sef::Waypoint getCurrentPoint() const
	{
		const uint currentFrame = m_timer.get();
		uint nextFrame;
		if (m_timer.isLastFrame())
		{
			if (m_repeat)
				nextFrame = 0;
			else
				nextFrame = currentFrame;
		}
		else
		{
			nextFrame = currentFrame + 1;
		}
		
		sef::Waypoint@ current = m_waypoints[currentFrame];
		sef::Waypoint@ next = m_waypoints[nextFrame];
		sef::easing::FUNCTION@ filter = @(current.filter);
		const float bias = m_timer.getBias();
		return sef::Waypoint(
			sef::interpolator::interpolate(current.getPos(), next.getPos(), filter(bias)),
			0,
			sef::interpolator::interpolate(current.color, next.color, sef::easing::smoothBothSides(bias)),
			null,
			sef::interpolator::interpolate(current.angle, next.angle, filter(bias)),
			sef::interpolator::interpolate(current.scale, next.scale, filter(bias)),
			sef::interpolator::interpolate(current.z,     next.z,     filter(bias)));
	}

	bool isFinished() const
	{
		if (m_repeat || !m_hasStarted)
		{
			return false;
		}
		else
		{
			return (m_timer.isLastFrame());
		}
	}

	void setPausable(const bool pausable)
	{
		m_timer.setPausable(pausable);
	}

	bool isLastFrame() const
	{
		return m_timer.isLastFrame();
	}

	uint getNumWaypoints() const
	{
		return m_waypoints.length();
	}

	void setCurrentWaypoint(const uint frame)
	{
		m_timer.setCurrentFrame(frame);
	}

	bool isRepeating() const
	{
		return m_repeat;
	}

	void update()
	{
		m_hasStarted = true;
		if (m_waypoints.length() <= 1)
			return;

		const uint lastWaypointIdx = m_waypoints.length() - 1;
		const uint currentFrame = min(m_timer.get(), lastWaypointIdx);

		m_timer.set(0, lastWaypointIdx, m_waypoints[currentFrame].time, m_repeat);

		m_timer.setCurrentStride(m_waypoints[m_timer.get()].time);
	}

	void draw() { }
}

} // namespace sef
