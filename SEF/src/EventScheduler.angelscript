namespace sef {

class EventScheduler : sef::GameController
{
	private ScheduledEvent@[] m_events;

	void update()
	{
		sef::Event@[] eventsToRun;
		for (uint t = 0; t < m_events.length();)
		{
			if (m_events[t].updateAndTellMeWhenItsDone())
			{
				sef::ScheduledEvent@ event = @(m_events[t]);
				m_events.removeAt(t);
				eventsToRun.insertLast(@(event.event));
				continue;
			}
			t++;
		}

		for (uint t = 0; t < eventsToRun.length(); t++)
		{
			eventsToRun[t].run();
		}
	}

	void scheduleEvent(const uint delay, sef::Event@ event, const bool pausable = true)
	{
		uint t = 0;
		for (; t < m_events.length();)
		{
			if (m_events[t].computeTimeLeft() > float(delay))
			{
				break;
			}
			t++;
		}
		m_events.insertAt(t, sef::ScheduledEvent(delay, @event, pausable));
	}

	void draw() {}
}

class ScheduledEvent
{
	private float m_delay;
	private bool m_pausable;
	private float m_elapsedTime = 0;

	sef::Event@ event;

	ScheduledEvent(const uint delay, sef::Event@ event, const bool pausable = true)
	{
		m_pausable = pausable;
		m_delay = float(delay);

		@(this.event) = @event;
	}

	float computeTimeLeft() const final
	{
		return m_delay - m_elapsedTime;
	}

	bool updateAndTellMeWhenItsDone() final
	{
		if (m_pausable)
		{
			m_elapsedTime += sef::TimeManager.getLastFrameElapsedTimeF();
		}
		else
		{
			m_elapsedTime += ::GetLastFrameElapsedTimeF();
		}
		return (m_elapsedTime >= m_delay);
	}
}

} // namespace sef
