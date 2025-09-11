import ballerina/grpc;
import ballerina/io;
import car_rental_pb;

car_rental_pb:CarRentalClient carRental = check new car_rental_pb:CarRentalClient("localhost:9090");

public function main() returns error? {
    car_rental_pb:User admin = {id: "admin1", name: "Alice", role: "admin"};
    car_rental_pb:User customer = {id: "u1", name: "Bob", role: "customer"};
CarRentalClient carRental = check new CarRentalClient("localhost:9090");

public function main() returns error? {
    // Create users (admin and customer)
    User admin = {id: "admin1", name: "Alice", role: "admin"};
    User customer = {id: "u1", name: "Bob", role: "customer"};
    stream<User, CreateUsersResponse> userStream = new ([admin, customer]);
    CreateUsersResponse userRes = check carRental->CreateUsers(userStream);
    io:println("Users created: ", userRes);

    // Admin adds a car
    Car car = {make: "Toyota", model: "Corolla", year: 2020, daily_price: 50.0, mileage: 10000, plate: "ABC123", status: "AVAILABLE"};
    CarId id = check carRental->AddCar(car);
    io:println("Added car: ", id);

    // Admin updates car
    UpdateCarRequest updateReq = {plate: "ABC123", daily_price: 55.0, status: "AVAILABLE"};
    Car updatedCar = check carRental->UpdateCar(updateReq);
    io:println("Updated car: ", updatedCar);

    // Customer lists available cars
    stream<Car, error> cars = carRental->ListAvailableCars({text: "Toyota", year: 2020});
    io:println("Available cars:");
    check from Car c in cars.next() do {
        io:println(c);
    };

    // Customer searches for a car
    CarStatus carStatus = check carRental->SearchCar({plate: "ABC123"});
    io:println("Search result: ", carStatus);

    // Customer adds to cart and places reservation
    CartItem item = {user_id: "u1", plate: "ABC123", start_date: "2025-09-12", end_date: "2025-09-13"};
    CartResponse cartRes = check carRental->AddToCart(item);
    io:println("Added to cart: ", cartRes);

    ReservationResponse res = check carRental->PlaceReservation({id: "u1"});
    io:println("Reservation: ", res);
}
