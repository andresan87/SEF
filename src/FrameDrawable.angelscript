namespace sef {

class FrameDrawable : Drawable
{
	private ::string m_backgroundTiles;
	private ::vector2 m_frameSize;

	private bool m_borderOutside;
	private bool m_highQuality;

	private sef::Drawable@[] m_addings;

	float addingScale = 1.0f;

	private sef::Color m_frameColor;

	float borderScale = 1.0f;

	FrameDrawable(
		const ::string &in backgroundTiles,
		const ::vector2 &in frameSize,
		const bool borderOutside = false,
		const bool highQuality = true)
	{
		m_frameSize = frameSize;
		m_borderOutside = borderOutside;
		m_backgroundTiles = backgroundTiles;
		m_highQuality = highQuality;

		m_frameColor = sef::Color(1.0f, ::vector3(1.0f));
	}

	::vector2 getGravity() const
	{
		return vector2(0.0f);
	}

	void setHighQuality(const bool highQuality)
	{
		m_highQuality = highQuality;
	}

	void setBackgroundTiles(const ::string &in backgroundTiles)
	{
		m_backgroundTiles = backgroundTiles;
	}

	void setFrameColor(const sef::Color frameColor)
	{
		m_frameColor = frameColor;
	}

	sef::TextDrawable@ setText(const ::string &in text, sef::Font@ font, const sef::Color@ textColor, const float textScale)
	{
		sef::TextDrawable textDrawable(@font, text, textScale, false, textColor.getUInt());
		m_addings.insertLast(@textDrawable);
		return @textDrawable;
	}

	sef::SpriteFrameDrawable@ setSprite(
		const ::string &in spriteName,
		const uint columns,
		const uint rows,
		const uint frame,
		const float angle = 0.0f,
		const uint color = 0xFFFFFFFF)
	{
		sef::SpriteFrameDrawable sprite(spriteName, columns, rows, frame, angle, color);
		m_addings.insertLast(@sprite);
		return @sprite;
	}

	void removeAllAddings()
	{
		m_addings.resize(0);
	}

	void removeAllSpriteAddings()
	{
		for (uint t = 0; t < m_addings.length();)
		{
			if (cast<sef::SpriteDrawable>(@m_addings[t]) !is null)
				m_addings.removeAt(t);
			else
				t++;
		}
	}

	void removeSpriteAdding(const ::string &in spriteName)
	{
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::SpriteDrawable@ sprite = cast<sef::SpriteDrawable>(@m_addings[t]);
			if (sprite !is null)
			{
				if (sprite.getName() == spriteName)
				{
					m_addings.removeAt(t);
					return;
				}
			}
		}
	}

	void setSize(const ::vector2 &in size)
	{
		m_frameSize = size;
	}

	::vector2 getSize() const
	{
		return m_frameSize;
	}

	::vector2 getUnscaledSize() const
	{
		return m_frameSize;
	}

	::string getName() const
	{
		return getBackgroundTiles();
	}

	::string getBackgroundTiles() const
	{
		return m_backgroundTiles;
	}

	void draw(const ::vector2 &in _pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		if (m_highQuality)
			drawHighQuality(_pos, size, origin, color * m_frameColor);
		else
			drawLowQuality(_pos, size, origin, color * m_frameColor);

		const ::vector2 min(_pos - (origin * size));
		const ::vector2 max(min + size);
		const ::vector2 center((min + max) / 2.0f);
		drawAddings(center, size, ::vector2(0.5f), @color);
	}

	private void drawHighQuality(
		const ::vector2 &in _pos,
		const ::vector2 &in size,
		const ::vector2 &in origin,
		const sef::Color@ color)
	{
		if (m_backgroundTiles == "")
			return;

		::vector2 pos(_pos);
		::vector2 middleSize(size);
		::SetupSpriteRects(m_backgroundTiles, 3, 3);
		::SetSpriteOrigin(m_backgroundTiles, ::vector2(0));
		::vector2 tileSize((::GetSpriteFrameSize(m_backgroundTiles)) * borderScale);

		if (size.x < tileSize.x * 2.0f)
			tileSize.x = size.x / 2.0f;
		if (size.y < tileSize.y * 2.0f)
			tileSize.y = size.y / 2.0f;

		if (!m_borderOutside)
		{
			middleSize -= tileSize * 2.0f;
			pos += tileSize;
		}
		pos -= origin * (middleSize + ((m_borderOutside) ? ::vector2(0) : (tileSize * 2)));
		
		// top left corner
		::SetSpriteRect(m_backgroundTiles, 0);
		drawSprite(m_backgroundTiles, pos, ::vector2(1), tileSize, color);

		// top bar
		if (middleSize.x > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 1);
			drawSprite(m_backgroundTiles, pos, ::vector2(0, 1), ::vector2(middleSize.x, tileSize.y), color);
		}

		// top right corner
		::SetSpriteRect(m_backgroundTiles, 2);
		drawSprite(m_backgroundTiles, pos + ::vector2(middleSize.x, 0.0f), ::vector2(0, 1), tileSize, color);

		// left bar
		if (middleSize.y > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 3);
			drawSprite(m_backgroundTiles, pos, ::vector2(1, 0), ::vector2(tileSize.x, middleSize.y), color);
		}

		// middle
		if (middleSize.x > 0.0f && middleSize.y > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 4);
			drawSprite(m_backgroundTiles, pos, ::vector2(0), middleSize, color);
		}

		// right bar
		if (middleSize.y > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 5);
			drawSprite(m_backgroundTiles, pos + ::vector2(middleSize.x, 0.0f), ::vector2(0), ::vector2(tileSize.x, middleSize.y), color);
		}

		// bottom left corner
		::SetSpriteRect(m_backgroundTiles, 6);
		drawSprite(m_backgroundTiles, pos + ::vector2(0.0f, middleSize.y), ::vector2(1, 0), tileSize, color);

		// bottom bar
		if (middleSize.x > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 7);
			drawSprite(m_backgroundTiles, pos + ::vector2(0.0f, middleSize.y), ::vector2(0), ::vector2(middleSize.x, tileSize.y), color);
		}

		// bottom right corner
		::SetSpriteRect(m_backgroundTiles, 8);
		drawSprite(m_backgroundTiles, pos + middleSize, ::vector2(0, 0), tileSize, color);
	}

	private void drawLowQuality(const ::vector2 &in _pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		if (m_backgroundTiles == "")
			return;

		::SetupSpriteRects(m_backgroundTiles, 1, 1);
		::SetSpriteRect(m_backgroundTiles, 0);
		::SetSpriteOrigin(m_backgroundTiles, ::vector2(0));
		drawSprite(m_backgroundTiles, _pos, origin, size, color);
	}

	private void drawAddings(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		for (uint t = 0; t < m_addings.length(); t++)
		{
			const ::vector2 actualSize(sef::math::max(getSize(), vector2(0.01f)));
			const ::vector2 spriteScale((size.x / actualSize.x), (size.y / actualSize.y));
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			const ::vector2 gravityVectorLength((m_frameSize * addingScale) * 0.5f);
			if (text !is null)
			{
				const ::vector2 textScale(actualSize.x, (size.y / actualSize.y));
				text.draw(pos + (gravityVectorLength * text.gravity * spriteScale) + (text.gravityOffset) * spriteScale, textScale * text.getSize(), origin, color);
			}
			else
			{
				const ::vector2 gravity(m_addings[t].getGravity() * spriteScale);
				::vector2 offset(0.0f);
				sef::SpriteDrawable@ spriteDrawable = cast<sef::SpriteDrawable>(@(m_addings[t]));
				if (spriteDrawable !is null)
				{
					offset = (spriteDrawable.m_gravityOffset) * spriteScale;
				}
				m_addings[t].draw(pos + (gravityVectorLength * gravity) + offset, spriteScale * m_addings[t].getSize() * addingScale, origin, color);
			}
		}
	}

	sef::TextDrawable@ getText(const uint idx) const
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				if (iter == idx)
				{
					return @text;
				}
				iter++;
			}
		}
		return null;
	}

	::string getTextStr(const uint idx) const
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				if (iter == idx)
				{
					return text.getText();
				}
				iter++;
			}
		}
		return "";
	}

	bool removeText(const uint idx)
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				if (iter == idx)
				{
					m_addings.removeAt(t);
					return true;
				}
				iter++;
			}
		}
		return false;
	}

	bool appendToText(const uint idx, const ::string &in str)
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				if (iter == idx)
				{
					text.setText(text.getText() + str);
					return true;
				}
				iter++;
			}
		}
		return false;
	}

	uint getNumAddings() const
	{
		return m_addings.length();
	}

	bool setText(const uint idx, const ::string &in str)
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				if (iter == idx)
				{
					text.setText(str);
					return true;
				}
				iter++;
			}
		}
		return false;
	}

	bool replaceText(const uint idx, const ::string &in str)
	{
		return setText(idx, str);
	}

	void replaceText(const uint idx, const ::string &in toReplace, const ::string replaceBy)
	{
		setText(0, sef::string::replace(getText(0).getText(), toReplace, replaceBy));
	}

	sef::SpriteDrawable@ setSprite(const ::string &in spriteName)
	{
		return setSprite(spriteName, 1.0f, 0.0f);
	}

	sef::SpriteDrawable@ setSprite(const ::string &in spriteName, const float scale, const float angle)
	{
		sef::SpriteDrawable sprite(spriteName, angle);
		sprite.m_superScale = scale;
		m_addings.insertLast(@sprite);
		return @sprite;
	}

	sef::SpriteDrawable@ setBackgroundSprite(const ::string &in spriteName, const float angle = 0.0f)
	{
		sef::SpriteDrawable sprite(spriteName, angle);
		m_addings.insertAt(0, @sprite);
		return @sprite;
	}

	sef::SpriteDrawable@ setSprite(
		const uint idx,
		const ::string &in spriteName,
		const float angle = 0.0f)
	{
		if (idx < m_addings.length())
		{
			sef::SpriteDrawable sprite(spriteName, angle);
			@m_addings[idx] = (@sprite);
			return @sprite;
		}
		else if (idx == m_addings.length())
		{
			return setSprite(
				spriteName,
				1.0f,
				angle);
		}
		return null;
	}

	void resizeToTextSize(const ::vector2 &in borderSize)
	{
		resizeToTextSize(borderSize, ::vector2(1.0f));
	}

	void resizeToTextSize(const ::vector2 &in borderSize, const ::vector2 &in minSize)
	{
		m_frameSize = borderSize;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::TextDrawable@ text = cast<sef::TextDrawable>(@m_addings[t]);
			if (text !is null)
			{
				const ::vector2 size(text.getSize());
				m_frameSize = sef::math::max(sef::math::max(size + borderSize, m_frameSize), minSize);
			}
		}
	}

	sef::SpriteDrawable@ getSpriteDrawable(const uint idx)
	{
		uint iter = 0;
		for (uint t = 0; t < m_addings.length(); t++)
		{
			sef::SpriteDrawable@ sprite = cast<sef::SpriteDrawable>(@m_addings[t]);
			if (sprite !is null)
			{
				if (iter == idx)
				{
					return @sprite;
				}
				iter++;
			}
		}
		return null;
	}

	void reverseAddings()
	{
		m_addings.reverse();
	}

	private void drawSprite(
		const ::string &in sprite,
		const ::vector2 &in pos,
		const ::vector2 &in origin,
		const ::vector2 &in size,
		const sef::Color@ color)
	{
		::DrawShapedSprite(sprite, pos - (origin * size), size, color.getAlpha(), color.getVector3(), 0.0f);
	}

	bool isInWorldSpace() const
	{
		return false;
	}
}

} // namespace sef
