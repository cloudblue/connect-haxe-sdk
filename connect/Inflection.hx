package connect;


class Inflection {
    public static function toCamelCase(text: String, capitalizeFirst: Bool = false): String {
        var buffer = new StringBuf();
        var lastWasUnderscore = capitalizeFirst;
        for (i in 0...text.length) {
            var char = lastWasUnderscore ? text.charAt(i).toUpperCase() : text.charAt(i);
            if (char != '_') {
                buffer.add(char);
                lastWasUnderscore = false;
            } else {
                lastWasUnderscore = true;
            }
        }
        return buffer.toString();
    }


    public static function toSingular(text: String): String {
        if (text.charAt(text.length - 1) == 's') {
            return text.substr(0, text.length - 1);
        } else {
            return text;
        }
    }


    public static function toSnakeCase(text: String): String {
        var r1 = ~/(.)([A-Z][a-z]+)/g;
        var r2 = ~/([a-z0-9])([A-Z])/g;
        var s1 = r1.replace(text, '$1_$2');
        return r2.replace(s1, '$1_$2').toLowerCase();
    }
}