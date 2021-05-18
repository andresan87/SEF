namespace sef {
namespace effects {

void quickBounceConstructor(ETHEntity@ thisEntity, const float startQuickBounceTime)
{
	thisEntity.SetFloat("sef_quickBounce_bounceTime", startQuickBounceTime);
	thisEntity.SetVector2("sef_quickBounce_originalPivotAdjust", thisEntity.GetPivotAdjust());
}

void quickBounceConstructor(ETHEntity@ thisEntity)
{
	sef::effects::quickBounceConstructor(thisEntity, randF(10000.0f));
}

void quickBounceUpdate(ETHEntity@ thisEntity, const uint bounceStride, const float unscaledStride, const bool vertical)
{
	const float bounceTime = thisEntity.AddToFloat("sef_quickBounce_bounceTime", sef::TimeManager.getLastFrameElapsedTimeF());

	const float pivotValue = sin(bounceTime / bounceStride) * (unscaledStride);

	thisEntity.SetPivotAdjust(
		vector2(
			vertical ? 0.0f : pivotValue,
			vertical ? pivotValue : 0.0f)
		+ thisEntity.GetVector2("sef_quickBounce_originalPivotAdjust"));
}

void quickCircularBounceUpdate(ETHEntity@ thisEntity, const uint bounceStride, const float unscaledStride, const bool clockwise)
{
	const float bounceTime = thisEntity.AddToFloat("sef_quickBounce_bounceTime", sef::TimeManager.getLastFrameElapsedTimeF());

	const float angle = (bounceTime / bounceStride) * ((clockwise) ? 1.0f : -1.0f);
	const vector2 rotation(sef::math::rotate(::vector2(1.0f, 0.0f), angle) * (unscaledStride));

	thisEntity.SetPivotAdjust(rotation);
}

void quickVerticalBounceUpdate(ETHEntity@ thisEntity, const uint bounceStride, const float unscaledStride)
{
	sef::effects::quickBounceUpdate(thisEntity, bounceStride, unscaledStride, true);
}

void quickLightBlinkEffectConstructor(::ETHEntity@ thisEntity, const uint timeStride, sef::Color@ a, sef::Color@ b)
{
	thisEntity.SetFloat("sef_quickLightBlinkEffect_elapsedTime", 0.0f);

	thisEntity.SetFloat("sef_quickLightBlinkEffect_timeStride", float(timeStride));

	thisEntity.SetFloat("sef_quickLightBlinkEffect_alphaA", a.getAlpha());
	thisEntity.SetFloat("sef_quickLightBlinkEffect_alphaB", b.getAlpha());

	thisEntity.SetVector3("sef_quickLightBlinkEffect_colorA", a.getVector3());
	thisEntity.SetVector3("sef_quickLightBlinkEffect_colorB", b.getVector3());
}

void quickLightBlinkEffectUpdate(::ETHEntity@ thisEntity, const bool emissive = false)
{
	const float elapsedTime = thisEntity.AddToFloat("sef_quickLightBlinkEffect_elapsedTime", sef::TimeManager.getLastFrameElapsedTimeF());

	const float timeStride = thisEntity.GetFloat("sef_quickLightBlinkEffect_timeStride");
	const float bias = (sin((elapsedTime * sef::math::PI2) / timeStride) + 1.0f) / 2.0f;

	const ::vector3 color(sef::interpolator::interpolate(
		thisEntity.GetVector3("sef_quickLightBlinkEffect_colorA"),
		thisEntity.GetVector3("sef_quickLightBlinkEffect_colorB"),
		bias));

	if (emissive)
		thisEntity.SetEmissiveColor(color);
	else
		thisEntity.SetColor(color);

	thisEntity.SetAlpha(
		sef::interpolator::interpolate(
			thisEntity.GetFloat("sef_quickLightBlinkEffect_alphaA"),
			thisEntity.GetFloat("sef_quickLightBlinkEffect_alphaB"),
			bias
		)
	);
}

sef::effects::WaypointAnimationManager@ setupEmptyAnimationManager(
	::ETHEntity@ thisEntity,
	const float scale = 1.0f,
	const bool deleteWhenFinished = false)
{
	sef::effects::WaypointAnimationManager animation;
	thisEntity.SetObject("sef::WaypointAnimationManager", @animation);

	thisEntity.SetVector3("sef::startPos", thisEntity.GetPosition());
	thisEntity.SetFloat("sef::startAngle", thisEntity.GetAngle());
	thisEntity.SetFloat("sef::scale", scale);
	thisEntity.SetVector3("sef::color", thisEntity.GetColor());
	thisEntity.SetVector2("sef::pivotAdjust", thisEntity.GetPivotAdjust());

	if (deleteWhenFinished)
		thisEntity.SetUInt("sef::deleteWhenFinished", 1);

	return @animation;
}

void setupPopEffect(
	::ETHEntity@ thisEntity,
	const uint stride,
	const float scaleOffset,
	const float scale = 1.0f,
	const bool elastic = false)
{
	sef::effects::WaypointAnimationManager@ animation = sef::effects::setupEmptyAnimationManager(thisEntity, scale);

	sef::WaypointManager@ zoomFx =
		sef::uieffects::createZoomEffect(
			scaleOffset,
			sef::Color(0xFFFFFFFF),
			sef::Color(0xFFFFFFFF),
			0,
			true, // zoomIn
			true, // fadeIn
			stride,
			elastic);

	animation.insert(@zoomFx);
}

void dismiss(::ETHEntity@ thisEntity, sef::WaypointManager@ fx)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	animation.clear();
	animation.insert(@fx);
	thisEntity.SetUInt("sef::deleteWhenFinished", 1);
}

void insertBlinkingEffect(::ETHEntity@ thisEntity, const uint stride, const sef::Color@ invisibleColor)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	animation.insert(sef::uieffects::createBlinkingEffect(stride, @invisibleColor));
}

void insertFloatingEffect(::ETHEntity@ thisEntity, const uint stride, const float scale, const float angle = 0.0f)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	animation.insert(sef::uieffects::createFloatingEffect(stride, scale, angle));
}

void insertAnimation(::ETHEntity@ thisEntity, sef::WaypointManager@ manager)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	animation.insert(@manager);
}

void goTo(
	::ETHEntity@ thisEntity,
	const ::vector3 &in pos,
	const uint time,
	const ::vector3 &in color = ::vector3(1))
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	if (animation is null)
		return;

	sef::WaypointManager goto(false);
	sef::Waypoint lastWaypoint = animation.getLastWaypoint();
	goto.addWaypoint(sef::Waypoint(
		thisEntity.GetPosition() - thisEntity.GetVector3("sef::startPos"),
		time,
		sef::Color(thisEntity.GetColor()),
		@lastWaypoint.filter,
		lastWaypoint.angle,
		lastWaypoint.scale));

	sef::Waypoint dest(pos, 0, sef::Color(color), @lastWaypoint.filter, lastWaypoint.angle, lastWaypoint.scale);
	goto.addWaypoint(@dest);

	animation.insert(@goto);
}

class GoToEvent : sef::Event
{
	::ETHEntity@ m_thisEntity;
	::vector3 m_pos;
	uint m_time;
	::vector3 m_color;

	GoToEvent(
		::ETHEntity@ thisEntity,
		const ::vector3 &in pos,
		const uint time,
		const ::vector3 &in color = ::vector3(1))
	{
		@m_thisEntity = @thisEntity;
		m_pos = pos;
		m_time = time;
		m_color = color;
	}

	void run()
	{
		sef::effects::goTo(m_thisEntity, m_pos, m_time, m_color);
	}
}

void insertAnimation(::ETHEntity@ thisEntity, sef::Waypoint@[]@ preDefined, const bool repeat)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);
	if (animation is null)
		return;

	sef::WaypointManager anim(repeat, @preDefined);
	animation.insert(@anim);
}

bool isFinished(::ETHEntity@ thisEntity)
{
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);

	if (animation is null)
		return false;

	return animation.isFinished();
}

void update(::ETHEntity@ thisEntity, const bool pivotOnly = false)
{
	bool deleted;
	sef::effects::update(thisEntity, pivotOnly, deleted);
}

void update(::ETHEntity@ thisEntity, const bool pivotOnly, bool &out deleted)
{
	deleted = false;
	sef::effects::WaypointAnimationManager@ animation;
	thisEntity.GetObject("sef::WaypointAnimationManager", @animation);

	if (animation is null)
		return;

	animation.update();

	if (animation.isFinished() && thisEntity.GetUInt("sef::deleteWhenFinished") != 0)
	{
		::DeleteEntity(thisEntity);
		deleted = true;
		return;
	}
	sef::Waypoint point = animation.getCurrentPoint();
	if (pivotOnly)
	{
		thisEntity.SetPivotAdjust(point.pos + thisEntity.GetVector2("sef::pivotAdjust"));
		thisEntity.SetVector2("sef::virtualScale", vector2(point.scale));
	}
	else
	{
		thisEntity.SetScale(::vector2(point.scale) * (thisEntity.GetFloat("sef::scale")));
		thisEntity.SetPosition((::vector3(point.pos, point.z)) + thisEntity.GetVector3("sef::startPos"));
		thisEntity.SetAlpha(point.color.getAlpha());
		thisEntity.SetAngle(point.angle + thisEntity.GetFloat("sef::startAngle"));
		thisEntity.SetColor(point.color.getVector3() * thisEntity.GetVector3("sef::color"));
	}
}

class WaypointAnimationManager
{
	private sef::WaypointManager@[] m_effects;
	private sef::Waypoint m_currentPoint;

	void insert(sef::WaypointManager@ waypoints, const bool last = true)
	{
		if (last)
			m_effects.insertLast(@waypoints);
		else
			m_effects.insertAt(0, @waypoints);
	}

	void clear()
	{
		m_effects.resize(0);
	}

	sef::Waypoint getCurrentPoint() const
	{
		return m_currentPoint;
	}

	sef::Waypoint getLastWaypoint() const
	{
		const uint len = m_effects.length();
		if (len > 0)
		{
			return m_effects[len - 1].getLastWaypoint();
		}
		else
		{
			return sef::Waypoint();
		}
	}

	bool isFinished() const
	{
		if (m_effects.length() == 0)
			return true;
		return m_effects[0].isFinished();
	}

	void update()
	{
		if (m_effects.length() >= 1)
		{
			m_effects[0].update();
			m_currentPoint = m_effects[0].getCurrentPoint();

			if (m_effects[0].isFinished())
			{
				goToNext();
			}
		}
	}

	uint getNumAnimations() const
	{
		return m_effects.length();
	}

	void goToNext()
	{
		if (m_effects.length() >= 1)
		{
			m_effects.removeAt(0);
		}		
	}
}

void lock(::ETHEntity@ entity, const bool locked)
{
	entity.SetUInt("locked", locked ? 1 : 0);
	entity.SetVector3("lockPos", entity.GetPosition());
	entity.SetFloat("lockAngle", entity.GetAngle());
	entity.SetUInt("lockElapsedTime", 0);

	::ETHPhysicsController@ controller = entity.GetPhysicsController();
	if (controller !is null)
	{
		controller.SetLinearVelocity(::vector2(0.0f));
		controller.SetAngularVelocity(0.0f);
	}
}

bool isLocked(::ETHEntity@ entity)
{
	return (entity.GetUInt("locked") != 0);
}

uint getLockElapsedTime(::ETHEntity@ entity)
{
	return entity.GetUInt("lockElapsedTime");
}

bool doLocking(::ETHEntity@ entity)
{
	if (!sef::effects::isLocked(entity))
		return false;

	entity.AddToUInt("lockElapsedTime", sef::TimeManager.getLastFrameElapsedTime());
	entity.SetPosition(entity.GetVector3("lockPos"));
	entity.SetAngle(entity.GetFloat("lockAngle"));
	return true;
}

void scaleToSize(::ETHEntity@ entity, const ::vector2 &in size)
{
	const ::vector2 currentSize(entity.GetSize());
	entity.Scale(::vector2(size.x / currentSize.x, size.y / currentSize.y));
}

} // namespace effects
} // namespace sef
