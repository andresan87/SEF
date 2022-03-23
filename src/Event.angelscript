namespace sef {

interface Event
{
	void run();
}

funcdef void EVENT();

class FunctionEvent : sef::Event
{
	private sef::EVENT@ m_event;

	FunctionEvent(sef::EVENT@ event)
	{
		@m_event = @event;
	}

	void run() override
	{
		if (m_event !is null)
		{
			m_event();
		}
	}
}

sef::Event@ createEvent(sef::EVENT@ event)
{
	return FunctionEvent(@event);
}

class PlayParticleEffectEvent : sef::Event
{
	private ::string m_fileName;
	private ::vector2 m_pos;
	private float m_angle;
	private float m_scale;

	PlayParticleEffectEvent(const ::string &in fileName, const ::vector2 &in pos, const float angle, const float scale)
	{
		m_fileName = fileName;
		m_pos = pos;
		m_angle = angle;
		m_scale = scale;
	}

	void run()
	{
		::PlayParticleEffect(m_fileName, m_pos, m_angle, m_scale);
	}
}

class DeleteEntityEvent : sef::Event
{
	private ::ETHEntity@ m_entity;

	DeleteEntityEvent(::ETHEntity@ entity)
	{
		@m_entity = @entity;
	}

	void run()
	{
		if (m_entity !is null && m_entity.IsAlive())
			::DeleteEntity(m_entity);
	}
}

class KillParticleSystemEvent : sef::Event
{
	private ::ETHEntity@ m_entity;
	private uint m_index;

	KillParticleSystemEvent(::ETHEntity@ entity, const uint index)
	{
		m_index = index;
		@m_entity = @entity;
	}

	void run()
	{
		m_entity.KillParticleSystem(m_index);
	}
}

class PlayParticleSystemEvent : sef::Event
{
	private ::ETHEntity@ m_entity;
	private uint m_index;

	PlayParticleSystemEvent(::ETHEntity@ entity, const uint index)
	{
		m_index = index;
		@m_entity = @entity;
	}

	void run()
	{
		m_entity.PlayParticleSystem(m_index);
	}
}

funcdef void RAW_FUNC();

class RunFunctionEvent : sef::Event
{
	sef::RAW_FUNC@ m_func;

	RunFunctionEvent(sef::RAW_FUNC@ rawFunc)
	{
		@m_func = @rawFunc;
	}

	void run()
	{
		m_func();
	}
}

class AddEntityEvent : sef::Event
{
	private ::string m_entityName;
	private ::vector3 m_position;
	private float m_angle;
	private ::string m_alternativeName;
	private float m_scale;

	::ETHEntity@ m_entity;

	AddEntityEvent(
		const ::string &in entityName,
		const ::vector3 &in position,
		const float angle = 0.0f,
		const ::string &in alternativeName = "",
		const float scale = 1.0f)
	{
		m_entityName = entityName;
		m_position = position;
		m_angle = angle;
		m_alternativeName = alternativeName;
		m_scale = scale;
	}

	AddEntityEvent(
		const ::string &in entityName,
		const ::vector3 &in position,
		const ::string &in alternativeName)
	{
		m_entityName = entityName;
		m_position = position;
		m_angle = 0.0f;
		m_alternativeName = alternativeName;
		m_scale = 1.0f;
	}

	void run()
	{
		::AddEntity(m_entityName, m_position, m_angle, m_entity, m_alternativeName, m_scale);
	} 	
}

class AddEntityIfOtherIsAliveEvent : sef::AddEntityEvent
{
	::ETHEntity@ m_other;

	AddEntityIfOtherIsAliveEvent(
		ETHEntity@ other,
		const ::string &in entityName,
		const ::vector3 &in position,
		const float angle = 0.0f,
		const ::string &in alternativeName = "",
		const float scale = 1.0f)
	{
		super(entityName, position, angle, alternativeName, scale);
		@m_other = other;
	}

	void run()
	{
		if (m_other.IsAlive())
		{
			AddEntityEvent::run();
		}
	} 	
}

class PlaySampleEvent : sef::Event
{
	protected ::string m_name;
	protected float m_speed;

	PlaySampleEvent(const ::string &in name, const float speed = 1.0f)
	{
		m_name = name;
		m_speed = speed;
	}

	void run()
	{
		::SetSampleSpeed(m_name, m_speed);
		::PlaySample(m_name);
	}
}

class PlaySampleEventEx : sef::PlaySampleEvent
{
	protected float m_volume;

	PlaySampleEventEx(const ::string &in name, const float speed, const float volume)
	{
		super(name, speed);
		m_volume = volume;
	}

	void run() override
	{
		::SetSampleVolume(m_name, m_volume);
		PlaySampleEvent::run();
	}
}

class SetUIntEvent : sef::Event
{
	private uint m_value;
	private ::string m_key;
	private ::ETHEntity@ m_entity;

	SetUIntEvent(::ETHEntity@ entity, const ::string &in key, const uint value)
	{
		m_key = key;
		m_value = value;
		@m_entity = @entity;
	}

	void run()
	{
		if (m_entity !is null)
		{
			m_entity.SetUInt(m_key, m_value);
		}
	}
}

class SetFrameEvent : sef::Event
{
	private uint m_frame;
	private ::ETHEntity@ m_entity;

	SetFrameEvent(::ETHEntity@ entity, const uint frame)
	{
		m_frame = frame;
		@m_entity = @entity;
	}

	void run()
	{
		if (m_entity !is null)
		{
			m_entity.SetFrame(m_frame);
		}
	}
}

class AddSceneEvent : sef::Event
{
	private string m_sceneFileName;
	private vector3 m_pos;

	AddSceneEvent(const string &in sceneFileName, const vector3 &in pos)
	{
		m_sceneFileName = sceneFileName;
		m_pos = pos;
	}

	void run() override
	{
		ETHEntityArray newPieceEntities;
		AddScene(m_sceneFileName, m_pos, newPieceEntities);
	}
}

} // namespace sef
