namespace sef {

enum ELEMENT_STATUS
{
	ES_DEFAULT,
	ES_DISMISSED,
	ES_UNKNOWN
}

class UILayer
{
	protected sef::UIElement@[] m_elements;
	private ::string m_name;
	private bool m_isPopup = false;
	private uint m_dismissedElementCount = 0;
	private float m_layerElapsedTime = 0.0f;

	sef::UIButtonDpadIterator@ iterator;

	bool recoverFirstLayerWhenRemoved = true;
	bool alwaysActive = false;

	bool visible = true;

	UILayer(const ::string &in name, const bool iterable = false, const ::string first = "")
	{
		m_name = name;

		if (iterable)
			@iterator = sef::UIButtonDpadIterator(this, first);
	}

	::string getName() const
	{
		return m_name;
	}

	void setPopup(const bool isPopup)
	{
		m_isPopup = isPopup;
	}

	bool isPopup() const
	{
		return m_isPopup;
	}

	void insertBackgroundElement(sef::UIElement@ element, uint order = 0)
	{
		remove(element.getName()); // check if it exists to avoid duplicate items

		order = min(order, m_elements.length());

		m_elements.insertAt(order, @element);
	}

	void insertElement(sef::UIElement@ element)
	{
		remove(element.getName()); // check if it exists to avoid duplicate items
		m_elements.insertLast(@element);
	}

	bool isButtonPressed(const ::string &in elementName) const
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			sef::UIButton@ button = cast<sef::UIButton>(@m_elements[t]);
			if (button !is null)
			{
				if (button.getName() == elementName)
				return button.isPressed();
			}
		}
		return false;
	}

	sef::ELEMENT_STATUS getElementStatus(const ::string &in name) const
	{
		sef::UIElement@ element = getElement(name);
		if (element is null)
		{
			return sef::ES_UNKNOWN;
		}
		else
		{
			return element.isDismissed() ? sef::ES_DISMISSED : sef::ES_DEFAULT;
		}
	}

	void dismiss(const ::string &in elementName)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == elementName)
				m_elements[t].dismiss();
		}
	}

	void bringToFront(const ::string &in elementName)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == elementName)
			{
				sef::UIElement@ element = m_elements[t];
				m_elements.removeAt(t);
				m_elements.insertLast(@element);
				return;
			}
		}
	}

	bool isPointInAnyButton(const ::vector2 &in p)
	{
		return (getButtonOnPoint(p) !is null);
	}

	sef::UIButton@ getButtonOnPoint(const ::vector2 &in p)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			sef::UIButton@ button = cast<sef::UIButton>(@m_elements[t]);
			if (button !is null)
			{
				if (button.isPointInside(p))
					return @button;
			}
		}
		return null;
	}

	sef::UIButton@ getButtonDrawableAreaOnPoint(const ::vector2 &in p)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			sef::UIButton@ button = cast<sef::UIButton>(@m_elements[t]);
			if (button !is null)
			{
				if (button.isPointInsideDrawableArea(p))
					return @button;
			}
		}
		return null;
	}

	void dismissAllElements()
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			m_elements[t].dismiss();
		}
	}

	void remove(const ::string &in elementName)
	{
		for (uint t = 0; t < m_elements.length();)
		{
			if (m_elements[t].getName() == elementName)
			{
				m_elements.removeAt(t);
				continue;
			}
			t++;
		}
	}

	void remove(const sef::UIElement@ element)
	{
		for (uint t = 0; t < m_elements.length();)
		{
			if (element is (m_elements[t]))
			{
				m_elements.removeAt(t);
				continue;
			}
			t++;
		}
	}

	bool elementExists(const ::string &in name) const
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == name)
				return true;
		}
		return false;

	}

	sef::UIElement@ getElement(const ::string &in name)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == name)
				return @m_elements[t];
		}
		return null;
	}

	void sendToBeginning(const ::string &in name)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == name)
			{
				sef::UIElement@ element = m_elements[t];
				m_elements.removeAt(t);
				m_elements.insertAt(0, @element);
				return;
			}
		}
	}

	void sendToEnd(const ::string &in name)
	{
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_elements[t].getName() == name)
			{
				sef::UIElement@ element = m_elements[t];
				m_elements.removeAt(t);
				m_elements.insertLast(@element);
				return;
			}
		}
	}

	sef::UIButton@[]@ getButtons()
	{
		sef::UIButton@[] r;
		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			sef::UIButton@ button = cast<sef::UIButton>(@m_elements[t]);
			if (button !is null)
			{
				r.insertLast(@button);
			}
		}
		return @r;
	}

	sef::UIButton@ getButton(const ::string &in name)
	{
		return cast<sef::UIButton>(getElement(name));
	}

	sef::UIDrawable@ getDrawable(const ::string &in name)
	{
		return cast<sef::UIDrawable>(getElement(name));
	}

	sef::UIElement@ getElement(const uint t)
	{
		if (t < m_elements.length())
			return @m_elements[t];
		else
			return null;
	}

	const sef::UIElement@[]@ getElements() const
	{
		return @m_elements;
	}

	bool isLastElement(const ::string &in name)
	{
		if (m_elements.length() > 0)
		{
			return m_elements[m_elements.length() - 1].getName() == name;
		}
		else
		{
			return false;
		}
	}

	void draw()
	{
		if (!visible)
			return;

		const uint length = m_elements.length();
		for (uint t = 0; t < length; t++)
		{
			m_elements[t].draw();
		}
	}

	void update()
	{
		// update the holder. This class cancels valid touches in order 
		// to avoid pressing overlaped buttons
		sef::internal::holder.update();

		for (int t = (m_elements.length() - 1); t >= 0; t--)
		{
			if (!m_elements[t].isDismissed())
				m_elements[t].update();
		}

		if (iterator !is null)
			iterator.update();

		m_layerElapsedTime += GetLastFrameElapsedTimeF();
	}

	float getElapsedTime() const
	{
		return m_layerElapsedTime;
	}

	void updateDismissedElements()
	{
		for (int t = (m_elements.length() - 1); t >= 0; t--)
		{
			if (m_elements[t].isDismissed())
				m_elements[t].update();

			if (m_elements[t].isDead())
			{
				m_elements.removeAt(t);
				m_dismissedElementCount++;
			}
		}		
	}

	bool isEmpty() const
	{
		return (m_elements.length() == 0);
	}

	bool isAlwaysActive() const
	{
		return alwaysActive;
	}

	uint getNumElements() const
	{
		return m_elements.length();
	}

	void onLayerRemoved()
	{
	}
}

class DismissAllElementsEvent : sef::Event
{
	private sef::UILayer@ m_layer;

	DismissAllElementsEvent(sef::UILayer@ layer)
	{
		@m_layer = @layer;
	}

	void run() override
	{
		if (m_layer !is null)
			m_layer.dismissAllElements();
	}
}

} // namespace sef
