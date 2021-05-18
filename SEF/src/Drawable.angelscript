namespace sef {

interface Drawable
{
	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color);
	::vector2 getSize() const;
	::string getName() const;
	bool isInWorldSpace() const;
	::vector2 getGravity() const;
}

class SpriteDrawable : sef::Drawable, sef::UIEffectManager
{
	protected ::string m_spriteName;
	protected float m_angle = 0.0f;
	protected sef::Color m_color;

	::vector2 m_gravityOffset(0.0f);
	::vector2 m_gravity(0.0f);
	float m_superScale = 1.0f;

	SpriteDrawable(
		const ::string &in spriteName,
		const float angle = 0.0f,
		const uint color = 0xFFFFFFFF)
	{
		m_spriteName = spriteName;
		m_angle = angle;
		m_color = sef::Color(color);
	}

	::vector2 getGravity() const
	{
		return m_gravity;
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		const sef::Color drawColor(color * m_color * sef::Color(computeEffectColor()));

		updateEffects();
		drawEffects();

		::SetSpriteOrigin(m_spriteName, origin);
		::DrawShapedSprite(
			m_spriteName,
			pos + computeEffectOffset(),
			size * m_superScale * computeEffectScale(),
			drawColor.getAlpha() * computeEffectAlpha(),
			drawColor.getVector3(),
			m_angle + computeEffectAngle());
	}

	void setAngle(const float angle)
	{
		m_angle = angle;
	}

	float getAngle() const
	{
		return m_angle;
	}

	::vector2 getSize() const
	{
		return ::GetSpriteFrameSize(m_spriteName);
	}

	::string getName() const
	{
		return m_spriteName;
	}

	void setName(const ::string &in spriteName)
	{
		m_spriteName = spriteName;
	}

	bool isInWorldSpace() const
	{
		return false;
	}

	void setColor(const sef::Color@ color)
	{
		m_color = color;
	}

	sef::Color getColor() const
	{
		return m_color;
	}
}

class SpriteFrameDrawable : sef::SpriteDrawable
{
	private uint m_columns;
	private uint m_rows;
	private uint m_frame;

	SpriteFrameDrawable(
		const ::string &in spriteName,
		const uint columns,
		const uint rows,
		const uint frame,
		const float angle = 0.0f,
		const uint color = 0xFFFFFFFF)
	{
		super(spriteName, angle, color);
		m_columns = columns;
		m_rows = rows;
		m_frame = frame;
	}

	void setFrame(const uint frame)
	{
		m_frame = frame;
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		setupFrames();
		SpriteDrawable::draw(pos, size, origin, color);
	}

	::vector2 getSize() const
	{
		setupFrames();
		return SpriteDrawable::getSize();
	}

	private void setupFrames()
	{
		::SetupSpriteRects(getName(), m_columns, m_rows);
		::SetSpriteRect(getName(), m_frame);
	}

	bool isInWorldSpace() const
	{
		return false;
	}
}

class FlipSpriteFrameDrawable : sef::SpriteFrameDrawable
{
	bool flipX = false;
	bool flipY = false;

	FlipSpriteFrameDrawable(
		const ::string &in spriteName,
		const uint columns,
		const uint rows,
		const uint frame,
		const float angle = 0.0f,
		const uint color = 0xFFFFFFFF)
	{
		super(spriteName, columns, rows, frame, angle, color);
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color) override
	{
		SetSpriteFlipX(m_spriteName, flipX);
		SetSpriteFlipY(m_spriteName, flipY);
		SpriteFrameDrawable::draw(pos, size, origin, @color);
	}
}

} // namespace sef
