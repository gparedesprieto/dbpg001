import ballerina/http;

service / on new http:Listener(8091) {
    resource function get listado() returns json {
        return { message: "hix 2025" };
    }
}
