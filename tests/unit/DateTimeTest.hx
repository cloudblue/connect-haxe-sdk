/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.util.DateTime;
import massive.munit.Assert;


class DateTimeTest {
    @Test
    public function testFromString() {
        final dt = DateTime.fromString('2018-06-04T13:19:10.102670+00:00');
        Assert.areEqual(2018, dt.getYear());
        Assert.areEqual(5, dt.getMonth());
        Assert.areEqual(4, dt.getDay());
        Assert.areEqual(13, dt.getHours());
        Assert.areEqual(19, dt.getMinutes());
        Assert.areEqual(10, dt.getSeconds());
        Assert.areEqual('2018-06-04T13:19:10+00:00', dt.toString());
    }


    @Test
    public function testFromStringNoOffset() {
        final dt = DateTime.fromString('2018-06-04T13:19:10.102670');
        Assert.areEqual('2018-06-04T13:19:10+00:00', dt.toString());
    }


    @Test
    public function testFromStringNoTime() {
        final dt = DateTime.fromString('2018-06-04');
        Assert.areEqual('2018-06-04T00:00:00+00:00', dt.toString());
    }


    @Test
    public function testFromStringYearOnly() {
        final dt = DateTime.fromString('2018');
        Assert.areEqual('2018-01-01T00:00:00+00:00', dt.toString());
    }


    @Test
    public function testFromStringInvalid() {
        final dt = DateTime.fromString('Invalid');
        Assert.isNull(dt);
    }
}
