namespace sef {
namespace util {

bool entityCallbackActionRepeater(::ETHEntity@ thisEntity, const ::string &in actionName, const float stride)
{
	if (thisEntity.CheckCustomData(actionName) != ::DT_FLOAT)
	{
		thisEntity.SetFloat(actionName, 0.0f);
	}

	const float elapsedTime = thisEntity.AddToFloat(actionName, sef::TimeManager.getLastFrameElapsedTimeF());

	if (elapsedTime >= stride)
	{
		thisEntity.AddToFloat(actionName, -stride);
		return true;
	}
	else
	{
		return false;
	}
}

::vector2 getScreenMiddle()
{
	return ::GetCameraPos() + (::GetScreenSize() * 0.5f);
}

void setCameraMiddlePos(const ::vector2 &in pos)
{
	::SetCameraPos(pos - (::GetScreenSize() * 0.5f));
}

void playSample(const ::string sample, const float volume = 1.0f, const float speed = 1.0f)
{
	if (sample != "")
	{
		::SetSampleSpeed(sample, speed);
		::SetSampleVolume(sample, volume);
		::PlaySample(sample);
	}
}

uint getKeyStateMultiplicationValue(const ::KEY_STATE state)
{
	switch (state)
	{
		case ::KS_RELEASE: return 1;
		case ::KS_HIT:     return 2;
		case ::KS_DOWN:    return 3;
	}
	return 0;
}

bool isKeyDown(const ::KEY_STATE state)
{
	switch (state)
	{
		case ::KS_HIT:
		case ::KS_DOWN:
			return true;
		default:
			return false;
	}
	return false; // script parser bug won't think this is unreachable
}

::KEY_STATE sum(const ::KEY_STATE a, const ::KEY_STATE b)
{
	return (sef::util::getKeyStateMultiplicationValue(a) > sef::util::getKeyStateMultiplicationValue(b)) ? a : b;
}

sef::BaseState@ getBaseState()
{
	return cast<sef::BaseState>(sef::StateManager.getCurrentState());
}

float getBaseStateElapsedTimeF()
{
	return sef::util::getBaseState().getBaseStateElapsedTimeF();
}

vector2 getBucketSize()
{
	return sef::util::getBaseState().getBucketSize();
}

vector2 getBucketWorldSpaceCenter(const vector2 &in bucket)
{
	return sef::util::getBaseState().getBucketWorldSpaceCenter(bucket);
}

uint getBaseStateElapsedTime()
{
	return sef::util::getBaseState().getBaseStateElapsedTime();
}

void callLayer(sef::UILayer@ layer)
{
	sef::BaseState@ state = sef::util::getBaseState();
	if (state is null)
		return;
	state.callLayer(@layer);
}

void setCurrentLayer(const ::string &in name)
{
	sef::BaseState@ state = sef::util::getBaseState();
	if (state is null)
		return;
	state.setCurrentLayer(name);
}

sef::UILayerManager@ getBaseStateLayerManager()
{
	sef::BaseState@ state = sef::util::getBaseState();

	if (state is null)
		return null;
	else
		return state.getLayerManager();
}

sef::UILayer@ getBaseStateCurrentLayer()
{
	sef::UILayerManager@ layerManager = sef::util::getBaseStateLayerManager();
	if (layerManager !is null)
	{
		sef::UILayer@ currentLayer = layerManager.getCurrentLayer();
		return @currentLayer;
	}
	return null;
}

void addLayer(sef::UILayer@ layer)
{
	sef::UILayerManager@ layerManager = sef::util::getBaseStateLayerManager();
	if (layerManager !is null)
	{
		layerManager.insertLayer(@layer);
	}
}

void addPrefixToText(sef::UIDrawable@ drawable, const ::string &in prefix)
{
	if (drawable is null)
		return;

	sef::FrameDrawable@ frameDrawable = cast<sef::FrameDrawable>(drawable.getDrawable());

	if (frameDrawable is null)
		return;

	frameDrawable.setText(0, prefix + frameDrawable.getTextStr(0));
}

void addSuffixToText(sef::UIDrawable@ drawable, const ::string &in suffix)
{
	if (drawable is null)
		return;

	sef::FrameDrawable@ frameDrawable = cast<sef::FrameDrawable>(drawable.getDrawable());

	if (frameDrawable is null)
		return;

	frameDrawable.setText(0, frameDrawable.getTextStr(0) + suffix);
}

bool scheduleEvent(const uint delay, sef::Event@ event, const bool pausable = true)
{
	sef::BaseState@ state = cast<sef::BaseState>(sef::StateManager.getCurrentState());

	if (state is null)
	{
		return false;
	}
	else
	{
		state.scheduleEvent(delay, @event, pausable);
		return true;
	}
}

void scheduleGlobalEvent(const uint delay, sef::Event@ event, const bool pausable = false)
{
	sef::GlobalEventScheduler.scheduleEvent(delay, @event, pausable);
}

bool scheduleEvent(const uint delay, sef::RAW_FUNC@ rawFunc, const bool pausable = true)
{
	return scheduleEvent(delay, sef::RunFunctionEvent(@rawFunc), pausable);
}

funcdef void PROCESS_ENTITY(::ETHEntity@ originalEntity, ::ETHEntity@ newEntity);
::ETHEntity@ replaceEntityIfNameMatches(::ETHEntity@ entity, const ::string &in entityName, const ::string &in otherEntity, PROCESS_ENTITY@ func = null)
{
	if (entity.GetEntityName() == entityName)
	{
		::ETHEntity@ r;
		::AddEntity(otherEntity, entity.GetPosition(), entity.GetAngle(), r, "", 1.0f);
		r.SetFlipX(entity.GetFlipX());
		r.SetFlipY(entity.GetFlipY());
		if (func !is null)
			func(entity, r);
		::DeleteEntity(entity);
		return @r;
	}
	return null;
}

void processEntityIfNameMatches(::ETHEntity@ entity, const ::string &in entityName, PROCESS_ENTITY@ func)
{
	if (entity.GetEntityName() == entityName)
	{
		func(entity, null);
	}
}

bool addUIntWhenInexistent(::ETHEntity@ thisEntity, const ::string &in name, const uint value)
{
	if (thisEntity.CheckCustomData(name) != ::DT_UINT)
	{
		thisEntity.SetUInt(name, value);
		return true;
	}
	else
	{
		return false;
	}
}

bool addFloatWhenInexistent(::ETHEntity@ thisEntity, const ::string &in name, const float value)
{
	if (thisEntity.CheckCustomData(name) != ::DT_FLOAT)
	{
		thisEntity.SetFloat(name, value);
		return true;
	}
	else
	{
		return false;
	}
}

bool mergeCustomData(const ::string &in name, ::ETHEntity@ a, ::ETHEntity@ b)
{
	const ::DATA_TYPE dtA = a.CheckCustomData(name);
	const ::DATA_TYPE dtB = b.CheckCustomData(name);

	const bool noDataA = (dtA == ::DT_NODATA);
	const bool noDataB = (dtB == ::DT_NODATA);

	if (!noDataA && noDataB)
		transferCustomData(name, a, b);
	else if (!noDataB && noDataA)
		transferCustomData(name, b, a);
	else if (noDataA && noDataB)
		return false;
	else if (dtA != dtB)
		return false;

	if (dtA == ::DT_STRING)
	{
		a.SetString(name, a.GetString(name) + b.GetString(name));
	}
	else if (dtA == ::DT_UINT)
	{
		const uint max = ::max(a.GetUInt(name), b.GetUInt(name));
		a.SetUInt(name, max);
		b.SetUInt(name, max);
	}
	else if (dtA == ::DT_INT)
	{
		const int max = ::max(a.GetInt(name), b.GetInt(name));
		a.SetInt(name, max);
		b.SetInt(name, max);
	}
	else if (dtA == ::DT_FLOAT)
	{
		const float max = ::max(a.GetFloat(name), b.GetFloat(name));
		a.SetFloat(name, max);
		b.SetFloat(name, max);
	}
	else if (dtA == ::DT_VECTOR2)
	{
		const ::vector2 max = sef::math::max(a.GetVector2(name), b.GetVector2(name));
		a.SetVector2(name, max);
		b.SetVector2(name, max);
	}
	else if (dtA == ::DT_VECTOR3)
	{
		const ::vector3 max = sef::math::max(a.GetVector3(name), b.GetVector3(name));
		a.SetVector3(name, max);
		b.SetVector3(name, max);
	}
	else
	{
		return false;
	}
	return true;
}

bool transferCustomData(const ::string &in name, ::ETHEntity@ source, ::ETHEntity@ dest)
{
	const ::DATA_TYPE dt = source.CheckCustomData(name);
	if (dt == ::DT_STRING)
	{
		dest.SetString(name, source.GetString(name));
	}
	else if (dt == ::DT_UINT)
	{
		dest.SetUInt(name, source.GetUInt(name));
	}
	else if (dt == ::DT_INT)
	{
		dest.SetInt(name, source.GetInt(name));
	}
	else if (dt == ::DT_FLOAT)
	{
		dest.SetFloat(name, source.GetFloat(name));
	}
	else if (dt == ::DT_VECTOR2)
	{
		dest.SetVector2(name, source.GetVector2(name));
	}
	else if (dt == ::DT_VECTOR3)
	{
		dest.SetVector3(name, source.GetVector3(name));
	}
	else
	{
		return false;
	}
	return true;
}

::vector2 getEntityPos(const ::string &in name, const ::vector2 &in bucket)
{
	const ::vector3 pos(sef::util::getEntityPos3D(name, bucket));
	return ::vector2(pos.x, pos.y);
}

::vector2 getEntityPos(const ::string &in name)
{
	const ::vector3 pos(sef::util::getEntityPos3D(name));
	return ::vector2(pos.x, pos.y);
}

::vector3 getEntityPos3D(const ::string &in name, const ::vector2 &in bucket)
{
	::ETHEntity@ entity = sef::seeker::forceSeekEntityAroundBucket(bucket, name);
	if (entity !is null)
		return entity.GetPosition();
	else
		return ::vector3();
}

::vector3 getEntityPos3D(const ::string &in name)
{
	::ETHEntity@ entity = ::SeekEntity(name);
	if (entity !is null)
		return entity.GetPosition();
	else
		return ::vector3();
}

::vector3 getEntityPos3D_s(const ::string &in name, const ::vector3 defaultValue = ::vector3(0.0f))
{
	::ETHEntity@ entity = ::SeekEntity(name);
	if (entity !is null)
		return entity.GetPosition();
	else
		return defaultValue;
}

void wakeEntitiesAroundBucket(const ::vector2 &in bucket)
{
	::ETHEntityArray entities;
	::GetEntitiesAroundBucket(bucket, entities);
	for (uint t = 0; t < entities.Size(); t++)
	{
		::ETHPhysicsController@ controller = entities[t].GetPhysicsController();
		if (!entities[t].IsStatic() && controller !is null)
		{
			controller.SetAwake(true);
		}
	}
}

void strechSprite(const ::string &in name, const ::vector2 &in min, const ::vector2 &in max, const uint color)
{
	if (!sef::math::isPointInScreen(min) && !sef::math::isPointInScreen(max))
		return;

	const ::vector2 actualMin(sef::math::min(min, max));
	const ::vector2 actualMax(sef::math::max(min, max));

	::SetSpriteOrigin(name, ::vector2(0.0f));
	::DrawShapedSprite(name, actualMin, actualMax - actualMin, color);
}

void drawLine(const ::vector2 &in a, const ::vector2 &in b, const uint color, const float width = 1.0f, const ::string &in bitmap = "SEF/media/sef-white.png")
{
	const ::vector2 v(a - b);
	::SetSpriteOrigin(bitmap, ::vector2(0.5f, 1.0f));
	::DrawShapedSprite(bitmap, a, vector2(width, length(v)), color, radianToDegree(getAngle(v)));
}

void drawAlignedLine(
	const ::vector2 &in pos,
	const ::string &in text,
	const ::string &in font,
	const uint color,
	const ::vector2 &in alignmentOrigin,
	const float scale,
	const ::vector2 &in selfFullTextBoxSize)
{
	::DrawText(pos - (selfFullTextBoxSize * alignmentOrigin), text, font, color, scale);
}

void drawAlignedLine(
	const ::vector2 &in pos,
	const ::string &in text,
	const ::string &in font,
	const uint color,
	const ::vector2 alignmentOrigin,
	const float scale = 1.0f)
{
	const ::vector2 fullTextBoxSize(::ComputeTextBoxSize(font, text) * scale);
	sef::util::drawAlignedLine(pos, text, font, color, alignmentOrigin, scale, fullTextBoxSize);
}

void drawAlignedParagraph(
	const ::vector2 &in pos,
	const ::string &in text,
	const ::string &in font,
	const uint color,
	const ::vector2 alignmentOrigin,
	const float scale = 1.0f,
	const float lineSpacing = 1.0f)
{
	const ::vector2 fullTextBoxSize(::ComputeTextBoxSize(font, text) * scale);
	::string[] lines = sef::string::split(text, "\n");
	const float lineHeight = (fullTextBoxSize.y / float(lines.length())) * lineSpacing;

	::vector2 cursor(pos.x, pos.y - (fullTextBoxSize.y * alignmentOrigin.y));
	for (uint t = 0; t < lines.length(); t++)
	{
		sef::util::drawAlignedLine(cursor, lines[t], font, color, ::vector2(alignmentOrigin.x, 0.0f), scale);
		cursor.y += lineHeight;
	}
}

class InsertElementEvent : sef::Event
{
	sef::UIElement@ m_element;
	sef::UILayer@ m_layer;

	InsertElementEvent(sef::UILayer@ layer, sef::UIElement@ element)
	{
		@m_layer = @layer;
		@m_element = @element;
	}

	void run() override
	{
		if (m_layer !is null && m_element !is null)
		{
			m_layer.insertElement(@m_element);
		}
	}
}

class RemoveLayerEvent : sef::Event
{
	private ::string m_name;

	RemoveLayerEvent(const ::string &in name)
	{
		m_name = name;
	}

	void run() override
	{
		sef::UILayerManager@ layerManager = sef::util::getBaseStateLayerManager();
		layerManager.removeLayer(m_name);
	}
}

class SetSharedDataEvent : sef::Event
{
	private ::string m_key;
	private ::string m_value;

	SetSharedDataEvent(const ::string &in key, const ::string &in value)
	{
		m_key = key;
		m_value = value;
	}

	void run() override
	{
		::SetSharedData(m_key, m_value);
	}
}

void alignElements(
	sef::UIDrawable@[]@ elements,
	const uint maxColumns,
	const ::vector2 &in size,
	const ::vector2 &in normOffset = ::vector2(0.0f))
{
	const ::vector2 screenSize(::GetScreenSize());

	const uint numElements = elements.length();
	const uint numColumns = ::min(maxColumns, numElements);
	const uint numRows = uint(::ceil(float(numElements) / float(maxColumns)));

	const float width  = float(numColumns) * size.x;
	const float height = float(numRows)    * size.y;

	::vector2 cursor((screenSize * 0.5f) - (vector2(width, height) * 0.5f) + (size * 0.5f));
	const ::vector2 firstElementPos(cursor);

	const bool willHaveToCentralizeLastRow = (numElements % numColumns > 0);

	uint currentColumn = 0;
	uint currentRow = 0;
	for (uint t = 0; t < numElements; t++)
	{
		currentColumn++;

		elements[t].setNormPos(sef::math::normalizePosition(cursor) + normOffset);

		cursor.x += (size.x);
		if (currentColumn >= maxColumns)
		{
			currentColumn = 0;
			++currentRow;
			cursor.x = firstElementPos.x;
			cursor.y += (size.y);

			if (willHaveToCentralizeLastRow)
			{
				const bool isLastRow = (currentRow == (numRows - 1));
				if (isLastRow)
				{
					const uint elementsInLastRow = numElements % numColumns;
					const float lastRowWidth  = float(elementsInLastRow) * size.x;
					cursor.x = ((screenSize.x * 0.5f) - (lastRowWidth * 0.5f) + (size.x * 0.5f));
				}
			}
		}
	}
}

void alignElements(
	sef::UIButton@[]@ buttonElements,
	const uint maxColumns,
	const ::vector2 &in size,
	const ::vector2 &in normOffset = ::vector2(0.0f))
{
	sef::UIDrawable@[] elements;
	for (uint t = 0; t < buttonElements.length(); t++)
	{
		elements.insertLast(@buttonElements[t]);
	}
	sef::util::alignElements(@elements, maxColumns, size, normOffset);
}

sef::UIDrawable@ pickDrawableFromArray(sef::UIDrawable@[]@ elements, const string &in name)
{
	for (uint t = 0; t < elements.length(); t++)
	{
		if (elements[t].getName() == name)
		{
			return @elements[t];
		}
	}
	return null;
}

::string getStringFromJSONObject(JSONObject parent, const ::string &in key, const ::string &in defaultValue = "")
{
	JSONObject child = parent.GetObjectItem(key);
	if (child.IsString())
	{
		return child.GetStringValue();
	}
	else if (child.IsNumber())
	{
		return "" + child.GetDoubleValue();
	}
	else if (child.IsBool())
	{
		return child.IsTrue() ? "true" : "false";
	}
	else
	{
		return defaultValue;
	}
}

bool getBooleanFromJSONObject(JSONObject parent, const ::string &in key, const bool defaultValue = false)
{
	JSONObject child = parent.GetObjectItem(key);
	if (child.IsString())
	{
		return child.GetStringValue() == "true";
	}
	else if (child.IsBool())
	{
		return child.IsTrue();
	}
	else
	{
		return defaultValue;
	}
}

double getNumberFromJSONObject(JSONObject parent, const ::string &in key, const double defaultValue = 0.0)
{
	JSONObject child = parent.GetObjectItem(key);
	if (child.IsNumber())
	{
		return child.GetDoubleValue();
	}
	else if (child.IsString())
	{
		if (sef::string::isValidNumber(child.GetStringValue()))
		{
			return parseDouble(child.GetStringValue());
		}
	}
	return defaultValue;
}

uint getUIntFromJSONObject(JSONObject parent, const ::string &in key, const uint defaultValue = 0)
{
	return uint(sef::util::getNumberFromJSONObject(parent, key, defaultValue));
}

int getIntFromJSONObject(JSONObject parent, const ::string &in key, const int defaultValue = 0)
{
	return int(sef::util::getNumberFromJSONObject(parent, key, defaultValue));
}

float getFloatFromJSONObject(JSONObject parent, const ::string &in key, const float defaultValue = 0.0)
{
	return float(sef::util::getNumberFromJSONObject(parent, key, defaultValue));
}

vector3 setIndexedValue(vector3 v, const uint index, const float value)
{
	switch (index)
	{
	case 0:
		v.x = value;
		break;
	case 1:
		v.y = value;
		break;
	case 2:
		v.z = value;
		break;
	}
	return v;
}

bool isEqual(const ::float[]@ v, const float f)
{
	const int size = int(v.length());
	for (int t = 0; t < size; t++)
	{
		if (v[t] != f)
		{
			return false;
		}
	}
	return true;
}

} // namespace util
} // namespace sef
