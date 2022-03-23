namespace sef {

class HorizontalBarDrawable : Drawable
{
	private ::string m_backgroundTiles;
	private ::vector2 m_frameSize;

	private bool m_borderOutside;

	private sef::Color m_frameColor;

	HorizontalBarDrawable(
		const ::string &in backgroundTiles,
		const ::vector2 &in frameSize)
	{
		m_frameSize = frameSize;
		m_backgroundTiles = backgroundTiles;
		m_frameColor = sef::Color(1.0f, ::vector3(1.0f));
	}

	void setBackgroundTiles(const ::string &in backgroundTiles)
	{
		m_backgroundTiles = backgroundTiles;
	}

	::string getBackgroundTiles() const
	{
		return m_backgroundTiles;
	}

	void setFrameColor(const sef::Color frameColor)
	{
		m_frameColor = frameColor;
	}

	sef::Color getFrameColor() const
	{
		return m_frameColor;
	}

	void setSize(const ::vector2 &in size)
	{
		m_frameSize = size;
	}

	::vector2 getSize() const override
	{
		return m_frameSize;
	}

	::string getName() const override
	{
		return getBackgroundTiles();
	}

	void draw(const ::vector2 &in _pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ _color) override
	{
		const sef::Color frameColor(_color * m_frameColor);
		::vector2 pos(_pos);
		::vector2 middleSize(size);
		::SetupSpriteRects(m_backgroundTiles, 3, 1);
		::SetSpriteOrigin(m_backgroundTiles, ::vector2(0));
		::vector2 tileSize(::GetSpriteFrameSize(m_backgroundTiles));

		if (size.x < tileSize.x * 2.0f)
			tileSize.x = size.x / 2.0f;

		tileSize.y = size.y;
		tileSize.x = min(tileSize.x, size.y);

		middleSize.x -= tileSize.x * 2.0f;

		pos += tileSize;

		pos -= origin * (middleSize + (tileSize * 2));
		
		// left corner
		::SetSpriteRect(m_backgroundTiles, 0);
		drawSprite(m_backgroundTiles, pos, ::vector2(1.0f, 0.0f), tileSize, frameColor);

		// bar
		if (middleSize.x > 0.0f)
		{
			::SetSpriteRect(m_backgroundTiles, 1);
			drawSprite(m_backgroundTiles, pos, ::vector2(0.0f, 0.0f), ::vector2(middleSize.x, tileSize.y), frameColor);
		}

		// right corner
		::SetSpriteRect(m_backgroundTiles, 2);
		drawSprite(m_backgroundTiles, pos + ::vector2(middleSize.x, 0.0f), ::vector2(0.0f, 0.0f), tileSize, frameColor);
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

	::vector2 getGravity() const override
	{
		return vector2(0.0f);
	}

	bool isInWorldSpace() const override
	{
		return false;
	}
}

} // namespace sef
