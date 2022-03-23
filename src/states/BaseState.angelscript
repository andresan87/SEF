namespace sef {

class BaseState : sef::State
{
	protected sef::UILayerManager m_layerManager;
	protected sef::GameControllerManager m_controllerManager;
	protected sef::EventScheduler m_eventScheduler;

	protected sef::ExclusiveResourceManager@ m_resourceManager;

	protected sef::Timer m_stateElapsedTime;

	private void BaseStateDefaultConstructor(const ::string &in sceneName)
	{
		m_controllerManager.addController(@m_eventScheduler);
		m_controllerManager.addController(@m_stateElapsedTime);
		@m_resourceManager = sef::ExclusiveResourceManager(sceneName);
	}

	BaseState(
		const ::string &in sceneName,
		const ::vector2 &in bucketSize = ::vector2(256,256))
	{
		super(sceneName, bucketSize);
		BaseStateDefaultConstructor(sceneName);
	}

	BaseState(
		const ::string &in sceneName,
		const ::string &in lightmapState,
		const ::vector2 &in bucketSize = ::vector2(256,256))
	{
		super(sceneName, lightmapState, bucketSize);
		BaseStateDefaultConstructor(sceneName);
	}

	void callLayer(sef::UILayer@ layer)
	{
		addLayer(@layer);
		setCurrentLayer(layer.getName());
	}

	uint getBaseStateElapsedTime() const
	{
		return m_stateElapsedTime.getElapsedTime();
	}

	float getBaseStateElapsedTimeF() const
	{
		return m_stateElapsedTime.getElapsedTimeF();
	}

	void removeControllers(sef::GAME_CONTROLLER_CHOOSER@ choose)
	{
		m_controllerManager.removeControllers(@choose);
	}

	sef::GameController@ getControllerWithChooser(sef::GAME_CONTROLLER_CHOOSER@ choose)
	{
		return m_controllerManager.getControllerWithChooser(@choose);
	}

	sef::UILayerManager@ getLayerManager()
	{
		return @m_layerManager;
	}

	::string getCurrentLayerName() const
	{
		return m_layerManager.getCurrentLayerName();
	}

	sef::UILayer@ getCurrentLayer()
	{
		return m_layerManager.getLayer(getCurrentLayerName());
	}

	void setCurrentLayer(const ::string &in name)
	{
		m_layerManager.setCurrentLayer(name);
	}

	void scheduleEvent(const uint delay, sef::Event@ event, const bool pausable = true)
	{
		m_eventScheduler.scheduleEvent(delay, @event, pausable);
	}

	void addLayer(sef::UILayer@ layer, const bool last = true)
	{
		m_layerManager.insertLayer(@layer, last);
	}

	sef::UILayer@ getLayer(const ::string &in name)
	{
		return m_layerManager.getLayer(name);
	}

	void addController(sef::GameController@ controller)
	{
		m_controllerManager.addController(@controller);
	}

	void removeController(sef::GameController@ controller)
	{
		m_controllerManager.removeController(@controller);
	}

	void requestControllerRemove(sef::GameController@ controller)
	{
		m_controllerManager.requestControllerRemove(@controller);
	}

	uint getControllerCount() const
	{
		return m_controllerManager.getControllerCount();
	}

	sef::GameController@ getController(const uint t)
	{
		return m_controllerManager.getController(t);
	}

	void loadExclusiveResources()
	{
		m_resourceManager.loadAll();
	}

	void releaseExclusiveResources()
	{
		m_resourceManager.releaseAll();
	}

	void onUpdate()
	{
		m_controllerManager.update();

		m_layerManager.update();
		m_layerManager.draw();

		m_controllerManager.draw();
	}
}

} // namespace sef
