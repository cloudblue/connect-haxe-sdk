/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

import connect.DateTime;


class DateTimeTest extends haxe.unit.TestCase {
    public function testFromString() {
        final dt = DateTime.fromString('2018-06-04T13:19:10.102670+00:00');
        this.assertEquals(2018, dt.getYear());
        this.assertEquals(5, dt.getMonth());
        this.assertEquals(4, dt.getDay());
        this.assertEquals(13, dt.getHours());
        this.assertEquals(19, dt.getMinutes());
        this.assertEquals(10, dt.getSeconds());
        this.assertEquals('2018-06-04T13:19:10+00:00', dt.toString());
    }


    public function testFromStringNoOffset() {
        final dt = DateTime.fromString('2018-06-04T13:19:10.102670');
        this.assertEquals('2018-06-04T13:19:10+00:00', dt.toString());
    }


    public function testFromStringNoTime() {
        final dt = DateTime.fromString('2018-06-04');
        this.assertEquals('2018-06-04T00:00:00+00:00', dt.toString());
    }


    public function testFromStringYearOnly() {
        final dt = DateTime.fromString('2018');
        this.assertEquals('2018-01-01T00:00:00+00:00', dt.toString());
    }


    public function testFromStringInvalid() {
        final dt = DateTime.fromString('Invalid');
        this.assertEquals(null, dt);
    }
}
