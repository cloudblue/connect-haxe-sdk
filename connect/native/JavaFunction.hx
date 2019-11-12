package connect.native;


#if java
@:nativeGen
@:abstract
@:javaNative
@:native("java.util.function.Function")
@:javaCanonical("java.util.function","Function")
interface JavaFunction<T, R> {
    @:overload
    function apply(param: T): R;
}
#end
