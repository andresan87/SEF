namespace sef {

class OrientedBoundingBox
{
	private vector2[] corner;
	private vector2[] axis;
	private float[] origin;

	OrientedBoundingBox(const vector2 &in pos, const vector2 &in size, const float angle)
	{
		build(pos, size, angle);
	}

	OrientedBoundingBox(ETHEntity@ entity)
	{
		build(entity.GetPositionXY(), entity.GetSize(), degreeToRadian(-entity.GetAngle()));
	}

	bool overlaps(const OrientedBoundingBox@ other) const
	{
		return overlaps1Way(@other) && other.overlaps1Way(@this);
	}

	private void build(const vector2 &in pos, const vector2 &in size, const float angle)
	{
		corner.resize(4);
		axis.resize(2);
		origin.resize(2);

		vector2 x( cos(angle), sin(angle));
		vector2 y(-sin(angle), cos(angle));

		x *= size.x / 2;
		y *= size.y / 2;

		corner[0] = pos - x - y;
		corner[1] = pos + x - y;
		corner[2] = pos + x + y;
		corner[3] = pos - x + y;

		computeAxes();
	}

	private bool overlaps1Way(const OrientedBoundingBox@ other) const
	{
		for (uint a = 0; a < 2; ++a)
		{

			float t = sef::math::dot(other.corner[0], axis[a]);

			float tMin = t;
			float tMax = t;

			for (uint c = 1; c < 4; ++c)
			{
				t = sef::math::dot(other.corner[c], axis[a]);

				if (t < tMin)
				{
					tMin = t;
				}
				else if (t > tMax)
				{
					tMax = t;
				}
			}

			if ((tMin > 1 + origin[a]) || (tMax < origin[a]))
			{
				return false;
			}
		}
		return true;
	}

	private void computeAxes()
	{
		axis[0] = corner[1] - corner[0]; 
		axis[1] = corner[3] - corner[0]; 

		for (uint a = 0; a < 2; ++a)
		{
			axis[a] /= sef::math::dot(axis[a], axis[a]);
			origin[a] = sef::math::dot(corner[0], axis[a]);
		}
	}
}

} // namespace sef
