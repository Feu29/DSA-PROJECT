import ballerina/grpc;

// Start gRPC server
listener grpc:Listener ep = new (9090);

// Global in-memory array to store cars
Car[] cars = [];

// Users array
User[] users = [];

//shopping caarts - plate to user mapping
map<json> carts = [];

@grpc:Descriptor {value: CAR_DESC}
service "CarRentalService" on ep {

    remote function AddCar(Car value) returns CarResponse|error {
        cars.push(value); // Add to array
        return {success: true, message: "Car added successfully", car: value};
    }

    remote function UpdateCar(UpdateCarRequest value) returns CarResponse|error {
        foreach var i in 0 ..< cars.length() {
            if cars[i].plate == value.plate {
                cars[i].daily_price = value.daily_price;
                cars[i].status = value.status;
                return {success: true, message: "Car updated successfully"};
            }
        }
        return {success: false, message: "Car not found"};
    }

    remote function RemoveCar(RemoveCarRequest value) returns stream<Car, error?>|error {
        // Remove car by plate
        Car[] updatedCars = [];
        boolean found = false;
        foreach var car in cars {
            if car.plate != value.plate {
                updatedCars.push(car);
            } else {
                found = true;
            }
        }

        if !found {
            return error("Car not found");
        }

        // Update the global array
        cars = updatedCars;

        // Stream updated cars
        stream<Car, error?> carStream = stream from var c in cars select c;
        return carStream;
    }

    remote function ListAvailableCars(ListCarsRequest value) returns stream<Car, error?>|error {
        // Stream only available cars
        stream<Car, error?> carStream = stream from var c in cars
                                        where c.status == "AVAILABLE"
                                        select c;
        return carStream;
    }

    remote function SearchCar(SearchCarRequest value) returns CarResponse|error {
        foreach var car in cars {
            if car.plate == value.plate {
                return {success: true, message: "Car found", car: car};
            }
        }
        return {success: false, message: "Car not found"};
    }

    remote function AddToCart(AddToCartRequest value) returns CartResponse|error {
       boolean carExists = false;
       foreach var car in cars{
        if car.plate == value.plate&& car.status =="AVAILABLE"{
            carExists = true;
            break;
        }

       }
       if !carExists{
        return {success: false, message: "car not avaible or not found"};
       }
       json cartsItem = {
        plate:value.plate,
        users:value.username,
        days:value.end_date
       };
       carts.push(cartsItem);
       
        return {success: true, message: "Car added to cart"};
    }

    remote function PlaceReservation(PlaceReservationRequest value) returns ReservationResponse|error {
       
       
       
       decimal totalPrice = 0.0;
       boolean carFound = false;

       foreach var car in cars {
        if car.plate == value.plate{
            carFound = true;
            totalPrice = car.daily_price* value.days;


            
            car.status ="RESERVED";
            break;
        }
        
       }
       if !carFound{
         return {success: false, message: "Car not found", total_price: 0.0};
        }
       

        return {success: true, message: "Reservatioan confirmed", total_price: 0.0};
    }


    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error {
       
       error? e = clientStream.forEach(function (User user) {
           users.push(user);
       });
       
       
       if e is error{
        return error("Error processing user stream: " + e.message());
       }
       
        return {success: true, message: "Users created successfully"};
    }

    remote function ListUsers(ListUsersRequest value) returns ListUsersResponse|error {
        if value.role != "" {
            User[] filtered = from var u in users
                              where u.role == value.role
                              select u;
            return {users: filtered};
        }
        return {users: users};
    }
}
