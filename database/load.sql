USE city_transit_hub;
SET NAMES utf8mb4;

LOAD DATA LOCAL INFILE 'data/route.csv'
INTO TABLE ROUTE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(route_id, route_name, start_location, end_location, distance);

LOAD DATA LOCAL INFILE 'data/vehicle.csv'
INTO TABLE VEHICLE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(vehicle_id, serial_number, vehicle_type, mileage, service_status, model_year, manufacturer, model);

LOAD DATA LOCAL INFILE 'data/employee.csv'
INTO TABLE EMPLOYEE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, first_name, last_name, role);

LOAD DATA LOCAL INFILE 'data/driver.csv'
INTO TABLE DRIVER
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, license_number, license_expiration);

LOAD DATA LOCAL INFILE 'data/mechanic.csv'
INTO TABLE MECHANIC
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id, specialization);

LOAD DATA LOCAL INFILE 'data/dispatcher.csv'
INTO TABLE DISPATCHER
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id);

LOAD DATA LOCAL INFILE 'data/fleet_manager.csv'
INTO TABLE FLEET_MANAGER
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id);

LOAD DATA LOCAL INFILE 'data/dba.csv'
INTO TABLE DBA
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(employee_id);

LOAD DATA LOCAL INFILE 'data/trip.csv'
INTO TABLE TRIP
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, trip_date, trip_status, scheduled_departure, scheduled_arrival, route_id, vehicle_id, driver_id);

LOAD DATA LOCAL INFILE 'data/maintenance.csv'
INTO TABLE MAINTENANCE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(maintenance_id, @service_date, status, maintenance_type,
 problem_description, priority, @repair_cost, @completion_date,
 vehicle_id, @mechanic_id)
SET service_date = NULLIF(@service_date, ''),
    repair_cost = NULLIF(@repair_cost, ''),
    completion_date = NULLIF(@completion_date, ''),
    mechanic_id = NULLIF(@mechanic_id, '');
