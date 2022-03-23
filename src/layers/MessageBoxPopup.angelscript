namespace sef {

enum MESSAGE_BOX_BUTTON_RESULT
{
	MBR_SCHEDULE_OPERATION,
	MBR_KEEP
}

class MessageBoxPopup : DefaultPopup
{
	private ::enmlFile m_elementsFile;
	protected sef::UILayerManager@ m_layerManager;
	protected sef::UILayer@ m_currentLayer;

	::vector2 FRAME_BORDERS = ::vector2(116.0f, 94.0f);

	MessageBoxPopup(
		const ::string &in name,
		sef::UILayerManager@ layerManager,
		sef::UILayer@ currentLayer,
		sef::Font@ fontCreator,
		::string elementFileName = "",
		const ::string first = "no")
	{
		super(name, first);
		@m_layerManager = @layerManager;
		@m_currentLayer = @currentLayer;

		if (elementFileName == "")
			elementFileName = ::GetResourceDirectory() + sef::options::frameworkDirectoryPath + "layers/MessageBox.element";

		// load elements
		if (!::FileInPackageExists(elementFileName))
		{
			print("ERROR: file not found: " + elementFileName);
		}
		m_elementsFile.parseString(::GetStringFromFileInPackage(elementFileName));
		sef::layerparser::setLayerOptions(@m_elementsFile, this);

		// create title
		sef::UIDrawable@ title = cast<sef::UIDrawable>(sef::layerparser::createElementFromEnmlEntity(@m_elementsFile, "title", @fontCreator));
		if (title !is null)
		{
			resizeToText(@title);
			insertElement(@title);
		}

		// if title is a button, make it not iterable
		sef::UIButton@ titleButton = cast<sef::UIButton>(@title);
		if (titleButton !is null)
			titleButton.iterable = false;

		// create buttons
		::string[] elements = sef::string::split(m_elementsFile.getEntityNames(), ",");
		for (uint t = 0; t < elements.length(); t++)
		{
			if (elements[t] == "title")
				continue;

			sef::UIElement@ element = sef::layerparser::createElementFromEnmlEntity(@m_elementsFile, elements[t], @fontCreator);
			if (element !is null)
			{
				insertElement(@element);
			}
		}
	}

	void setTitleText(const ::string &in text, sef::Font@ font, const float borderScale, const float unscaledWidth = 720.0f)
	{
		const string formatedText = sef::string::formatIntoTextBox(vector2(unscaledWidth), @font, text);
		sef::UIDrawable@ title = cast<sef::UIDrawable>(getElement("title"));
		if (title !is null)
		{
			sef::FrameDrawable@ drawable = cast<sef::FrameDrawable>(title.getDrawable());
			if (drawable !is null)
			{
				drawable.setText(0, formatedText);
				drawable.getText(0).centered = true;
				resizeToText(title, borderScale);
			}
		}
	}

	void setElementText(const ::string &in elementName, const ::string &in text, const float borderScale = 1.0f)
	{
		sef::UIDrawable@ element = cast<sef::UIDrawable>(getElement(elementName));
		if (element !is null)
		{
			sef::FrameDrawable@ drawable = cast<sef::FrameDrawable>(element.getDrawable());
			if (drawable !is null)
			{
				drawable.setText(0, text);
				resizeToText(element, borderScale);
			}
		}
	}

	void update() override
	{
		checkSlotButtons();
		DefaultPopup::update();
		if (getScheduledOperation() != "")
		{
			m_layerManager.setCurrentLayer(m_currentLayer.getName());
		}
	}

	private void checkSlotButtons()
	{
		for (uint t = 0; t < getNumElements(); t++)
		{
			sef::UIButton@ button = cast<sef::UIButton>(getElement(t));
			if (button is null)
				continue;

			if (button.isPressed())
			{
				if (onButtonPressed(@button) == sef::MBR_SCHEDULE_OPERATION)
					scheduleOperation(button.getName());
			}
		}
	}

	sef::MESSAGE_BOX_BUTTON_RESULT onButtonPressed(sef::UIButton@ button)
	{
		return sef::MBR_SCHEDULE_OPERATION;
	}

	private void resizeToText(sef::UIDrawable@ element, const float borderScale = 1.0f)
	{
		sef::FrameDrawable@ drawable = cast<sef::FrameDrawable>(element.getDrawable());
		if (drawable !is null)
		{
			drawable.resizeToTextSize(FRAME_BORDERS * borderScale);
		}
	}
}

} // namespace sef
