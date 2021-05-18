namespace sef {

class ExclusiveResourceManager
{
	private ::string[] m_sprites;

	private ::string[] m_sfxs;

	ExclusiveResourceManager(const ::string &in sceneName)
	{
		m_sprites = parseArray(sceneName, ".resources");
		m_sfxs    = parseArray(sceneName, ".sfx.resources");
	}

	::string[]@ parseArray(const ::string &in sceneName, const ::string &in suffix)
	{
		::string[] r;
		const ::string fileContent = ::GetStringFromFileInPackage(::GetResourceDirectory() + sceneName + suffix);
		if (fileContent.length() > 0)
		{
			r = sef::string::split(fileContent, "\n");
		}
		return @r;
	}

	void loadAll()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			#if TESTING
				::print("Loading exclusive sprite: " + m_sprites[t]);
			#endif
			::LoadSprite(m_sprites[t]);
		}

		for (uint t = 0; t < m_sfxs.length(); t++)
		{
			#if TESTING
				::print("Loading exclusive sound effect: " + m_sfxs[t]);
			#endif
			::LoadSoundEffect(m_sfxs[t]);
		}
	}

	void releaseAll()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			#if TESTING
				::print("Releasing exclusive sprite: " + m_sprites[t]);
			#endif
			::ReleaseSprite(m_sprites[t]);
		}
		//TO-DO/TODO: unload SFXs
	}
}

} // namespace sef
