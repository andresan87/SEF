namespace sef {

class TextInputElement : sef::UIButton, sef::UIButtonIterationListener
{
	sef::FrameDrawable@ m_frame;

	private sef::TextDrawable@ m_input;
	private sef::TextDrawable@ m_cursorText;

	private string m_parentLayerName;
	private string m_cursor;

	TextInputElement(
		const string &in parentLayerName,
		const string &in elementName,
		const string &in backgroundTiles,
		sef::Font@ font,
		const vector2 &in normPos,
		const vector2 &in frameSize,
		sef::WaypointManager@ beginningAnimation,
		const vector2 &in origin = vector2(0),
		const float scale = 1.0f)
	{
		m_parentLayerName = parentLayerName;
		m_cursor = AssembleColorCode(0xFFBBBBBB) + "  _";
		@m_frame = sef::FrameDrawable(backgroundTiles, frameSize);

		@m_input      = m_frame.setText("", @font, sef::Color(0xFFFFFFFF), 1.0f);
		@m_cursorText = m_frame.setText("", @font, sef::Color(0xFFBBBBBB), 1.0f);

		super(elementName, @m_frame, normPos, @beginningAnimation, origin, scale);

		// sets a UIButtonIterationListener to prevent DPAD iteration while focused
		@iterationListener = @this;

		// make cursor slightly transparent for text input element
		cursorColorMultiplier = sef::Color(0x00FFFFFF);
	}

	bool isFocusedByCursor() const
	{
		sef::UILayerManager@ layerManager = sef::util::getBaseStateLayerManager();
		sef::UILayer@ parent = layerManager.getLayer(m_parentLayerName);
		if (parent !is null)
		{
			sef::UIButton@ current = parent.iterator.getCurrent();
			if (current !is null)
			{
				return current.getName() == getName();
			}
		}
		return false;
	}

	void recoverFocusWhenNoCursor() const
	{
		sef::UILayerManager@ layerManager = sef::util::getBaseStateLayerManager();
		sef::UILayer@ parent = layerManager.getLayer(m_parentLayerName);
		if (parent !is null)
		{
			sef::UIButton@ current = parent.iterator.getCurrent();
			if (current is null)
			{
				parent.iterator.grab(getName());
			}
		}		
	}

	void update() override
	{
		UIButton::update();

		recoverFocusWhenNoCursor();

		ETHInput@ input = GetInputHandle();

		if (isFocusedByCursor())
		{
			if (m_input.getSize().x * getScale() < (m_frame.getSize().x - 64))
			{
				m_frame.appendToText(0, input.GetLastCharInput());
			}

			if (input.GetKeyState(K_BACK) == KS_HIT)
			{
				string currentText = m_input.getText();
				while (!isValidUTF8(currentText = currentText.substr(0, currentText.length() - 1)));
				m_input.setText(currentText);
			}

			// blink cursor
			m_cursorText.setColor(sef::Color((sin(GetTimeF() / 70.0f) + 1.0f) / 2.0f, vector3(1.0f)).getUInt());
		}
		else
		{
			// hide cursor
			m_cursorText.setColor(sef::Color(0x00000000).getUInt());
		}

		m_cursorText.setText(AssembleColorCode(0x00000000) + m_input.getText() + m_cursor);
	}

	string getText()
	{
		return m_input.getText();
	}
	
	// UIButtonIterationListener: prevents cursor from moving when DPAD is activated
	bool move(const ::vector2 &in direction) override
	{
		return (direction.x == 0.0f && direction.y != 0.0f);
	}
}

} // namespace sef
