import ballerina/grpc;
import ballerina/io;

type Car record {
    string plate;
    string make;
    string model;
    int year;
    float daily_price;
    int mileage;
    string status; // AVAILABLE or UNAVAILABLE
};

type User record {
    string id;
    string name;
    string role; // ADMIN or CUSTOMER
};

type CartItem record {
    string userId;
    string plate;
    string startDate;
    string endDate;
};

type CarResponse record {
    string message;
    Car? car;
};

type UserResponse record {
    string message;
};

type UpdateCarRequest record {
    string plate;
    float daily_price;
    string status;
};

type CarPlate record {
    string plate;
};

type CarList record {
    Car[] cars;
};

type CarFilter record {
    string query;
};

type CartRequest record {
    string user_id;
    string plate;
    string start_date;
    string end_date;
};

type CartResponse record {
    string message;
};

type UserId record {
    string id;
};

type ReservationResponse record {
    string message;
    float total_price;
};

map<Car> cars = {};
map<User> users = {};
map<CartItem[]> carts = {};
map<float> reservations = {}; // userId -> total price

@grpc:ServiceDescriptor {
    descriptor: "car.proto"
}
service "CarRental" on new grpc:Listener(9090) {

    remote function add_car(Car car) returns CarResponse {
        cars[car.plate] = car;
        return {message: "Car added successfully", car};
    }

    remote function create_users(stream<User, error?> clientStream) returns UserResponse|error {
        error? result = clientStream.forEach(function(User u) {
            users[u.id] = u;
            io:println("Added user: ", u.name);
        });
        if result is error {
            return result;
        }
        return {message: "Users added successfully"};
    }

    remote function update_car(UpdateCarRequest req) returns CarResponse {
        if !cars.hasKey(req.plate) {
            return {message: "Car not found", car: ()};
        }
        Car? oldCarNullable = cars[req.plate];
        Car oldCar = <Car>oldCarNullable;
        Car updatedCar = {
            plate: oldCar.plate,
            make: oldCar.make,
            model: oldCar.model,
            year: oldCar.year,
            daily_price: req.daily_price,
            mileage: oldCar.mileage,
            status: req.status
        };
        cars[req.plate] = updatedCar;
        return {message: "Car updated", car: updatedCar};
    }

    remote function remove_car(CarPlate plate) returns CarList {
        _ = cars.remove(plate.plate);
        Car[] carList = [];
        foreach var car in cars {
            carList.push(car);
        }
        return {cars: carList};
    }

    remote function list_available_cars(CarFilter filter) returns stream<Car, error?> {
        Car[] availableCars = [];
        foreach var c in cars {
            if c.status == "AVAILABLE" && (filter.query == "" || c.make == filter.query || c.model == filter.query) {
                availableCars.push(c);
            }
        }
        return availableCars.toStream();
    }

    remote function search_car(CarPlate plate) returns CarResponse {
        if cars.hasKey(plate.plate) {
            return {message: "Car found", car: cars[plate.plate]};
        }
        return {message: "Car not available", car: ()};
    }

    remote function add_to_cart(CartRequest req) returns CartResponse {
        if !cars.hasKey(req.plate) {
            return {message: "Car not found"};
        }
        CartItem item = {userId: req.user_id, plate: req.plate, startDate: req.start_date, endDate: req.end_date};
        if !carts.hasKey(req.user_id) {
            carts[req.user_id] = [];
        }
        CartItem[]? currentCart = carts[req.user_id];
        if currentCart is CartItem[] {
            currentCart.push(item);
        }
        return {message: "Car added to cart"};
    }

    remote function place_reservation(UserId u) returns ReservationResponse {
        float total = 0;
        if carts.hasKey(u.id) {
            CartItem[]? userCart = carts[u.id];
            if userCart is CartItem[] {
                foreach var item in userCart {
                    if cars.hasKey(item.plate) {
                        Car? carNullable = cars[item.plate];
                        if carNullable is Car {
                            total += carNullable.daily_price * 3; // assume 3 days for now
                        }
                    }
                }
                reservations[u.id] = total;
                carts[u.id] = []; // clear cart
                return {message: "Reservation confirmed", total_price: total};
            }
        }
        return {message: "No items in cart", total_price: 0.0};
    }
}
