namespace sef {

interface Font
{
	::string getFont() const;
	void setFont(const ::string &in font);
	float getScale() const;
}

class StaticFont : sef::Font
{
	private ::string m_font;

	StaticFont()
	{
	}

	StaticFont(const ::string &in font)
	{
		setFont(font);
	}

	void setFont(const ::string &in font)
	{
		m_font = font;
	}

	::string getFont() const
	{
		return m_font;
	}

	float getScale() const
	{
		return 1.0f;
	}
}

} // namespace sef
