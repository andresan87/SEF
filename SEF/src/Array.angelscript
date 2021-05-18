namespace sef {
namespace array {

bool hasStaticEntity(::ETHEntityArray@ entities)
{
	for (uint t = 0; t < entities.Size(); t++)
	{
		if (entities[t].IsStatic())
			return true;
	}
	return false;
}

bool hasStaticEntityExceptID(::ETHEntityArray@ entities, const int id)
{
	for (uint t = 0; t < entities.Size(); t++)
	{
		::ETHEntity@ entity = @(entities[t]);
		if (entity.IsStatic() && entity.GetID() != id)
			return true;
	}
	return false;
}

bool hasEntity(::ETHEntityArray@ entities, sef::seeker::EntityChooser@ chooser)
{
	for (uint t = 0; t < entities.Size(); t++)
	{
		if (chooser.choose(@(entities[t])))
			return true;
	}
	return false;
}

} // namespace array
} // namespace sef
