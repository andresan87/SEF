namespace sef {

class SingleLayerBaseState : sef::BaseState
{
	private sef::UILayer@ m_layer;

	SingleLayerBaseState(
		sef::UILayer@ layer,
		const ::string &in sceneName = "empty",
		const ::vector2 &in bucketSize = ::vector2(256,256))
	{
		super(sceneName, bucketSize);
		@m_layer = @layer;

		addLayer(@m_layer);
	}

	void onCreated() override
	{
		BaseState::onCreated();
	}

	void onUpdate() override
	{
		BaseState::onUpdate();
	}
}

} // namespace sef
