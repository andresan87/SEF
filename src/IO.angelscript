namespace sef {
namespace io {

void ErrorMessage(const ::string &in context, const ::string &in message)
{
	::print("ERROR: " + context + ": " + message);
}

} // namespace io
} // namespace sef
