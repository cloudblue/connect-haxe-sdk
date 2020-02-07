

class Helper {
    public static function sortObject(obj: Dynamic): Dynamic {
        final sortedObj = {};
        final sortedFields = Reflect.fields(obj);
        sortedFields.sort((a, b) -> (a == b) ? 0 : (a > b) ? 1 : -1);
        for (field in sortedFields) {
            Reflect.setField(sortedObj, field, Reflect.field(obj, field));
        }
        return sortedObj;
    }
}
