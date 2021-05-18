namespace sef {

class TextDrawable : sef::Drawable, sef::UIEffectManager
{
	private ::string m_font;
	private ::string m_text;
	private float m_scale;
	private bool m_worldSpace;
	private uint m_color;

	float lineSpacing = 1.0f;
	float zPos = 0.0f;
	bool keepColor = false;
	bool centered = false;

	private float m_internalFontScale = 1.0f;

	::vector2 gravity = ::vector2(0.0f);
	::vector2 gravityOffset = ::vector2(0.0f);

	bool enableCustomAligmentOrigin = false;
	vector2 customAlignmentOrigin;

	TextDrawable(
		sef::Font@ font,
		const ::string &in text,
		const float scale,
		const bool worldSpace = false,
		const uint color = 0xFFFFFFFF)
	{
		setFont(@font);
		m_text = text;
		m_scale = scale;
		m_worldSpace = worldSpace;
		m_color = color;
	}

	::vector2 getGravity() const
	{
		return gravity;
	}

	::vector2 computeParallaxOffset(const ::vector2 &in screenSpacePos) const
	{
		return (sef::math::computeParallaxOffset(::vector3(screenSpacePos, zPos)));
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		updateEffects();
		drawEffects();

		::vector2 nPos(pos);
		if (m_worldSpace)
		{
			nPos -= ::GetCameraPos();
			nPos += computeParallaxOffset(nPos);
		}

		const float textScale = (size.y / ::max(1.0f, ::ComputeTextBoxSize(m_font, m_text).y * m_internalFontScale)) * computeEffectScale();

		// compute color
		uint finalColor;
		if (keepColor)
		{
			sef::Color c(m_color);
			finalColor = sef::Color(c.getAlpha() * color.getAlpha() * computeEffectAlpha(), c.getVector3() * computeEffectColor()).getClampedUInt();
		}
		else
		{
			finalColor = (sef::Color(m_color) * color * sef::Color(computeEffectColor())).getClampedUInt();
		}

		// draw
		if (centered || enableCustomAligmentOrigin)
		{
			sef::util::drawAlignedParagraph(nPos, m_text, m_font, finalColor, enableCustomAligmentOrigin ? customAlignmentOrigin : origin, textScale * m_internalFontScale, lineSpacing);
		}
		else
		{
			::DrawText(
				(nPos - (getSize() * textScale * (origin / m_scale))) + computeEffectOffset(),
				m_text,
				m_font,
				finalColor,
				textScale * m_internalFontScale);
		}
	}

	float fitScaleIntoWidth(const float width)
	{
		const float textWidth = computeTextBoxSize().x;
		float factor = 1.0f;
		if (textWidth > width)
		{
			factor = width / textWidth;
			m_scale *= factor;
		}
		return factor;
	}

	vector2 computeTextBoxSize() const
	{
		return ::ComputeTextBoxSize(m_font, m_text) * m_internalFontScale * m_scale;
	}

	vector2 computeAbsoluteTextBoxSize() const
	{
		return (computeTextBoxSize());
	}

	void setColor(const uint color)
	{
		m_color = color;
	}

	void setText(const ::string &in text)
	{
		m_text = text;
	}

	void setFont(sef::Font@ font)
	{
		m_font = font.getFont();
		m_internalFontScale = font.getScale();
	}

	::string getFont() const
	{
		return m_font;
	}

	::string getText() const
	{
		return m_text;
	}

	void setScale(const float scale)
	{
		m_scale = scale;
	}

	float getScale() const
	{
		return m_scale;
	}

	::vector2 getSize() const
	{
		return ::vector2((m_scale) * ::ComputeTextBoxSize(m_font, m_text) * m_internalFontScale);
	}

	float getInternalFontScale() const
	{
		return m_internalFontScale;
	}

	::string getName() const
	{
		return m_text;
	}

	bool isInWorldSpace() const
	{
		return m_worldSpace;
	}
}

} // namespace sef
