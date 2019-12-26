/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

class Response extends Base {
    public final status: Int;
    public final text: String;
    public final data: Blob;

    public function new(status:Int, text:String, data:Blob) {
        this.status = status;
        this.text = text;
        this.data = data;
    }
}
