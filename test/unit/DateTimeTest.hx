/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
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


    @Test
    public function testGetEpochTimestamp() {
        final dt = new DateTime(1970, 0, 1, 0, 0, 0);
        Assert.areEqual(0, Std.int(dt.getTimestamp()));
    }


    @Test
    public function testGetOneHourAfterEpochTimestamp() {
        final dt = new DateTime(1970, 0, 1, 1, 0, 0);
        Assert.areEqual(3600, Std.int(dt.getTimestamp()));
    }


    @Test
    public function testCompareWithEarlier() {
        final earlier = DateTime.fromString('2000-01-01T00:00:00');
        final now = DateTime.now();
        Assert.isTrue(now.compare(earlier) > 0);
    }


    @Test
    public function testCompareWithNow() {
        final earlier = DateTime.fromString('2000-01-01T00:00:00');
        final now = DateTime.now();
        Assert.isTrue(earlier.compare(now) < 0);
    }


    @Test
    public function testCompareWithSame() {
        final now = DateTime.now();
        Assert.areEqual(0, now.compare(now));
    }


    @Test
    public function testCompareWithEqual() {
        final now = DateTime.now();
        final other = DateTime.now();
        Assert.areEqual(0, now.compare(other));
    }

    
    @Test
    public function testEqualsWithEarlier() {
        final earlier = DateTime.fromString('2000-01-01T00:00:00');
        final now = DateTime.now();
        Assert.isFalse(now.equals(earlier));
    }


    @Test
    public function testEqualsWithNow() {
        final earlier = DateTime.fromString('2000-01-01T00:00:00');
        final now = DateTime.now();
        Assert.isFalse(earlier.equals(now));
    }


    @Test
    public function testEqualsWithSame() {
        final now = DateTime.now();
        Assert.isTrue(now.equals(now));
    }


    @Test
    public function testEqualsWithEqual() {
        final now = DateTime.now();
        final other = DateTime.now();
        Assert.isTrue(now.equals(other));
    }

    
    @Test
    public function testIsBetweenDatesInBetween() {
        final first = DateTime.fromString('2000-01-01T00:00:00');
        final second = DateTime.fromString('2010-01-01T00:00:00');
        final inBetween = DateTime.fromString('2005-01-01T00:00:00');
        Assert.isTrue(inBetween.isBetweenDates(first, second));
    }

    @Test
    public function testIsBetweenDatesEarlier() {
        final first = DateTime.fromString('2005-01-01T00:00:00');
        final second = DateTime.fromString('2010-01-01T00:00:00');
        final inBetween = DateTime.fromString('2000-01-01T00:00:00');
        Assert.isFalse(inBetween.isBetweenDates(first, second));
    }


    @Test
    public function testIsBetweenDatesLater() {
        final first = DateTime.fromString('2000-01-01T00:00:00');
        final second = DateTime.fromString('2005-01-01T00:00:00');
        final inBetween = DateTime.fromString('2010-01-01T00:00:00');
        Assert.isFalse(inBetween.isBetweenDates(first, second));
    }

    @Test
    public function testIsBetweenDatesInBetweenSwapped() {
        final first = DateTime.fromString('2010-01-01T00:00:00');
        final second = DateTime.fromString('2000-01-01T00:00:00');
        final inBetween = DateTime.fromString('2005-01-01T00:00:00');
        Assert.isTrue(inBetween.isBetweenDates(first, second));
    }


    @Test
    public function testIsBetweenDatesEquals() {
        final first = DateTime.fromString('2000-01-01T00:00:00');
        final second = DateTime.fromString('2000-01-01T00:00:00');
        final inBetween = DateTime.fromString('2000-01-01T00:00:00');
        Assert.isTrue(inBetween.isBetweenDates(first, second));
    }
}
