namespace sef {

class UIDrawableText : sef::UIDrawable
{
	protected sef::TextDrawable@ m_textDrawable;

	UIDrawableText(
		const ::vector2 &in normPos,
		const ::vector2 &in origin,
		sef::Font@ font,
		const ::string &in text,
		const float scale,
		const bool centered,
		sef::WaypointManager@ beginningAnimation,
		const bool worldSpace = false,
		const uint color = 0xFFFFFFFF)
	{
		@m_textDrawable = sef::TextDrawable(@font, text, scale, worldSpace, color);
		m_textDrawable.centered = centered;

		super(@m_textDrawable, normPos, @beginningAnimation, origin);
	}

	::vector2 getAbsoluteMin() const override
	{
		const ::vector2 screenSpacePos((m_normPos * ::GetScreenSize()));
		return screenSpacePos + m_textDrawable.computeParallaxOffset(screenSpacePos) - (getSize() * m_origin);
	}

	void setZPos(const float z)
	{
		m_textDrawable.zPos = z;
	}

	void setText(const ::string &in text)
	{
		m_textDrawable.setText(text);
	}

	sef::TextDrawable@ getTextDrawable()
	{
		return @m_textDrawable;
	}

	::string getText() const
	{
		return m_textDrawable.getText();
	}

	void setColor(const uint color)
	{
		m_textDrawable.setColor(color);
	}
}

} // namespace sef
