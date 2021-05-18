namespace sef {

class Selector : sef::UIButton, sef::UIButtonIterationListener
{
	private ::string[] m_thumbnails;

	private bool m_horizontal;

	private int m_current;

	private int m_latestDisplayedFrame =-1;

	private ::vector2 m_frameSize;

	private sef::FrameDrawable@ m_frameDrawable;

	private sef::TextDrawable@ m_dotIndicator;

	bool lockCursor = false;

	Selector(
		const ::string frameSprite,
		const ::string[] thumbnails,
		const ::vector2 &in frameSize,
		const uint first,
		const bool horizontal,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		m_thumbnails = thumbnails;
		m_horizontal = horizontal;
		m_frameSize  = frameSize;

		pick(first);

		@m_frameDrawable = sef::FrameDrawable(
			frameSprite,
			m_frameSize,
			false, // borderOutside
			false); // highQuality
		m_frameDrawable.setSprite(0, getCurrentThumbnail());

		super(m_frameDrawable, normPos, @beginningAnimation, origin, scale);

		@iterationListener = this;
	}

	void setCurrent(const int current)
	{
		m_current = current;
	}

	void insertArrows(
		const ::string &in spaceSeparatedArrows,
		sef::Font@ font,
		const uint color,
		const float gravityDist,
		const float scale)
	{
		::string[] arrows = sef::string::split(spaceSeparatedArrows, " ");
		if (arrows.length() < 2)
			 return;

		sef::TextDrawable@ textDrawable;

		@textDrawable = m_frameDrawable.setText(arrows[0], @font, sef::Color(color), scale);
		textDrawable.gravity = ::vector2(-gravityDist, 0.0f);
		textDrawable.centered = true;

		@textDrawable = m_frameDrawable.setText(arrows[1], @font, sef::Color(color), scale);
		textDrawable.gravity = ::vector2(gravityDist, 0.0f);
		textDrawable.centered = true;
	}

	void setHighQualityFrame(const bool enable)
	{
		m_frameDrawable.setHighQuality(enable);
	}

	void insertDotIndicator(
		sef::Font@ font,
		const uint color,
		const float gravityDist,
		const float scale)
	{
		@m_dotIndicator = m_frameDrawable.setText(".", @font, sef::Color(color), scale);
	 	m_dotIndicator.gravity = ::vector2(0.0f, gravityDist);
		m_dotIndicator.centered = true;
	}

	void pick(int idx)
	{
		if (idx < 0) idx = int(m_thumbnails.length()) + idx;
		m_current = (idx % m_thumbnails.length());
	}

	uint getNumThumbnails() const
	{
		return m_thumbnails.length();
	}

	::string getCurrentThumbnail()
	{
		return m_thumbnails[m_current];
	}

	int getCurrent() const
	{
		return m_current;
	}

	void update() override
	{
		if (m_latestDisplayedFrame != m_current && !isDismissed())
		{
			m_frameDrawable.setSprite(0, getCurrentThumbnail());
			if (getAnimation() is null)
				setAnimation(sef::uieffects::createSingleBounceEffect(80, 1.1f));
			m_latestDisplayedFrame = m_current;

			// update text in point indicator
			if (m_dotIndicator !is null)
			{
				::string str;
				for (uint t = 0; t < m_thumbnails.length(); t++)
				{
					str += (int(t) == m_current) ? ::AssembleColorCode(0xFFFFFFFF) : ::AssembleColorCode(0x66FFFFFF);
					str += ".";
				}
				m_dotIndicator.setText(str);
			}
		}

		UIButton::update();
	}

	void priorItem()
	{
		pick(getCurrent() - 1);
	}

	void nextItem()
	{
		pick(getCurrent() + 1);
	}

	bool move(const ::vector2 &in direction) override
	{
		int movement = 0;
		if (m_horizontal)
		{
			if (direction.x > 0.0f)
				movement = 1;
			else if (direction.x < 0.0f)
				movement = -1;
		}
		else
		{
			if (direction.y > 0.0f)
				movement = 1;
			else if (direction.y < 0.0f)
				movement = -1;
		}

		if (movement != 0)
		{
			if (movement > 0)
				nextItem();
			else
				priorItem();
			return false;
		}
		else
		{
			return !lockCursor;
		}
	}

	void dismiss() override
	{
		@iterationListener = null;
		UIButton::dismiss();
	}
}

} // namespace sef
