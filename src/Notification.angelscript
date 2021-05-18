namespace sef {

class Notification : sef::UIDrawable
{
	::string soundSample = "";
	uint delay = 0;

	private float m_elapsedTime = 0;
	private bool m_soundPlayed = false;
	private sef::TextDrawable@ m_textAdding;
	private sef::TextDrawable@ m_textTitle;
	private sef::FrameDrawable@ m_frameDrawable;

	private void NotificationDefaultConstructor(
		const ::vector2 &in normPos,
		const ::vector2 &in origin,
		const ::string &in frameBitmap,
		sef::Font@ font,
		const ::string &in text,
		const ::vector2 &in borderWidth)
	{
		m_frameDrawable.setHighQuality(true);

		@m_textAdding = m_frameDrawable.setText(text, @font, sef::Color(0xFFFFFFFF), 1.0f);
		m_textAdding.centered = true;
	}

	Notification(
		const ::vector2 &in normPos,
		const ::vector2 &in origin,
		const ::string &in frameBitmap,
		sef::Font@ font,
		const ::string &in text,
		const ::vector2 &in borderWidth)
	{
		@m_frameDrawable = sef::FrameDrawable(frameBitmap, ::vector2(30.0f));
		super(
			@m_frameDrawable,
			normPos,
			null,
			origin);

		NotificationDefaultConstructor(normPos, origin, frameBitmap, @font, text, borderWidth);
		m_frameDrawable.resizeToTextSize(borderWidth);
	}

	Notification(
		const ::vector2 &in normPos,
		const ::vector2 &in origin,
		const ::string &in frameBitmap,
		sef::Font@ font,
		const ::string &in text,
		const ::vector2 &in borderWidth,
		const ::string &in titleText,
		sef::Font@ titleFont)
	{
		@m_frameDrawable = sef::FrameDrawable(frameBitmap, ::vector2(30.0f));
		super(
			@m_frameDrawable,
			normPos,
			null,
			origin);

		NotificationDefaultConstructor(normPos, origin, frameBitmap, @font, text, borderWidth);

		@m_textTitle = m_frameDrawable.setText(titleText, @titleFont, sef::Color(0xFFFFFFFF), 1.0f);
		m_textTitle.centered = true;
		m_frameDrawable.resizeToTextSize(borderWidth);
	}

	bool opEquals(const Notification &in other) const
	{
		return (other.m_textAdding.getText() == m_textAdding.getText()
				&& other.m_textAdding.getFont() == m_textAdding.getFont()
				&& other.m_frameDrawable.getBackgroundTiles() == m_frameDrawable.getBackgroundTiles());
	}

	sef::FrameDrawable@ getFrameDrawable()
	{
		return @m_frameDrawable;
	}

	sef::TextDrawable@ getTextAdding()
	{
		return @m_textAdding;
	}

	void update()
	{
		UIDrawable::update();
		if (isAnimationFinished())
			dismiss();
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= float(delay) && soundSample != "" && !m_soundPlayed)
		{
			m_soundPlayed = true;
			sef::util::playSample(soundSample);
		}
	}

	void setBorderScale(const float scale)
	{
		m_frameDrawable.borderScale = scale;
	}
}

class NotificationLayer : sef::UILayer
{
	private uint m_notificationCounter = 0;

	private float m_waitTime = 0;

	private uint m_effectDuration = 400;

	NotificationLayer()
	{
		super("Notificator");
	}

	void notify(
		const uint delay,
		const uint holdTime,
		sef::Notification@ notification,
		sef::WaypointManager@ appearEffect = null,
		sef::WaypointManager@ dismissEffect = null,
		const bool unique = true)
	{
		if (unique && find(@notification))
		{
			return;
		}

		const ::vector2 normPos(notification.getNormPos());

		notification.delay = uint(::max(float(delay), m_waitTime));
		notification.setAnimation((appearEffect !is null) ? @appearEffect : createDefaultAppearEffect(notification.delay, normPos));

		m_waitTime += (delay + holdTime + float(m_effectDuration * 2));

		notification.setDismissEffect((dismissEffect !is null) ? @dismissEffect : createDefaultDismissEffect(holdTime, normPos));
		notification.setName("notification" + (m_notificationCounter++));
		insertElement(@notification);
	}

	sef::WaypointManager@ createDefaultAppearEffect(const uint delay, const ::vector2 &in normPos)
	{
		float scaleA = 0.5f, scaleB = 1.0f;
		const sef::Color colorA(0x55FFFFFF);
		const sef::Color colorB(0xFFFFFFFF);

		const ::vector2 startPos((::normalize(normPos - ::vector2(0.5f)) * 0.05f));

		const bool repeat = false;
		sef::WaypointManager r(repeat);
		r.setPausable(false);

		if (delay > 0)
		{
			sef::Color invisible(0x00FFFFFF);
			r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, invisible, @sef::easing::smoothEnd));
			r.addWaypoint(sef::Waypoint(startPos,            0, invisible, @sef::easing::linear, 0.0f, scaleA));			
		}

		r.addWaypoint(sef::Waypoint(startPos,        m_effectDuration, colorA, @sef::easing::elastic2, 0.0f, scaleA));
		r.addWaypoint(sef::Waypoint(::vector2(0.0f),               12, colorB, @sef::easing::linear,   0.0f, scaleB));
		return @r;
	}

	bool find(Notification@ notification) const
	{
		for (uint t = 0; t < m_elements.length(); t++)
		{
			sef::Notification@ n = cast<sef::Notification>(m_elements[t]);
			if (n == notification)
				return true;
		}
		return false;
	}

	sef::WaypointManager@ createDefaultDismissEffect(const uint delay, const ::vector2 &in normPos)
	{
		float scaleA = 1.0f, scaleB = 0.4f;
		const sef::Color colorA(0xFFFFFFFF);
		const sef::Color colorB(0x11FFFFFF);

		const ::vector2 finalPos((::normalize(normPos - ::vector2(0.5f)) * 0.15f));

		const bool repeat = false;
		sef::WaypointManager r(repeat);
		r.setPausable(false);

		if (delay > 0)
		{
			r.addWaypoint(sef::Waypoint(::vector2(0.0f), delay, colorA, @sef::easing::smoothEnd));
		}

		r.addWaypoint(sef::Waypoint(::vector2(0.0f), m_effectDuration, colorA, @sef::easing::smoothBeginning, 0.0f, scaleA));
		r.addWaypoint(sef::Waypoint(finalPos,                      12, colorB, @sef::easing::linear,          0.0f, scaleB));
		return @r;
	}

	void update()
	{
		UILayer::update();
		m_waitTime = ::max(0.0f, m_waitTime - ::GetLastFrameElapsedTimeF());
	}
}

NotificationLayer notificator;

} // namespace sef
