namespace sef {

class State
{
	private ::string m_sceneName;
	private ::vector2 m_bucketSize;

	State(const ::string &in sceneName, const ::vector2 &in bucketSize = ::vector2(256, 256))
	{
		m_sceneName = sceneName;
		m_bucketSize = bucketSize;
		::LoadScene(
			m_sceneName,
			"sef_internal_onSceneCreated",
			"sef_internal_onSceneUpdate",
			"sef_internal_onResume",
			bucketSize);
	}

	State(
		const ::string &in sceneName,
		const ::string &in lightmapDirectory,
		const ::vector2 &in bucketSize = ::vector2(256, 256))
	{
		m_sceneName = sceneName;
		m_bucketSize = bucketSize;
		::LoadScene(
			m_sceneName,
			"sef_internal_onSceneCreated",
			"sef_internal_onSceneUpdate",
			"sef_internal_onResume",
			lightmapDirectory,
			bucketSize);
	}

	vector2 getBucketSize() const final
	{
		return m_bucketSize;
	}

	vector2 getBucketWorldSpaceCenter(const vector2 &in bucket) const
	{
		return (bucket * m_bucketSize) + (m_bucketSize * 0.5f);
	}

	void loadExclusiveResources() {}
	void releaseExclusiveResources() {}
	void onCreated() {}
	void onUpdate() {}
	void onResume() {}
}

namespace internal {
	class StateManager
	{
		void setState(sef::State@ state)
		{
			if (m_currentState !is null)
			{
				m_currentState.releaseExclusiveResources();
			}
			@m_currentState = @state;
		}

		void runCurrentOnSceneCreatedFunction()
		{
			m_currentState.loadExclusiveResources();
			m_currentState.onCreated();
		}

		void runCurrentOnSceneUpdateFunction()
		{
			m_currentState.onUpdate();
		}

		void runCurrentOnResumeFunction()
		{
			m_currentState.loadExclusiveResources();
			m_currentState.onResume();
		}

		sef::State@ getCurrentState()
		{
			return m_currentState;
		}

		const sef::State@ getCurrentState() const
		{
			return m_currentState;
		}

		private sef::State@ m_currentState;
	}

	float g_elapsedTime = 0.0f;
} // namespace internal

sef::internal::StateManager StateManager;

sef::EventScheduler GlobalEventScheduler;

float getElapsedTimeF()
{
	return sef::internal::g_elapsedTime;
}

uint getElapsedTime()
{
	return uint(sef::internal::g_elapsedTime);
}

} // namespace sef

void sef_internal_onSceneCreated()
{
	::SetBackgroundColor(sef::state::backgroundColor);
	::SetZBuffer(sef::state::zbuffer);
	sef::StateManager.runCurrentOnSceneCreatedFunction();
	sef::statefactory::globalOnSceneCreatedFunction();
}

void sef_internal_onSceneUpdate()
{
	sef::input::update();
	sef::StateManager.runCurrentOnSceneUpdateFunction();
	sef::TimeManager.update();

	#if TESTING
		if (GetInputHandle().GetKeyState(K_F10) == KS_HIT) sef::state::showFpsRate = !sef::state::showFpsRate;
	#endif

	if (sef::state::showFpsRate)
	{
		DrawText(
			vector2(0.0f),
			"" + ::floor(GetFPSRate()) + " / " + GetNumRenderedPieces() + "/" + GetNumProcessedEntities() + "/" + GetNumEntities()
			+ " [" + GetScreenSizeInPixels().x + "x" + GetScreenSizeInPixels().y + "]",
			"Verdana20_shadow.fnt",
			0xBBFFFFFF,
			1.0f);
	}

	sef::internal::g_elapsedTime += GetLastFrameElapsedTimeF();

	sef::notificator.update();
	sef::notificator.updateDismissedElements();
	sef::notificator.draw();
	sef::statefactory::globalOnSceneUpdateFunction();
	sef::GlobalEventScheduler.update();
}

void sef_internal_onResume()
{
	::SetBackgroundColor(sef::state::backgroundColor);
	sef::StateManager.runCurrentOnResumeFunction();
	sef::statefactory::globalOnResumeFunction();
}
