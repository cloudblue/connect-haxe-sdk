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
            a: {y: 'World'},
            d: {},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testDeletions() {
        final a = {x: 'Hello', y: 'World'};
        final b = {y: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {x: 'Hello'},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesNoChange() {
        final a = {x: 'Hello'};
        final b = {x: 'Hello'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesTypeChange() {
        final a = {x: '10'};
        final b = {x: 10};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {x: untyped ['10', 10]}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesSimpleChange() {
        final a = {x: 'Hello'};
        final b = {x: 'World'};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {x: ['Hello', 'World']}
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArraySimpleChange() {
        final a = {x: [10, 20]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArraySimpleChangeAndDelete() {
        final a = {x: [10, 20, 100]};
        final b = {x: [10, 30]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [100],
                    [
                        [1, 20, 30]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayArrayChange() {
        final a = {x: untyped [10, [20]]};
        final b = {x: untyped [10, [30]]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
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
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


    public function testChangesArrayObjectChange() {
        final a = {x: untyped [10, {y: 20}]};
        final b = {x: untyped [10, {y: 30}]};
        final diff = new Diff(a, b);
        final expected = {
            a: {},
            d: {},
            c: {
                x: untyped [
                    [],
                    [],
                    [
                        [1, {
                            a: {},
                            d: {},
                            c: {
                                y: [20, 30]
                            }
                        }]
                    ]
                ]
            }
        };
        this.assertEquals(Json.stringify(expected), diff.toString());
    }


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
        this.assertEquals(Json.stringify(expected), diff.toString());
    }
}
