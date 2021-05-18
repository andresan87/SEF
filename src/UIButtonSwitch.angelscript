namespace sef {

class UIButtonSwitch : UIButton
{
	private bool m_enabled = false;

	bool autoSwitchOnClick = true;

	UIButtonSwitch(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, origin, scale);
	}

	UIButtonSwitch(
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(@drawable, normPos, @beginningAnimation, origin, scale);
	}

	UIButtonSwitch(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(spriteName, normPos, @beginningAnimation, origin, scale);
	}

	bool isEnabled() const
	{
		return m_enabled;
	}

	void setEnabled(const bool enabled)
	{
		const bool switched = (m_enabled != enabled);
		m_enabled = enabled;
		if (switched)
		{
			onSwitch();
		}
	}

	void onSwitch()
	{
	}

	void update()
	{
		UIButton::update();
		if (autoSwitchOnClick && isPressed())
		{
			m_enabled = !m_enabled;
		}
	}
}

class UIButtonFrameSwitch : UIButtonSwitch
{
	private sef::FrameDrawable@ m_frameDrawable;
	private sef::SpriteDrawable@ m_icon;

	private ::string m_fillSpriteA;
	private ::string m_fillSpriteB;

	UIButtonFrameSwitch(
		const ::string &in frameSprite,
		const ::string &in fillSpriteA,
		const ::string &in fillSpriteB,
		const ::vector2 &in unscaledSize,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f,
		const bool highQuality = true)
	{
		m_fillSpriteA = fillSpriteA;
		m_fillSpriteB = fillSpriteB;

		@m_frameDrawable =
			sef::FrameDrawable(
				frameSprite,
				unscaledSize,
				false, // borderOutside
				highQuality);

		super(
			@m_frameDrawable,
			normPos,
			@beginningAnimation,
			origin,
			scale);

		@m_icon = m_frameDrawable.setSprite(0, fillSpriteA);
		updateSprite();
	}

	void setBackgroundTiles(const string &in name)
	{
		m_frameDrawable.setBackgroundTiles(name);
	}

	sef::FrameDrawable@ getFrameDrawable()
	{
		return @m_frameDrawable;
	}

	sef::SpriteDrawable@ getIcon()
	{
		return @m_icon;
	}

	private void updateSprite()
	{
		::string spriteName;
		if (isEnabled())
			spriteName = m_fillSpriteA;
		else
			spriteName = m_fillSpriteB;

		m_icon.setName(spriteName);
	}

	void update()
	{
		UIButtonSwitch::update();
		updateSprite();
	}
}

class UIButtonFrameTextSwitch : UIButtonSwitch
{
	private sef::FrameDrawable@ m_frameDrawable;

	private ::string m_sequenceA;
	private ::string m_sequenceB;

	private uint m_textColorA;
	private uint m_textColorB;

	private ::string m_text;
	private sef::Font@ m_font;

	private sef::TextDrawable@ m_textDrawable;

	UIButtonFrameTextSwitch(
		const ::string &in frameSprite,
		const ::string &in sequenceA,
		const ::string &in sequenceB,
		const ::string &in text,
		sef::Font@ font,
		const uint textColorA,
		const uint textColorB,
		const ::vector2 &in unscaledSize,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f,
		const bool highQuality = true)
	{
		m_sequenceA = sequenceA;
		m_sequenceB = sequenceB;
		m_textColorA = textColorA;
		m_textColorB = textColorB;
		m_text = text;
		@m_font = @font;

		@m_frameDrawable =
			sef::FrameDrawable(
				frameSprite,
				unscaledSize,
				false, // borderOutside
				highQuality);

		super(
			@m_frameDrawable,
			normPos,
			@beginningAnimation,
			origin,
			scale);

		updateText();
	}

	void setText(const ::string &in text)
	{
		m_text = text;
	}

	::string getText() const
	{
		return m_text;
	}

	sef::FrameDrawable@ getFrameDrawable()
	{
		return @m_frameDrawable;
	}

	::string generateString() const
	{
		const ::string sequence = isEnabled() ? m_sequenceA : m_sequenceB;
		const ::string preText  = isEnabled() ? ::AssembleColorCode(m_textColorA) : ::AssembleColorCode(m_textColorB);
		return sequence + preText + m_text;
	}

	private void updateText()
	{
		if (m_textDrawable is null)
		{
			@m_textDrawable = m_frameDrawable.setText(generateString(), @m_font, sef::Color(0xFFFFFFFF), 1.0f);
		}
		else
		{
			m_textDrawable.setText(generateString());
		}
	}

	void update()
	{
		UIButtonSwitch::update();
		updateText();
	}
}

} // namespace sef
