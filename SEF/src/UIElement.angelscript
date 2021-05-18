namespace sef {

interface UIElement
{
	void draw();
	void update();
	::string getName() const;

	bool isDismissed() const;
	void dismiss();
	bool isDead() const;
}

} // namespace sef
