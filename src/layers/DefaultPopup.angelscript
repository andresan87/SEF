namespace sef {

class DefaultPopup : UISchedulerLayer
{
	protected bool autoDetectEscapeInput = true;

	bool enableGamepadBack = true;

	DefaultPopup(const ::string &in name, const ::string &in first)
	{
		super(name, true, first);
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
