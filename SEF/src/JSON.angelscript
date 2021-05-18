namespace sef {

abstract class JSONElement
{
	private string m_name;

	JSONElement(const string &in name)
	{
		m_name = name;
	}

	string getName() const final
	{
		return m_name;
	}

	string write() const
	{
		return "\"" + m_name + "\":null";
	};
}

class JSONStringObject : JSONElement
{
	private string m_value;

	JSONStringObject(const string &in name, const string &in value)
	{
		super(name);
		setValue(value);
	}

	void setValue(const string &in value)
	{
		m_value = sef::generateJSONString(value);
	}

	string write() const override
	{
		return "\"" + getName() + "\":" + "\"" + m_value + "\"";
	}
}

class JSONBoolObject : JSONElement
{
	private bool m_value;

	JSONBoolObject(const string &in name, const bool value)
	{
		super(name);
		setValue(value);
	}

	void setValue(const bool value)
	{
		m_value = value;
	}

	string write() const override
	{
		return "\"" + getName() + "\":" + (m_value ? "true" : "false");
	}
}

class JSONElementList : JSONElement
{
	JSONElement@[] elements;

	JSONElementList(const string &in name = "")
	{
		super(name);
	}

	string write() const
	{
		string r;
		if (getName() != "")
		{
			r += "\"" + getName() + "\":";
		}
		r += "{\n";
		for (uint t = 0; t < elements.length(); t++)
		{
			r += "\t" + elements[t].write();

			if ((t + 1) < elements.length())
			{
				r += ",";
			}

			r += "\n";
		}
		r += "}\n";
		return r;
	};
}

string generateJSONString(const string &in value)
{
	string r = sef::string::replace(value, "\\", "\\\\");
	r = sef::string::replace(r, "\"", "\\\"");
	r = sef::string::replace(r, "\t", "\\t");
	r = sef::string::replace(r, "\n", "\\n");
	return sef::string::replace(r, "\r", "\\r");

}

} // namespace sef
