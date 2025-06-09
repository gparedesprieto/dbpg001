import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;
configurable int dbPort = ?;

type getResult record {
    json data;
};

service / on new http:Listener(8093) {

    // Variable para almacenar el cliente PostgreSQL
    postgresql:Client pgClient;

    // Constructor del servicio: se ejecuta al iniciar
    function init() returns error? {
        self.pgClient = check new (host = host,
                                   username = username,
                                   password = password,
                                   database = database,
                                   port = dbPort);
    }

    resource function get list() returns json {
        return { message: "hi 2025" };
    }

    resource function post UsuarioPaginaFiltro(@http:Payload json inputJson) returns json|error {
        
        getResult result = check self.pgClient->queryRow(
            `SELECT get_UsuarioPaginaFiltro($1) AS data`,
                                   inputJson.toJsonString()
        );

        return result.data;
    }
}
