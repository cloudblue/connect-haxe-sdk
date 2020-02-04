/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package tests.unit;

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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
    }


    @Test
    public function testChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = sortObject(Json.parse('{
            "a": {},
            "d": {},
            "c": {"x": ["10", 10]}
        }'));
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
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
        Assert.areEqual(Json.stringify(expected), diff.toString());
    }


    @Test
    public function testChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = sortObject(Json.parse('{
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
        }'));
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }


    @Test
    public function testChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = sortObject(Json.parse('{
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [100],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        }'));
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }


    @Test
    public function testChangesArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        final expected = sortObject(Json.parse('{
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [],
                    [
                        [1, [
                            [],
                            [],
                            [
                                [0, 20, 30]
                            ]
                        ]]
                    ]
                ]
            }
        }'));
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }


    @Test
    public function testChangesArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        final expected = sortObject(Json.parse('{
            "a": {},
            "d": {},
            "c": {
                "x": [
                    [],
                    [],
                    [
                        [1, {
                            "a": {},
                            "d": {},
                            "c": {
                                "y": [20, 30]
                            }
                        }]
                    ]
                ]
            }
        }'));
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
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
        final expected = sortObject({
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
        });
        final result = sortObject(Json.parse(diff.toString()));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }


    @Test
    public function testApplySame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        Assert.areEqual(Std.string(obj), Std.string(diff.apply(obj)));
    }


    @Test
    public function testApplyWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = sortObject(b);
        final result = sortObject(diff.apply(a));
        Assert.areEqual(Std.string(expected), Std.string(result));
    }


    @Test
    public function testApplyWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyWithArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(b), Std.string(diff.apply(a)));
    }


    @Test
    public function testApplyComplex() {
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
        final expected = Std.string(sortObject(second));
        final result = Std.string(sortObject(diff.apply(first)));
        Assert.areEqual(expected, result);
    }


    @Test
    public function testSwapSame() {
        final obj = {x: 'Hello'};
        final diff = new Diff(obj, obj);
        Assert.areEqual(Std.string(obj), Std.string(diff.swap().apply(obj)));
    }


    @Test
    public function testSwapWithAddition() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithDeletion() {
        final a = {x: 'Hello', y: 'World'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = sortObject(a);
        final result = sortObject(diff.swap().apply(b));
        Assert.areEqual(Std.string(expected), Std.string(result));
    }


    @Test
    public function testSwapWithObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithArrayAddition() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithArrayDeletion() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapWithArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        Assert.areEqual(Std.string(a), Std.string(diff.swap().apply(b)));
    }


    @Test
    public function testSwapComplex() {
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
            },
        };
        final diff = new Diff(first, second);
        final expected = Std.string(sortObject(first));
        final result = Std.string(sortObject(diff.swap().apply(second)));
        Assert.areEqual(expected, result);
    }


    @Test
    public function testBuildWithAdditions() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {y: 'World'};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {x: 10};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {x: 'World'};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesObjectAddition() {
        final a = {x: {y: 'Hello'}};
        final b = {x: {y: 'Hello', z: 'World'}};
        final diff = new Diff(a, b);
        final expected = {x: {z: 'World'}};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesObjectDeletion() {
        final a = {x: {y: 'Hello', z: 'World'}};
        final b = {x: {y: 'Hello'}};
        final diff = new Diff(a, b);
        final expected = {x: {}};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesObjectChange() {
        final a = {x: {y: 'Hello', z: 'Hi', w: 'Other'}};
        final b = {x: {y: 'World', z: 'He', w: 'Other'}};
        final diff = new Diff(a, b);
        final expected = {x: {y: 'World', z: 'He'}};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArrayAdd() {
        final a = {x: [10, 20]};
        final b = {x: [10, 20, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [30]};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArrayDelete() {
        final a = {x: [10, 20, 30]};
        final b = {x: [10, 20]};
        final diff = new Diff(a, b);
        final expected = {x: []};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [null, 30]};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {x: [null, 30]};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArrayArrayChange() {
        final a = Json.parse('{"x": [10, [20]]}');
        final b = Json.parse('{"x": [10, [30]]}');
        final diff = new Diff(a, b);
        final expected = {x: [null, [30]]};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
    }


    @Test
    public function testBuildWithChangesArrayObjectChange() {
        final a = Json.parse('{"x": [10, {"y": 20}]}');
        final b = Json.parse('{"x": [10, {"y": 30}]}');
        final diff = new Diff(a, b);
        final expected = {x: [null, {y: 30}]};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({})));
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
        final expected = sortObject({
            title: 'Hellooo',
            stargazers: ['/users/40'],
            settings: {
                assignees: [null, null, 202]
            }
        });
        final result = sortObject(diff.apply({}));
        Assert.areEqual(Json.stringify(expected), Json.stringify(result));
    }


    @Test
    public function testBuildWithAddedId() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello', y: 'World'};
        final diff = new Diff(a, b);
        final expected = {id: 'Identifier', y: 'World'};
        Assert.areEqual(Json.stringify(expected), Json.stringify(diff.apply({id: 'Identifier'})));
    }


    @Test
    public function testNoObj() {
        final a = 0;
        final b = {x: 'Hello', y: 'World'};
        try {
            new Diff(a, b);
            Assert.isTrue(false);
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


    @Test
    private static function sortObject(obj: Dynamic): Dynamic {
        final sortedObj = {};
        final sortedFields = Reflect.fields(obj);
        sortedFields.sort((a, b) -> (a == b) ? 0 : (a > b) ? 1 : -1);
        for (field in sortedFields) {
            Reflect.setField(sortedObj, field, Reflect.field(obj, field));
        }
        return sortedObj;
    }
}
