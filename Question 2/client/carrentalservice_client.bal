import ballerina/io;

CarRentalServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Car addCarRequest = {make: "ballerina", model: "ballerina", year: 1, daily_price: 1, mileage: 1, plate: "ballerina", status: "ballerina"};
    CarResponse addCarResponse = check ep->AddCar(addCarRequest);
    io:println(addCarResponse);

    UpdateCarRequest updateCarRequest = {plate: "ballerina", daily_price: 1, status: "ballerina"};
    CarResponse updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println(updateCarResponse);

    CreateUsersRequest createUsersRequest = {users: [{username: "ballerina", role: "ballerina", email: "ballerina"}]};
    CreateUsersResponse createUsersResponse = check ep->CreateUsers(createUsersRequest);
    io:println(createUsersResponse);

    SearchCarRequest searchCarRequest = {plate: "ballerina"};
    CarResponse searchCarResponse = check ep->SearchCar(searchCarRequest);
    io:println(searchCarResponse);

    AddToCartRequest addToCartRequest = {username: "ballerina", plate: "ballerina", days: 1};
    CartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    PlaceReservationRequest placeReservationRequest = {username: "ballerina"};
    ReservationResponse placeReservationResponse = check ep->PlaceReservation(placeReservationRequest);
    io:println(placeReservationResponse);

    RemoveCarRequest removeCarRequest = {plate: "ballerina"};
    stream<Car, error?> removeCarResponse = check ep->RemoveCar(removeCarRequest);
    check removeCarResponse.forEach(function(Car value) {
        io:println(value);
    });

    ListCarsRequest listAvailableCarsRequest = {filter: "ballerina"};
    stream<Car, error?> listAvailableCarsResponse = check ep->ListAvailableCars(listAvailableCarsRequest);
    check listAvailableCarsResponse.forEach(function(Car value) {
        io:println(value);
    });
}
