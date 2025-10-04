# DSA-PROJECT

# QUESTION 1

## Asset Management System (REST API)
This project is a RESTful Asset Management System built using Ballerina.
It provides an API for managing assets, components, schedules, and work orders,
along with an interactive CLI client for testing and usage.


## FEATURES

* Add Asset: Register new assets with components, schedules, and work orders

* View All Assets: Fetch and display all assets in the system

* View Asset by Tag: Retrieve a single asset by its assetTag

* Filter by Faculty: View assets belonging to a specific faculty

* Update Asset: Modify an existing asset

* Delete Asset: Remove an asset from the system

* Due Items (Review): List items that are due for review (WORKING PROGRESS)


## PREREQUISITES 
Before running the project, ensure you have:

* Ballerina

* Protocol Buffers Compile

* VS Code


## SETUP AND INSTALLATION

1. Clone the repository:

   git clone https://github.com/Feu29/DSA-PROJECT.git
   NB Choose DSA assignment its Question 1 the REST API

3. Run the service 

   cd ../service
   bal run

4. Run the Client

   cd ../client
   bal run

   * NB Splite the terminal so you run them independently!


## CLIENT MENU
When you run bal run inside the client folder, you get a menu:

=== MAIN MENU ===
1. Add New Asset
2. View All Assets
3. View Asset by Tag
4. View Assets by Faculty
5. View Due Items for Review
6. Update Asset
7. Delete Asset
8. Exit

## CONTRIBUTORS 

* Lenchiwasijey Mudzengerere 224091034@nust.na 

* Siyamba Alfeus alfeusfeu@gmail.com 

* Mukuve Erastus 224079921@nust.na 

* Mutuku Aloys 224052470@nust.com 

* Nathan Duarte bradleyduarte1998@gmail.com 




# QUESTION 2

## Car Rental System (gRPC)

This is a simple Car Rental System implemented using Ballerina and gRPC.
The system allows you to manage cars, users, and reservations through remote procedure calls (RPCs).
It uses in-memory arrays for data storage, making it a lightweight and fast prototype.

## Features

* AddCar – Register a new car into the system.

* GetCars – Retrieve a list of all available cars.

* AddUser – Register a new user into the system.

* GetUsers – View all registered users.

* PlaceReservation – Reserve a car for a user.

* GetReservations – Retrieve all reservations.

## PREREQUISITES 

* Before running the project, ensure you have the following installed:

* Ballerina (latest version)

* Protocol Buffers Compiler (protoc) for generating stubs.

* VS Code (recommended) with the Ballerina Extension Pack.

## SETUP AND INSTALLATION

1. Clone the repository:

   git clone https://github.com/Feu29/DSA-PROJECT.git
   NB Choose question 2 its the GRPC   

3. Run the service  gRPC

   cd ../service
   bal run

4. Run the client to test the service:

   cd ../client
   bal run

   * NB Splite the terminal so you run them independently!
  
## EXAMPLE USAGE IN THE CLINT IF YOU DONT WANT TO USE POSTMAN

AddCar({

    make: "ballerina",
    model: "ballerina",
    year: 1,
    daily_price: 1,
    mileage: 1,
    plate: "ballerina",
    status: "ballerina"
});


UpdateCar({

    plate: "ballerina",
    daily_price: 1,
    status: "ballerina"
});

SearchCar({

    plate: "ballerina"
});

AddToCart({

    username: "ballerina",
    plate: "ballerina",
    days: 1
});

PlaceReservation({

    username: "ballerina"
});

ListAvailableCars({

    filter: "ballerina"
});

CreateUsers({

    users: [
        {
            username: "ballerina",
            role: "ballerina",
            email: "ballerina"
        }
    ]
});


## Testing

Run the client multiple times to test adding cars, users, and reservations.

You can modify the data inside car_rental_client.bal to test different scenarios.

NB If you dont know how to use postman!

## Modifying Test Data

You can edit the values (like make, model, username, days) inside car_rental_client.bal to test different scenarios.
For example, change status to "AVAILABLE" or "UNAVAILABLE"to see how the system behaves.

