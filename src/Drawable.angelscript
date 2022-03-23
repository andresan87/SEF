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

	SpriteDrawable(
		const ::string &in spriteName,
		const float angle,
		const vector3 &in color)
	{
		m_spriteName = spriteName;
		m_angle = angle;
		m_color = sef::Color(color);
	}

	::vector2 getGravity() const override
	{
		return m_gravity;
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color) override
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

	::vector2 getSize() const override
	{
		return ::GetSpriteFrameSize(m_spriteName);
	}

	::string getName() const override
	{
		return m_spriteName;
	}

	void setName(const ::string &in spriteName)
	{
		m_spriteName = spriteName;
	}

	bool isInWorldSpace() const override
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

	SpriteFrameDrawable(
		const ::string &in spriteName,
		const uint columns,
		const uint rows,
		const uint frame,
		const float angle,
		const vector3 &in color)
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

	uint getFrame() const
	{
		return m_frame;
	}

	void draw(const ::vector2 &in pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color) override
	{
		setupFrames();
		SpriteDrawable::draw(pos, size, origin, color);
	}

	::vector2 getSize() const override
	{
		setupFrames();
		return SpriteDrawable::getSize();
	}

	private void setupFrames()
	{
		::SetupSpriteRects(getName(), m_columns, m_rows);
		::SetSpriteRect(getName(), m_frame);
	}

	bool isInWorldSpace() const override
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

class ShadowedSpriteFrameDrawable : sef::SpriteFrameDrawable
{
	vector2 shadowOffset = vector2(2.0f);
	sef::Color shadowColor = sef::Color(0x66000000);

	ShadowedSpriteFrameDrawable(
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
		sef::Color finalShadowColor = shadowColor;
		finalShadowColor.a *= color.a;
		SpriteFrameDrawable::draw(pos + shadowOffset, size, origin, @finalShadowColor);
		SpriteFrameDrawable::draw(pos, size, origin, @color);
	}
}

} // namespace sef
