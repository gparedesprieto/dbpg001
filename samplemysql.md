import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

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
                                                
        mysql:Client mysqlClient = check new (host = "choreo-shared-mysql.mysql.database.azure.com",
                                            user = "readonly-sampleuser@choreo-shared-mysql.mysql.database.azure.com",
                                            password = "non_confidential_password",
                                            database = "customers_db", port = 3306);

        stream<Result, sql:Error?> resultStream = mysqlClient->query(`SELECT registrationId, firstName, lastName FROM Customers 
                                                WHERE country=${country}`);
        map<json> resultOutput = {};

        check from Result {registrationId, firstName, lastName} in resultStream
            do {
                resultOutput[registrationId] = {firstName, lastName};
            };

        return resultOutput;
    }
}
