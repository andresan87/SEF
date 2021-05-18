namespace sef {
namespace seeker {

const ::vector2[] bucketsAround = {
	::vector2(-1,-1), ::vector2(0,-1), ::vector2(1,-1),
	::vector2(-1, 0),                  ::vector2(1, 0),
	::vector2(-1, 1), ::vector2(0, 1), ::vector2(1, 1)
};

const ::vector2[] bucketsAroundXL = {
	::vector2(-1,-1), ::vector2(0,-1), ::vector2(1,-1),
	::vector2(-1, 0),                  ::vector2(1, 0),
	::vector2(-1, 1), ::vector2(0, 1), ::vector2(1, 1),

	::vector2(-2,-1), ::vector2(-2, 0), ::vector2(-2, 1),
	::vector2(2,-1),  ::vector2(2, 0),  ::vector2(2, 1),

	::vector2(-2,-2), ::vector2(-1,-2), ::vector2(0,-2), ::vector2(1,-2), ::vector2(2,-2),
	::vector2(-2, 1), ::vector2(-2, 2), ::vector2(0, 2), ::vector2(1, 2), ::vector2(2, 2)
};

interface EntityChooser
{
	bool choose(::ETHEntity@ entity);
}

class DefaultChooser : EntityChooser { bool choose(::ETHEntity@ entity) { return true; } }
class DynamicChooser : EntityChooser { bool choose(::ETHEntity@ entity) { return !entity.IsStatic(); } }

class ByNameChooser : EntityChooser
{
	private ::string m_name;

	ByNameChooser(const ::string &in name)
	{
		m_name = name;
	}

	bool choose(::ETHEntity@ entity) override
	{
		return entity.GetEntityName() == m_name;
	}

	::string getName() const
	{
		return m_name;
	}
}

class ByNamesChooser : EntityChooser
{
	private ::string[] m_names;

	ByNamesChooser(const ::string[] names)
	{
		m_names = names;
	}

	bool choose(::ETHEntity@ entity) override
	{
		for (uint t = 0; t < m_names.length(); t++)
		{
			if (m_names[t] == entity.GetEntityName())
			{
				return true;
			}
		}
		return false;
	}
}

class ByNamePrefixChooser : EntityChooser
{
	private ::string m_prefix;

	ByNamePrefixChooser(const ::string &in prefix)
	{
		m_prefix = prefix;
	}

	bool choose(::ETHEntity@ entity) override
	{
		return sef::string::prefixMatches(entity.GetEntityName(), m_prefix);
	}
}

class ByIDChooser : EntityChooser
{
	private int m_id;

	ByIDChooser(const int id)
	{
		m_id = id;
	}

	bool choose(::ETHEntity@ entity) override
	{
		return entity.GetID() == m_id;
	}
}

class LightSourceChooser : EntityChooser
{
	bool choose(::ETHEntity@ entity) override
	{
		return entity.HasLightSource();
	}
}

void seekEntities(::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	::ETHEntityArray ents;
	::GetAllEntitiesInScene(ents);
	for (uint t = 0; t < ents.Size(); t++)
	{
		::ETHEntity@ entity = @(ents[t]);
		if (chooser.choose(entity))
		{
			entities.Insert(entity);
		}
	}
}

void deleteEntities(sef::seeker::EntityChooser@ chooser)
{
	::ETHEntityArray ents;
	::GetAllEntitiesInScene(ents);
	for (uint t = 0; t < ents.Size(); t++)
	{
		::ETHEntity@ entity = @(ents[t]);
		if (chooser.choose(entity))
		{
			::DeleteEntity(entity);
		}
	}
}

::ETHEntity@ seekEntityAroundBucket(const ::vector2 &in bucket, const int ID)
{
	sef::seeker::ByIDChooser chooser(ID);
	return sef::seeker::seekEntityAroundBucket(bucket, @chooser);
}

::ETHEntity@ seekEntityAroundBucket(const ::vector2 &in bucket, const ::string &in name)
{
	sef::seeker::ByNameChooser chooser(name);
	return sef::seeker::seekEntityAroundBucket(bucket, @chooser);
}

::ETHEntity@ forceSeekEntityAroundBucket(const ::vector2 &in bucket, const ::string &in name)
{
	sef::seeker::ByNameChooser chooser(name);
	::ETHEntity@ r = sef::seeker::seekEntityAroundBucket(bucket, @chooser);
	if (r is null)
	{
		@r = ::SeekEntity(name);
	}
	return r;
}

::ETHEntity@ forceSeekEntityAroundBucket(const ::vector2 &in bucket, const int id)
{
	sef::seeker::ByIDChooser chooser(id);
	::ETHEntity@ r = sef::seeker::seekEntityAroundBucket(bucket, @chooser);
	if (r is null)
	{
		@r = ::SeekEntity(id);
	}
	return r;
}

::ETHEntity@ seekEntityAroundBucket(const ::vector2 &in bucket, sef::seeker::EntityChooser@ chooser)
{
	::ETHEntity@ ent;
	@ent = sef::seeker::seekEntityFromBucket(bucket, @chooser);

	if (ent is null)
	{
		for (uint t = 0; t < sef::seeker::bucketsAround.length(); t++)
		{
			@ent = sef::seeker::seekEntityFromBucket(bucket + sef::seeker::bucketsAround[t], @chooser);
			if (ent !is null)
				break;
		}
	}
	return ent;
}

::ETHEntity@ seekEntityAroundBucketXL(const ::vector2 &in bucket, sef::seeker::EntityChooser@ chooser)
{
	::ETHEntity@ ent;
	@ent = sef::seeker::seekEntityFromBucket(bucket, @chooser);

	if (ent is null)
	{
		for (uint t = 0; t < sef::seeker::bucketsAroundXL.length(); t++)
		{
			@ent = sef::seeker::seekEntityFromBucket(bucket + sef::seeker::bucketsAroundXL[t], @chooser);
			if (ent !is null)
				break;
		}
	}
	return ent;
}

::ETHEntity@ cyclicSeekEntityAroundBucketXL(const ::vector2 &in bucket, sef::seeker::EntityChooser@ chooser, uint cycle, uint &out outCycle)
{
	::ETHEntity@ ent;
	@ent = sef::seeker::seekEntityFromBucket(bucket, @chooser);

	if (ent is null)
	{
		++cycle;
		cycle %= sef::seeker::bucketsAroundXL.length();
		outCycle = cycle;
		@ent = sef::seeker::seekEntityFromBucket(bucket + sef::seeker::bucketsAroundXL[cycle], @chooser);
	}
	return ent;
}

void seekEntitiesAroundBucketXL(const ::vector2 &in bucket, ::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	sef::seeker::seekEntitiesFromBucket(bucket, @entities, @chooser);

	for (uint t = 0; t < sef::seeker::bucketsAroundXL.length(); t++)
	{
		sef::seeker::seekEntitiesFromBucket(bucket + sef::seeker::bucketsAroundXL[t], @entities, @chooser);
	}
}

::ETHEntity@ seekEntityFromBucket(const ::vector2 &in bucket, const ::string &in entityName)
{
	return sef::seeker::seekEntityFromBucket(bucket, sef::seeker::ByNameChooser(entityName));
}

::ETHEntity@ seekEntityFromBucket(const ::vector2 &in bucket, sef::seeker::EntityChooser@ chooser)
{
	::ETHEntityArray ents;
	::GetEntitiesFromBucket(bucket, ents);
	for (uint t = 0; t < ents.Size(); t++)
	{
		if (chooser.choose(ents[t]))
		{
			return ents[t];
		}
	}
	return null;
}

void seekEntitiesAroundBucket(const ::vector2 &in bucket, ::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	sef::seeker::seekEntitiesFromBucket(bucket, @entities, @chooser);
	for (uint t = 0; t < sef::seeker::bucketsAround.length(); t++)
	{
		sef::seeker::seekEntitiesFromBucket(bucket + sef::seeker::bucketsAround[t], @entities, @chooser);
	}
}

void seekEntitiesAroundBucket(const ::vector2 &in bucket, ::ETHEntityArray@ entities, const ::string &in entityName)
{
	sef::seeker::seekEntitiesAroundBucket(bucket, entities, sef::seeker::ByNameChooser(entityName));
}

void seekEntitiesFromBucket(const ::vector2 &in bucket, ::ETHEntityArray@ entities, const ::string &in entityName)
{
	seekEntitiesFromBucket(bucket, @entities, sef::seeker::ByNameChooser(entityName));
}

void seekEntitiesFromBucket(const ::vector2 &in bucket, ::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	::ETHEntityArray ents;
	::GetEntitiesFromBucket(bucket, ents);
	for (uint t = 0; t < ents.Size(); t++)
	{
		if (chooser.choose(ents[t]))
		{
			::ETHEntity@ entity = @(ents[t]);
			 entities.Insert(entity);
		}
	}
}

void seekEntitiesFromBuckets(const ::vector2[]@ buckets, ::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	for (uint b = 0; b < buckets.length(); b++)
	{
		::ETHEntityArray ents;
		::GetEntitiesFromBucket(buckets[b], ents);
		for (uint t = 0; t < ents.Size(); t++)
		{
			if (chooser.choose(ents[t]))
			{
				::ETHEntity@ entity = @(ents[t]);
				 entities.Insert(entity);
			}
		}
	}
}

::ETHEntityArray@ seekEntities(const string[]@ entityNames)
{
	ETHEntityArray allEntities;
	GetAllEntitiesInScene(allEntities);

	ETHEntityArray r;
	for (uint t = 0; t < allEntities.Size(); t++)
	{
		if (sef::string::equalsAny(allEntities[t].GetEntityName(), @entityNames))
		{
			r.Insert(allEntities[t]);
		}
	}
	return @r;
}

vector2[]@ findIntersectingBuckets(const vector2 &in pos, const vector2 &in size)
{
	const vector2 halfSize(size * 0.5f);
	const vector2[] rectangleEdges = {
		vector2(pos - halfSize), // upper-left corner
		vector2(pos + vector2(halfSize.x,-halfSize.y)), // upper-right corner
		vector2(pos + halfSize), // lower-right corner
		vector2(pos + vector2(-halfSize.x, halfSize.y)) // lower-left corner
	};

	vector2[] bucketSet;

	for (uint t = 0; t < rectangleEdges.length(); t++)
	{
		const vector2 edgeBucket(GetBucket(rectangleEdges[t]));
		if (bucketSet.find(edgeBucket) < 0)
		{
			bucketSet.insertLast(edgeBucket);
		}
	}

	return @bucketSet;
}

ETHEntity@ seekClosestEntityAroundBucket(const ::vector2 &in origin, sef::seeker::EntityChooser@ chooser)
{
	const ::vector2 bucket(GetBucket(origin));

	ETHEntityArray entities;
	sef::seeker::seekEntitiesAroundBucket(bucket, entities, @chooser);

	ETHEntity@ r;

	if (entities.Size() > 0)
	{
		@r = @entities[0];
	}
	else
	{
		return null;
	}

	for (uint t = 1; t < entities.Size(); t++)
	{
		if (sef::math::squaredDistance(entities[t].GetPositionXY(), origin) < sef::math::squaredDistance(r.GetPositionXY(), origin))
		{
			@r = @entities[0];
		}
	}

	return @r;
}

} // namespace seeker
} // namespace sef
