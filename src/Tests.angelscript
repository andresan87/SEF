namespace sef {
namespace tests {

void run()
{
	runTests();
}

void assert(const bool success, const ::string &in desc)
{
	if (!success)
	{
		sef::io::ErrorMessage("TEST assert failed: ", desc);
		::Exit();
	}
}

void runTests()
{
	sef::tests::assert(sef::Time().isEarlierThan(sef::Time("3400:10:1:14:45:30")), "isEarlierThan test 1");
	sef::tests::assert(!sef::Time("2014:10:24:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 2");
	sef::tests::assert(sef::Time("2014:10:24:17:37:28").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 4");
	sef::tests::assert(sef::Time("2014:10:24:17:36:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 5");
	sef::tests::assert(sef::Time("2014:10:24:16:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 6");
	sef::tests::assert(sef::Time("2014:10:23:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 7");
	sef::tests::assert(sef::Time("2014:9:24:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 8");
	sef::tests::assert(sef::Time("2013:10:24:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 9");

	sef::tests::assert(!sef::Time("2014:10:24:17:37:31").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 10");
	sef::tests::assert(!sef::Time("2014:10:24:17:38:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 11");
	sef::tests::assert(!sef::Time("2014:10:24:18:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 12");
	sef::tests::assert(!sef::Time("2014:10:25:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 13");
	sef::tests::assert(!sef::Time("2014:11:24:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 14");
	sef::tests::assert(!sef::Time("2015:10:24:17:37:30").isEarlierThan(sef::Time("2014:10:24:17:37:30")), "isEarlierThan test 15");

	sef::tests::assert(!sef::Time("0:0:0:0:0:1").isEarlierThan(sef::Time("")), "isEarlierThan test 16");
	sef::tests::assert(sef::Time("0:0:0:0:0:0").isEarlierThan(sef::Time("1")), "isEarlierThan test 17");

	sef::tests::assert(sef::string::isValidNumber("0"), "isValidNumber test #1");
	sef::tests::assert(sef::string::isValidNumber("1"), "isValidNumber test #2");
	sef::tests::assert(sef::string::isValidNumber("2"), "isValidNumber test #3");
	sef::tests::assert(sef::string::isValidNumber("3"), "isValidNumber test #4");
	sef::tests::assert(sef::string::isValidNumber("4"), "isValidNumber test #5");
	sef::tests::assert(sef::string::isValidNumber("5"), "isValidNumber test #6");
	sef::tests::assert(sef::string::isValidNumber("6"), "isValidNumber test #7");
	sef::tests::assert(sef::string::isValidNumber("7"), "isValidNumber test #8");
	sef::tests::assert(sef::string::isValidNumber("8"), "isValidNumber test #9");
	sef::tests::assert(sef::string::isValidNumber("9"), "isValidNumber test #10");
	sef::tests::assert(sef::string::isValidNumber("-0"), "isValidNumber test #11");
	sef::tests::assert(sef::string::isValidNumber("-1"), "isValidNumber test #12");
	sef::tests::assert(sef::string::isValidNumber("-2"), "isValidNumber test #13");
	sef::tests::assert(sef::string::isValidNumber("-3"), "isValidNumber test #14");
	sef::tests::assert(sef::string::isValidNumber("-4"), "isValidNumber test #15");
	sef::tests::assert(sef::string::isValidNumber("-5"), "isValidNumber test #16");
	sef::tests::assert(sef::string::isValidNumber("-6"), "isValidNumber test #17");
	sef::tests::assert(sef::string::isValidNumber("-7"), "isValidNumber test #18");
	sef::tests::assert(sef::string::isValidNumber("-8"), "isValidNumber test #19");
	sef::tests::assert(sef::string::isValidNumber("-9"), "isValidNumber test #20");
	sef::tests::assert(sef::string::isValidNumber("001"), "isValidNumber test #21");
	sef::tests::assert(sef::string::isValidNumber("0000014"), "isValidNumber test #22");
	sef::tests::assert(sef::string::isValidNumber("32442395"), "isValidNumber test #23");
	sef::tests::assert(sef::string::isValidNumber("488"), "isValidNumber test #24");
	sef::tests::assert(sef::string::isValidNumber("10"), "isValidNumber test #25");
	sef::tests::assert(sef::string::isValidNumber("1097876"), "isValidNumber test #26");
	sef::tests::assert(sef::string::isValidNumber("0.0"), "isValidNumber test #27");
	sef::tests::assert(sef::string::isValidNumber("0.9"), "isValidNumber test #28");
	sef::tests::assert(sef::string::isValidNumber("9.0"), "isValidNumber test #29");
	sef::tests::assert(sef::string::isValidNumber("10.0005"), "isValidNumber test #30");
	sef::tests::assert(sef::string::isValidNumber("100.5"), "isValidNumber test #31");
	sef::tests::assert(sef::string::isValidNumber("0.0"), "isValidNumber test #32");
	sef::tests::assert(sef::string::isValidNumber("055.0"), "isValidNumber test #33");
	sef::tests::assert(sef::string::isValidNumber("-001"), "isValidNumber test #34");
	sef::tests::assert(sef::string::isValidNumber("-0000014"), "isValidNumber test #35");
	sef::tests::assert(sef::string::isValidNumber("-32442395"), "isValidNumber test #36");
	sef::tests::assert(sef::string::isValidNumber("-488"), "isValidNumber test #37");
	sef::tests::assert(sef::string::isValidNumber("-10"), "isValidNumber test #38");
	sef::tests::assert(sef::string::isValidNumber("-1097876"), "isValidNumber test #39");
	sef::tests::assert(sef::string::isValidNumber("-0.0"), "isValidNumber test #40");
	sef::tests::assert(sef::string::isValidNumber("-0.9"), "isValidNumber test #41");
	sef::tests::assert(sef::string::isValidNumber("-9.0"), "isValidNumber test #42");
	sef::tests::assert(sef::string::isValidNumber("-10.0005"), "isValidNumber test #43");
	sef::tests::assert(sef::string::isValidNumber("-100.5"), "isValidNumber test #44");
	sef::tests::assert(sef::string::isValidNumber("-0.0"), "isValidNumber test #45");
	sef::tests::assert(sef::string::isValidNumber("-055.0"), "isValidNumber test #46");

	sef::tests::assert(!sef::string::isValidNumber(".1097876"), "isValidNumber test #47");
	sef::tests::assert(!sef::string::isValidNumber(".0"), "isValidNumber test #48");
	sef::tests::assert(!sef::string::isValidNumber("."), "isValidNumber test #49");
	sef::tests::assert(!sef::string::isValidNumber("a"), "isValidNumber test #50");
	sef::tests::assert(!sef::string::isValidNumber("b"), "isValidNumber test #51");
	sef::tests::assert(!sef::string::isValidNumber("-"), "isValidNumber test #52");
	sef::tests::assert(!sef::string::isValidNumber("--"), "isValidNumber test #53");
	sef::tests::assert(!sef::string::isValidNumber(".."), "isValidNumber test #54");
	sef::tests::assert(!sef::string::isValidNumber("oie"), "isValidNumber test #55");
	sef::tests::assert(!sef::string::isValidNumber("0.a"), "isValidNumber test #56");
	sef::tests::assert(!sef::string::isValidNumber("10.bb"), "isValidNumber test #57");
	sef::tests::assert(!sef::string::isValidNumber(""), "isValidNumber test #58");

	sef::tests::assert(sef::string::split("testing;this",      ";").length() == 2, "split test #1");
	sef::tests::assert(sef::string::split("testing;this;text", ";").length() == 3, "split test #2");
	sef::tests::assert(sef::string::split("t",                 ";").length() == 1, "split test #3");
	sef::tests::assert(sef::string::split("t;s",               ";").length() == 2, "split test #4");
	sef::tests::assert(sef::string::split("t;s;w",             ";").length() == 3, "split test #5");
	sef::tests::assert(sef::string::split("",                  ";").length() == 1, "split test #6");
	sef::tests::assert(sef::string::split("word",              ";").length() == 1, "split test #7");
	sef::tests::assert(sef::string::split("word;",             ";").length() == 2, "split test #8");
	sef::tests::assert(sef::string::split("word;;two",         ";").length() == 3, "split test #9");
	sef::tests::assert(sef::string::split("word;;;two",        ";").length() == 4, "split test #10");
	sef::tests::assert(sef::string::split("word;;two;",        ";").length() == 4, "split test #11");

	sef::tests::assert(sef::string::split("t",         ";")[0] == "t",    "split test #12");
	sef::tests::assert(sef::string::split("word;two",  ";")[0] == "word", "split test #13");
	sef::tests::assert(sef::string::split("word;two",  ";")[1] == "two",  "split test #14");
	sef::tests::assert(sef::string::split("word;;two", ";")[1] == "",     "split test #15");
	sef::tests::assert(sef::string::split("word;;two", ";")[2] == "two",  "split test #16");

	bool success;
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("0.0.0", "0.0.0", success) && success, "isVersionGreaterOrEqual test #1");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("0.0.1", "0.0.0", success) && success, "isVersionGreaterOrEqual test #2");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("0.1.0", "0.0.0", success) && success, "isVersionGreaterOrEqual test #3");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.0.0", "0.0.0", success) && success, "isVersionGreaterOrEqual test #4");

	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.0.1", "0.0.0", success) && success, "isVersionGreaterOrEqual test #5");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("0.1.1", "0.0.0", success) && success, "isVersionGreaterOrEqual test #6");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.1.0", "0.0.0", success) && success, "isVersionGreaterOrEqual test #7");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.1.1", "0.0.0", success) && success, "isVersionGreaterOrEqual test #8");

	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("0.0.0", "1.0.1", success) && success, "isVersionGreaterOrEqual test #9");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("0.0.0", "0.1.1", success) && success, "isVersionGreaterOrEqual test #10");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("0.0.0", "1.1.0", success) && success, "isVersionGreaterOrEqual test #11");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("0.0.0", "1.1.1", success) && success, "isVersionGreaterOrEqual test #12");

	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.1.0", "1.0.1", success) && success, "isVersionGreaterOrEqual test #13");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("2.0.0", "0.1.1", success) && success, "isVersionGreaterOrEqual test #14");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.2.0", "1.1.0", success) && success, "isVersionGreaterOrEqual test #15");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.1.2", "1.1.1", success) && success, "isVersionGreaterOrEqual test #16");

	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("a.1.0", "1.0.1", success) && !success, "isVersionGreaterOrEqual test #17");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("2.*.0", "0.1.1", success) && success, "isVersionGreaterOrEqual test #18");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.2.asd", "1.1.0", success) && success, "isVersionGreaterOrEqual test #19");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("1.lll.2", "1.1.1", success) && !success, "isVersionGreaterOrEqual test #20");

	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("a.1.0", "1.0..", success) && !success, "isVersionGreaterOrEqual test #21");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("2.*.0", "0.dd.1", success) && success, "isVersionGreaterOrEqual test #22");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("1.2.asd", "a.1.0", success) && !success, "isVersionGreaterOrEqual test #23");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("1.lll.2", "1.1.&&&", success) && !success, "isVersionGreaterOrEqual test #24");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("oifje", "fiejfe", success) && !success, "isVersionGreaterOrEqual test #24.1");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("a.3.1", "ffff.2", success) && !success, "isVersionGreaterOrEqual test #24.2");

	sef::tests::assert(sef::math::isVersionGreaterOrEqual("1.2", "1.0.1", success) && success, "isVersionGreaterOrEqual test #25");
	sef::tests::assert(sef::math::isVersionGreaterOrEqual("2",   "1.1",   success) && success, "isVersionGreaterOrEqual test #26");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("0", "4", success) && success, "isVersionGreaterOrEqual test #27");
	sef::tests::assert(!sef::math::isVersionGreaterOrEqual("1.1", "1.2.1", success) && success, "isVersionGreaterOrEqual test #28");

	sef::tests::assert(sef::string::parseVector3(",,") == vector3(0.0f), "parseVector3 test #1");
	sef::tests::assert(sef::string::parseVector3("0,,") == vector3(0.0f), "parseVector3 test #2");
	sef::tests::assert(sef::string::parseVector3(",0,") == vector3(0.0f), "parseVector3 test #3");
	sef::tests::assert(sef::string::parseVector3(",,0") == vector3(0.0f), "parseVector3 test #4");
	sef::tests::assert(sef::string::parseVector3("0,0,") == vector3(0.0f), "parseVector3 test #5");
	sef::tests::assert(sef::string::parseVector3(",0,0") == vector3(0.0f), "parseVector3 test #6");

	sef::tests::assert(sef::string::parseVector3("1.1,,") == vector3(1.1f, 0.0f, 0.0f), "parseVector3 test #7");
	sef::tests::assert(sef::string::parseVector3(",2.2,") == vector3(0.0f, 2.2f, 0.0f), "parseVector3 test #8");
	sef::tests::assert(sef::string::parseVector3(",,3.3") == vector3(0.0f, 0.0f, 3.3f), "parseVector3 test #9");
	sef::tests::assert(sef::string::parseVector3("1.1,2.2,") == vector3(1.1f, 2.2f, 0.0f), "parseVector3 test #10");
	sef::tests::assert(sef::string::parseVector3(",2.2,3.3") == vector3(0.0f, 2.2f, 3.3f), "parseVector3 test #11");

	sef::tests::assert(sef::string::parseVector3("1.1,0,0") == vector3(1.1f, 0.0f, 0.0f), "parseVector3 test #12");
	sef::tests::assert(sef::string::parseVector3("0,2.2,0") == vector3(0.0f, 2.2f, 0.0f), "parseVector3 test #13");
	sef::tests::assert(sef::string::parseVector3("0,0,3.3") == vector3(0.0f, 0.0f, 3.3f), "parseVector3 test #14");
	sef::tests::assert(sef::string::parseVector3("1.1,2.2,0") == vector3(1.1f, 2.2f, 0.0f), "parseVector3 test #15");
	sef::tests::assert(sef::string::parseVector3("0,2.2,3.3") == vector3(0.0f, 2.2f, 3.3f), "parseVector3 test #16");

	sef::tests::assert(sef::string::parseVector3("1.1,b,c") == vector3(1.1f, 0.0f, 0.0f), "parseVector3 test #17");
	sef::tests::assert(sef::string::parseVector3("a,2.2,c") == vector3(0.0f, 2.2f, 0.0f), "parseVector3 test #18");
	sef::tests::assert(sef::string::parseVector3("a,b,3.3") == vector3(0.0f, 0.0f, 3.3f), "parseVector3 test #19");
	sef::tests::assert(sef::string::parseVector3("1.1,2.2,c") == vector3(1.1f, 2.2f, 0.0f), "parseVector3 test #20");
	sef::tests::assert(sef::string::parseVector3("a,2.2,3.3") == vector3(0.0f, 2.2f, 3.3f), "parseVector3 test #21");

	sef::tests::assert(sef::string::parseVector3("-1.1,-,-") == vector3(-1.1f, 0.0f, 0.0f), "parseVector3 test #22");
	sef::tests::assert(sef::string::parseVector3("-,-2.2,-") == vector3(0.0f, -2.2f, 0.0f), "parseVector3 test #23");
	sef::tests::assert(sef::string::parseVector3("-,-,-3.3") == vector3(-0.0f, 0.0f, -3.3f), "parseVector3 test #24");
	sef::tests::assert(sef::string::parseVector3("-1.1,-2.2,-") == vector3(-1.1f, -2.2f, 0.0f), "parseVector3 test #25");
	sef::tests::assert(sef::string::parseVector3("-,-2.2,-3.3") == vector3(0.0f, -2.2f, -3.3f), "parseVector3 test #26");

	sef::tests::assert(sef::string::parseVector3("0,0,0") == vector3(0.0f), "parseVector3 test #27");
	sef::tests::assert(sef::string::parseVector3("1,-2,3") == vector3(1.0f, -2.0f, 3.0f), "parseVector3 test #28");
	sef::tests::assert(sef::string::parseVector3("1,,3") == vector3(1.0f, 0.0f, 3.0f), "parseVector3 test #29");
	sef::tests::assert(sef::string::parseVector3("0.0,0.0,0.0") == vector3(0.0f), "parseVector3 test #30");
	sef::tests::assert(sef::string::parseVector3("-1.0,2.0,3.0") == vector3(-1.0f, 2.0f, 3.0f), "parseVector3 test #31");
	sef::tests::assert(sef::string::parseVector3("1.0,,-3.0") == vector3(1.0f, 0.0f, -3.0f), "parseVector3 test #32");

	sef::tests::assert(sef::string::parseVector3("0, 0, 0") == vector3(0.0f), "parseVector3 test #33");
	sef::tests::assert(sef::string::parseVector3("  1, -2,3  ") == vector3(1.0f, -2.0f, 3.0f), "parseVector3 test #34");
	sef::tests::assert(sef::string::parseVector3("1  ,,3") == vector3(1.0f, 0.0f, 3.0f), "parseVector3 test #35");
	sef::tests::assert(sef::string::parseVector3("0.0,   0.0,0.0      ") == vector3(0.0f), "parseVector3 test #36");
	sef::tests::assert(sef::string::parseVector3("    - 1.0,2.0,3.0") == vector3(-1.0f, 2.0f, 3.0f), "parseVector3 test #37");
	sef::tests::assert(sef::string::parseVector3("1.0, ,-3.0") == vector3(1.0f, 0.0f, -3.0f), "parseVector3 test #38");
	sef::tests::assert(sef::string::parseVector3("1.0,     ,-3.0") == vector3(1.0f, 0.0f, -3.0f), "parseVector3 test #39");

	sef::tests::assert(sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", " dwarf"), "suffixMatches test #1");
	sef::tests::assert(sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", "f"), "suffixMatches test #2");
	sef::tests::assert(!sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", "  dwarf"), "suffixMatches test #3");
	sef::tests::assert(!sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", " f"), "suffixMatches test #4");
	sef::tests::assert(sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", "he quick onyx goblin jumps over the lazy dwarf"), "suffixMatches test #5");
	sef::tests::assert(sef::string::suffixMatches("The quick onyx goblin jumps over the lazy dwarf", "The quick onyx goblin jumps over the lazy dwarf"), "suffixMatches test #6");
	sef::tests::assert(sef::string::suffixMatches("Эти твари выползают отовсюду, конца им нет!", "нет!"), "suffixMatches test #7");
	sef::tests::assert(sef::string::suffixMatches("Эти твари выползают отовсюду, конца им нет!", " нет!"), "suffixMatches test #8");
	sef::tests::assert(sef::string::suffixMatches("Эти твари выползают отовсюду, конца им нет!", "ти твари выползают отовсюду, конца им нет!"), "suffixMatches test #9");
	sef::tests::assert(sef::string::suffixMatches("Эти твари выползают отовсюду, конца им нет!", "Эти твари выползают отовсюду, конца им нет!"), "suffixMatches test #10");
	sef::tests::assert(!sef::string::suffixMatches("Эти твари выползают отовсюду, конца им нет!", "Something else"), "suffixMatches test #11");
	sef::tests::assert(!sef::string::suffixMatches("", "hello"), "suffixMatches test #12");
	sef::tests::assert(!sef::string::suffixMatches("", " "), "suffixMatches test #13");
	sef::tests::assert(sef::string::suffixMatches("", ""), "suffixMatches test #14");

	string[] a, b;
	sef::tests::assert(sef::string::areEqual(a, b), "areEqual test #1");

	a = { "marielle", "karl", "marcelo", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::tests::assert(sef::string::areEqual(@a, @b), "areEqual test #2");

	a = { "marielle", "karl", "marcelo", "noam" };
	b = { "marielle", "karl" };
	sef::tests::assert(!sef::string::areEqual(@a, @b), "areEqual test #3");

	a = { "marielle", "karl", "marcelo", "noam" };
	b = { "marielle", "karl", "marcelo", "noam", "thomas" };
	sef::tests::assert(!sef::string::areEqual(@a, @b), "areEqual test #4");

	a = { "marielle" };
	b = { "marx" };
	sef::tests::assert(!sef::string::areEqual(@a, @b), "areEqual test #5");

	a = { "marielle" };
	b = { "marielle" };
	sef::tests::assert(sef::string::areEqual(@a, @b), "areEqual test #5");


	a = { "marielle", "karl", "marcelo", "karl", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #1");

	a = { "marielle", "karl", "marcelo", "karl", "noam", "karl", "karl" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #2");

	a = { "marielle", "karl", "marcelo", "marcelo", "marcelo", "marcelo", "marcelo", "marcelo", "karl", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #3");

	a = { "marielle", "marielle", "karl", "marcelo", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #4");

	a = { "marielle", "marielle", "marielle", "marielle", "marielle", "marielle", "marielle", "marielle", "karl", "marcelo", "noam", "noam", "noam", "noam", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #5");

	a = { "marielle", "karl", "karl", "marcelo", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #6");

	a = { "marielle", "karl", "karl", "karl", "marcelo", "noam" };
	b = { "marielle", "karl", "marcelo", "noam" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #7");

	a = { "marielle", "marielle" };
	b = { "marielle" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #8");

	a = { "marielle", "marielle", "marielle", "marielle", "marielle", "marielle" };
	b = { "marielle" };
	sef::string::removeDuplicates(@a);
	sef::tests::assert(sef::string::areEqual(@a, @b), "removeDuplicates test #9");
}

} // namespace tests
} // namespace sef
