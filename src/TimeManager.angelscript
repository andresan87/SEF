namespace sef {

namespace internal {
	const string SD_PAUSE_COMMAND = "com.magicrampage.pauseCommand";

	class TimeManager
	{
		private float m_factor;

		TimeManager()
		{
			m_factor = 1.0f;
		}
		
		bool isPaused() const
		{
			return (m_factor == 0.0f);
		}

		void pause()
		{
			setFactor(0.0f);
		}

		void resume()
		{
			setFactor(1.0f);
		}

		float getFactor() const
		{
			return m_factor;
		}

		uint getLastFrameElapsedTime()
		{
			return uint(getLastFrameElapsedTimeF());
		}

		float getLastFrameElapsedTimeF()
		{
			return (::GetLastFrameElapsedTimeF() * m_factor);
		}

		void setFactor(float _factor)
		{
			m_factor = _factor;
			::SetTimeStepScale(m_factor);
		}

		float unitsPerSecond(const float speed)
		{
			return float(speed * (::min(::GetLastFrameElapsedTimeF(), 200.0f) / 1000.0f)) * m_factor;
		}

		::vector2 unitsPerSecond(const ::vector2 dir)
		{
			return ::vector2(unitsPerSecond(dir.x), unitsPerSecond(dir.y));
		}

		void update()
		{
			if (GetSharedData(SD_PAUSE_COMMAND) != "")
			{
				if (GetSharedData(SD_PAUSE_COMMAND) == "pause")
				{
					pause();
				}
				else if (GetSharedData(SD_PAUSE_COMMAND) == "resume")
				{
					resume();
				}

				SetSharedData(SD_PAUSE_COMMAND, "");
			}
		}
	}
} // namespace internal

sef::internal::TimeManager TimeManager;

} // namespace sef
