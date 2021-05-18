namespace sef {

class UIFrameDrawable : sef::UIDrawable
{
	sef::FrameDrawable@ m_frameDrawable;

	UIFrameDrawable(
		const ::string &in backgroundTiles,
		const ::vector2 &in frameSize,
		const ::vector2 &in normPos,
		sef::WaypointManager@ beginningAnimation,
		const ::vector2 &in origin = ::vector2(0),
		const float scale = 1.0f)
	{
		sef::FrameDrawable frameDrawable(backgroundTiles, frameSize, false /*borderOutside*/, true /*highQuality*/);

		super(@frameDrawable, normPos, beginningAnimation, origin, scale);

		@m_frameDrawable = @frameDrawable;
	}

	void setFrameSize(const ::vector2 &in size)
	{
		m_frameDrawable.setSize(size);
	}
}

} // namespace sef
