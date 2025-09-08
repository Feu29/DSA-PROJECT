import ballerina/io;
import ballerina/http;
import ballerina/time;
import ballerina/log;


type Component record{
    string id;
    string name;
    string description;
}

type Schedule record {
    string id;
    string frequency;
    string nextDueDate;
}
type Task record {
    string id;
    string description;
    string status;
}
type WorkOrders record{
    string id;
    string title;
    string status;
    Task[]task;
}

type Asset record{
     readonly string assetTag;
     string name;
     string faculty;
     string department;
     string dateAquired;
     string curent_status;
     Component[] componets;
     Schedule[] schedules;
     WorkOrders[] workOrders;
};
 

table<Asset>key(assetTag) assetTable = {};

service /asset on new http:Listener(8080){

resource function post addNewAsset(http:Caller caller, http:Request req)returns error?{

    json payload = check req.getJsonPayload();

    Asset asset = check payload.fromJsonWithType(Asset);


    if assetTable.hasKey(asset.asstTag){
        http:Response response = new;
        response.statusCode=409;
        response.setJsonPayload({"message":"Programme with this code already exists!"});
        check caller->respond(response);
        return;


    }
assetTable.add(asset);

http:Response response = new ;
response.statusCode= 201;
response.setJsonPayload({"message":"Asset successfully"});
check caller->respond(response);


}
resource function get allAssets(http:Caller caller )returns error? {
    check  caller->respond(assetTable.toArray());
    
}

resource function get getAsset/[string tag](http:Caller caller)returns error? {
    Asset? asset = assetTable[assetTag];
    if asset is Asset{
        check caller->respond(asset);
    }else {
        http:Response response = new;
        response.statusCode =404;
        response.setJsonPayload({"message":"Asset not found"});
        check caller->respond(response);
        
    }

    
}

resource function get getAssetFromFaculty/[string faculty](http:Caller caller)returns error? {
    Asset[] filtered=[];
    foreach var [k,v] in assetTable {
        if v.faculty.toLowerAscii() == faculty.toLowerAscii(){
            filtered.push(v);
        }
        
    }
    check caller->respond(filtered);




}



resource function delete Asset/[string aassetTag]()returns http:Response {
    http:Response response = new http:Response();

    if assetTable.hasKey(assetTag){
        _=assetTable.remove(assetTag);
        response.statusCode = 204;
        response.setPayload("Asset successfully removed");

    }else {
        response.statusCode = 404;
        response.setPayload("Asset Not Found");
    }
    return response;
    
}










resource function get getDueItems(http:Caller caller)returns error? {
    time:Seconds reviewCycle = 5*365*24*60*60;
        io:println("reviewCycle "+reviewCycle.toString());
    
    
    time:Utc currentTime = time:utcNow();

    Asset[] dueItems = [];

    foreach Asset asset in assetTable.toArray() {
        time:Utc rregistrationTime = check time:utcFromString(asset.dateAquired);
        time:Seconds elapsedTime = time:utcDiffSeconds(currentTime, dateAquired);

        if elapsedTime>= reviewCycle{
            io:println("revieCycle has been breached" +elapsedTime.toString());
            dueItems.push(asset);
        }  
            
        
    }
    check caller->respond(dueItems);
    
}


resource function put updateAsset/[string assetTag](http:Caller caller, http:Request req) returns error?{

    json|error reqPayload = req.getJsonPayload();

    if(reqPayload is json){
        Asset|error updateAsset = reqPayload.cloneWithType(Asset);

    if(updateAsset is Asset){

        Asset? existingAssetOpt = assetTable[assetTag];


        if(existingAssetOpt is Asset){

            Asset existingAsset = existingAssetOpt;
            existingAsset.name = updateAsset.name;
            existingAsset.faculty = updateAsset.faculty;
            existingAsset.department=updateAsset.department;
            existingAsset.dateAquired = updateAsset.dateAquired;
            existingAsset.componets = updateAsset.componets;
            existingAsset.schedules = updateAsset.schedules;
            existingAsset.workOrders = updateAsset.workOrders;


        assetTable.put(existingAsset);
        log:printInfo("Asset updated Successfully:" + assetTag);


check caller->respond({
    message:"Asset updated successfully",
    asset:existingAsset
});

        }else {
            log:printError("Asset not found:" + tag);
            check caller->respond({
                status:http:STATUS_BAD_REQUEST,
                message:"Invalid JSON payload"
            });
        }else {
            log:printError("Invalid JSON payload");

            check caller->respond({
                status: http:STATUS_BAD_REQUEST,
                message:"Invalid JSON payload"
            });
        }
    }




    }
}






}

