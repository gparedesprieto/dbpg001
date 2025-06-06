import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

type Result record {| 
    string registrationId;
    string firstName;
|};

service "/default/dbpg001/v1.0" on new http:Listener(8090) {
    resource function get list/[string country]() returns json|error {
        return { country };
    }
}
