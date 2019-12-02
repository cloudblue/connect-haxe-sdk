package tests.unit;

import connect.Diff;
import haxe.Json;


class DiffTest extends haxe.unit.TestCase {
    public function testNoObj() {
        final a = 0;
        final b = {x: 'Hello', y: 'World'};
        try {
            new Diff(a, b);
            this.assertTrue(false);
        } catch (ex: Dynamic) {
            this.assertTrue(true);
        }
    }


    public function testNoObj2() {
        final a = {x: 'Hello'};
        final b = 0;
        try {
            new Diff(a, b);
            this.assertTrue(false);
        } catch (ex: Dynamic) {
            this.assertTrue(true);
        }
    }


    public function testAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            additions: {y: 'World'},
            deletions: {},
            changes: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {x: 'Hello'},
            changes: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {},
            changes: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {},
            changes: {x: untyped ['10', 10]}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {},
            changes: {x: ['Hello', 'World']}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {},
            changes: {
                x: {
                    additions: {},
                    deletions: {},
                    changes: {
                        y: ['Hello', 'World'],
                        z: ['Hi', 'He']
                    }
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {
            additions: {},
            deletions: {},
            changes: {
                x: {
                    additions: {z: 'World'},
                    deletions: {},
                    changes: {}
                }
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArray() {

    }
}
