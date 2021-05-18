namespace sef {
namespace statefactory {

funcdef sef::BaseState@ BASE_STATE_FACTORY();

funcdef void ON_RESUME_FUNCTION();
funcdef void ON_SCENE_UPDATE_FUNCTION();
funcdef void ON_SCENE_CREATED_FUNCTION();

sef::statefactory::BASE_STATE_FACTORY@ init = @sef::statefactory::defaultInitialState;

sef::statefactory::ON_RESUME_FUNCTION@ globalOnResumeFunction = @sef::statefactory::defaultGlobalOnResumeFunction;
sef::statefactory::ON_SCENE_UPDATE_FUNCTION@ globalOnSceneUpdateFunction = @sef::statefactory::defaultGlobalOnSceneUpdateFunction;
sef::statefactory::ON_SCENE_CREATED_FUNCTION@ globalOnSceneCreatedFunction = @sef::statefactory::defaultGlobalOnSceneCreatedFunction;

void defaultGlobalOnResumeFunction()
{
	// dummy...
}

void defaultGlobalOnSceneUpdateFunction()
{
	// dummy...
}

void defaultGlobalOnSceneCreatedFunction()
{
	// dummy...
}

sef::BaseState@ defaultInitialState()
{
	return sef::BaseState("empty");
}

} // namespace statefactory
} // namespace sef
