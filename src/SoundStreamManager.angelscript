namespace sef {

class StreamableSound
{
	StreamableSound(const float time, const ::string &in soundName)
	{
		this.time = time;
		this.soundName = soundName;
	}

	float time;
	::string soundName;
}

interface SoundStreamListener
{
	void beforePlayback(const ::string soundName, const float time, const float startTime);
}

class SoundStreamManager : sef::GameController
{
	private sef::StreamableSound@[] m_sounds;
	private float m_elapsedTime = 0;
	private float m_startTime = 0;

	sef::SoundStreamListener@ listener;

	SoundStreamManager(const ::string &in fileName)
	{
		loadStreamFromFileInPackage(fileName);
	}

	bool loadStreamFromFileInPackage(const ::string &in fileName)
	{
		const ::string content = GetStringFromFileInPackage(::GetResourceDirectory() + fileName);
		return loadStream(content);
	}

	bool loadStream(const ::string &in content)
	{
		if (content == "")
			return false;

		const ::string[] lines = sef::string::split(content, "\n");

		if (lines.length() <= 1)
			return false;

		m_elapsedTime = m_startTime = ::parseFloat(lines[0]);

		for (uint t = 1; t < lines.length(); t++)
		{
			const ::string[] pieces = sef::string::split(lines[t], " ");
			const float time = ::parseFloat(pieces[0]);
			const ::string soundName = pieces[1];
			const bool music = (pieces.length() >= 3 && pieces[2] == "music");
			m_sounds.insertLast(sef::StreamableSound(time, soundName));
			if (music)
			{
				::LoadMusic(soundName);
			}
			else
			{
				::LoadSoundEffect(soundName);
			}
		}

		return true;
	}

	private void update() override
	{
		m_elapsedTime += sef::TimeManager.getLastFrameElapsedTimeF();

		if (m_sounds.length() == 0)
			return;

		if (m_elapsedTime >= m_sounds[0].time)
		{
			if (listener !is null)
			{
				listener.beforePlayback(m_sounds[0].soundName, m_sounds[0].time, m_startTime);
			}
			::PlaySample(m_sounds[0].soundName);
			m_sounds.removeAt(0);
		}
	}

	private void draw() override {  }
}

} // namespace sef
