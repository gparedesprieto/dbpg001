import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

type Result record {| 
    string a;
    string b;
    string apellido;
|};

service / on new http:Listener(8092) {
    resource function get listy() returns json|error {

        postgresql:Client pgClient = check new (host = "ep-polished-dew-ace0mauf-pooler.sa-east-1.aws.neon.tech",
                                                username = "neondb_owner",
                                                password = "npg_k3OCBSqFx6mQ",
                                                database = "neondb",
                                                port = 5432);

        stream<Result, sql:Error?> resultStream = pgClient->query(`SELECT a, b, apellido FROM Persona`);
        map<json> resultOutput = {};

        check from Result {a, b, apellido} in resultStream
            do {
                resultOutput[a] = {b, apellido};
            };

        return resultOutput;
    }

    resource function get listie/[string id]() returns json|error {

        postgresql:Client pgClient = check new (host = "ep-polished-dew-ace0mauf-pooler.sa-east-1.aws.neon.tech",
                                                username = "neondb_owner",
                                                password = "npg_k3OCBSqFx6mQ",
                                                database = "neondb",
                                                port = 5432);

        stream<Result, sql:Error?> resultStream = pgClient->query(`SELECT a, b, apellido FROM Persona WHERE a=${id}`);
        map<json> resultOutput = {};

        check from Result {a, b, apellido} in resultStream
            do {
                resultOutput[a] = {b, apellido};
            };

        return resultOutput;
    }
}
