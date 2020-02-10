/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/

class Helper {
    public static function sortObject(obj: Dynamic): Dynamic {
        final sortedObj = {};
        final sortedFields = Reflect.fields(obj);
        sortedFields.sort((a, b) -> (a == b) ? 0 : (a > b) ? 1 : -1);
        Lambda.iter(sortedFields, f -> Reflect.setField(sortedObj, f, sortValue(Reflect.field(obj, f))));
        return sortedObj;
    }


    private static function sortArrayObjects(arr: Array<Dynamic>): Array<Dynamic> {
        return Lambda.map(arr, elem -> sortValue(elem));
    }

    private static function sortValue(value: Dynamic): Dynamic {
        switch (Type.typeof(value)) {
            case TClass(Array):
                return sortArrayObjects(value);
            case TObject:
                return sortObject(value);
            default:
                return value;
        }
    }
}
