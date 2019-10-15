package connect.native;


#if java
@:nativeGen
@:abstract
@:javaNative
@:native("java.util.function.BiFunction")
@:javaCanonical("java.util.function","BiFunction")
interface JavaBiFunction<T, U, R> {
    @:overload
    function apply(param1: T, param2: U): R;
}
#end
