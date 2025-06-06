import ballerina/http;

service / on new http:Listener(8090) {
    resource function get list() returns json {
        return { message: "hi 2025" };
    }
}
