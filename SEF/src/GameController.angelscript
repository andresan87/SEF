namespace sef {

interface GameController
{
	void update();
	void draw();
}

interface GameControllerDestroyer
{
	void destroy();
}

funcdef bool GAME_CONTROLLER_CHOOSER(sef::GameController@ gameController);

} // namespace sef
