namespace sef {

class UIList : sef::UIElement
{
	private ::vector2 m_absoluteOffset;
	private ::vector2 m_rails;
	private ::vector2 m_normOrigin;

	private ::vector2 m_absoluteUnscrolledMin;
	private ::vector2 m_absoluteUnscrolledMax;

	protected sef::UIDrawable@[] m_elements;

	private ::string m_name;

	private bool m_dismissed = false;

	private sef::UIScroller@ m_scroller;

	private bool m_vertical;

	bool enableScrolling = true;

	UIList(
		const ::string &in name,
		const ::vector2 &in normOrigin,
		const bool vertical = true)
	{
		m_name = name;
		m_normOrigin = normOrigin;
		@m_scroller = sef::UIScroller();
		m_vertical = vertical;

		computeAlignment();
	}

	sef::UIDrawable@ getElement(const uint t)
	{
		if (t >= m_elements.length())
			return null;
		return @(m_elements[t]);
	}

	void insertLast(sef::UILayer@ parent, sef::UIDrawable@ element, const ::vector2 extraAbsoluteOffset = ::vector2(0.0f), const uint baseDelay = 0)
	{
		parent.insertElement(@element);
		m_elements.insertLast(@element);
		element.setNormPos(m_rails);
		updateRails(@element, extraAbsoluteOffset);

		m_absoluteUnscrolledMin = sef::math::min(m_absoluteUnscrolledMin, element.getAbsoluteMin());
		m_absoluteUnscrolledMax = sef::math::max(m_absoluteUnscrolledMax, element.getAbsoluteMax());
	}

	void resetRailsNormPos(const ::vector2 &in normPos)
	{
		m_rails = normPos;
	}

	private void computeAlignment()
	{
		// zero boundaries
		m_absoluteUnscrolledMin = ::GetScreenSize();
		m_absoluteUnscrolledMax = ::vector2(0.0f);

		// align elements
		m_rails = m_normOrigin;
		const uint elementCount = m_elements.length();
		for (uint t = 0; t < elementCount; t++)
		{
			m_elements[t].setNormPos(m_rails);
			updateRails(@(m_elements[t]), ::vector2());
		}

		// set boundaries
		if (elementCount > 0)
		{
			m_absoluteUnscrolledMin = m_elements[0].getAbsoluteMin();
			m_absoluteUnscrolledMax = m_elements[elementCount - 1].getAbsoluteMax();
		}
	}

	float getAbsoluteMinScrollY() const
	{
		return ::GetScreenSize().y - m_absoluteUnscrolledMax.y;
	}

	float getAbsoluteMaxScrollY() const
	{
		return m_absoluteUnscrolledMin.y;
	}

	void updateRails(sef::UIDrawable@ element, const ::vector2 &in extraAbsoluteOffset)
	{
		if (m_vertical)
		{
			m_rails.y += ((element.getSize().y + extraAbsoluteOffset.y) / GetScreenSize().y);
		}
		else
		{
			m_rails.x += ((element.getSize().x + extraAbsoluteOffset.x) / GetScreenSize().x);
		}
	}

	void update() override
	{
		// update offset
		if (enableScrolling)
		{
			m_scroller.update(m_absoluteUnscrolledMin, m_absoluteUnscrolledMax);
			m_absoluteOffset += m_scroller.getScroll();
			m_absoluteOffset =  m_scroller.clampAbsoluteOffsetY(m_absoluteOffset, getAbsoluteMinScrollY(), getAbsoluteMaxScrollY());

			// update elements
			for (uint t = 0; t < m_elements.length(); t++)
			{
				m_elements[t].setScrollAbsoluteOffset(m_absoluteOffset);
			}
		}
	}

	const sef::UIScroller@ getScroller() const
	{
		return @m_scroller;
	}

	void draw() override
	{
	}

	::string getName() const override
	{
		return m_name;
	}

	bool isDismissRequested() const
	{
		return m_dismissed;
	}

	bool isDismissed() const override
	{
		if (!m_dismissed)
			return false;

		for (uint t = 0; t < m_elements.length(); t++)
		{
			if (!m_elements[t].isDismissed())
				return false;
		}
		return true;
	}

	void dismiss() override
	{
		m_name += "_dismissed";
		dismissAllElements();
		m_dismissed = true;
	}

	void dismissAllElements()
	{
		for (uint t = 0; t < m_elements.length(); t++)
		{
			m_elements[t].setName(m_elements[t].getName() + "_dismissed");
			m_elements[t].dismiss();
		}
		m_elements.resize(0);
		m_rails = m_normOrigin;
	}

	vector2 getRails() const
	{
		return m_rails;
	}

	bool isDead() const override
	{
		for (uint t = 0; t < m_elements.length(); t++)
		{
			if (!m_elements[t].isDead())
				return false;
		}
		return true;
	}

	void setAbsoluteOffset(const ::vector2 &in absoluteOffset)
	{
		m_absoluteOffset = absoluteOffset;
	}

	::vector2 getAbsoluteOffset() const
	{
		return m_absoluteOffset;
	}

	uint getNumElements() const
	{
		return m_elements.length();
	}

	vector2 getAbsoluteMinPoint() const
	{
		if (m_elements.length() == 0)
			return vector2(0.0f);

		return sef::math::min(m_elements[0].getAbsoluteMin(), m_elements[m_elements.length() - 1].getAbsoluteMin());
	}

	vector2 getAbsoluteMaxPoint() const
	{
		if (m_elements.length() == 0)
			return vector2(0.0f);

		return sef::math::max(m_elements[m_elements.length() - 1].getAbsoluteMax(), m_elements[0].getAbsoluteMax());
	}
}

class UIListWithAutomaticFx : sef::UIList
{
	private uint m_stride;

	UIListWithAutomaticFx(
		const ::string &in name,
		const ::vector2 &in normOrigin,
		const bool vertical = true,
		const uint stride = 100)
	{
		super(name, normOrigin, vertical);
		m_stride = stride;
	}

	void insertLast(sef::UILayer@ parent, sef::UIDrawable@ element, const ::vector2 extraAbsoluteOffset = ::vector2(0.0f), const uint baseDelay = 0) override
	{
		UIList::insertLast(@parent, @element, extraAbsoluteOffset);

		const uint delay = (m_elements.length() * m_stride);

		element.setAnimation(sef::uieffects::createBounceAppearEffect(300, 1.1f, baseDelay + delay));
		element.setDismissEffect(sef::uieffects::createZoomEffect(
			0.2f,
			sef::Color(0xFFFFFFFF),
			sef::Color(0x00FFFFFF),
			delay / 2,
			false /*zoomIn*/,
			false /*fadeIn*/,
			200));
	}
}

class UIRadioButtonList : sef::UIListWithAutomaticFx
{
	sef::UIButtonSwitch@[] m_radioButtons;

	UIRadioButtonList(
		const ::string &in name,
		const ::vector2 &in normOrigin,
		const bool vertical = true)
	{
		super(name, normOrigin, vertical);
	}

	void insertRadioButton(sef::UILayer@ parent, sef::UIButtonSwitch@ element, const ::vector2 extraAbsoluteOffset = ::vector2(0.0f))
	{
		insertLast(@parent, @element, extraAbsoluteOffset);
		m_radioButtons.insertLast(@element);
		element.setEnabled(false);
		element.autoSwitchOnClick = false;
	}

	int getCurrent() const
	{
		for (uint j = 0; j < m_radioButtons.length(); j++)
		{
			if (m_radioButtons[j].isEnabled())
			{
				return int(j);
			}
		}
		return -1;
	}

	sef::UIButtonSwitch@ getCurrentSwitch()
	{
		for (uint j = 0; j < m_radioButtons.length(); j++)
		{
			if (m_radioButtons[j].isEnabled())
			{
				return @(m_radioButtons[j]);
			}
		}
		return null;
	}

	void activate(const uint t)
	{
		for (uint j = 0; j < m_radioButtons.length(); j++)
		{
			if (j != t)
			{
				m_radioButtons[j].setEnabled(false);
			}
			else
			{
				m_radioButtons[j].setEnabled(true);
			}
		}
	}

	void deactivateAll()
	{
		for (uint t = 0; t < m_radioButtons.length(); t++)
		{
			m_radioButtons[t].setEnabled(false);
		}		
	}

	void dismiss() override
	{
		UIListWithAutomaticFx::dismiss();
		m_radioButtons.resize(0);
	}

	void update() override
	{
		for (uint t = 0; t < m_radioButtons.length(); t++)
		{
			if (m_radioButtons[t].isPressed())
			{
				activate(t);
			}
		}

		UIListWithAutomaticFx::update();
	}
}

} // namespace sef
