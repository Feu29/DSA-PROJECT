import ballerina/io;
import ballerina/http;
import ballerina/time;

type assetComp record {
string assetComponents;
string maintenaceSchedules;
string workOrders;
string task;
};



type Asset record{
     readonly string tag;
     string name;
     string faculty;
     string department;
     string dateAquired;
     string curent_status;
     assetComp[] componets;
};
 

table<Asset>key(tag) assetTable = table[{
    tag: "01COM",
    name: "Computer asus i5",
    faculty: "Computer science",
    department: "software Engineering",
    dateAquired: "2025-02-20",
    curent_status: "ACTIVE",
    componets: [
        {assetComponents: "Hardrive, charger,usb ",maintenaceSchedules: "2025-10-01",workOrders: "Active",task: "update AntiVirus"}
        ]
}
];

service /asset on new http:Listener(8080){

resource function post addNewAsset(http:Caller caller, http:Request req)returns error?{

    json payload = check req.getJsonPayload();

    Asset asset = check payload.fromJsonWithType(Asset);


    if assetTable.hasKey(asset.tag){
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
    Asset? asset = assetTable[tag];
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







}
