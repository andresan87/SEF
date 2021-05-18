namespace sef {

class StateFadeInSprite : UIDrawable
{
	StateFadeInSprite(const uint time = 1500)
	{
		super("SEF/media/sef-white.png", ::vector2(0), null, ::vector2(0), 100.0f);
		setColor(sef::Color(0xFF000000));
		setName("curtain");
		dismiss(sef::uieffects::createFadeOutEffect(time));
	}
}

} // namespace sef
