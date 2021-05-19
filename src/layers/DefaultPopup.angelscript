namespace sef {

class DefaultPopup : UISchedulerLayer
{
	protected sef::UILayerManager@ m_layerManager;
	protected sef::UILayer@ m_currentLayer;
	protected bool autoDetectEscapeInput = true;

	bool enableGamepadBack = true;

	DefaultPopup(const ::string &in name, const ::string &in first)
	{
		super(name, true /*iterable*/, first);
	}

	DefaultPopup(const ::string &in name, const ::string &in first, sef::UILayerManager@ layerManager, sef::UILayer@ currentLayer)
	{
		super(name, true /*iterable*/, first);
		@m_currentLayer = @currentLayer;
		@m_layerManager = @layerManager;
	}

	void update()
	{
		UISchedulerLayer::update();

		// escape shortcuts
		const bool escape = detectEscapeTouch();

		const bool physicalBack = (enableGamepadBack
			? (sef::input::global.getBackState() == ::KS_HIT)
			: (sef::input::global.getKeyboardOnlyBackState() == ::KS_HIT));

		if ((
				escape
				|| physicalBack
				|| isButtonPressed("back")
			)
			&& !hasScheduledOperation()
			&& autoDetectEscapeInput)
		{
			if (onBackRequested())
			{
				sef::input::global.resetBackState();
				onPopupCloseBegin();
			}
		}

		if (getScheduledOperation() == "back")
		{
			onPopupClosed();
		}

		if (getScheduledOperation() != "")
		{
			onScheduledOperation();
		}
	}

	bool onBackRequested()
	{
		scheduleOperation("back");
		return true;
	}

	void onPopupCloseBegin()
	{
	}

	void onPopupClosed()
	{
	}

	void onScheduledOperation()
	{
		if (m_currentLayer !is null && m_layerManager !is null)
		{
			m_layerManager.setCurrentLayer(m_currentLayer.getName());
		}
	}

	bool detectEscapeTouch() const
	{
		const ::vector2 touchPos(sef::input::getAnyHitPos());
		if (touchPos != sef::input::NO_TOUCH)
		{
			if (!isPointInAnyButton(touchPos))
				return true;
		}
		return false;
	}

	bool isPopup() const
	{
		return true;
	}
}

} // namespace sef
