namespace sef {

class WorldSpaceFrameDrawable : FrameDrawable
{
	float zPos = 0.0f;

	WorldSpaceFrameDrawable(
		const ::string &in backgroundTiles,
		const ::vector2 &in frameSize,
		const bool borderOutside = false,
		const bool highQuality = true)
	{
		super(backgroundTiles, frameSize, borderOutside, highQuality);
	}

	::vector2 computeParallaxOffset(const ::vector2 &in screenSpacePos) const
	{
		return (sef::math::computeParallaxOffset(::vector3(screenSpacePos, zPos)));
	}

	void draw(const ::vector2 &in _pos, const ::vector2 &in size, const ::vector2 &in origin, const sef::Color@ color)
	{
		::vector2 nPos(_pos);
		nPos -= ::GetCameraPos();
		nPos += computeParallaxOffset(nPos);
		FrameDrawable::draw(nPos, size, origin, @color);
	}

	bool isInWorldSpace() const
	{
		return true;
	}
}

} // namespace sef
