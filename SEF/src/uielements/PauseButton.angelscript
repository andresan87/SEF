namespace sef {

class PauseButton : UIButton
{
	PauseButton(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, origin, scale);
	}

	PauseButton(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, @beginningAnimation, origin, scale);
	}

	void update()
	{
		UIButton::update();
		if (isPressed())
		{
			if (!sef::TimeManager.isPaused())
				sef::TimeManager.pause();
			else
				sef::TimeManager.resume();
		}
	}
}

} // namespace sef
