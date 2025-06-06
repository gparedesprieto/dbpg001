import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

type Result record {| 
    string registrationId;
    string firstName;
    string lastName;
|};


service / on new http:Listener(8090) {
    resource function get list/[string country]() returns json|error {

        postgresql:Client pgClient = check new (host = "ep-polished-dew-ace0mauf-pooler.sa-east-1.aws.neon.tech",
                                                username = "neondb_owner",
                                                password = "npg_k3OCBSqFx6mQ",
                                                database = "neondb",
                                                port = 5432);

        stream<Result, sql:Error?> resultStream = pgClient->query(`SELECT a FROM Persona WHERE a = ${country}`);
        map<json> resultOutput = {};

        check from Result {registrationId, firstName, lastName} in resultStream
            do {
                resultOutput[registrationId] = {firstName, lastName};
            };

        return resultOutput;
    }
}
