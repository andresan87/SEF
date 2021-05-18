namespace sef {

class EntityTree : sef::Entity
{
	EntityTree(::ETHEntity@ ethEntity, const ::vector3 &in pos, const float angle)
	{
		ethEntity.SetPosition(pos);
		ethEntity.SetAngle(angle);
		super(null, @ethEntity, ::vector3(0.0f), 0.0f);
	}

	void setAngle(const float angle)
	{
		m_ethEntity.SetAngle(angle);
		updatePosition(@this);
	}

	void addToAngle(const float angle)
	{
		m_ethEntity.AddToAngle(angle);
		updatePosition(@this);
	}

	void setPosition(const ::vector3 &in pos)
	{
		m_ethEntity.SetPosition(pos);
		updatePosition(@this);
	}

	void setPositionXY(const ::vector2 &in pos)
	{
		m_ethEntity.SetPositionXY(pos);
		updatePosition(@this);
	}

	void addToPosition(const ::vector3 &in pos)
	{
		m_ethEntity.AddToPosition(pos);
		updatePosition(@this);
	}

	void addToPositionXY(const ::vector2 &in pos)
	{
		m_ethEntity.AddToPositionXY(pos);
		updatePosition(@this);
	}
}

class Entity
{
	private sef::Entity@[] m_children;

	protected ::ETHEntity@ m_ethEntity;
	private ::vector3 m_relativePos;
	private float m_relativeAngle;

	Entity(
		const sef::Entity@ parent,
		::ETHEntity@ ethEntity,
		const ::vector3 &in relativePos,
		const float relativeAngle)
	{
		m_relativeAngle = relativeAngle;
		@m_ethEntity = ethEntity;
		m_relativePos = relativePos;

		updatePosition(@parent);
	}

	void addToRelativePosition(const sef::Entity@ parent, const ::vector3 &in pos)
	{
		m_relativePos += pos;
		updatePosition(@parent);
	}

	void addToRelativePositionXY(const sef::Entity@ parent, const ::vector2 &in pos)
	{
		m_relativePos.x = pos.x;
		m_relativePos.y = pos.y;
		updatePosition(@parent);
	}

	void setRelativePosition(const sef::Entity@ parent, const ::vector3 &in pos)
	{
		m_relativePos = pos;
		updatePosition(@parent);
	}

	void setRelativePositionXY(const sef::Entity@ parent, const ::vector2 &in pos)
	{
		m_relativePos.x = pos.x;
		m_relativePos.y = pos.y;
		updatePosition(@parent);
	}

	void setRelativeAngle(const sef::Entity@ parent, const float angle)
	{
		m_relativeAngle = angle;
		updatePosition(@parent);
	}

	void addToRelativeAngle(const sef::Entity@ parent, const float angle)
	{
		m_relativeAngle += angle;
		updatePosition(@parent);
	}

	float getRelativeAngle() const
	{
		return m_relativeAngle;
	}

	::vector3 getPosition() const
	{
		return m_ethEntity.GetPosition();
	}

	::vector2 getPositionXY() const
	{
		return m_ethEntity.GetPositionXY();
	}

	float getAngle() const
	{
		return m_ethEntity.GetAngle();
	}

	void getAllEntities(::ETHEntityArray@ entities)
	{
		entities.Insert(m_ethEntity);
		for (uint t = 0; t < m_children.length(); t++)
		{
			m_children[t].getAllEntities(@entities);
		}
	}

	::ETHEntity@ getETHEntity()
	{
		return @m_ethEntity;
	}

	sef::Entity@ insertChild(
		::ETHEntity@ ethEntity,
		const ::vector3 &in relativePos,
		const float relativeAngle)
	{
		sef::Entity entity(@this, @ethEntity, relativePos, relativeAngle);
		m_children.insertLast(@entity);
		entity.updatePosition(@this);
		return @entity;
	}

	bool removeChild(const sef::Entity@ child, const bool deleteEntity)
	{
		for (uint t = 0; t < m_children.length(); t++)
		{
			if (child is m_children[t])
			{
				if (deleteEntity)
					::DeleteEntity(m_children[t].getETHEntity());
				m_children[t].removeAllChildren(deleteEntity);
				m_children.removeAt(t);
				return true;
			}
		}
		return false;
	}

	void removeAllChildren(const bool deleteEntity)
	{
		while (m_children.length() > 0)
		{
			removeChild(@m_children[0], deleteEntity);
		}
	}

	void updatePosition(const sef::Entity@ parent)
	{
		if (parent !is null)
		{
			m_ethEntity.SetAngle(parent.getAngle() + m_relativeAngle);
			const ::vector2 rotatedRelativePos(
				sef::math::rotate(
					::vector2(m_relativePos.x, m_relativePos.y), -degreeToRadian(parent.getAngle())));
			m_ethEntity.SetPosition(parent.getPosition() + (::vector3(rotatedRelativePos, m_relativePos.z)));
		}

		for (uint t = 0; t < m_children.length(); t++)
		{
			m_children[t].updatePosition(@this);
		}
	}
}

} // namespace sef
