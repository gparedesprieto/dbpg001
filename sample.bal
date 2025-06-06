import ballerina/http;

service / on new http:Listener(8090) {
    resource function get list() returns json {
        return { message: "hi 2025" };
    }

    resource function get listas() returns json {
        return { message: "his 2025" };
    }
}
