namespace sef {

class UIDrawable : sef::UIAnimatedElement, sef::UIEffectManager
{
	::dictionary@ customData;

	protected ::vector2 m_origin;
	protected ::vector2 m_normPos;
	protected ::vector2 m_positionOffset;
	protected float m_scale;
	protected sef::Drawable@ m_drawable;
	protected sef::Color m_color;
	private ::string m_elementName;
	protected bool m_hidden;

	bool scaleOnlyAddings = false;

	private sef::WaypointManager@ m_dismissEffect = null;

	::vector2 m_currentNormPos;
	float m_currentScale;
	sef::Color m_currentColor;
	sef::DimController@ m_dimController;

	private sef::UIScrollOffset@ m_scrollOffset = sef::UIScrollOffset();

	private void UIDrawableConstructor(
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		const ::vector2 &in origin,
		const float scale)
	{
		m_hidden = false;
		m_normPos = normPos;
		m_currentNormPos = normPos;
		m_currentScale = m_scale = scale;
		m_origin = origin;
		@m_drawable = @drawable;
		m_elementName = drawable.getName();
		m_color = sef::Color(0xFFFFFFFF);
		m_positionOffset = ::vector2(0.0f);
	}

	UIDrawable(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(sef::uieffects::createSlideFromEdgeEffect(normPos));
		UIDrawableConstructor(sef::SpriteDrawable(spriteName), normPos, origin, scale);
	}

	UIDrawable(
		const ::string &in elementName,
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(sef::uieffects::createSlideFromEdgeEffect(normPos));
		UIDrawableConstructor(sef::SpriteDrawable(spriteName), normPos, origin, scale);
		setName(elementName);
	}

	UIDrawable(
		const ::string &in spriteName,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(beginningAnimation);
		UIDrawableConstructor(sef::SpriteDrawable(spriteName), normPos, origin, scale);
	}

	UIDrawable(
		const ::string &in elementName,
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(beginningAnimation);
		UIDrawableConstructor(@drawable, normPos, origin, scale);
		setName(elementName);
	}

	UIDrawable(
		sef::Drawable@ drawable,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		super(beginningAnimation);
		UIDrawableConstructor(@drawable, normPos, origin, scale);
	}

	const sef::Color@ getDimControllerColor()
	{
		if (m_dimController !is null)
			return m_dimController.getDimColor();
		else
			return @sef::WHITE_COLOR;
	}

	void setScrollOffset(sef::UIScrollOffset@ scrollOffset)
	{
		@m_scrollOffset = @scrollOffset;
	}

	sef::UIScrollOffset@ getScrollOffset()
	{
		return @m_scrollOffset;
	}

	void setDismissEffect(sef::WaypointManager@ dismissEffect)
	{
		@m_dismissEffect = @dismissEffect;
	}

	sef::WaypointManager@ getDismissEffect()
	{
		return @m_dismissEffect;
	}

	::vector2 getPositionOffset() const
	{
		return m_positionOffset;
	}

	void setNormPos(const ::vector2 &in normPos)
	{
		m_normPos = normPos;
	}

	::vector2 addToNormPos(const ::vector2 &in normPos)
	{
		return (m_normPos += normPos);
	}

	::vector2 addAbsValueToNormPos(const ::vector2 &in absValue)
	{
		return (m_normPos += sef::math::normalizePosition(absValue));
	}

	void setNormPosX(const float x)
	{
		m_normPos.x = x;
	}

	void setNormPosY(const float y)
	{
		m_normPos.y = y;
	}

	::vector2 getNormPos() const
	{
		return m_normPos;
	}

	float getNormPosX() const
	{
		return m_normPos.x;
	}

	float getNormPosY() const
	{
		return m_normPos.y;
	}

	void setPositionOffset(const ::vector2 &in positionOffset)
	{
		m_positionOffset = positionOffset;
	}

	void setScale(const float scale)
	{
		m_scale = m_currentScale = scale;
	}

	void dismiss() override
	{
		if (!isDismissed())
		{
			sef::WaypointManager@ dismissAnimation = @m_dismissEffect;
			if (dismissAnimation is null)
				@dismissAnimation = sef::uieffects::createSlideOutEffect(m_currentNormPos);
			setAnimation(@dismissAnimation);

			setNormPos(m_currentNormPos - sef::math::normalizePosition(m_scrollOffset.getAbsoluteOffset()));
			setScale(m_currentScale);
			setColor(m_currentColor);

			if (customData !is null)
			{
				customData.deleteAll();
				@customData = null;
				#if TESTING
					print("Custom data deleted for " + getName());
				#endif
			}
		}
		UIAnimatedElement::dismiss();
	}

	void setHidden(const bool hidden)
	{
		m_hidden = hidden;
	}

	bool isHidden() const
	{
		return m_hidden;
	}

	sef::Drawable@ getDrawable()
	{
		return @m_drawable;
	}

	void setDrawable(sef::Drawable@ drawable)
	{
		@m_drawable = @drawable;
	}

	void dismiss(sef::WaypointManager@ animation)
	{
		if (!isDismissed())
		{
			setAnimation(@animation);
		}
		UIAnimatedElement::dismiss();
	}

	void setColor(const sef::Color color)
	{
		m_color = color;
	}

	sef::Color getColor() const
	{
		return m_color;
	}

	void setAlpha(const float a)
	{
		m_color.a = a;
	}

	float getAlpha() const
	{
		return m_color.a;
	}

	void forceCurrentColor(const sef::Color color)
	{
		m_currentColor = color;
	}

	float getScale() const
	{
		return m_scale;
	}

	void setName(const ::string &in name)
	{
		m_elementName = name;
	}

	::string getName() const
	{
		return m_elementName;
	}

	::vector2 getOrigin() const
	{
		return m_origin;
	}

	void setOrigin(const ::vector2 &in origin)
	{
		m_origin = origin;
	}

	void centralizeOrigin()
	{
		const vector2 originDelta(vector2(0.5f) - getOrigin());
		setOrigin(vector2(0.5f));
		addToNormPos(sef::math::normalizePosition(getSize()) * originDelta);
	}

	private ::vector2 getAbsoluteMiddlePoint(const ::vector2 &in normPos) const
	{
		::vector2 pos(::GetScreenSize() * normPos);
		::vector2 size(getSize());

		const ::vector2 min(pos - (m_origin * size));
		const ::vector2 max(min + size);
		return ((min + max) / 2.0f);
	}

	::vector2 getAbsoluteCurrentMiddlePoint() const
	{
		return getAbsoluteMiddlePoint(m_currentNormPos);
	}

	::vector2 getAbsoluteMiddlePoint() const
	{
		return getAbsoluteMiddlePoint(m_normPos);
	}

	::vector2 getNormalizedMiddlePoint() const
	{
		return sef::math::normalizePosition(getAbsoluteMiddlePoint(m_normPos));
	}

	::vector2 getAbsoluteMinPoint(const ::vector2 &in normPos) const
	{
		return (normPos * ::GetScreenSize()) - (getSize() * m_origin);
	}

	::vector2 getAbsoluteMaxPoint(const ::vector2 &in normPos) const
	{
		return getAbsoluteMinPoint(normPos) + getSize();
	}

	void draw() override
	{
		if (isHidden())
			return;

		if (!isVisible())
			return;

		UIAnimatedElement::draw();
		const ::vector2 pos((m_currentNormPos + computeEffectOffset()) * ::GetScreenSize());

		const sef::Color drawColor(m_currentColor * sef::Color(computeEffectAlpha(), computeEffectColor()) * getDimControllerColor());
		m_drawable.draw(pos + m_positionOffset, getSize() * computeEffectScale(), m_origin, @drawColor);

		drawEffects();
	}

	::vector2 getSize() const
	{
		return (m_currentScale * m_drawable.getSize());
	}

	::vector2 getNormSize() const
	{
		const vector2 screenSize(GetScreenSize());
		const vector2 size(m_drawable.getSize());
		return vector2((m_currentScale * size.x) / screenSize.x, (m_currentScale * size.y) / screenSize.y);
	}

	::vector2 getAbsoluteMin() const
	{
		return getAbsoluteMinPoint(m_normPos);
	}

	::vector2 getAbsoluteMax() const
	{
		return getAbsoluteMaxPoint(m_normPos);
	}

	sef::Color getCurrentColor() const
	{
		return m_currentColor;
	}

	float getCurrentScale() const
	{
		return m_currentScale;
	}

	bool isOverlapping(const sef::UIDrawable@ other, const float tolerance = 0.0f)
	{
		const vector2 thisMin = getAbsoluteMinPoint(m_currentNormPos);
		const vector2 thisMax = getAbsoluteMaxPoint(m_currentNormPos);
		const vector2 otherMin = other.getAbsoluteMinPoint(other.m_currentNormPos);
		const vector2 otherMax = other.getAbsoluteMaxPoint(other.m_currentNormPos);
		if (thisMax.x <= otherMin.x + tolerance ||
			thisMax.y <= otherMin.y + tolerance ||
			thisMin.x >= otherMax.x - tolerance ||
			thisMin.y >= otherMax.y - tolerance)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	void alignToTheLeftOf(const sef::UIDrawable@ other, const float extraAbsOffset)
	{
		const float otherAbsMinX = other.getAbsoluteMin().x;
		const float thisAbsMaxX  = getAbsoluteMax().x;
		const float absShiftX = otherAbsMinX - thisAbsMaxX;
		addToNormPos(vector2(sef::math::normalizeWidth(absShiftX + extraAbsOffset), 0.0f));
	}

	void pushToTheLeftBy(const sef::UIDrawable@ other, const float extraAbsOffset)
	{
		const float otherAbsMinX = other.getAbsoluteMin().x;
		const float thisAbsMaxX  = getAbsoluteMax().x;
		const float absShiftX = otherAbsMinX - thisAbsMaxX;
		if (absShiftX < 0.0f)
		{
			addToNormPos(vector2(sef::math::normalizeWidth(absShiftX + extraAbsOffset), 0.0f));
		}
	}

	bool isVisible() const
	{
		const ::vector2 min(getAbsoluteMin() + m_scrollOffset.getAbsoluteOffset());
		const ::vector2 max(getAbsoluteMax() + m_scrollOffset.getAbsoluteOffset());

		// compute screen boundaries
		::vector2 screenMin(0.0f);
		::vector2 screenMax(::GetScreenSize());
		if (m_drawable.isInWorldSpace())
		{
			const ::vector2 cameraPos(::GetCameraPos());
			screenMin += cameraPos;
			screenMax += cameraPos;
		}

		// check
		if (min.x > screenMax.x
		 || min.y > screenMax.y
		 || max.x < screenMin.x
		 || max.y < screenMin.y)
			return false;
		return true;
	}

	void updateCurrentPos(const sef::Waypoint@ p)
	{
		m_currentNormPos = p.pos + m_normPos + sef::math::normalizePosition(m_scrollOffset.getAbsoluteOffset());
	}

	void update() override
	{
		UIAnimatedElement::update();

		updateEffects();

		const sef::Waypoint@ p = getCurrentWaypoint();
		updateCurrentPos(@p);
		m_currentColor = m_color * p.color;

		// apply scale
		m_currentScale = m_scale;
		if (scaleOnlyAddings)
		{
			sef::FrameDrawable@ frameDrawable = cast<sef::FrameDrawable>(getDrawable());
			if (frameDrawable !is null)
			{
				frameDrawable.addingScale = p.scale;
			}
		}
		else
		{
			m_currentScale *= p.scale;
		}
	}
}

class DismissUIDrawable : sef::Event
{
	private sef::UIDrawable@ m_drawable;
	private sef::WaypointManager@ m_dismissEffect;

	DismissUIDrawable(sef::UIDrawable@ drawable, sef::WaypointManager@ dismissEffect = null)
	{
		@m_drawable = @drawable;
		@m_dismissEffect = @dismissEffect;
	}

	void run()
	{
		m_drawable.dismiss(@m_dismissEffect);
	}
}

interface DimController
{
	sef::Color@ getDimColor();
}

} // namespace sef
