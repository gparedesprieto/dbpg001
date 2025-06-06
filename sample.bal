import ballerina/http;

type Result record {| 
    string registrationId;
    string firstName;
|};

service / on new http:Listener(8090) {
    resource function get list() returns json|error {
        return { country };
    }
}
