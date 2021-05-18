#include "src/GameController.angelscript"
#include "src/String.angelscript"
#include "src/TimeManager.angelscript"
#include "src/FrameTimer.angelscript"
#include "src/Timer.angelscript"
#include "src/Follower.angelscript"
#include "src/FollowerAsymptotic.angelscript"
#include "src/SetDestinationEvent.angelscript"
#include "src/Easing.angelscript"
#include "src/Interpolator.angelscript"
#include "src/Color.angelscript"
#include "src/WaypointManager.angelscript"
#include "src/IO.angelscript"
#include "src/EffectFadeOut.angelscript"
#include "src/Math.angelscript"
#include "src/Time.angelscript"
#include "src/StateManager.angelscript"
#include "src/GameControllerManager.angelscript"
#include "src/Drawable.angelscript"
#include "src/TextDrawable.angelscript"
#include "src/FrameDrawable.angelscript"
#include "src/WorldSpaceFrameDrawable.angelscript"
#include "src/Font.angelscript"
#include "src/Util.angelscript"
#include "src/Effects.angelscript"
#include "src/Seeker.angelscript"
#include "src/Notification.angelscript"
#include "src/Input.angelscript"
#include "src/Event.angelscript"
#include "src/EventScheduler.angelscript"
#include "src/Array.angelscript"
#include "src/UserData.angelscript"
#include "src/ExclusiveResourceManager.angelscript"
#include "src/PositionTracker.angelscript"
#include "src/EntityTree.angelscript"
#include "src/KeyStateManager.angelscript"
#include "src/SoundStreamManager.angelscript"
#include "src/OrientedBoundingBox.angelscript"
#include "src/JSON.angelscript"

#include "src/Tests.angelscript"

#include "src/UIElement.angelscript"
#include "src/UIList.angelscript"
#include "src/UIScroller.angelscript"
#include "src/UIAnimatedElement.angelscript"
#include "src/UIEffects.angelscript"
#include "src/UIDrawable.angelscript"
#include "src/UIDrawableWithOwner.angelscript"
#include "src/UIDrawableText.angelscript"
#include "src/UITextInputElement.angelscript"
#include "src/UIFrameDrawable.angelscript"
#include "src/UILayer.angelscript"
#include "src/UISchedulerLayer.angelscript"
#include "src/UILayerManager.angelscript"
#include "src/UIButton.angelscript"
#include "src/UIWorldSpaceButton.angelscript"
#include "src/UIWorldSpaceDrawable.angelscript"
#include "src/UIButtonSwitch.angelscript"
#include "src/UIButtonIterator.angelscript"
#include "src/UIButtonDpadIterator.angelscript"
#include "src/UIButtonJoystickIterator.angelscript"
#include "src/UIEffectManager.angelscript"

#include "src/StateFactory.angelscript"

#include "src/states/BaseState.angelscript"
#include "src/states/SingleLayerBaseState.angelscript"

#include "src/layers/Parser.angelscript"
#include "src/layers/MessageBoxPopup.angelscript"
#include "src/layers/DefaultPopup.angelscript"

#include "src/uielements/StateFadeInSprite.angelscript"
#include "src/uielements/LayerDarkBackground.angelscript"
#include "src/uielements/PauseButton.angelscript"
#include "src/uielements/Selector.angelscript"

namespace sef {

namespace state {
	bool zbuffer = false;
	uint backgroundColor = 0xFF000000;
	bool showFpsRate = false;
	float fixedHeight = 1080.0f;
} // namespace state

void init(const float fixedHeight, const uint backgroundColor, sef::statefactory::BASE_STATE_FACTORY@ init)
{
	@sef::statefactory::init = @init;

	sef::setFixedHeight(fixedHeight);

	::SetPersistentResources(true);
	::SetBackgroundColor((sef::state::backgroundColor = backgroundColor));
	::SetPositionRoundUp(false);

	sef::uieffects::initUIPredefinedEffects();
	sef::options::internal::readFrameworkOptions();

	sef::StateManager.setState(sef::statefactory::init());

	sef::input::init();

	#if TESTING
		sef::tests::run();
	#endif
}

void setFixedHeight()
{
	sef::setFixedHeight(sef::state::fixedHeight);
}

void setFixedHeight(const float fixedHeight)
{
	sef::state::fixedHeight = fixedHeight;
	::SetFixedHeight(fixedHeight);
}

float getFixedHeight()
{
	return sef::state::fixedHeight;
}

::string getFrameworkDirectoryName()
{
	return "SEF/";
}

bool isTesting()
{
	bool testing = false;
	#if TESTING
		testing = true;
	#endif
	return testing;
}

namespace options {
	namespace internal {
		::string[] options;
		void readFrameworkOptions()
		{
			::enmlFile file;
			file.parseString(::GetStringFromFileInPackage("app.enml"));
			sef::options::internal::options = sef::string::split(file.get("sef", "options"), ",");
		}
	} // namespace internal

	const ::string JOYSTICK_MODE = "joystick-mode";

	bool isInJoystickOnlyMode()
	{
		return sef::options::get(sef::options::JOYSTICK_MODE);
	}

	void set(const ::string &in option, const bool enabled)
	{
		// remove first to avoid duplicates
		sef::options::removeOption(option);
		if (enabled)
		{
			sef::options::internal::options.insertLast(option);
		}
	}

	bool get(const ::string &in option)
	{
		for (uint t = 0; t < sef::options::internal::options.length(); t++)
		{
			if (sef::options::internal::options[t] == option)
				return true;
		}
		return false;
	}

	void removeOption(const ::string &in option)
	{
		for (uint t = 0; t < sef::options::internal::options.length();)
		{
			if (sef::options::internal::options[t] == option)
			{
				sef::options::internal::options.removeAt(t);
				continue;
			}
			t++;
		}
	}
} // namespace options

} // namespace sef

string GetSharedData(const string &in sdName, const string defaultValue)
{
	if (SharedDataExists(sdName) && GetSharedData(sdName) != "")
	{
		return GetSharedData(sdName);
	}
	else
	{
		return defaultValue;
	}
}
