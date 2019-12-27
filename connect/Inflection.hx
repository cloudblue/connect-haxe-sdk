/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect;


/**
    This class provides static methods for string transformation. For example,
    to change casing (snake_case, camelCase, UpperCamelCase), or to singularize a word.
**/
@:dox(hide)
class Inflection {
    /**
        Returns a string with the given text converted from snake_case to camelCase.

        If `capitalizeFirst` is true, then the string is returned as UpperCamelCase.
    **/
    public static function toCamelCase(text: String, capitalizeFirst: Bool = false): String {
        final buffer = new StringBuf();
        var lastWasUnderscore = capitalizeFirst;
        for (i in 0...text.length) {
            final char = lastWasUnderscore ? text.charAt(i).toUpperCase() : text.charAt(i);
            if (char != '_') {
                buffer.add(char);
                lastWasUnderscore = false;
            } else {
                lastWasUnderscore = true;
            }
        }
        return buffer.toString();
    }


    /**
        Returns a string the trailing "s" removed from the given text, if it has one.
    **/
    public static function toSingular(text: String): String {
        if (text.charAt(text.length - 1) == 's') {
            return text.substr(0, text.length - 1);
        } else {
            return text;
        }
    }


    /**
        Returns a string with the given text converted from camelCase or UpperCamelCase to
        snake_case.
    **/
    public static function toSnakeCase(text: String): String {
        final r1 = ~/(.)([A-Z][a-z]+)/g;
        final r2 = ~/([a-z0-9])([A-Z])/g;
        final s1 = r1.replace(text, '$1_$2');
        return r2.replace(s1, '$1_$2').toLowerCase();
    }
}
