namespace sef {

bool userDataExists(const ::string &in key)
{
	return ::FileExists(sef::assembleUserDataFilePath(key));
}

::string assembleUserDataFilePath(const ::string &in key)
{
	return (::GetExternalStorageDirectory() + key + ".userValue");
}

void setUserData(const ::string &in key, const ::string &in value)
{
	::SaveStringToFile(sef::assembleUserDataFilePath(key), value);
}

void setUserData(const ::string &in key, const uint64 value)
{
	setUserData(key, "" + value);
}

void setUserData(const ::string &in key, const bool value)
{
	setUserData(key, value ? "true" : "false");
}

void setUserData(const ::string &in key, const ::vector3 &in value)
{
	setUserData(key, "" + value.x + "," + value.y + "," + value.z);
}

void setUserData(const ::string &in key, const ::vector2 &in value)
{
	setUserData(key, "" + value.x + "," + value.y);
}

::string getUserData(const ::string &in key)
{
	return ::GetStringFromFile(sef::assembleUserDataFilePath(key));
}

bool getBoolUserData(const ::string &in key, const bool defaultValue)
{
	const string value = getUserData(key);
	if (value == "true")
	{
		return true;
	}
	else if (value == "false")
	{
		return false;
	}
	else
	{
		return defaultValue;
	}
}

float getFloatUserData(const ::string &in key, const float defaultValue = 0.0f)
{
	const ::string value = sef::getUserData(key);
	if (value != "")
		return ::parseFloat(value);
	else
		return defaultValue;
}

uint getUIntUserData(const ::string &in key, const uint defaultValue = 0)
{
	const ::string value = sef::getUserData(key);
	if (value != "")
		return ::parseUInt(value);
	else
		return defaultValue;
}

uint64 getUInt64UserData(const ::string &in key, const uint64 defaultValue = 0)
{
	const ::string value = sef::getUserData(key);
	if (value != "")
		return ::parseUInt64(value);
	else
		return defaultValue;
}

vector3 getVector3UserData(const ::string &in key, const ::vector3 &in defaultValue)
{
	const ::string value = sef::getUserData(key);
	if (value != "")
	{
		const ::string[] pieces = sef::string::split(value, ",");
		if (pieces.length() >= 3)
		{
			return ::vector3(::parseFloat(pieces[0]), ::parseFloat(pieces[1]), ::parseFloat(pieces[2]));
		}
	}
	return defaultValue;
}

vector2 getVector2UserData(const ::string &in key, const ::vector2 &in defaultValue)
{
	const ::string value = sef::getUserData(key);
	if (value != "")
	{
		const ::string[] pieces = sef::string::split(value, ",");
		if (pieces.length() >= 2)
		{
			return ::vector2(::parseFloat(pieces[0]), ::parseFloat(pieces[1]));
		}
	}
	return defaultValue;
}

uint tickUserPersistentCounter(const ::string &in key, const uint initialValue = 0)
{
	uint r = sef::getUIntUserData(key, initialValue);
	sef::setUserData(key, "" + (r + 1));
	return r;
}

} // namespace sef
