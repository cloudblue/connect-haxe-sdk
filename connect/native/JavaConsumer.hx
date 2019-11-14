package connect.native;


#if java
@:nativeGen
@:abstract
@:javaNative
@:native("java.util.function.Consumer")
@:javaCanonical("java.util.function","Consumer")
interface JavaConsumer<T> {
    @:overload
    function accept(param: T): Void;
}
#end
