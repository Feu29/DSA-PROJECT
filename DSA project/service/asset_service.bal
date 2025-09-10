import ballerina/http;
import ballerina/time;
import ballerina/log;

// Types (must match server)
type Component record {
    string id;
    string name;
    string description;
};

type Schedule record {
    string id;
    string frequency;
    string nextDueDate;
};

type Task record {
    string id;
    string description;
    string status;
};

type WorkOrders record {
    string id;
    string title;
    string status;
    Task[] tasks;
};

type Asset record {
    readonly string assetTag;
    string name;
    string faculty;
    string department;
    string dateAcquired;
    string current_status;
    Component[] components;
    Schedule[] schedules;
    WorkOrders[] workOrders;
};


table<Asset> key(assetTag) assetTable = table [];

service /asset on new http:Listener(8080) {

    resource function post .(http:Caller caller, http:Request req) returns error? {
        json|error payloadResult = req.getJsonPayload();
        if payloadResult is error {
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({"message": "Invalid JSON payload"});
            check caller->respond(response);
            return;
        }
        json payload = <json> payloadResult;

        Asset|error assetRes = payload.fromJsonWithType(Asset);
        if assetRes is error {
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({"message": "Invalid Asset data: " + assetRes.message()});
            check caller->respond(response);
            return;
        }
        Asset asset = assetRes;

        if assetTable.hasKey(asset.assetTag) {
            http:Response response = new;
            response.statusCode = 409;
            response.setJsonPayload({"message": "Asset with this tag already exists!"});
            check caller->respond(response);
            return;
        }

        assetTable.add(asset);
        http:Response response = new;
        response.statusCode = 201;
        response.setJsonPayload({"message": "Asset added successfully"});
        check caller->respond(response);
    }

    resource function get .(http:Caller caller) returns error? {
        Asset[] assets = from var asset in assetTable select asset;
        check caller->respond(assets);
    }

    resource function get [string tag](http:Caller caller) returns error? {
        Asset? asset = assetTable[tag];
        if asset is Asset {
            check caller->respond(asset);
        } else {
            http:Response response = new;
            response.statusCode = 404;
            response.setJsonPayload({"message": "Asset not found"});
            check caller->respond(response);
        }
    }

    resource function get faculty/[string faculty](http:Caller caller) returns error? {
        Asset[] filtered = [];
        foreach var asset in assetTable {
            if asset.faculty.toLowerAscii() == faculty.toLowerAscii() {
                filtered.push(asset);
            }
        }
        check caller->respond(filtered);
    }

    resource function delete [string tag](http:Caller caller) returns error? {
        http:Response response = new;
        if assetTable.hasKey(tag) {
            _ = assetTable.remove(tag);
            // 204 no content — respond with status only
            response.statusCode = 204;
        } else {
            response.statusCode = 404;
            response.setJsonPayload({"message": "Asset Not Found"});
        }
        check caller->respond(response);
    }

    resource function get dueItems(http:Caller caller) returns error? {
        // 5 years in seconds (approx)
        Asset[] dueItems = [];

        foreach Asset asset in assetTable {
            time:Utc|error registrationTime = time:utcFromString(asset.dateAcquired + "T00:00:00Z");
            if registrationTime is error {
                log:printError("Invalid date format for asset: " + asset.assetTag);
                continue;
            }
        }
        check caller->respond(dueItems);
    }

    resource function put [string assetTag](http:Caller caller, http:Request req) returns error? {
        json|error reqPayloadRes = req.getJsonPayload();
        if reqPayloadRes is error {
            log:printError("Invalid JSON payload: " + reqPayloadRes.message());
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({"message": "Invalid JSON payload"});
            check caller->respond(response);
            return;
        }
        json reqPayload = <json> reqPayloadRes;

        Asset|error updateAssetRes = reqPayload.cloneWithType(Asset);
        if updateAssetRes is error {
            log:printError("Invalid Asset data: " + updateAssetRes.message());
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({"message": "Invalid Asset data: " + updateAssetRes.message()});
            check caller->respond(response);
            return;
        }
        Asset updateAsset = updateAssetRes;

        Asset? existingAssetOpt = assetTable[assetTag];

        if existingAssetOpt is Asset {
            // Replace fields (keeping the assetTag same)
            Asset existingAsset = existingAssetOpt;
            existingAsset.name = updateAsset.name;
            existingAsset.faculty = updateAsset.faculty;
            existingAsset.department = updateAsset.department;
            existingAsset.dateAcquired = updateAsset.dateAcquired;
            existingAsset.current_status = updateAsset.current_status;
            existingAsset.components = updateAsset.components;
            existingAsset.schedules = updateAsset.schedules;
            existingAsset.workOrders = updateAsset.workOrders;

            log:printInfo("Asset updated Successfully: " + assetTag);

            check caller->respond({"message": "Asset updated successfully"});
        } else {
            log:printError("Asset not found: " + assetTag);
            http:Response response = new;
            response.statusCode = 404;
            response.setJsonPayload({"message": "Asset not found"});
            check caller->respond(response);
        }
    }
}
