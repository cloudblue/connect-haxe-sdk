import massive.munit.TestSuite;

import TierAccountTest;
import AssetTest;
import MarkdownLoggerFormatterTest;
import CategoryTest;
import ItemTest;
import ConfigurationTest;
import AccountTest;
import TierConfigRequestTest;
import DiffTest;
import AgreementTest;
import AssetRequestTest;
import UsageFileTest;
import TierConfigTest;
import ConversationTest;
import ConfigTest;
import ModelTest;
import QueryTest;
import ProductTest;
import DateTimeTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(TierAccountTest);
		add(AssetTest);
		add(MarkdownLoggerFormatterTest);
		add(CategoryTest);
		add(ItemTest);
		add(ConfigurationTest);
		add(AccountTest);
		add(TierConfigRequestTest);
		add(DiffTest);
		add(AgreementTest);
		add(AssetRequestTest);
		add(UsageFileTest);
		add(TierConfigTest);
		add(ConversationTest);
		add(ConfigTest);
		add(ModelTest);
		add(QueryTest);
		add(ProductTest);
		add(DateTimeTest);
	}
}
