import ballerina/http;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;
configurable int dbPort = ?;
                                 
type Persona record {
    string nombre;
    int edad;
};

type BusPersona record {
    string id;
    string usuario;
};

type xPersona record {
    string codigo;
    string nombre;
    string apellido;
    int edad;
};

type UpsertResult record {
    json upsert_persona;
};

service / on new http:Listener(8091) {

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
        Persona persona = check inputJson.fromJsonWithType(Persona);

        return {
            message: "JSON recibido correctamente",
            recibido: inputJson,
            nombre: persona.nombre,
            edad: persona.edad
        };
    }

    resource function post getData(@http:Payload json inputJson) returns json|error {
        BusPersona busPersona = check inputJson.fromJsonWithType(BusPersona);

        postgresql:Client pgClient = check new (host = host,
                                                username = username,
                                                password = password,
                                                database = database,
                                                port = dbPort);

        stream<Result, sql:Error?> resultStream = pgClient->query(`SELECT a, b, apellido FROM Persona WHERE a=${busPersona.id}`);
        map<json> resultOutput = {};

        check from Result {a, b, apellido} in resultStream
            do {
                resultOutput[a] = {b, apellido};
            };

        return resultOutput;
    }

    resource function get listy() returns json|error {

        postgresql:Client pgClient = check new (host = host,
                                                username = username,
                                                password = password,
                                                database = database,
                                                port = dbPort);

        stream<Result, sql:Error?> resultStream = pgClient->query(`SELECT a, b, apellido FROM Persona`);
        map<json> resultOutput = {};

        check from Result {a, b, apellido} in resultStream
            do {
                resultOutput[a] = {b, apellido};
            };

        return resultOutput;
    }

    resource function post insData(@http:Payload json inputJson) returns json|error {
    
        // Convertir el JSON a un objeto del tipo Persona
        xPersona persona = check inputJson.fromJsonWithType(xPersona);

        // Crear cliente de conexión a PostgreSQL
        postgresql:Client pgClient = check new (host = host,
                                                port = dbPort,
                                                username = username,
                                                password = password,
                                                database = database);

        // Ejecutar inserción — aquí no necesitas `query()` sino `execute()`
        sql:ParameterizedQuery insertQuery = `INSERT INTO Persona (a, b, apellido, edad) VALUES (${persona.codigo}, ${persona.nombre}, ${persona.apellido}, ${persona.edad})`;
        _ = check pgClient->execute(insertQuery);

        // Puedes devolver una respuesta simple de éxito
        return { status: "success", nombre: persona.nombre };
    }

    resource function post upsertData(@http:Payload json inputJson) returns json|error {
        xPersona persona = check inputJson.fromJsonWithType(xPersona);

        postgresql:Client pgClient = check new (host = host,
                                                port = dbPort,
                                                username = username,
                                                password = password,
                                                database = database);

        // Llamada a la función PostgreSQL que retorna JSON
        UpsertResult result = check pgClient->queryRow(
            `SELECT upsert_persona(${persona.codigo}, ${persona.nombre}, ${persona.apellido}, ${persona.edad}::integer) AS upsert_persona`
        );

        // Retornar el campo JSON de la función
        return result.upsert_persona;
    }

    resource function post upsertData1(@http:Payload json inputJson) returns json|error {
        xPersona persona = check inputJson.fromJsonWithType(xPersona);

        // Llamada a la función PostgreSQL que retorna JSON
        UpsertResult result = check self.pgClient->queryRow(
            `SELECT upsert_persona(${persona.codigo}, ${persona.nombre}, ${persona.apellido}, ${persona.edad}::integer) AS upsert_persona`
        );

        // Retornar el campo JSON de la función
        return result.upsert_persona;
    }

    resource function post upsertData2(@http:Payload json inputJson) returns json|error {
        
        UpsertResult result = check self.pgClient->queryRow(
            `SELECT upsert_persona4(${inputJson.toJsonString()}) AS upsert_persona`
        );
        
        return result.upsert_persona;
    }

}
