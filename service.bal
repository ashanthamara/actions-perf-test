import ballerina/http;
import ballerina/log;
import ballerina/lang.runtime;

enum ActionSuccessStatus {
    SUCCESS
}

enum ActionFailedStatus {
    ERROR
}

enum OperationType {
    ADD = "add",
    REMOVE = "remove",
    REPLACE = "replace"
}

type OperationValue record {
    string name;
    string | string[] | boolean value;
};

type Operation record {
    string op;
    string path;
    string | OperationValue value?;
};

type ActionSuccessResponse record {
    ActionSuccessStatus actionStatus;
    Operation[] operations;
};

type ActionFailedResponse record {
    ActionFailedStatus actionStatus;
    string 'error;
    string error_description;
};

service / on new http:Listener(8091) {
    resource function post successResponse(http:Request req) returns http:Response|error? {

        log:printInfo("Request Received: Success Response");
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: ADD,
                    path: "/accessToken/scopes/-",
                    value: "test_api_perm_1"
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/aud/-",
                    value: "https://myextension.com"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/claims/expires_in",
                    value: "4000"
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/-",
                    value: {
                        name: "isPermanent",
                        value: true
                    }
                }
            ]
        };

        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post readTimeoutResponse(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received: Read Time Out Response");

        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: ADD,
                    path: "/accessToken/scopes/-",
                    value: "test_api_perm_1"
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/aud/-",
                    value: "https://myextension.com"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/claims/expires_in",
                    value: "4000"
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/-",
                    value: {
                        name: "isPermanent",
                        value: true
                    }
                }
            ]
        };

        // Sleep for 6 seconds
        runtime:sleep(5);
        log:printInfo("Execution resumed after 6 seconds.");

        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }
}

