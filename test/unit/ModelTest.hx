/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.models.Item;
import connect.models.Param;
import connect.util.Collection;
import connect.util.Util;
import massive.munit.Assert;


class ModelTest {
    @Test
    public function testParamToObject() {
        final param = new Param();
        param.valueChoice = new Collection<String>().push('My choice');
        final expected = '{\n  "value_choice": [\n    "My choice"\n  ]\n}';
        Assert.areEqual(expected, Util.beautifyObject(param.toObject(), false, false));
    }


    @Test
    public function testParamToString() {
        final param = new Param();
        param.valueChoice = new Collection<String>().push('My choice');
        final expected = '{"value_choice":["My choice"]}';
        Assert.areEqual(expected, param.toString());
    }


    @Test
    public function testAssetToString() {
        final item = new Item();
        final param = new Param();
        param.value = 'Param value';
        item.params = new Collection<Param>().push(param);
        final expected = '{"params":[{"value":"Param value"}]}';
        Assert.areEqual(expected, item.toString());
    }
}
