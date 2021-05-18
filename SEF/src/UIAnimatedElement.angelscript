namespace sef {

class UIAnimatedElement : UIElement
{
	private sef::WaypointManager@ m_animationManager;
	private bool m_dismissed = false;

	UIAnimatedElement(sef::WaypointManager@ beginningAnimation)
	{
		@m_animationManager = @beginningAnimation;
	}

	sef::Waypoint@ getCurrentWaypoint() const
	{
		if (m_animationManager !is null)
			return m_animationManager.getCurrentPoint();
		else
			return sef::Waypoint();
	}

	void draw()
	{
	}

	void update()
	{
		if (m_animationManager !is null)
		{
			m_animationManager.update();
			if (m_animationManager.isFinished())
			{
				@m_animationManager = null;
			}
		}
	}

	void setAnimation(sef::WaypointManager@ animation)
	{
		@m_animationManager = animation;
	}

	sef::WaypointManager@ getAnimation()
	{
		return @m_animationManager;
	}

	bool isDead() const
	{
		return isDismissed() && isAnimationFinished();
	}

	bool isAnimationFinished() const
	{
		return (m_animationManager is null);
	}

	void dismiss()
	{
		m_dismissed = true;
	}

	bool isDismissed() const
	{
		return m_dismissed;
	}

	::string getName() const
	{
		return "";
	}
}

class SetAnimationEvent : sef::Event
{
	private sef::UIAnimatedElement@ m_element;
	private sef::WaypointManager@ m_animation;

	SetAnimationEvent(sef::UIAnimatedElement@ element, sef::WaypointManager@ animation)
	{
		@m_element = @element;
		@m_animation = @animation;
	}

	void run() override
	{
		m_element.setAnimation(@m_animation);
	}
}

} // namespace sef
