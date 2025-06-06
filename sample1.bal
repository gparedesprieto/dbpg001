import ballerina/http;

service / on new http:Listener(8091) {
    resource function get listado() returns json {
        return { message: "hix 2025" };
    }

    resource function get listada/{id}(string id) returns json {
        return { message: "hix 2025", id: id };
    }

}
