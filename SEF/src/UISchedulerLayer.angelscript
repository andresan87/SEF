namespace sef {

class UISchedulerLayer : sef::UILayer
{
	private ::string m_scheduledOpName;

	UISchedulerLayer(const ::string &in name, const bool iterable = false, const ::string first = "")
	{
		super(name, iterable, first);
	}

	void scheduleOperation(const ::string &in name)
	{
		m_scheduledOpName = name;
		dismissAllElements();
	}

	bool hasScheduledOperation() const
	{
		return (m_scheduledOpName != "");
	}

	void insertElement(sef::UIElement@ element) override
	{
		if (!hasScheduledOperation())
		{
			UILayer::insertElement(@element);
		}
	}

	void insertBackgroundElement(sef::UIElement@ element, uint order = 0) override
	{
		if (!hasScheduledOperation())
		{
			UILayer::insertBackgroundElement(@element, order);
		}
	}

	::string getScheduledOperation() const
	{
		if (isEmpty())
		{
			return m_scheduledOpName;
		}
		else
		{
			return "";
		}
	}
}

} // namespace sef
