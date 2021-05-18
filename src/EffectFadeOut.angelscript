namespace sef {
namespace effect {

void constructFadeOut(::ETHEntity@ entity, const uint fadeOutTime, const uint delay = 0)
{
	entity.SetUInt("sef::elapsedTime", 0);
	entity.SetUInt("sef::fadeOutElapsedTime", 0);
	entity.SetUInt("sef::fadeOutTime", fadeOutTime);
	entity.SetUInt("sef::delay", delay);
}

uint getElapsedTime(::ETHEntity@ entity)
{
	return entity.GetUInt("sef::elapsedTime");
}

void startFadingOut(::ETHEntity@ entity)
{
	entity.SetUInt("sef::fadeOutStarted", 1);
}

bool isFadingOutStarted(::ETHEntity@ entity)
{
	return entity.GetUInt("sef::fadeOutStarted") != 0;
}

void startFadingOut(::ETHEntity@ entity, const uint fadeOutTime)
{
	startFadingOut(entity);
	entity.SetUInt("sef::fadeOutTime", fadeOutTime);
}

void updateFadeOut(::ETHEntity@ entity, const bool deleteWhenFinished)
{
	bool deleted;
	sef::effect::updateFadeOut(entity, deleteWhenFinished, deleted);
}

void forceFadeOut(::ETHEntity@ entity, const uint fadeOutTime)
{
	entity.SetUInt("sef::delay", 0);
	entity.SetUInt("sef::fadeOutTime", fadeOutTime);
}

void updateFadeOut(::ETHEntity@ entity, const bool deleteWhenFinished, bool &out deleted)
{
	deleted = false;
	entity.AddToUInt("sef::elapsedTime", sef::TimeManager.getLastFrameElapsedTime());
	if (entity.GetUInt("sef::fadeOutStarted") != 0 && sef::effect::getElapsedTime(entity) > entity.GetUInt("sef::delay"))
	{
		const uint fadeOutTime = entity.GetUInt("sef::fadeOutTime");
		entity.AddToUInt("sef::fadeOutElapsedTime", sef::TimeManager.getLastFrameElapsedTime());
		const uint fadeOutElapsedTime = entity.GetUInt("sef::fadeOutElapsedTime");

		// set fading alpha
		entity.SetAlpha(::max(0.0f, 1.0f - (float(fadeOutElapsedTime) / float(fadeOutTime))));

		// delete if finished
		if (deleteWhenFinished && fadeOutElapsedTime >= fadeOutTime)
		{
			deleted = true;
			::DeleteEntity(entity);
		}
	}
}

} // namespace effect
} // namespace sef
