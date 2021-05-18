namespace sef {

interface UIButtonIterationListener
{
	bool move(const ::vector2 &in direction);
}

class UIButtonIterator
{
	protected sef::UILayer@ m_layer;

	protected sef::UIButton@ m_current;

	private ::string m_first = "";

	UIButtonIterator(sef::UILayer@ layer, const ::string &in first)
	{
		@m_layer = @layer;
		m_first = first;
	}

	void setFirst(const ::string &in name)
	{
		m_first = name;
	}

	void move(const ::vector2 &in direction)
	{
		if (m_current is null)
		{
			UIButtonIterator::grabFirst(false /*acceptNoneOption*/);
			return;
		}

		sef::UIButton@[]@ buttons = m_layer.getButtons();

		const ::vector2 screenSize(::GetScreenSize());

		float closerProduct = 0.0f;
		float currentDistance = ::max(screenSize.x, screenSize.y);

		sef::UIButton@ newCurrent = @m_current;
		for (uint t = 0; t < buttons.length(); t++)
		{
			if (!buttons[t].iterable)
				continue;

			const vector2 currentNormPos(m_current.getNormPos() + sef::math::normalizePosition(m_current.getScrollOffset().getAbsoluteOffset()));
			const vector2 buttonNormPos(buttons[t].getNormPos() + sef::math::normalizePosition(buttons[t].getScrollOffset().getAbsoluteOffset()));

			const float distance = ::distance(currentNormPos, buttonNormPos);
			const ::vector2 b(::normalize(buttonNormPos - currentNormPos));

			const float value = distance == 0.0f ? 0.0f : (sef::math::dot(direction, b) / distance);

			if ((value > closerProduct && m_current !is buttons[t]))
			{
				closerProduct = value;
				@newCurrent = @(buttons[t]);
			}
		}
		@m_current = @newCurrent;
	}

	sef::UILayer@ getLayer()
	{
		return @m_layer;
	}

	sef::UIButton@ getCurrent()
	{
		return @m_current;
	}

	void setCurrent(sef::UIButton@ current)
	{
		@m_current = @current;
	}

	bool grabFirstInList()
	{
		sef::UIButton@[]@ buttons = m_layer.getButtons();
		for (uint t = 0; t < buttons.length(); t++)
		{
			if (buttons[t].iterable && !buttons[t].isDismissed())
			{
				@m_current = @(buttons[t]);
				return true;
			}
		}
		return false;
	}

	bool grab(const ::string &in name)
	{
		sef::UIButton@ button = cast<sef::UIButton>(m_layer.getElement(name));
		return grab(@button);
	}

	bool grab(sef::UIButton@ element)
	{
		if (element is null || element.isDismissed())
			return false;

		if (element !is null && element.iterable && !element.isDismissed())
		{
			#if TESTING
				if (m_current !is element)
					::print("GRABBED: " + element.getName());
			#endif
			@m_current = @element;
		}
		return true;
	}

	bool grabFirst(const bool acceptNoneOption)
	{
		@m_current = null;
		if (m_first != "")
		{
			UIButtonIterator::grab(m_first);
		}

		if (m_current is null && (!acceptNoneOption || m_first != "NONE"))
		{
			return grabFirstInList();
		}
		return true;
	}

	::KEY_STATE getEnterState()
	{
		return sef::input::global.getEnterState();
	}
}

} // namespace sef
