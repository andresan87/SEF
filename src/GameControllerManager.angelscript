namespace sef {

class GameControllerManager
{
	private sef::GameController@[] controllers;
	private sef::GameController@[] controllerRemoveList;

	void addController(sef::GameController@ controller)
	{
		controllers.insertLast(controller);
	}

	void removeController(sef::GameController@ controller)
	{
		const uint size = getControllerCount();
		for (uint t = 0; t < size; t++)
		{
			if (controller is (controllers[t]))
			{
				sef::GameControllerDestroyer@ destroyer = cast<sef::GameControllerDestroyer>(@controllers[t]);
				if (destroyer !is null)
				{
					destroyer.destroy();
				}
				controllers.removeAt(t);
				break;
			}
		}
	}

	void removeControllers(sef::GAME_CONTROLLER_CHOOSER@ choose)
	{
		const uint size = getControllerCount();
		for (uint t = 0; t < size; t++)
		{
			if (choose(@controllers[t]))
			{
				requestControllerRemove(@controllers[t]);
			}
		}
	}

	sef::GameController@ getControllerWithChooser(sef::GAME_CONTROLLER_CHOOSER@ choose)
	{
		const uint size = getControllerCount();
		for (uint t = 0; t < size; t++)
		{
			if (choose(@controllers[t]))
			{
				return (@controllers[t]);
			}
		}
		return null;
	}

	uint getControllerCount() const
	{
		return controllers.length();
	}

	sef::GameController@ getController(const uint t)
	{
		if (t >= getControllerCount())
			return null;
		else
			return @(controllers[t]);
	}

	void requestControllerRemove(sef::GameController@ controller)
	{
		controllerRemoveList.insertLast(@controller);
	}

	private void removeControllersInRemoveList()
	{
		while (controllerRemoveList.length() > 0)
		{
			removeController(@(controllerRemoveList[0]));
			controllerRemoveList.removeAt(0);
		}
	}

	void update()
	{
		removeControllersInRemoveList();
		const uint size = getControllerCount();
		for (uint t = 0; t < size; t++)
		{
			controllers[t].update();
		}
	}
	
	void draw()
	{		
		const uint size = getControllerCount();
		for (uint t = 0; t < size; t++)
		{
			controllers[t].draw();
		}
	}
}

} // namespace sef
