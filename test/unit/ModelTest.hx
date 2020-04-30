/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.models.Param;
import connect.util.Collection;
import connect.util.Util;
import massive.munit.Assert;


class ModelTest {
    @Test
    public function testToObject() {
        final param = new Param();
        param.valueChoice = new Collection<String>().push('My choice');
        final expected = '{\n  "value_choice": [\n    "My choice"\n  ]\n}';
        Assert.areEqual(expected, Util.beautifyObject(param.toObject(), false, false));
    }
}
