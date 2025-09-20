import ballerina/grpc;

listener grpc:Listener ep = new(9090);

// --- Global storage ---
Car[] cars = [];
User[] users = [];
CartItem[] cart = [];
Car[] updatedCars = [];

type CartItem record {
    string username;
    string plate;
    int days;
};

@grpc:Descriptor {value: CAR_DESC}
service "CarRentalService" on ep {

    // --- Add a car ---
     remote function AddCar(Car value) returns CarResponse|error {
    // Validation: required fields
    if value.make.trim().length() == 0 ||
       value.model.trim().length() == 0 ||
       value.plate.trim().length() == 0 {
        return { success: false, message: "Make, model, and plate cannot be empty", car: {} };
    }


    // Check for duplicate plate
    foreach var c in cars {
        if c.plate == value.plate {
            return { success: false, message: "Car with this plate already exists", car: {} };
        }
    }

    // Passed all validations, add car
    cars.push(value);
    return { success: true, message: "Car added successfully", car: value };
}


    // --- Update a car ---
    remote function UpdateCar(UpdateCarRequest value) returns CarResponse|error {
        foreach int i in 0 ..< cars.length() {
            if cars[i].plate == value.plate {
                cars[i].daily_price = value.daily_price;
                cars[i].status = value.status;
                return { success: true, message: "Car updated", car: cars[i] };
            }
        }
        return { success: false, message: "Car not found", car: {} };
    }

    // --- Remove a car ---
    remote function RemoveCar(RemoveCarRequest value) returns CarResponse|error {
        boolean found = false;
        int index = -1;

        // Find the car index by plate
        foreach var i in 0 ..< cars.length() {
            if cars[i].plate == value.plate {
                index = i;
                found = true;
                break;
            }
        }

        if !found {
            return { success: false, message: "Car not found", car: {} };
        }

        // Remove the car from the global array
        _ = cars.remove(index);

        return { success: true, message: "Car removed successfully", car: {} };
    }



    // --- Create multiple users from client stream ---
     remote function CreateUsers(CreateUsersRequest req) returns CreateUsersResponse|error {
        foreach var u in req.users {
            if u.username.trim().length() > 0 && u.role.trim().length() > 0 {
                users.push(u);
            }
        }
        return { success: true, message: "Users created" };
    }

    // --- List available cars ---
    remote function ListAvailableCars(ListCarsRequest value) returns stream<Car, error?>|error {
        // Stream only available cars
        stream<Car, error?> carStream = stream from var c in cars
                                        where c.status == "AVAILABLE"
                                        select c;
        return carStream;
    }

    // --- Search car by plate ---
    remote function SearchCar(SearchCarRequest value) returns CarResponse|error {
        foreach var c in cars {
            if c.plate == value.plate {
                return { success: true, message: "Car found", car: c };
            }
        }
        return { success: false, message: "Car not found", car: {} };
    }

    // --- Add to cart ---
    // Add to cart
remote function AddToCart(AddToCartRequest value) returns CartResponse|error {
    // Check if the car exists
    Car? car = cars.filter(c => c.plate == value.plate)[0];
    if car is Car {
        if value.days <= 0 {
            return { success: false, message: "Days must be greater than 0" };
        }

        // Add to cart
        cart.push({ username: value.username, plate: value.plate, days: value.days });
        return { success: true, message: "Car added to cart" };
    }
    return { success: false, message: "Car not found" };
}

// Place reservation
remote function PlaceReservation(PlaceReservationRequest value) returns ReservationResponse|error {
    float total = 0.0;
    boolean found = false;

    foreach var item in cart {
        if item.username == value.username {
            found = true;

            // Find the car
            foreach var c in cars {
                if c.plate == item.plate {
                    total += c.daily_price * item.days;
                }
            }
        }
    }

    if !found {
        return { success: false, message: "No items in cart for this user", total_price: 0.0 };
    }

    return { success: true, message: "Reservation placed", total_price: total };
}
}
