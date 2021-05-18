namespace sef {

class SetDestinationEvent : sef::Event
{
	private sef::Follower@ m_follower;
	private ::vector3 m_pos;

	SetDestinationEvent(sef::Follower@ follower, const ::vector3 &in pos)
	{
		@m_follower = @follower;
		m_pos = pos;
	}

	void run()
	{
		m_follower.setDestinationPos(m_pos);
	}
}

} // namespace sef
