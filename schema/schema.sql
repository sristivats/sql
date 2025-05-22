-- Drop tables if they already exist (in reverse dependency order)
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Staff;

-- Inventory table
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    date DATE NOT NULL,
    store_id INT,
    product_id INT,
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast INT,
    discount FLOAT,
    competitor_pricing FLOAT,
    holiday_promotion BOOLEAN,
    weather_condition VARCHAR(100),
);

-- Stores table
CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    region VARCHAR(100),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

-- Staff table
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    store_id INT,
    FOREIGN KEY (store_id) REFERENCES Staff(store_id)
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    category VARCHAR(100),
    price FLOAT,
    seasonality VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
