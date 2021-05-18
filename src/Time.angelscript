namespace sef {

namespace time {
	const ::string SD_CURRENT_TIME_MILLIS = "com.ethanonengine.data.currentTimeMillis";

	uint64 getCurrentTimeMillis()
	{
		if (!::SharedDataExists(sef::time::SD_CURRENT_TIME_MILLIS))
			return GetTime();
		else
			return ::parseUInt64(::GetSharedData(sef::time::SD_CURRENT_TIME_MILLIS));
	}

	::string getDayCode(const ::string &in separator)
	{
		::dateTime time;
		const ::string month = time.getMonth();
		const ::string day   = time.getDay();
		const ::string year  = time.getYear();
		return day + separator + month + separator + year;
	}
} // namespace time

class Time
{
	private uint m_year = 0;
	private uint m_month = 0;
	private uint m_day = 0;
	private uint m_hours = 0;
	private uint m_minutes = 0;
	private uint m_seconds = 0;

	private ::string SEPARATOR = ":";

	Time()
	{
		update();
	}

	Time(const ::string &in str)
	{
		update(str);
	}

	Time(const ::string &in str, const ::string &in separator)
	{
		update(str, separator);
	}

	::string getMonthEnglishCode() const
	{
		::string r;
		switch (m_month)
		{
		case 1:  r = "Jan"; break;
		case 2:  r = "Feb"; break;
		case 3:  r = "Mar"; break;
		case 4:  r = "Apr"; break;
		case 5:  r = "May"; break;
		case 6:  r = "Jun"; break;
		case 7:  r = "Jul"; break;
		case 8:  r = "Aug"; break;
		case 9:  r = "Sep"; break;
		case 10: r = "Oct"; break;
		case 11: r = "Nov"; break;
		case 12: r = "Dec"; break;
		}
		return r;
	}

	bool isEarlierThan(const Time@ time) const
	{
		int sign = 0;
		sign = ::sign(int(m_year) - int(time.m_year));
		if (sign == 0)
		{
			sign = ::sign(int(m_month) - int(time.m_month));
			if (sign == 0)
			{
				sign = ::sign(int(m_day) - int(time.m_day));
				if (sign == 0)
				{
					sign = ::sign(int(m_hours) - int(time.m_hours));
					if (sign == 0)
					{
						sign = ::sign(int(m_minutes) - int(time.m_minutes));
						if (sign == 0)
						{
							sign = ::sign(int(m_seconds) - int(time.m_seconds));
						}
					}
				}
			}
		}

		return (sign < 0) ? true : false;
	}

	int opCmp(const sef::Time &in other) const
	{
		if (isEarlierThan(@other))
		{
			return -1;
		}
		else if (other.isEarlierThan(this))
		{
			return 1;
		}
		return 0;
	}

	uint getYear() const
	{
		return m_year;
	}

	uint getMonth() const
	{
		return m_month;
	}

	uint getDay() const
	{
		return m_day;
	}

	uint getHours() const
	{
		return m_hours;
	}

	uint getMinutes() const
	{
		return m_minutes;
	}

	uint getSeconds() const
	{
		return m_seconds;
	}

	::string toString() const
	{
		return toString(SEPARATOR);
	}

	::string toString(const ::string separator) const
	{
		return 
			  m_year    + separator
			+ m_month   + separator
			+ m_day     + separator
			+ m_hours   + separator
			+ m_minutes + separator
			+ m_seconds;
	}

	void update()
	{
		::dateTime time;
		m_year    = time.getYear();
		m_month   = time.getMonth();
		m_day     = time.getDay();
		m_hours   = time.getHours();
		m_minutes = time.getMinutes();
		m_seconds = time.getSeconds();
	}

	void update(const ::string &in str)
	{
		update(str, SEPARATOR);
	}

	void update(const ::string &in str, const ::string &in separator)
	{
		::string[] pieces = sef::string::split(str, separator);
		m_year    = parsePiece(0, @pieces);
		m_month   = parsePiece(1, @pieces);
		m_day     = parsePiece(2, @pieces);
		m_hours   = parsePiece(3, @pieces);
		m_minutes = parsePiece(4, @pieces);
		m_seconds = parsePiece(5, @pieces);
	}

	private uint parsePiece(const uint idx, const ::string[]@ pieces)
	{
		if (idx < pieces.length())
		{
			return ::parseUInt(pieces[idx]);
		}
		else
		{
			return 0;
		}
	}
}

} // namespace sef
