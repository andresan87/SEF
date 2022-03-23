namespace sef {
namespace string {

::string vector3ToString(const ::vector3 &in v3)
{
	return "(" + v3.x + ", " + v3.y + ", " + v3.z + ")";
}

::string vector2ToString(const ::vector2 &in v2)
{
	return "(" + v2.x + ", " + v2.y + ")";
}

::string floatArrayToString(const float[]@ v)
{
	::string r;
	const int size = int(v.length());
	for (int t = 0; t < size; t++)
	{
		r += v[t];
		if (t < (size - 1))
		{
			r += ",";
		}
	}
	return r;
}

::string[] split(::string str, const ::string c)
{
	::string[] v;
	uint64 pos;
	while ((pos = str.find(c)) != ::NPOS)
	{
		v.insertLast(str.substr(0, pos));
		str = str.substr(pos + c.length(), ::NPOS);
	}
	v.insertLast(str);
	return v;
}

::string formatTimeString(const float elapsedTimeMS)
{
	const uint totalSeconds = uint(elapsedTimeMS / 1000.0f);
	const uint secondsDisplay = totalSeconds % 60;
	const uint minutesDisplay = totalSeconds / 60;

	::string extraDigit;
	if (secondsDisplay < 10) extraDigit = "0";

	return "" + minutesDisplay + ":" + extraDigit + secondsDisplay;
}

::string formatLongTimeString(const float elapsedTimeMS)
{
	const uint totalSeconds = uint(elapsedTimeMS / 1000.0f);
	const uint secondsDisplay = totalSeconds % 60;
	const uint totalMinutes = totalSeconds / 60;
	const uint minutesDisplay = totalMinutes % 60;
	const uint hoursDisplay = totalMinutes / 60;

	::string extraSecDigit;
	if (secondsDisplay < 10) extraSecDigit = "0";

	::string extraMinDigit;
	if (minutesDisplay < 10) extraMinDigit = "0";

	return "" + hoursDisplay + ":" + extraMinDigit + minutesDisplay + ":" + extraSecDigit + secondsDisplay;
}

::string reduce(const string &in str, const uint maxChars, const string &in suffix)
{
	string r = str;
	if (r.length() > maxChars)
	{
		r = r.substr(0, 8) + suffix;
	}
	return r;
}

int sendElementToEnd(const ::string &in element, ::string[]@ elements)
{
	int r = -1;
	for (uint t = 0; t < elements.length(); t++)
	{
		if (elements[t] == element)
		{
			r = t;
			break;
		}
	}
	if (r != -1)
	{
		elements.removeAt(r);
		elements.insertLast(element);
	}
	return r;
}

void removeDuplicates(::string[]@ elements)
{
	for (uint i = 0; i < elements.length(); ++i)
	{
		for (uint j = 0; j < elements.length();)
		{
			if (i != j)
			{
				if (elements[i] == elements[j])
				{
					elements.removeAt(j);
					continue;
				}
			}
			++j;
		}
	}
}

bool areEqual(const ::string[]@ a, const ::string[]@ b)
{
	if (a.length() != b.length())
	{
		return false;
	}

	for (uint i = 0; i < a.length(); ++i)
	{
		if (a[i] != b[i])
		{
			return false;
		}
	}
	return true;
}

::string getFormattedLongInteger(const int amount, const ::string &in separator)
{
	::string r = "";
	const ::string unformated = "" + (amount);
	const int originalLen = int(unformated.length());

	int lastCursor;
	int cursor;
	for (cursor = originalLen;;)
	{
		lastCursor = cursor;
		cursor -= 3;
		if (cursor < 0)
			break;

		const ::string piece = unformated.substr(cursor, 3);

		r = piece + r;

		if (cursor > 0)
			r = separator + r;
	}

	if (cursor <= 0)
	{
		r = unformated.substr(0, cursor + 3) + r;
	}

	return r;
}

::string replace(const ::string &in str, const ::string &in sequence, const ::string &in replace)
{
	::string r;
	::string[] pieces = sef::string::split(str, sequence);
	const uint len = pieces.length();
	if (len >= 2)
	{
		for (uint t = 0; t < pieces.length() - 1; t++)
		{
			r += pieces[t] + replace;
		}
		r += pieces[len - 1];
	}
	else
	{
		r = str;
	}
	return r;
}

::string appendToFileName(const ::string &in fileName, const ::string &in appendix)
{
	::string[] pieces = sef::string::split(fileName, ".");
	const int last = pieces.length() - 1;
	::string r;
	for (int t = last; t >= 0; t--)
	{

		r = pieces[t] + r;
		if (t != 0)
			r = "." + r;
		if (t == last)
		{
			r = appendix + r;
		}
	}
	return r;
}

bool suffixMatches(const ::string &in str, const ::string &in suffix)
{
	const uint strLen = str.length();
	const uint suffixLen = suffix.length();

	if (suffixLen > strLen)
		return false;

	return (str.substr(strLen - suffixLen, ::NPOS) == suffix);
}

bool prefixMatches(const ::string &in str, const ::string &in prefix)
{
	return (str.substr(0, prefix.length()) == prefix);
}

bool equalsAny(const ::string &in a, const ::string[]@ values)
{
	const uint n = values.length();
	for (uint t = 0; t < n; t++)
	{
		if (a == values[t])
			return true;
	}
	return false;
}

bool prefixEqualsAny(const ::string &in a, const ::string[]@ values)
{
	const uint n = values.length();
	for (uint t = 0; t < n; t++)
	{
		if (sef::string::prefixMatches(a, values[t]))
			return true;
	}
	return false;
}

uint lineCount(const ::string &in str)
{
	return sef::string::split(str, "\n").length();
}

uint utf8Length(const string &in str)
{
	uint r = 0;
	const uint n = str.length();
	for (uint t = 1; t < n; t++)
	{
		if (isValidUTF8(str.substr(0, t)))
			r++;
	}
	return r;
}

::string repeat(const ::string str, const uint count)
{
	::string r;
	for (uint t = 0; t < count; t++)
	{
		r += str;
	}
	return r;
}

::string resizeToWidth(float width, const sef::Font@ font, const ::string &in str, const ::string &in append = "")
{
	if (str.length() == 0)
		return "";

	width /= font.getScale();

	for (uint t = 1; t < str.length(); t++)
	{
		if (ComputeTextBoxSize(font.getFont(), str.substr(0, t)).x > width)
		{
			return str.substr(0, t - 1) + append;
		}
	}

	return str;
}

::string formatIntoTextBox(::vector2 textBoxSize, const sef::Font@ font, const ::string &in str)
{
	if (str.length() == 0)
		return "";

	textBoxSize /= font.getScale();
 
	const ::string[] words = sef::string::split(str, " ");
	const uint numWords = words.length();
 
	::string r = words[0];
	::string currentLine = words[0] + " ";
	for (uint t = 1; t < numWords; t++)
	{
		const ::string currentLineAppendix = words[t] + " ";
		currentLine += currentLineAppendix;
		const ::vector2 pieceSize = ::ComputeTextBoxSize(font.getFont(), currentLine);
		if (pieceSize.x > textBoxSize.x)
		{
			r += "\n";
			currentLine = currentLineAppendix;
		}
		else
		{
			r += " ";
		}
 
		r += words[t];
	}
	return r;
}

bool isBoolean(const ::string &in value)
{
	return (value == "true" || value == "false");
}

bool toBoolean(const ::string &in value)
{
	return (value == "true") ? true : false;
}

bool isValidNumber(const ::string &in str)
{
	if (str == "")
	{
		return false;
	}

	for (uint t = 0; t < str.length(); t++)
	{
		const ::string c = str.substr(t, 1);
		if (t == 0)
		{
			const bool onlyMinusSymbol = (c == "-" && str.length() == 1);
			if (!sef::string::isFirstCharacterADigit(c) && c != "-" || onlyMinusSymbol)
			{
				return false;
			}
		}
		else
		{
			// if not last
			if (t < (str.length() - 1))
			{
				if (!sef::string::isFirstCharacterADigit(c) && c != ".")
				{
					return false;
				}
			}
			else
			{
				if (!sef::string::isFirstCharacterADigit(c))
				{
					return false;
				}
			}
		}
	}
	return true;
}

bool isFirstCharacterADigit(const ::string &in str)
{
	const ::string c = str.substr(0, 1);
	if (c == "0") return true;
	if (c == "1") return true;
	if (c == "2") return true;
	if (c == "3") return true;
	if (c == "4") return true;
	if (c == "5") return true;
	if (c == "6") return true;
	if (c == "7") return true;
	if (c == "8") return true;
	if (c == "9") return true;
	return false;
}

::string toTwoDigitDecimal(const int value, const ::string &in digit = "0")
{
	::string r = "" + value;
	if (value < 10 && value >= 0 && value < 100)
		r = digit + r;
	return r;
}

::string paintEveryWord(const ::string &in text, const uint color)
{
	return paintBetweenSequence(text, " ", color);
}

::string paintEveryLine(const ::string &in text, const uint color)
{
	return paintBetweenSequence(text, "\n", color);
}

::string paintBetweenSequence(const ::string &in text, const ::string &in sequence, const uint color)
{
	::string r;
	::string[] words = sef::string::split(text, sequence);
	for (uint t = 0; t < words.length(); t++)
	{
		r += AssembleColorCode(color) + words[t];
		if ((t + 1) < words.length())
		{
			r += sequence;
		}
	}
	return r;
}

::string generateProgressBar(
	const double progress,
	const double maximum,
	const uint maxCharacterCount = 100,
	const ::string filledCharacter = "|",
	const ::string emptyCharacter = "-")
{
	const uint charCount = uint((progress / maximum) * double(maxCharacterCount));
	::string line;
	for (uint t = 0; t < maxCharacterCount; t++)
	{
		if (t <= charCount)
			line += filledCharacter;
		else
			line += emptyCharacter;
	}
	return line;
}

uint parseUInt(const ::string &in value, const uint defaultValue)
{
	if (value == "" || !sef::string::isValidNumber(value))
	{
		return defaultValue;
	}
	else
	{
		return ::parseUInt(value);
	}
}

::vector3 parseVector3(const ::string &in v, const vector3 defaultValue = vector3(0.0f))
{
	::string[] elements = sef::string::split(v, ",");
	const uint length = uint(min(elements.length(), 3));
	vector3 r(defaultValue);
	for (uint t = 0; t < length; t++)
	{
		elements[t] = sef::string::replace(elements[t], " ", "");
		if (sef::string::isValidNumber(elements[t]))
		{
			r = sef::util::setIndexedValue(r, t, parseFloat(elements[t]));
		}
	}
	return r;
}

::vector2 parseVector2(const ::string &in v, const vector2 defaultValue = vector2(0.0f))
{
	::string[] elements = sef::string::split(v, ",");
	const uint length = uint(min(elements.length(), 2));
	vector2 r(defaultValue);
	for (uint t = 0; t < length; t++)
	{
		elements[t] = sef::string::replace(elements[t], " ", "");
		if (sef::string::isValidNumber(elements[t]))
		{
			r = sef::util::setIndexedValue(r, t, parseFloat(elements[t]));
		}
	}
	return r;
}

float[] parseFloatList(const ::string &in v)
{
	float[] r;
	const ::string[] elements = sef::string::split(v, ",");
	for (uint t = 0; t < elements.length(); t++)
	{
		const string element = sef::string::replace(elements[t], " ", "");
		float f = 0.0f;
		if (sef::string::isValidNumber(element))
		{
			f = parseFloat(element);
		}
		r.insertLast(f);
	}
	return r;
}

} // namespace sef
} // namespace string
