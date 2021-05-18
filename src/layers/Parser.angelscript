namespace sef {

void parseLayerFileAndAddTo(const ::string &in fileName, sef::UILayer@ layer, sef::Font@ fontCreator)
{
	::enmlFile file;
	file.parseString(::GetStringFromFileInPackage(fileName));

	sef::layerparser::setLayerOptions(@file, layer);

	::string[] elements = sef::string::split(file.getEntityNames(), ",");
	for (uint t = 0; t < elements.length(); t++)
	{
		if (elements[t] == "layer")
			continue;

		sef::UIElement@ element = sef::layerparser::createElementFromEnmlEntity(@file, elements[t], @fontCreator);
		if (element !is null)
		{
			layer.insertElement(@element);
		}
	}
}

namespace layerparser {
	enum EFFECT
	{
		APPEAR,
		DISMISS
	}

	sef::WaypointManager@ createEffectFromString(
		const sef::layerparser::EFFECT effect,
		const ::string &in name,
		const ::vector2 &in normPos,
		uint delay,
		const uint effectDuration)
	{
		const bool isAppear = (effect == sef::layerparser::APPEAR);
		sef::Color colorA = (isAppear) ? sef::Color(0x00FFFFFF) : sef::Color(0xFFFFFFFF);
		sef::Color colorB = (isAppear) ? sef::Color(0xFFFFFFFF) : sef::Color(0x00FFFFFF);
		const float directionSign = 1.0f;
		const bool slideIn = isAppear;
		const bool elastic = sef::layerparser::isOptionEnabled("elastic", name, "-");

		if (name == "slide-left" || name == "slide-left-elastic")
		{
			return sef::uieffects::createSlideEffect(::vector2(-1,0) * directionSign, colorA, colorB, delay, slideIn, effectDuration, elastic);
		}
		else if (name == "slide-right" || name == "slide-right-elastic")
		{
			return sef::uieffects::createSlideEffect(::vector2(1,0) * directionSign, colorA, colorB, delay, slideIn, effectDuration, elastic);
		}
		else if (name == "slide-up" || name == "slide-up-elastic")
		{
			return sef::uieffects::createSlideEffect(::vector2(0,-1) * directionSign, colorA, colorB, delay, slideIn, effectDuration, elastic);
		}
		else if (name == "slide-down" || name == "slide-down-elastic")
		{
			return sef::uieffects::createSlideEffect(::vector2(0,1) * directionSign, colorA, colorB, delay, slideIn, effectDuration, elastic);
		}
		else if (name == "zoom-in" || name == "zoom-in-elastic")
		{
			return sef::uieffects::createZoomEffect(0.3f, colorA, colorB, delay, true, slideIn, effectDuration, elastic);
		}
		else if (name == "zoom-out" || name == "zoom-out-elastic")
		{
			return sef::uieffects::createZoomEffect(0.3f, colorA, colorB, delay, false, slideIn, effectDuration, elastic);
		}
		else if (name == "fade-in")
		{
			return sef::uieffects::createZoomEffect(0.1f, colorA, colorB, delay, true, slideIn, effectDuration, elastic);
		}
		else if (name == "fade-out")
		{
			return sef::uieffects::createZoomEffect(0.1f, colorA, colorB, delay, false, slideIn, effectDuration, elastic);
		}
		else
		{
			return (isAppear)
				? sef::uieffects::createSlideFromEdgeEffect(normPos, delay, effectDuration, elastic)
				: sef::uieffects::createSlideOutEffect(normPos,      delay, effectDuration);
		}
	}

	void setLayerOptions(::enmlFile@ file, sef::UILayer@ layer)
	{
		if (!file.exists("layer"))
			return;

		if (file.get("layer", "darkenBg") != "")
		{
			float opacity = 1.0f;
			file.getFloat("layer", "darkenBg", opacity);

			uint delay;
			if (!file.getUInt("layer", "darkenBgDelay", delay))
			{
				delay = 0;
			}

			if (opacity > 0.0f)
			{
				layer.insertBackgroundElement(sef::LayerDarkBackground(opacity, 1000, 300, vector3(0.0f), "", delay));
			}
		}

		if (sef::layerparser::isPopup(file.get("layer", "options")))
		{
			layer.setPopup(true);
		}
	}

	sef::UIElement@ createElementFromEnmlEntity(::enmlFile@ file, const ::string &in enmlEntityName, sef::Font@ fontCreator)
	{
		if (enmlEntityName == "layer")
		{
			return null;
		}

		if (!file.exists(enmlEntityName))
		{
			sef::io::ErrorMessage("layerparser::createElementFromEnmlEntity", "Couldn't find element " + enmlEntityName);
			return null;
		}

		const ::string options = file.get(enmlEntityName, "options");

		const ::string type = file.get(enmlEntityName, "type");
		::vector2 pos, origin, frameSize;

		::string appearEffect = file.get(enmlEntityName, "appearEffect");
		::string dismissEffect = file.get(enmlEntityName, "dismissEffect");
		::string fileName = file.get(enmlEntityName, "fileName");
		::string text = file.get(enmlEntityName, "text");
		::string textFont = file.get(enmlEntityName, "textFont");
		file.getFloat(enmlEntityName, "posX", pos.x);
		file.getFloat(enmlEntityName, "posY", pos.y);
		file.getFloat(enmlEntityName, "originX", origin.x);
		file.getFloat(enmlEntityName, "originY", origin.y);
		file.getFloat(enmlEntityName, "frameSizeX", frameSize.x);
		file.getFloat(enmlEntityName, "frameSizeY", frameSize.y);

		fontCreator.setFont((textFont == "") ? "Verdana20_shadow.fnt" : textFont);

		uint color;
		if (!file.getUInt(enmlEntityName, "color", color))
			color = 0xFFFFFFFF;

		uint appearDelay;
		if (!file.getUInt(enmlEntityName, "appearDelay", appearDelay))
			appearDelay = 0;

		uint dismissDelay;
		if (!file.getUInt(enmlEntityName, "dismissDelay", dismissDelay))
			dismissDelay = 0;

		float scale;
		if (!file.getFloat(enmlEntityName, "scale", scale))
			scale = 1.0f;

		float borderScale;
		if (!file.getFloat(enmlEntityName, "borderScale", borderScale))
			borderScale = 1.0f;

		uint appearEffectDuration;
		if (!file.getUInt(enmlEntityName, "appearEffectDuration", appearEffectDuration))
			 appearEffectDuration = 300;

		uint dismissEffectDuration;
		if (!file.getUInt(enmlEntityName, "dismissEffectDuration", dismissEffectDuration))
			 dismissEffectDuration = 200;

		sef::WaypointManager@ appearWaypointEffect = sef::layerparser::createEffectFromString(sef::layerparser::APPEAR, appearEffect, pos, appearDelay, appearEffectDuration);
		sef::WaypointManager@ dismissWaypointEffect = sef::layerparser::createEffectFromString(sef::layerparser::DISMISS, dismissEffect, pos, dismissDelay, dismissEffectDuration);

		// TO-DO: clear code blocks above / remove duplicate code
		sef::UIDrawable@ element;
		sef::FrameDrawable@ frameDrawable;
		if (sef::layerparser::isButton(type))
		{
			if (sef::layerparser::isPauseButton(type))
			{
				@element = sef::PauseButton(fileName, pos, @appearWaypointEffect, origin, scale);
			}
			else if (sef::layerparser::isFromFrame(type))
			{
				@frameDrawable = sef::FrameDrawable(fileName, frameSize);
				if (text != "")
				{
					frameDrawable.setText(
						text,
						@fontCreator,
						sef::Color(0xFFFFFFFF),
						1.0f);
				}
				@element = sef::UIButton(@frameDrawable, pos, @appearWaypointEffect, origin, scale);
			}
			else
			{
				@element = sef::UIButton(fileName, pos, @appearWaypointEffect, origin, scale);
			}

			// read button sfx
			sef::UIButton@ buttonElement = cast<sef::UIButton>(element);
			if (buttonElement !is null)
			{
				buttonElement.hitSoundEffect = file.get(enmlEntityName, "hitSoundEffect");
				buttonElement.releaseSoundEffect = file.get(enmlEntityName, "releaseSoundEffect");

				if (file.get(enmlEntityName, "iterable") != "")
					buttonElement.iterable = (file.get(enmlEntityName, "iterable") == "true");
			}
		}
		else if (sef::layerparser::isSprite(type))
		{
			if (sef::layerparser::isFromFrame(type))
			{
				@frameDrawable = sef::FrameDrawable(fileName, frameSize);
				if (text != "")
				{
					frameDrawable.setText(
						text,
						@fontCreator,
						sef::Color(0xFFFFFFFF),
						1.0f);
				}
				@element = sef::UIDrawable(@frameDrawable, pos, @appearWaypointEffect, origin, scale);
			}
			else
			{
				@element = sef::UIDrawable(fileName, pos, @appearWaypointEffect, origin, scale);
			}
		}
		else if (sef::layerparser::isText(type))
		{
			if (sef::layerparser::isFromFrame(type))
			{
				@frameDrawable = sef::FrameDrawable(fileName, frameSize);
				if (text != "")
				{
					frameDrawable.setText(
						text,
						@fontCreator,
						sef::Color(0xFFFFFFFF),
						1.0f);
				}
				@element = sef::UIDrawable(@frameDrawable, pos, @appearWaypointEffect, origin, scale);
			}
			else
			{
				sef::TextDrawable drawable(@fontCreator, text, scale, false, color);
				@element = sef::UIDrawable(@drawable, pos, @appearWaypointEffect, origin, 1.0f);
			}
		}

		if (element !is null)
		{
			element.setName(enmlEntityName);
			element.setDismissEffect(@dismissWaypointEffect);
		}
		else
		{
			sef::io::ErrorMessage("layerparser::createElementFromEnmlEntity",
				"Couldn't create element for " + enmlEntityName + ": " + type);
		}

		if (frameDrawable !is null)
		{
			frameDrawable.borderScale = borderScale;
		}

		return @element;
	}

	bool isButton(const ::string &in type)
	{
		return sef::layerparser::isOptionEnabled("button", type, "-");
	}

	bool isFromFrame(const ::string &in type)
	{
		return sef::layerparser::isOptionEnabled("frame", type, "-");
	}

	bool isSprite(const ::string &in type)
	{
		return sef::layerparser::isOptionEnabled("sprite", type, "-");
	}

	bool isText(const ::string &in type)
	{
		return sef::layerparser::isOptionEnabled("text", type, "-");
	}

	bool isPauseButton(const ::string &in type)
	{
		return type == "pause-button";
	}

	bool isPopup(const ::string &in options)
	{
		return sef::layerparser::isOptionEnabled("popup", options, ",");
	}

	bool isOptionEnabled(const ::string &in option, const ::string &in optionList, const ::string &in separator)
	{
		::string[] options = sef::string::split(optionList, separator);
		for (uint t = 0; t < options.length(); t++)
		{
			if (options[t] == option)
				return true;
		}
		return false;
	}
} // namespace layerparser
} // namespace sef
