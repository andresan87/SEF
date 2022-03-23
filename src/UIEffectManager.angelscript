namespace sef {

mixin class UIEffectManager
{
	private sef::UIEffect@[] m_effects;

	void addEffect(sef::UIEffect@ effect)
	{
		m_effects.insertLast(@effect);
	}

	float computeEffectScale() const
	{
		float r = 1.0f;
		for (uint t = 0; t < m_effects.length(); t++)
		{
			r *= m_effects[t].scale;
		}
		return r;
	}

	float computeEffectAlpha() const
	{
		float r = 1.0f;
		for (uint t = 0; t < m_effects.length(); t++)
		{
			r *= m_effects[t].alpha;
		}
		return r;
	}

	float computeEffectAngle() const
	{
		float r = 0.0f;
		for (uint t = 0; t < m_effects.length(); t++)
		{
			r += m_effects[t].angle;
		}
		return r;
	}

	vector2 computeEffectOffset() const
	{
		vector2 r(0.0f);
		for (uint t = 0; t < m_effects.length(); t++)
		{
			r += m_effects[t].posOffset;
		}
		return r;
	}

	vector3 computeEffectColor() const
	{
		::vector3 r(1.0f);
		for (uint t = 0; t < m_effects.length(); t++)
		{
			r = r * m_effects[t].color;
		}
		return r;
	}

	void updateEffects()
	{
		for (uint t = 0; t < m_effects.length();)
		{
			m_effects[t].update();

			if (m_effects[t].ended())
			{
				m_effects.removeAt(t);
			}
			else
			{
				t++;
			}
		}
	}

	void drawEffects() const
	{
		for (uint t = 0; t < m_effects.length(); t++)
		{
			m_effects[t].draw();
		}
	}	

	void clearEffects()
	{
		m_effects.resize(0);
	}
}

abstract class UIEffect : sef::GameController
{
	float scale = 1.0f;
	float alpha = 1.0f;
	float angle = 0.0f;
	::vector3 color = ::vector3(1.0f);
	vector2 posOffset;

	bool ended() { return false; }
	void draw() override { }
	void update() override { }
}

class UIHighlightEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_scaleA;
	private float m_scaleB;
	private ::vector3 m_colorA;
	private ::vector3 m_colorB;

	UIHighlightEffect(const uint stride, const float scaleA, const float scaleB, const ::vector3 &in colorA, const ::vector3 &in colorB)
	{
		m_stride = ::max(stride, 1);
		m_scaleA = scaleA;
		m_scaleB = scaleB;
		m_colorA = colorA;
		m_colorB = colorB;
	}

	void update() override
	{
		m_elapsedTime = min(m_elapsedTime + ::GetLastFrameElapsedTimeF(), m_stride);
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		color = sef::interpolator::interpolate(m_colorA, m_colorB, bias);
		scale = sef::interpolator::interpolate(m_scaleA, m_scaleB, bias);
	}

	void draw() override { }
}

class UIBlinkEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private uint m_stride;
	private ::vector3 m_colorA;
	private ::vector3 m_colorB;

	UIBlinkEffect(const uint stride, const ::vector3 &in colorA, const ::vector3 &in colorB)
	{
		m_stride = ::max(stride, 1);
		m_colorA = colorA;
		m_colorB = colorB;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= float(m_stride))
			m_elapsedTime -= float(m_stride);
		const float radian = (m_elapsedTime / float(m_stride)) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		color = sef::interpolator::interpolate(m_colorA, m_colorB, bias);
	}

	void draw() override { }
}

class UIBlinkAlphaEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_alphaA;
	private float m_alphaB;

	UIBlinkAlphaEffect(const float stride, const float alphaA, const float alphaB)
	{
		m_stride = ::max(stride, 1.0f);
		m_alphaA = alphaA;
		m_alphaB = alphaB;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= m_stride)
			m_elapsedTime -= m_stride;
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		alpha = sef::interpolator::interpolate(m_alphaA, m_alphaB, bias);
	}

	void draw() override { }
}

class UIFadeOutEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private uint m_stride;

	UIFadeOutEffect(const uint stride)
	{
		m_stride = ::max(stride, 1);
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		const float bias = min(m_elapsedTime / float(m_stride), 1.0f);
		alpha = sef::interpolator::interpolate(1.0f, 0.0f, bias);
	}

	void draw() override { }
}

class UIBounceEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_scaleA;
	private float m_scaleB;

	UIBounceEffect(const float stride, const float scaleA, const float scaleB, const bool randomize = false)
	{
		m_stride = ::max(stride, 1.0f);
		m_scaleA = scaleA;
		m_scaleB = scaleB;
		if (randomize)
		{
			m_elapsedTime = randF(0.0f, float(m_stride));
		}
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= m_stride)
		{
			m_elapsedTime -= m_stride;
		}
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		scale = sef::interpolator::interpolate(m_scaleA, m_scaleB, bias);
	}

	void draw() override { }
}

class UIDelayedBounceEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_scaleA;
	private float m_scaleB;

	UIDelayedBounceEffect(const float stride, const float scaleA, const float scaleB, const float delay)
	{
		m_stride = ::max(stride, 1.0f);
		m_scaleA = scaleA;
		m_scaleB = scaleB;
		m_elapsedTime = -delay;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();

		if (m_elapsedTime < 0.0f)
		{
			return;
		}

		if (m_elapsedTime >= m_stride)
		{
			m_elapsedTime -= m_stride;
		}
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		scale = sef::interpolator::interpolate(m_scaleA, m_scaleB, bias);
	}

	void draw() override { }
}

class UIFloatEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_normalizedOffset;

	UIFloatEffect(const float stride, const float normalizedOffset, const bool randomize = false)
	{
		if (randomize)
		{
			m_elapsedTime = randF(0.0f, float(m_stride));
		}

		m_stride = ::max(stride, 1.0f);
		m_normalizedOffset = normalizedOffset;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= m_stride)
			m_elapsedTime -= m_stride;
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		posOffset.y = sef::interpolator::interpolate(-m_normalizedOffset, m_normalizedOffset, bias);
	}

	void draw() override { }
}

class UIWiggleEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_angleOffset;

	UIWiggleEffect(const float stride, const float angleOffset, const bool randomize = false)
	{
		if (randomize)
		{
			m_elapsedTime = randF(0.0f, float(m_stride));
		}

		m_stride = ::max(stride, 1.0f);
		m_angleOffset = angleOffset;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= m_stride)
			m_elapsedTime -= m_stride;
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		angle = sef::interpolator::interpolate(-m_angleOffset, m_angleOffset, bias);
	}

	void draw() override { }
}

class UIParticleEffect : sef::UIEffect
{
	private uint m_elapsedTime = 0;
	private uint m_stride;
	private ::string m_element;
	private ::string m_effectName;
	private sef::UILayer@ m_layer;
	private float m_scale;

	UIParticleEffect(
		const ::string &in effectName,
		sef::UILayer@ layer,
		const ::string &in element,
		const uint stride = 2000,
		const float scale = 1.0f)
	{
		m_effectName = effectName;
		m_element = element;
		@m_layer = @layer;
		m_stride = stride;
		m_scale = scale;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTime();
	}

	void draw() override
	{
		sef::UIDrawable@ uiElement = cast<sef::UIDrawable>(m_layer.getElement(m_element));
		if (uiElement !is null && !uiElement.isDismissed() && uiElement.getAnimation() is null && m_elapsedTime > m_stride)
		{
			m_elapsedTime = 0;
			PlayParticleEffect(m_effectName, uiElement.getAbsoluteCurrentMiddlePoint(), 0.0f, m_scale);
		}
	}
}

class UIPlayParticleEffectOnce : sef::UIEffect
{
	private ::string m_effectName;
	private vector2 m_absPos;
	private float m_scale;
	private bool m_updatedOnce = false;

	UIPlayParticleEffectOnce(
		const string &in effectName,
		const ::vector2 &in absPos,
		const float scale = 1.0f)
	{
		m_effectName = effectName;
		m_absPos = absPos;
		m_scale = scale;
	}

	bool ended() override
	{
		const bool r = m_updatedOnce;
		m_updatedOnce = true;
		return r;
	}

	void update() override
	{
	}

	void draw() override
	{
		PlayParticleEffect(m_effectName, m_absPos, 0.0f, m_scale);
	}
}

class UIBounceRepeaterEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_scale;
	private uint m_repeats;
	private bool m_ended = false;

	UIBounceRepeaterEffect(
		const float stride,
		const float destScale,
		const uint repeats)
	{
		m_stride = ::max(stride, 1.0f);
		m_scale = destScale;
		m_repeats = repeats;
	}

	bool ended() override
	{
		return m_ended;
	}

	void update() override
	{
		const float maxElapsedTime = float(m_repeats) * m_stride;

		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		m_elapsedTime = ::min(m_elapsedTime, maxElapsedTime);

		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		scale = sef::interpolator::interpolate(1.0f, m_scale, bias);

		if (m_elapsedTime >= maxElapsedTime)
		{
			m_ended = true;
		}
	}

	void draw() override { }
}

class UIShakeEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_totalElapsedTime = 0.0f;
	private float m_stride;
	private float m_offset;
	private float m_duration;
	private bool m_ended = false;

	UIShakeEffect(const float stride, const float offset, const float duration)
	{
		m_stride = ::max(stride, 1.0f);
		m_offset = offset;
		m_duration = duration;
	}

	bool ended() override
	{
		return m_ended;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		m_totalElapsedTime += ::GetLastFrameElapsedTimeF();

		if (m_elapsedTime >= m_stride)
		{
			m_elapsedTime -= m_stride;
		}
		const float radian = (m_elapsedTime / m_stride) * (::PI * 2.0f);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		posOffset.x = sef::interpolator::interpolate(-m_offset, m_offset, bias);

		if (m_duration > 0 && m_totalElapsedTime >= m_duration)
		{
			m_ended = true;
		}
	}

	void draw() override { }
}

class UIWarpBackEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_startScale;
	private float m_startAlpha;

	UIWarpBackEffect(const float stride, const float startScale, const float startAlpha)
	{
		m_stride = ::max(stride, 1.0f);
		m_startScale = startScale;
		m_startAlpha = startAlpha;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();
		if (m_elapsedTime >= m_stride)
		{
			m_elapsedTime = m_stride;
		}
		const float radian = (m_elapsedTime / m_stride) * (PIb);
		const float bias = sin(radian);
		scale = sef::interpolator::interpolate(m_startScale, 1.0f, bias);
		alpha = sef::interpolator::interpolate(m_startAlpha, 1.0f, bias);
	}

	bool ended() override
	{
		return (m_elapsedTime >= m_stride);
	}

	void draw() override { }
}

class UITimedBounceEffect : sef::UIEffect
{
	private float m_elapsedTime = 0.0f;
	private float m_stride;
	private float m_delay;
	private float m_scaleA;
	private float m_scaleB;

	UITimedBounceEffect(const float stride, const float delay, const float scaleA, const float scaleB)
	{
		m_stride = ::max(stride, 1.0f);
		m_scaleA = scaleA;
		m_scaleB = scaleB;
		m_delay = delay;
	}

	void update() override
	{
		m_elapsedTime += ::GetLastFrameElapsedTimeF();

		const float fullLength = m_delay + m_stride;
		if (m_elapsedTime > fullLength)
		{
			m_elapsedTime -= fullLength;
		}

		const float radian = min(1.0f, max(0.0f, ((m_elapsedTime - m_delay) / m_stride))) * (::PI);
		const float bias = (::sin(radian) + 1.0f) / 2.0f;
		scale = sef::interpolator::interpolate(m_scaleA, m_scaleB, bias);
	}

	void addToElapsedTime(const float v)
	{
		m_elapsedTime += v;
	}

	void draw() override { }
}

} // namespace sef
