CREATE DATABASE IF NOT EXISTS city_transit_hub
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE city_transit_hub;

DROP TABLE IF EXISTS TRIP;
DROP TABLE IF EXISTS MAINTENANCE;
DROP TABLE IF EXISTS DRIVER;
DROP TABLE IF EXISTS MECHANIC;
DROP TABLE IF EXISTS DISPATCHER;
DROP TABLE IF EXISTS FLEET_MANAGER;
DROP TABLE IF EXISTS DBA;
DROP TABLE IF EXISTS ROUTE;
DROP TABLE IF EXISTS VEHICLE;
DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE ROUTE (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    start_location VARCHAR(150) NOT NULL,
    end_location VARCHAR(150) NOT NULL,
    distance DECIMAL(7,2) NOT NULL,
    CONSTRAINT chk_route_distance CHECK (distance > 0)
) ENGINE=InnoDB;

CREATE TABLE VEHICLE (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    serial_number VARCHAR(50) NOT NULL UNIQUE,
    vehicle_type VARCHAR(30) NOT NULL,
    mileage DECIMAL(11,1) NOT NULL,
    service_status VARCHAR(25) NOT NULL DEFAULT 'Available',
    model_year SMALLINT UNSIGNED NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    CONSTRAINT chk_vehicle_type CHECK (vehicle_type IN ('Bus', 'Light Rail')),
    CONSTRAINT chk_vehicle_mileage CHECK (mileage >= 0),
    CONSTRAINT chk_vehicle_model_year CHECK (model_year BETWEEN 1980 AND 2100),
    CONSTRAINT chk_vehicle_status CHECK (
        service_status IN ('Available', 'Assigned',
                           'Under Maintenance', 'Out of Service')
    )
) ENGINE=InnoDB;

CREATE TABLE EMPLOYEE (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    role VARCHAR(20) NOT NULL,
    CONSTRAINT chk_employee_role CHECK (
        role IN ('Driver', 'Mechanic', 'Dispatcher', 'Manager', 'Administrator')
    )
) ENGINE=InnoDB;

CREATE TABLE DRIVER (
    employee_id INT PRIMARY KEY,
    license_number VARCHAR(40) NOT NULL UNIQUE,
    license_expiration DATE NOT NULL,
    CONSTRAINT fk_driver_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE MECHANIC (
    employee_id INT PRIMARY KEY,
    specialization VARCHAR(100) NULL,
    CONSTRAINT fk_mechanic_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE DISPATCHER (
    employee_id INT PRIMARY KEY,
    CONSTRAINT fk_dispatcher_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE FLEET_MANAGER (
    employee_id INT PRIMARY KEY,
    CONSTRAINT fk_manager_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE DBA (
    employee_id INT PRIMARY KEY,
    CONSTRAINT fk_dba_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEE(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE TRIP (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_date DATE NOT NULL,
    trip_status VARCHAR(15) NOT NULL DEFAULT 'Scheduled',
    scheduled_departure TIME NOT NULL,
    scheduled_arrival TIME NOT NULL,
    route_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT NOT NULL,
    CONSTRAINT chk_trip_status CHECK (
        trip_status IN ('Scheduled', 'Delayed', 'Completed', 'Canceled')
    ),
    CONSTRAINT chk_trip_times CHECK (scheduled_arrival > scheduled_departure),
    CONSTRAINT fk_trip_route FOREIGN KEY (route_id)
        REFERENCES ROUTE(route_id) ON DELETE RESTRICT,
    CONSTRAINT fk_trip_vehicle FOREIGN KEY (vehicle_id)
        REFERENCES VEHICLE(vehicle_id) ON DELETE RESTRICT,
    CONSTRAINT fk_trip_driver FOREIGN KEY (driver_id)
        REFERENCES DRIVER(employee_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE MAINTENANCE (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    service_date DATE NULL DEFAULT NULL,
    status VARCHAR(15) NOT NULL DEFAULT 'Open',
    maintenance_type VARCHAR(80) NOT NULL,
    problem_description TEXT NOT NULL,
    priority VARCHAR(10) NOT NULL DEFAULT 'Medium',
    repair_cost DECIMAL(10,2) NULL DEFAULT NULL,
    completion_date DATE NULL DEFAULT NULL,
    vehicle_id INT NOT NULL,
    mechanic_id INT NULL DEFAULT NULL,
    CONSTRAINT chk_maintenance_status CHECK (
        status IN ('Open', 'In Progress', 'Completed')
    ),
    CONSTRAINT chk_maintenance_type CHECK (
        maintenance_type IN ('Inspection', 'Service', 'Repair')
    ),
    CONSTRAINT chk_maintenance_priority CHECK (
        priority IN ('Low', 'Medium', 'High', 'Critical')
    ),
    CONSTRAINT chk_maintenance_cost CHECK (
        repair_cost IS NULL OR repair_cost >= 0
    ),
    CONSTRAINT chk_maintenance_completion CHECK (
        status <> 'Completed' OR completion_date IS NOT NULL
    ),
    CONSTRAINT fk_maintenance_vehicle FOREIGN KEY (vehicle_id)
        REFERENCES VEHICLE(vehicle_id) ON DELETE RESTRICT,
    CONSTRAINT fk_maintenance_mechanic FOREIGN KEY (mechanic_id)
        REFERENCES MECHANIC(employee_id) ON DELETE SET NULL
) ENGINE=InnoDB;
