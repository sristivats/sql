CREATE DATABASE retail_db;
USE retail_db;
-- Drop tables if they already exist (in reverse dependency order)
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Inventory_Staging;


-- Stores table
CREATE TABLE Stores (
    store_id VARCHAR(4) PRIMARY KEY,
    region VARCHAR(100)
);

-- Staff table
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    store_id VARCHAR(4),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

-- Products table
CREATE TABLE Products (
    product_id VARCHAR(5) PRIMARY KEY,
    category VARCHAR(100),
    price FLOAT,
    seasonality VARCHAR(100)
);

-- Inventory table
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    store_id VARCHAR(4),
    product_id VARCHAR(5),
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast FLOAT,
    discount FLOAT,
    competitor_pricing FLOAT,
    holiday_promotion BOOLEAN,
    weather_condition VARCHAR(100),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


CREATE TABLE Inventory_Staging (
    date DATE,
    store_id VARCHAR(4),
    product_id VARCHAR(5),
    category VARCHAR(100),
    region VARCHAR(100),
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast FLOAT,
    price FLOAT,
    discount FLOAT,
    weather_condition VARCHAR(100),
    holiday_promotion BOOLEAN,
    competitor_pricing FLOAT,
    seasonality VARCHAR(100)
);

LOAD DATA LOCAL INFILE './data/inventory_data.csv'
INTO TABLE Inventory_Staging
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, store_id, product_id, category, region, inventory_level, units_sold, units_ordered, demand_forecast, price, discount, weather_condition, holiday_promotion, competitor_pricing, seasonality);
-- Insert distinct stores
INSERT IGNORE INTO Stores (store_id, region)
SELECT DISTINCT store_id, region FROM Inventory_Staging;

-- Insert distinct products
INSERT IGNORE INTO Products (product_id, category, price, seasonality)
SELECT DISTINCT product_id, category, price, seasonality FROM Inventory_Staging;

-- Insert into Inventory
INSERT INTO Inventory (
    date, store_id, product_id, inventory_level, units_sold, units_ordered,
    demand_forecast, discount, competitor_pricing, holiday_promotion, weather_condition
)
SELECT
    date, store_id, product_id, inventory_level, units_sold, units_ordered,
    demand_forecast, discount, competitor_pricing, holiday_promotion, weather_condition
FROM Inventory_Staging;
ALTER TABLE Staff MODIFY staff_id INT AUTO_INCREMENT;
-- Insert random staff records, one per store
INSERT INTO Staff (email, store_id)
SELECT 
  CONCAT('staff', store_id, '@urbanretail.com') AS email,
  store_id
FROM Stores;
