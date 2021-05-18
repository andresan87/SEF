namespace sef {

interface MouseCursorPositionTracker
{
	vector2 getAbsPosition();
	bool hasMoved();
	void onHover(sef::UIButton@ button);
	bool isMouseCursorVisible();
}

sef::MouseCursorPositionTracker@ globalMouseCursorTracker;

::string globalCursorSoundEffect = "";

class UIButtonDpadIterator : sef::UIButtonIterator, sef::GameController
{
	sef::UIDrawable@ m_cursor;

	sef::UIDrawable@ m_cursorHitElement;

	bool enabled = true;

	bool enableMouseIteration = true;

	protected ::string m_elementName = "sef::iterator0";

	protected sef::Color m_color;

	UIButtonDpadIterator(sef::UILayer@ layer, const ::string &in first)
	{
		super(@layer, first);
		m_color = sef::Color(0xFFFFFFFF);
	}

	void setColor(const sef::Color color)
	{
		m_color = color;
	}

	sef::Color getColor() const
	{
		return m_color;
	}

	void move(const ::vector2 &in direction)
	{
		sef::UIButton@ previous = getCurrent();

		// perform overloaded iteration functionality and return if overload returns false
		if (previous !is null)
		{
			if (previous.iterationListener !is null)
			{
				if (!previous.isDismissed() && !previous.iterationListener.move(direction))
				{
					return;
				}
			}
		}

		UIButtonIterator::move(direction);
		createCursor(previous, direction, true);
	}

	bool isMouseCursorActive() const
	{
		return (sef::globalMouseCursorTracker !is null && sef::globalMouseCursorTracker.isMouseCursorVisible());
	}

	bool grabIfCursorExists(const ::string &in name)
	{
		if (m_cursor !is null && !isMouseCursorActive())
		{
			return grab(name);
		}
		else
		{
			return false;
		}
	}

	bool grabIfCursorExists(const sef::UIButton@ element)
	{
		return grabIfCursorExists(element.getName());
	}

	bool grab(sef::UIButton@ element) override
	{
		sef::UIButton@ previous = getCurrent();
		const bool r = UIButtonIterator::grab(@element);

		sef::UIButton@ new = getCurrent();
		if (new !is previous || (m_cursor is null || m_cursor.isDismissed()))
		{
			createCursor(@previous, ::vector2(0.0f), false);
		}
		return r;
	}

	bool isCursorCreated() const
	{
		return (m_cursor !is null);
	}

	bool grabFirst(const bool acceptNoneOption) override
	{
		if (sef::globalMouseCursorTracker !is null && sef::globalMouseCursorTracker.isMouseCursorVisible())
			return false;

		sef::UIButton@ previous = getCurrent();
		const bool r = UIButtonIterator::grabFirst(acceptNoneOption);

		sef::UIButton@ new = getCurrent();
		if (new is null)
		{
			dismissCursor(sef::uieffects::createFadeOutEffect(100));
			return r;
		}

		if (new !is previous)
		{
			createCursor(@previous, ::vector2(0.0f), false);
		}

		return r;
	}

	void createCursor(sef::UIButton@ previous, ::vector2 direction, const bool playSoundIfAny)
	{
		sef::UIButton@ current = getCurrent();
		if (current is null)
		{
			dismissCursor(sef::uieffects::createFadeOutEffect(100));
			return;
		}

		// find appear effect direction
		if (previous !is null)
		{
			const ::vector2 currentAbsPos(current.getAbsoluteCurrentMiddlePoint());
			const ::vector2 previousAbsPos(previous.getAbsoluteCurrentMiddlePoint());

			direction = (previousAbsPos - currentAbsPos);
		}
		else
		{
			direction *= (-64.0f);
		}

		// dismiss current cursor with proper effect
		if (m_cursor !is null)
		{
			sef::WaypointManager@ slideEffect = sef::uieffects::createSlideEffect(
				direction * -1.0f,
				sef::Color(0xFFFFFFFF),
				sef::Color(0x00FFFFFF),
				0,
				false, // slide in
				200,
				false, // elastic
				true); // fullLengthDirectionVector

			m_cursor.setName("sef::iterator0::dismissed");
			dismissCursor(@slideEffect);
		}

		// create appear effect
		sef::WaypointManager@ slideEffect = sef::uieffects::createSlideEffect(
			direction,
			sef::Color(0x00FFFFFF),
			sef::Color(0xFFFFFFFF),
			0,
			true, // slide in
			200,
			false, // elastic
			true); // fullLengthDirectionVector

		// create element
		sef::FrameDrawable drawable(
			"sprites/button-highlight.png",
			computeSize(@current),
			false,  // borderOutside
			true);

		@m_cursor = sef::UIDrawable(
			@drawable,
			current.getNormPos() + sef::math::normalizePosition(current.getScrollOffset().getAbsoluteOffset()),
			slideEffect,
			current.getOrigin(),
			current.getScale());

		#if TESTING
			::print("CURSOR CREATED");
		#endif

		m_cursor.setDismissEffect(sef::uieffects::createFadeOutEffect(100));
		m_cursor.setName(m_elementName);
		m_cursor.setColor(sef::Color(0.0f, m_color.getVector3()));
		m_cursor.update();

		getLayer().insertElement(@m_cursor);

		if (playSoundIfAny && globalCursorSoundEffect != "")
			sef::util::playSample(globalCursorSoundEffect, 0.5f, randF(0.9f, 1.1f));
	}

 	::KEY_STATE getBackRequestState() const
	{
		return sef::input::global.getBackState();
	}

	::vector2 findMoveDirection() const
	{
		::vector2 r(0.0f);
		if (sef::input::global.getNextState() == ::KS_HIT)
			r = (::vector2(1,0));
		if (sef::input::global.getPriorState() == ::KS_HIT)
			r = (::vector2(-1,0));
		if (sef::input::global.getUpState() == ::KS_HIT)
			r = (::vector2(0,-1));
		if (sef::input::global.getDownState() == ::KS_HIT)
			r = (::vector2(0,1));
		return r;
	}

	void update()
	{
		::KEY_STATE enterState = getEnterState();

		if (enterState == ::KS_HIT)
			@m_cursorHitElement = getCurrent();
		if (enterState == ::KS_DOWN || enterState == ::KS_RELEASE)
			if (m_cursorHitElement !is getCurrent())
				enterState = ::KS_UP;

		if (enterState == ::KS_UP && enabled)
		{
			const ::vector2 moveDirection(findMoveDirection());
			if (moveDirection != ::vector2(0.0f))
			{
				move(moveDirection);
			}
		}

		if (m_cursor !is null && m_cursor.getAnimation() is null)
		{
			m_cursor.setAnimation(sef::uieffects::createBumpingEffect(200, 0.98f));
		}

		sef::UIButton@ current = getCurrent();
		if (current !is null)
		{
			current.forceState(enterState);
			if (enabled)
			{
				const sef::Color currentColor = current.getCurrentColor();
				if (m_cursor !is null)
				{
					sef::Color finalColor = current.cursorColorMultiplier * m_color;
					m_cursor.setColor(sef::Color(currentColor.a * finalColor.getAlpha(), finalColor.getVector3()));
				}

				if (current.isDismissed())
				{
					if (!grabFirst(true /*acceptNoneOption*/))
						dismissCursor(sef::uieffects::createFadeOutEffect(200, 0));
				}
			}
		}

		if (current is null || !enabled)
		{
			if (m_cursor !is null)
			{
				dismissCursor(sef::uieffects::createFadeOutEffect(100));
			}
		}

		if (m_cursor !is null)
		{
			// always send cursor to the front
			if (!m_layer.isLastElement(m_cursor.getName()))
			{
				m_layer.remove(m_cursor.getName());
				m_layer.insertElement(@m_cursor);
			}

			// follow current button
			if (current !is null)
			{
				m_cursor.setNormPos(current.getNormPos() + sef::math::normalizePosition(current.getScrollOffset().getAbsoluteOffset()));

				sef::FrameDrawable@ cursorFrame = cast<sef::FrameDrawable>(m_cursor.getDrawable());
				cursorFrame.setSize(computeSize(@current));
			}
		}

		checkCursorHover();
	}

	private void checkCursorHover()
	{
		// do cursor hover selection
		if (enableMouseIteration && sef::globalMouseCursorTracker !is null)
		{
			if (sef::globalMouseCursorTracker.hasMoved())
			{
				bool hoveringAnything = false;
				const ::vector2 pos(sef::globalMouseCursorTracker.getAbsPosition());
				sef::UIButton@[]@ buttons = m_layer.getButtons();
				for (int t = int(buttons.length() - 1); t >= 0; t--)
				{
					sef::UIButton@ button = @(buttons[t]);

					if (!button.iterable || button.isDismissed())
						continue;

					if (button.isPointInside(pos))
					{
						if (m_current !is button)
						{
							sef::globalMouseCursorTracker.onHover(@button);
							@m_current = null;
						}

						grab(@button);

						hoveringAnything = true;
						break;
					}
				}

				if (!hoveringAnything)
				{
					dismissCursor(sef::uieffects::createFadeOutEffect(200, 0));
					@m_current = null;
				}
			}
		}
	}

	::vector2 computeSize(sef::UIDrawable@ current) const
	{
		return (current.getDrawable().getSize());
	}

	sef::UIDrawable@ getCursor()
	{
		return @m_cursor;
	}

	void dismissCursor(sef::WaypointManager@ dismissEffect)
	{
		if (m_cursor !is null)
		{
			m_cursor.dismiss(@dismissEffect);
			@m_cursor = null;

			#if TESTING
				::print("CURSOR DELETED");
			#endif
		}
	}

	void draw() override
	{
	}
}

} // namespace sef
