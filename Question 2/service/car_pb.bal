import ballerina/grpc;
import ballerina/protobuf;

public const string CAR_DESC = "0A096361722E70726F746F120963617272656E74616C22AC010A0343617212120A046D616B6518012001280952046D616B6512140A056D6F64656C18022001280952056D6F64656C12120A0479656172180320012805520479656172121F0A0B6461696C795F7072696365180420012801520A6461696C79507269636512180A076D696C6561676518052001280552076D696C6561676512140A05706C6174651806200128095205706C61746512160A067374617475731807200128095206737461747573224C0A0455736572121A0A08757365726E616D651801200128095208757365726E616D6512120A04726F6C651802200128095204726F6C6512140A05656D61696C1803200128095205656D61696C223B0A1243726561746555736572735265717565737412250A05757365727318012003280B320F2E63617272656E74616C2E557365725205757365727322610A105570646174654361725265717565737412140A05706C6174651801200128095205706C617465121F0A0B6461696C795F7072696365180220012801520A6461696C79507269636512160A06737461747573180320012809520673746174757322280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522290A0F4C697374436172735265717565737412160A0666696C746572180120012809520666696C74657222280A105365617263684361725265717565737412140A05706C6174651801200128095205706C61746522580A10416464546F4361727452657175657374121A0A08757365726E616D651801200128095208757365726E616D6512140A05706C6174651802200128095205706C61746512120A046461797318032001280552046461797322350A17506C6163655265736572766174696F6E52657175657374121A0A08757365726E616D651801200128095208757365726E616D6522630A0B436172526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512200A0363617218032001280B320E2E63617272656E74616C2E436172520363617222420A0C43617274526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765226A0A135265736572766174696F6E526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765121F0A0B746F74616C5F7072696365180320012801520A746F74616C507269636522490A134372656174655573657273526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676532B0040A1043617252656E74616C5365727669636512300A06416464436172120E2E63617272656E74616C2E4361721A162E63617272656E74616C2E436172526573706F6E736512400A09557064617465436172121B2E63617272656E74616C2E557064617465436172526571756573741A162E63617272656E74616C2E436172526573706F6E7365123A0A0952656D6F7665436172121B2E63617272656E74616C2E52656D6F7665436172526571756573741A0E2E63617272656E74616C2E4361723001124C0A0B4372656174655573657273121D2E63617272656E74616C2E4372656174655573657273526571756573741A1E2E63617272656E74616C2E4372656174655573657273526573706F6E736512410A114C697374417661696C61626C6543617273121A2E63617272656E74616C2E4C69737443617273526571756573741A0E2E63617272656E74616C2E436172300112400A09536561726368436172121B2E63617272656E74616C2E536561726368436172526571756573741A162E63617272656E74616C2E436172526573706F6E736512410A09416464546F43617274121B2E63617272656E74616C2E416464546F43617274526571756573741A172E63617272656E74616C2E43617274526573706F6E736512560A10506C6163655265736572766174696F6E12222E63617272656E74616C2E506C6163655265736572766174696F6E526571756573741A1E2E63617272656E74616C2E5265736572766174696F6E526573706F6E7365620670726F746F33";

public isolated client class CarRentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CAR_DESC);
    }

    isolated remote function AddCar(Car|ContextCar req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function AddCarContext(Car|ContextCar req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function UpdateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers(CreateUsersRequest|ContextCreateUsersRequest req) returns CreateUsersResponse|grpc:Error {
        map<string|string[]> headers = {};
        CreateUsersRequest message;
        if req is ContextCreateUsersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/CreateUsers", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CreateUsersResponse>result;
    }

    isolated remote function CreateUsersContext(CreateUsersRequest|ContextCreateUsersRequest req) returns ContextCreateUsersResponse|grpc:Error {
        map<string|string[]> headers = {};
        CreateUsersRequest message;
        if req is ContextCreateUsersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/CreateUsers", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CreateUsersResponse>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchCarRequest|ContextSearchCarRequest req) returns CarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarResponse>result;
    }

    isolated remote function SearchCarContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns CartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ReservationResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.CarRentalService/RemoveCar", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.CarRentalService/RemoveCar", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function ListAvailableCars(ListCarsRequest|ContextListCarsRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListCarsRequest message;
        if req is ContextListCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.CarRentalService/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailableCarsContext(ListCarsRequest|ContextListCarsRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        ListCarsRequest message;
        if req is ContextListCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.CarRentalService/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public class CarStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Car value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Car value;|} nextRecord = {value: <Car>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class CarRentalServiceReservationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendReservationResponse(ReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextReservationResponse(ContextReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCarResponse(CarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCarResponse(ContextCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCarCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCar(Car response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCar(ContextCar response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCartResponse(CartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCartResponse(ContextCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextCarStream record {|
    stream<Car, error?> content;
    map<string|string[]> headers;
|};

public type ContextReservationResponse record {|
    ReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextCarResponse record {|
    CarResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersRequest record {|
    CreateUsersRequest content;
    map<string|string[]> headers;
|};

public type ContextListCarsRequest record {|
    ListCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextCartResponse record {|
    CartResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CAR_DESC}
public type ReservationResponse record {|
    boolean success = false;
    string message = "";
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: CAR_DESC}
public type User record {|
    string username = "";
    string role = "";
    string email = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type UpdateCarRequest record {|
    string plate = "";
    float daily_price = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type CarResponse record {|
    boolean success = false;
    string message = "";
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_DESC}
public type AddToCartRequest record {|
    string username = "";
    string plate = "";
    int days = 0;
|};

@protobuf:Descriptor {value: CAR_DESC}
public type CreateUsersRequest record {|
    User[] users = [];
|};

@protobuf:Descriptor {value: CAR_DESC}
public type SearchCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type CartResponse record {|
    boolean success = false;
    string message = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type Car record {|
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    int mileage = 0;
    string plate = "";
    string status = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type PlaceReservationRequest record {|
    string username = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type CreateUsersResponse record {|
    boolean success = false;
    string message = "";
|};

@protobuf:Descriptor {value: CAR_DESC}
public type ListCarsRequest record {|
    string filter = "";
|};
