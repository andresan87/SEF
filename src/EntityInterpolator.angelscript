namespace sef {
namespace interpolator {

void initializeEntityInterpolator(ETHEntity@ thisEntity)
{
	thisEntity.SetFloat("sef::interpolator::elapsedTime", 0.0f);

	thisEntity.SetVector3("sef::interpolator::originPos", thisEntity.GetPosition());
	thisEntity.SetVector3("sef::interpolator::destPos", thisEntity.GetPosition());

	thisEntity.SetFloat("sef::interpolator::strideMS", 2000.0f);
}

void setEntityInterpolatorDestPos(ETHEntity@ thisEntity, const vector3 &in pos, const float stride)
{
	if (pos != thisEntity.GetVector3("sef::interpolator::destPos"))
	{
		thisEntity.SetFloat("sef::interpolator::elapsedTime", 0.0f);
		thisEntity.SetVector3("sef::interpolator::originPos", thisEntity.GetPosition());
		thisEntity.SetVector3("sef::interpolator::destPos", pos);
	}
	thisEntity.SetFloat("sef::interpolator::strideMS", stride);
}

vector3 getEntityInterpolatorDestPos(ETHEntity@ thisEntity)
{
	return thisEntity.GetVector3("sef::interpolator::destPos");
}

void updateEntityInterpolator(ETHEntity@ thisEntity, sef::easing::FUNCTION@ ease)
{
	const float elapsedTime = thisEntity.AddToFloat("sef::interpolator::elapsedTime", sef::TimeManager.getLastFrameElapsedTimeF());

	const vector3 originPos = thisEntity.GetVector3("sef::interpolator::originPos");
	const vector3 destPos   = thisEntity.GetVector3("sef::interpolator::destPos");

	const float bias = ease(min(1.0f, elapsedTime / thisEntity.GetFloat("sef::interpolator::strideMS")));

	thisEntity.SetPosition(sef::interpolator::interpolate(originPos, destPos, bias));
}

} // namespace interpolator
} // namespace sef
