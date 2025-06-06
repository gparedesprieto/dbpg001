import ballerina/http;

service / on new http:Listener(8091) {
    resource function get listado() returns json {
        return { message: "hix 2025" };
    }

    resource function get listie(string id) returns json {
        return { message: "desde Choreo", id: id };
    }

    resource function post datos(@http:Payload json inputJson) returns json|error {
        return {
            message: "JSON recibido correctamente",
            recibido: inputJson
        };
    }

    resource function put datos(@http:Payload json inputJson) returns json|error {
        return {
            message: "JSON recibido correctamente",
            recibido: inputJson
        };
    }

    resource function patch datos(@http:Payload json inputJson) returns json|error {
        return {
            message: "JSON recibido correctamente",
            recibido: inputJson
        };
    }

}
