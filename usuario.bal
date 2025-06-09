import ballerina/http;
//import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

type getResult record {
    json data;
};

type xUsuarioPayload record {|
    string codigo;
    string usuarioAudit;
|};

type xUsuario record {|
    xUsuarioPayload payload;
|};

type evalPayload record {|
    string codigos;
    string accion;
    string usuarioAudit;
|};

type evalUsuario record {|
    evalPayload payload;
|};

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

    resource function patch evaluarUsuario(@http:Payload json inputJson) returns json|error {
        evalUsuario x = check inputJson.fromJsonWithType(evalUsuario);

        getResult result = check self.pgClient->queryRow(
            `SELECT usuario_eval(${x.codigos},${x.accion},${x.usuarioAudit}) AS data`
        );

        return result.data;
    }

    resource function delete eliminarUsuario(@http:Payload json inputJson) returns json|error {
        xUsuario x = check inputJson.fromJsonWithType(xUsuario);

        getResult result = check self.pgClient->queryRow(
            `SELECT usuario_del(${x.codigo},${x.usuarioAudit}) AS data`
        );

        return result.data;
    }
}
