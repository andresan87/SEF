namespace sef {

class LayerDarkBackground : UIDrawable
{
	LayerDarkBackground(
		const float opacity,
		const uint fadeInTime = 1000,
		const uint fadeOutTime = 300,
		const ::vector3 color = ::vector3(0.0f),
		const ::string sprite = "",
		const uint delay = 0,
		const uint dismissDelay = 0)
	{
		const ::string spriteName = (sprite == "") ? "SEF/media/sef-white-2-1.png" : sprite;
		const float scaleY = (::GetScreenSize().y / ::GetSpriteFrameSize(spriteName).y);
		const float scaleX = (::GetScreenSize().x / ::GetSpriteFrameSize(spriteName).x);
		const float scale = max(scaleX, scaleY);

		super(
			spriteName,
			::vector2(0.5f),
			sef::uieffects::createColorBlendEffect(sef::Color(0x00FFFFFF), sef::Color(0xFFFFFFFF), fadeInTime, delay),
			::vector2(0.5f),
			scale);

		setColor(sef::Color(opacity, color));
		setDismissEffect(sef::uieffects::createColorBlendEffect(sef::Color(0xFFFFFFFF), sef::Color(0x00FFFFFF), fadeOutTime, dismissDelay));
		setName("background");
	}
}

} // namespace sef
