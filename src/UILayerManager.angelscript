namespace sef {

class UILayerManager : sef::GameController
{
	private sef::UILayer@[] m_layers;
	private ::string m_activeLayer;

#if ALLOW_HUD_TOGGLE
	private bool m_hideUI = false;
#endif

	void insertLayer(sef::UILayer@ layer, const bool last = true)
	{
		if (layer.getName() != "")
			removeLayer(layer.getName());

		if (last)
			m_layers.insertLast(@layer);
		else
			m_layers.insertAt(0, @layer);

		if (m_activeLayer == "" && !layer.alwaysActive)
			m_activeLayer = layer.getName();
	}

	void setCurrentLayer(const ::string &in name)
	{
		const uint length = m_layers.length();
		for (uint t = 0; t < length; t++)
		{
			if (name == m_layers[t].getName())
			{
				setCurrentLayer(t);
			}
		}
	}

	void disableAllLayers()
	{
		m_activeLayer = "";
	}

	void setCurrentLayer(const uint t)
	{
		if (t >= m_layers.length())
		{
			m_activeLayer = "";
			return;
		}
		m_activeLayer = m_layers[t].getName();
		m_layers[t].update();
	}

	bool dismissLayer(const ::string &in name)
	{
		sef::UILayer@ layer = getLayer(name);
		if (layer !is null)
		{
			layer.dismissAllElements();
			return true;
		}
		else
		{
			return false;
		}
	}

	sef::UILayer@ getLayer(const ::string &in name)
	{
		const uint length = m_layers.length();
		for (uint t = 0; t < length; t++)
		{
			if (name == m_layers[t].getName())
			{
				return @m_layers[t];
			}
		}
		return null;
	}

	sef::UILayer@ getCurrentLayer()
	{
		return getLayer(m_activeLayer);
	}

	void draw()
	{
#if ALLOW_HUD_TOGGLE
		if (m_hideUI) return;
#endif

		sef::UILayer@[] topLayers;

		const uint length = m_layers.length();
		for (uint t = 0; t < length; t++)
		{
			// do not draw active layer just yet
			if (m_activeLayer == m_layers[t].getName() || m_layers[t].isAlwaysActive())
			{
				topLayers.insertLast(@m_layers[t]);
			}
			else
			{
				m_layers[t].draw();
			}
		}

		// draw active layer last
		for (uint t = 0; t < topLayers.length(); t++)
		{
			topLayers[t].draw();
		}
	}

	void update()
	{
#if ALLOW_HUD_TOGGLE
		if (::GetInputHandle().GetKeyState(::K_F1) == ::KS_HIT || ::GetInputHandle().JoyButtonState(0, JK_06) == ::KS_HIT) m_hideUI = !m_hideUI;
#endif

		for (uint t = 0; t < m_layers.length();)
		{
			m_layers[t].updateDismissedElements();
			if (m_layers[t].getName() == m_activeLayer || m_layers[t].isAlwaysActive())
			{
				m_layers[t].update();
				if (m_layers[t].isEmpty() && m_layers[t].isPopup())
				{
					removeLayer(m_layers[t].getName());
				}
			}
			t++;
		}
	}

	::string getCurrentLayerName() const
	{
		return m_activeLayer;
	}

	uint getNumLayers() const
	{
		return m_layers.length();
	}

	void removeLayer(const ::string &in name)
	{
		const uint length = m_layers.length();
		for (uint t = 0; t < length; t++)
		{
			if (m_layers[t].getName() == name)
			{
				#if TESTING
					::print("Layer removed: " + m_layers[t].getName());
				#endif
				const bool recoverFirstLayerWhenRemoved = m_layers[t].recoverFirstLayerWhenRemoved;
				m_layers[t].onLayerRemoved();
				m_layers.removeAt(t);

				// if it is the current active layer and there are others, activate the first
				if (m_activeLayer == name)
				{
					if (recoverFirstLayerWhenRemoved)
						setCurrentLayer(0);
					else
						m_activeLayer = "";
				}
				return;
			}
		}
	}

	private bool isLastLayer(const uint t)
	{
		if (m_layers.length() == 0)
			return false;
		return (t == (m_layers.length() - 1));
	}
}

} // namespace sef
