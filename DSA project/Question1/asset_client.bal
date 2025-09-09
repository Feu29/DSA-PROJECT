import ballerina/http;
import ballerina/io;
import ballerina/lang.value; // required for fromJsonWithType conversions
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

// HTTP client for the Asset Management API
final http:Client assetClient = check new ("http://localhost:8080");

public function main() returns error? {
    displayWelcomeMessage();

    while true {
        displayMainMenu();
        string choice = io:readln("Enter your choice (1-8): ");

        match choice {
            "1" => { check addNewAssetInteractive(); }
            "2" => { check viewAllAssets(); }
            "3" => { check viewAssetByTag(); }
            "4" => { check viewAssetsByFaculty(); }
            "5" => { check viewDueItems(); }
            "6" => { check updateAssetInteractive(); }
            "7" => { check deleteAssetInteractive(); }
            "8" => {
                io:println("Thank you for using Asset Management System!");
                break;
            }
            _ => { io:println("Invalid choice! Please try again."); }
        }

        io:println("\nPress Enter to continue...");
        _ = io:readln();
    }

    return;
}

function displayWelcomeMessage() {
    io:println("=========================================");
    io:println("    ASSET MANAGEMENT SYSTEM CLIENT");
    io:println("=========================================");
}

function displayMainMenu() {
    io:println("\n=== MAIN MENU ===");
    io:println("1. Add New Asset");
    io:println("2. View All Assets");
    io:println("3. View Asset by Tag");
    io:println("4. View Assets by Faculty");
    io:println("5. View Due Items for Review");
    io:println("6. Update Asset");
    io:println("7. Delete Asset");
    io:println("8. Exit");
    io:println("=================");
}

function addNewAssetInteractive() returns error? {

    io:println("\n=== ADD NEW ASSET ===");

    string assetTag = io:readln("Enter Asset Tag: ");
    string name = io:readln("Enter Asset Name: ");
    string faculty = io:readln("Enter Faculty: ");
    string department = io:readln("Enter Department: ");
    string dateAcquired = io:readln("Enter Date Acquired (YYYY-MM-DD): ");
    string current_status = io:readln("Enter Current Status: ");

    // Ask if user wants to add components
    Component[] components = [];
    io:println("\nAdd Components? (y/n): ");
    string addComponents = io:readln();
    if addComponents.toLowerAscii() == "y" {
        components = addComponentsInteractive();
    }

    // Ask if user wants to add schedules
    Schedule[] schedules = [];
    io:println("\nAdd Schedules? (y/n): ");
    string addSchedules = io:readln();
    if addSchedules.toLowerAscii() == "y" {
        schedules = addSchedulesInteractive();
    }

    // Ask if user wants to add work orders
    WorkOrders[] workOrders = [];
    io:println("\nAdd Work Orders? (y/n): ");
    string addWorkOrders = io:readln();
    if addWorkOrders.toLowerAscii() == "y" {
        workOrders = addWorkOrdersInteractive();
    }

    Asset newAsset = {
        assetTag: assetTag,
        name: name,
        faculty: faculty,
        department: department,
        dateAcquired: dateAcquired,
        current_status: current_status,
        components: components,
        schedules: schedules,
        workOrders: workOrders
    };

    string result = check addAsset(newAsset);
    io:println(result);
}

function addComponentsInteractive() returns Component[] {
    Component[] components = [];
    io:println("\n=== ADD COMPONENTS ===");

    while true {
        string id = io:readln("Enter Component ID (or 'done' to finish): ");
        if id.toLowerAscii() == "done" {
            break;
        }

        string name = io:readln("Enter Component Name: ");
        string description = io:readln("Enter Component Description: ");

        components.push({
            id: id,
            name: name,
            description: description
        });

        io:println("Component added! Add another? (y/n): ");
        string addAnother = io:readln();
        if addAnother.toLowerAscii() != "y" {
            break;
        }
    }

    return components;
}

function addSchedulesInteractive() returns Schedule[] {
    Schedule[] schedules = [];
    io:println("\n=== ADD SCHEDULES ===");

    while true {
        string id = io:readln("Enter Schedule ID (or 'done' to finish): ");
        if id.toLowerAscii() == "done" {
            break;
        }

        string frequency = io:readln("Enter Frequency: ");
        string nextDueDate = io:readln("Enter Next Due Date (YYYY-MM-DD): ");

        schedules.push({
            id: id,
            frequency: frequency,
            nextDueDate: nextDueDate
        });

        io:println("Schedule added! Add another? (y/n): ");
        string continueInput = io:readln();
        if continueInput.toLowerAscii() != "y" {
            break;
        }
    }

    return schedules;
}

function addWorkOrdersInteractive() returns WorkOrders[] {
    WorkOrders[] workOrders = [];
    io:println("\n=== ADD WORK ORDERS ===");

    while true {
        string id = io:readln("Enter Work Order ID (or 'done' to finish): ");
        if id.toLowerAscii() == "done" {
            break;
        }

        string title = io:readln("Enter Work Order Title: ");
        string status = io:readln("Enter Work Order Status: ");

        Task[] tasks = [];
        io:println("Add Tasks to this Work Order? (y/n): ");
        string addTasks = io:readln();
        if addTasks.toLowerAscii() == "y" {
            tasks = addTasksInteractive();
        }

        workOrders.push({
            id: id,
            title: title,
            status: status,
            tasks: tasks
        });

        io:println("Work Order added! Add another? (y/n): ");
        string continueInput = io:readln();
        if continueInput.toLowerAscii() != "y" {
            break;
        }
    }

    return workOrders;
}

function addTasksInteractive() returns Task[] {
    Task[] tasks = [];
    io:println("\n=== ADD TASKS ===");

    while true {
        string id = io:readln("Enter Task ID (or 'done' to finish): ");
        if id.toLowerAscii() == "done" {
            break;
        }

        string description = io:readln("Enter Task Description: ");
        string status = io:readln("Enter Task Status: ");

        tasks.push({
            id: id,
            description: description,
            status: status
        });

        io:println("Task added! Add another? (y/n): ");
        string continueInput = io:readln();
        if continueInput.toLowerAscii() != "y" {
            break;
        }
    }

    return tasks;
}

function viewAllAssets() returns error? {
    io:println("\n=== ALL ASSETS ===");
    Asset[] assets = getAllAssets();

    if assets.length() == 0 {
        io:println("No assets found.");
        return;
    }

    foreach var [i, asset] in assets.enumerate() {
        io:println("\n[" + (i + 1).toString() + "] " + asset.assetTag + " - " + asset.name);
        io:println("   Faculty: " + asset.faculty + ", Department: " + asset.department);
        io:println("   Status: " + asset.current_status + ", Acquired: " + asset.dateAcquired);
    }

    io:println("\nTotal assets: " + assets.length().toString());
}

function viewAssetByTag() returns error? {
    io:println("\n=== VIEW ASSET BY TAG ===");
    string assetTag = io:readln("Enter Asset Tag: ");

    Asset? asset = getAsset(assetTag);
    if asset is Asset {
        displayAssetDetails(asset);
    } else {
        io:println("Asset not found with tag: " + assetTag);
    }
}

function viewAssetsByFaculty() returns error? {
    io:println("\n=== VIEW ASSETS BY FACULTY ===");
    string faculty = io:readln("Enter Faculty Name: ");

    Asset[] assets = getAssetsByFaculty(faculty);

    if assets.length() == 0 {
        io:println("No assets found for faculty: " + faculty);
        return;
    }

    io:println("\nAssets in Faculty '" + faculty + "':");
    foreach var [i, asset] in assets.enumerate() {
        io:println("[" + (i + 1).toString() + "] " + asset.assetTag + " - " + asset.name);
        io:println("   Department: " + asset.department + ", Status: " + asset.current_status);
    }

    io:println("\nTotal assets: " + assets.length().toString());
}

function viewDueItems() returns error? {
    io:println("\n=== DUE ITEMS FOR REVIEW ===");
    Asset[] dueItems = getDueItems();

    if dueItems.length() == 0 {
        io:println("No items due for review.");
        return;
    }

    io:println("Items due for review:");
    foreach var [i, asset] in dueItems.enumerate() {
        io:println("[" + (i + 1).toString() + "] " + asset.assetTag + " - " + asset.name);
        io:println("   Acquired: " + asset.dateAcquired + ", Faculty: " + asset.faculty);
    }

    io:println("\nTotal due items: " + dueItems.length().toString());
}

function updateAssetInteractive() returns error? {
    io:println("\n=== UPDATE ASSET ===");
    string assetTag = io:readln("Enter Asset Tag to update: ");

    // First get the current asset
    Asset? currentAsset = getAsset(assetTag);
    if currentAsset is () {
        io:println("Asset not found with tag: " + assetTag);
        return;
    }

    io:println("\nCurrent Asset Details:");
    displayAssetDetails(currentAsset);

    io:println("\nEnter new details (press Enter to keep current value):");

    string name = io:readln("New Name [" + currentAsset.name + "]: ");
    string faculty = io:readln("New Faculty [" + currentAsset.faculty + "]: ");
    string department = io:readln("New Department [" + currentAsset.department + "]: ");
    string status = io:readln("New Status [" + currentAsset.current_status + "]: ");

    // Build a new asset object based on current asset then override changed fields
    Asset updatedAsset = {
        assetTag: currentAsset.assetTag,
        name: currentAsset.name,
        faculty: currentAsset.faculty,
        department: currentAsset.department,
        dateAcquired: currentAsset.dateAcquired,
        current_status: currentAsset.current_status,
        components: currentAsset.components,
        schedules: currentAsset.schedules,
        workOrders: currentAsset.workOrders
    };

    if name != "" { updatedAsset.name = name; }
    if faculty != "" { updatedAsset.faculty = faculty; }
    if department != "" { updatedAsset.department = department; }
    if status != "" { updatedAsset.current_status = status; }

    string result = check updateAsset(updatedAsset);
    io:println(result);
}

function deleteAssetInteractive() returns error? {
    io:println("\n=== DELETE ASSET ===");
    string assetTag = io:readln("Enter Asset Tag to delete: ");

    // Confirm deletion
    io:println("Are you sure you want to delete asset '" + assetTag + "'? (y/n): ");
    string confirm = io:readln();

    if confirm.toLowerAscii() == "y" {
        boolean success = deleteAsset(assetTag);
        if success {
            io:println("Asset deleted successfully!");
        } else {
            io:println("Failed to delete asset or asset not found.");
        }
    } else {
        io:println("Deletion cancelled.");
    }
}

function displayAssetDetails(Asset asset) {
    io:println("\n=== ASSET DETAILS ===");
    io:println("Tag: " + asset.assetTag);
    io:println("Name: " + asset.name);
    io:println("Faculty: " + asset.faculty);
    io:println("Department: " + asset.department);
    io:println("Date Acquired: " + asset.dateAcquired);
    io:println("Current Status: " + asset.current_status);

    io:println("\nComponents (" + asset.components.length().toString() + "):");
    foreach var component in asset.components {
        io:println("  - " + component.name + " (" + component.id + "): " + component.description);
    }

    io:println("\nSchedules (" + asset.schedules.length().toString() + "):");
    foreach var schedule in asset.schedules {
        io:println("  - " + schedule.id + ": " + schedule.frequency + ", Due: " + schedule.nextDueDate);
    }

    io:println("\nWork Orders (" + asset.workOrders.length().toString() + "):");
    foreach var workOrder in asset.workOrders {
        io:println("  - " + workOrder.title + " (" + workOrder.id + "): " + workOrder.status);
        foreach var task in workOrder.tasks {
            io:println("    * Task: " + task.description + " (" + task.status + ")");
        }
    }
}

 public function addAsset(Asset asset) returns string|error {
    http:Request request = new;
    request.setJsonPayload(<json> asset);
    http:Response response = check assetClient->post("/asset", request);

    if (response.statusCode >= 400) {
        json|error errPayload = response.getJsonPayload();
        string message = errPayload is json ? errPayload.message.toString() : "Unknown error";
        return "Failed to add asset. Status: " + response.statusCode.toString() + ". Message: " + message;
    }

    json payload = check response.getJsonPayload();
    return payload.message.toString();
}

public function getAllAssets() returns Asset[] {
    http:Response response = check assetClient->get("/asset");
    
    if (response.statusCode == 200) {
        json payload = check response.getJsonPayload();
        return check payload.fromJsonWithType(<Asset[]>);
    }
    
    return [];
}

public function getAsset(string assetTag) returns Asset? {
    string path = "/asset/" + assetTag;
    http:Response response = check assetClient->get(path);

    if (response.statusCode == 404) {
        return ();
    }
    if (response.statusCode == 200) {
        json payload = check response.getJsonPayload();
        return check payload.fromJsonWithType(Asset);
    }
    
    return ();
}

public function getAssetsByFaculty(string faculty) returns Asset[] {
    string path = "/asset/faculty/" + faculty;
    http:Response response = check assetClient->get(path);

    if (response.statusCode == 200) {
        json payload = check response.getJsonPayload();
        return check payload.fromJsonWithType(<Asset[]>);
    }
    
    return [];
}

public function getDueItems() returns Asset[] {
    http:Response response = check assetClient->get("/asset/dueItems");

    if (response.statusCode == 200) {
        json payload = check response.getJsonPayload();
        return check payload.fromJsonWithType(<Asset[]>);
    }
    
    return [];
}

public function updateAsset(Asset asset) returns string|error {
    string path = "/asset/" + asset.assetTag;
    http:Request request = new;
    request.setJsonPayload(<json> asset);
    http:Response response = check assetClient->put(path, request);

    if (response.statusCode >= 400) {
        json|error errPayload = response.getJsonPayload();
        string message = errPayload is json ? errPayload.message.toString() : "Unknown error";
        return "Failed to update asset. Status: " + response.statusCode.toString() + ". Message: " + message;
    }

    json payload = check response.getJsonPayload();
    return payload.message.toString();
}

public function deleteAsset(string assetTag) returns boolean {
    string path = "/asset/" + assetTag;
    http:Response response = check assetClient->delete(path);
    return response.statusCode == 204;
}