import carrental; // Generated module from proto

// Create a subtype with readonly `plate`
public type Car readonly & carrental:Car;

// Table of cars using plate as key
table<Car> key(plate) cars = table [];
