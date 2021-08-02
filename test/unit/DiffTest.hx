/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
import connect.util.Diff;
import haxe.Json;
import massive.munit.Assert;


class DiffTest {
    @Test
    public function testAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {y: 'World'},
            d: {},
            c: {}
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {x: 'Hello'},
            c: {}
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {}
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {
            "a": {},
            "d": {},
            "c": {"x": Json.parse('["10", 10]')}
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {x: ['Hello', 'World']}
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {z: 'World'},
                    d: {},
                    c: {}
                }
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {},
                    d: {z: 'World'},
                    c: {}
                }
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: {
                    a: {},
                    d: {},
                    c: {
                        y: ['Hello', 'World'],
                        z: ['Hi', 'He']
                    }
                }
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesArrayAdd() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: [
                    [30],
                    [],
                    []
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesArrayDelete() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: [
                    [],
                    [30],
                    []
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [100],
                    Json.parse('[[1, 20, 30]]')
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testChangesArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        final expected = {
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [],
                    [Json.parse('[1, [[], [], [[0, 20, 30]]]]')]
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }
    
    @Test
    public function testChangesArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        final expected = {
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [],
                    [Json.parse('[1, {"a": {}, "d": {}, "c": {"y": [20, 30]}}]')]
                ]
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }
    
    @Test
    public function testComplexObjects() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        final expected = {
            a: {},
            d: {},
            c: {
                title: ['Hello', 'Hellooo'],
                stargazers: [
                    ['/users/40'],
                    [],
                    []
                ],
                settings: {
                    a: {},
                    d: {},
                    c: {
                        assignees: [
                            [],
                            [],
                            [
                                [2, 201, 202]
                            ]
                        ]
                    }
                }
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), diff.toString()));
    }

    @Test
    public function testApplySame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        Assert.isTrue(areJsonEqual(Json.stringify(obj), Json.stringify(diff.apply(obj))));
    }

    @Test
    public function testApplyWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyWithArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testApplyComplex() {
        final a = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final b = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(b), Json.stringify(diff.apply(a))));
    }

    @Test
    public function testSwapSame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        Assert.isTrue(areJsonEqual(Json.stringify(obj), Json.stringify(diff.swap().apply(obj))));
    }

    @Test
    public function testSwapWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapWithArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testSwapComplex() {
        final a = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final b = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            },
        };
        final diff = new Diff(a, b);
        Assert.isTrue(areJsonEqual(Json.stringify(a), Json.stringify(diff.swap().apply(b))));
    }

    @Test
    public function testBuildWithAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {y: 'World'};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {x: 10};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {x: 'World'};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {x: {z: 'World'}};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        final expected = {x: {}};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {x: {y: 'World', z: 'He'}};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArrayAdd() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [30]};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArrayDelete() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        final expected = {x: []};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        #if !cpp
        final expected = {x: [null, 30]};
        #else
        final expected = {x: [0, 30]};
        #end
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        #if !cpp
        final expected = {x: [null, 30]};
        #else
        final expected = {x: [0, 30]};
        #end
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        final expected = {x: [null, [30]]};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithChangesArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        final expected = {x: [null, {y: 30}]};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithComplexObjects() {
        final first = {
            title: 'Hello',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30'],
            settings: {
                assignees: [100, 101, 201]
            }
        };
        final second = {
            title: 'Hellooo',
            forkCount: 20,
            stargazers: ['/users/20', '/users/30', '/users/40'],
            settings: {
                assignees: [100, 101, 202]
            }
        };
        final diff = new Diff(first, second);
        final expected = {
            title: 'Hellooo',
            stargazers: ['/users/40'],
            settings: {
                #if !cpp
                assignees: [null, null, 202]
                #else
                assignees: [0, 0, 202]
                #end
            }
        };
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({}))));
    }

    @Test
    public function testBuildWithAddedId() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {id: 'Identifier', y: 'World'};
        Assert.isTrue(areJsonEqual(Json.stringify(expected), Json.stringify(diff.apply({id: 'Identifier'}))));
    }

    @Test
    public function testNoObj() {
        final a = 0;
        final b = {x: 'Hello', y: 'World'};
        try {
            new Diff(a, b);
            Assert.fail('We should not get here');
        } catch (ex: Dynamic) {}
    }

    @Test
    public function testNoObj2() {
        final a = {x: 'Hello'};
        final b = 0;
        try {
            new Diff(a, b);
            Assert.fail('We should not get here');
        } catch (ex: Dynamic) {}
    }

    private static function areJsonEqual(a:String, b:String):Bool {
        return areObjectsEqual(Json.parse(a), Json.parse(b));
    }

    private static function areObjectsEqual(a:Dynamic, b:Dynamic):Bool {
        final fieldsA = Reflect.fields(a);
        final fieldsB = Reflect.fields(b);
        return areFieldNamesEqual(fieldsA, fieldsB) && areFieldValuesEqual(fieldsA, a, b);
    }

    private static function areFieldNamesEqual(fieldsA:Array<String>, fieldsB:Array<String>):Bool {
        return (fieldsA.length == fieldsB.length) && Lambda.foreach(fieldsA, a -> fieldsB.contains(a));
    }

    private static function areFieldValuesEqual(fields:Array<String>, a:Dynamic, b:Dynamic):Bool {
        for (fieldName in fields) {
            final fieldA:Dynamic = Reflect.field(a, fieldName);
            final fieldB:Dynamic = Reflect.field(b, fieldName);
            if (!areFieldTypesEqual(fieldA, fieldB) || !areEqual(fieldA, fieldB)) {
                return false;
            }
        }
        return true;
    }

    private static function areFieldTypesEqual(fieldA:Dynamic, fieldB:Dynamic):Bool {
        return Std.string(Type.typeof(fieldA)) == Std.string(Type.typeof(fieldB));
    }

    private static function areEqual(fieldA:Dynamic, fieldB:Dynamic):Bool {
        switch (Type.typeof(fieldA)) {
        case TObject:
            return areObjectsEqual(fieldA, fieldB);
        case TClass(Array):
            return areArraysEqual(fieldA, fieldB);
        default:
            return fieldA == fieldB;
        }
    }

    private static function areArraysEqual(arrA:Array<Dynamic>, arrB:Array<Dynamic>):Bool {
        return arrA.length == arrB.length
            && Lambda.foreach([for (i in 0...arrA.length) i], i -> areEqual(arrA[i], arrB[i]));
    }
}
