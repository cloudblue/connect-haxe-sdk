/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.models.Model;
import connect.models.Param;
import connect.util.Collection;
import connect.util.Util;


class ModelTest extends haxe.unit.TestCase {
    public function testToObject() {
        final param = new Param();
        param.valueChoice = new Collection<String>().push('My choice');
        final expected = '{\n  "value_choice": [\n    "My choice"\n  ]\n}';
        this.assertEquals(expected, Util.beautifyObject(param.toObject(), false));
    }
}
