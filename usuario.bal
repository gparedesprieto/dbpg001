import ballerina/http;
//import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

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
            `SELECT get_UsuarioPaginaFiltro(${inputJson.toJsonString()}) AS data`
        );

        return result.data;
    }

    resource function post guardarUsuario(@http:Payload json inputJson) returns json|error {
        
        getResult result = check self.pgClient->queryRow(
            `SELECT upsert_Usuario(${inputJson.toJsonString()}) AS data`
        );

        return result.data;
    }

    resource function put guardarUsuario(@http:Payload json inputJson) returns json|error {
        
        getResult result = check self.pgClient->queryRow(
            `SELECT upsert_Usuario(${inputJson.toJsonString()}) AS data`
        );

        return result.data;
    }

    resource function post evaluarUsuario(string codigos, string accion, string usuario) returns json|error {
        
        getResult result = check self.pgClient->queryRow(
            `SELECT usuario_eval(${codigos},${accion},${usuario}) AS data`
        );

        return result.data;
    }
}
