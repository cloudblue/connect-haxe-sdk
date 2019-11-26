package connect.native;

#if python
import haxe.io.Bytes;
import python.Syntax;


class PythonZlib {
    public static function compress(data: Bytes, level: Int): Bytes {
        Syntax.code("import zlib");
        final pythonBytes = new python.Bytes(Blob._bytesToArray(data));
        final result = Syntax.code("zlib.compress({0}, {1})", pythonBytes, level);
        return Bytes.ofData(result);
    }


    public static function decompress(data: Bytes): Bytes {
        Syntax.code("import zlib");
        final pythonBytes = new python.Bytes(Blob._bytesToArray(data));
        final result = Syntax.code("zlib.decompress({0})", pythonBytes);
        return Bytes.ofData(result);
    }
}
#end
