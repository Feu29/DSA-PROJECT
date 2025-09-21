# DSA-PROJECT

## QUESTION 1

Asset Management System (REST API)
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

2. Run the service 

   cd ../service
   bal run

3. Run the Client

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

* 224091034 Lenchiwasijey Mudzengerere 224091034@nust.na 0816753051

* 224065092 Siyamba Alfeus alfeusfeu@gmail.com 0812244302

* 224079921 Mukuve Erastus 224079921@nust.na 0813104059

* 224052470 Mutuku Aloys mutukualoys@gmail.com 0817571307

* 217090427 Nathan Duarte bradleyduarte1998@gmail.com 0813409693
