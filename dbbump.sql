DROP DATABASE IF EXISTS smart_traffic_management;
CREATE DATABASE IF NOT EXISTS smart_traffic_management;
USE smart_traffic_management;


-- create tables

CREATE TABLE Driver
	(id CHAR(10) NOT NULL,
	name VARCHAR(30) NOT NULL,
	age INT NOT NULL,
	gender ENUM('MALE', 'FEMALE') NOT NULL,
	mobile_number CHAR(10) NOT NULL UNIQUE,
	PRIMARY KEY (id));

CREATE TABLE Area 	           
	(id CHAR(10),
	name VARCHAR(30) NOT NULL,
	traffic_metric ENUM('VERY_LOW', 'LOW', 'MEDIUM', 'HIGH', 'VERY_HIGH'),
	PRIMARY KEY (id));
    
CREATE TABLE Route 	 		   
	(id CHAR(10),
	duration_in_min INT,
	PRIMARY KEY (id));
    
CREATE TABLE Vehicle 		   
	(licence_plate CHAR(10),
	type ENUM('CAR', 'MOTORCYCLE', 'TRUCK') NOT NULL,
	driver_id CHAR(10) NOT NULL,
	route_id CHAR(10),
	current_area_id CHAR(10),
	starting_area_id CHAR(10),
	destination_area_id CHAR(10),
	PRIMARY KEY (licence_plate, driver_id),
	FOREIGN KEY (driver_id) REFERENCES Driver(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (route_id) REFERENCES Route(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (current_area_id) REFERENCES Area(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (starting_area_id) REFERENCES Area(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (destination_area_id) REFERENCES Area(id) ON DELETE SET NULL ON UPDATE CASCADE);

CREATE TABLE Violation  	   
	(id CHAR(10),
	type ENUM('TRAFFIC_LIGHT', 'SPEED_LIMIT', 'TRAFFIC_SIGN'),
	fee_in_euros FLOAT,
	driver_id CHAR(10) NOT NULL,
	PRIMARY KEY (id, driver_id),
	FOREIGN KEY (driver_id) REFERENCES Driver(id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE Traffic_light 	   
	(id CHAR(10),
	status ENUM('GREEN', 'RED'),
	duration_in_sec INT,
	location CHAR(24) NOT NULL,
	area_id CHAR(10) NOT NULL,
	PRIMARY KEY (id, area_id),
	FOREIGN KEY (area_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE);
                        
CREATE TABLE Parking_slot 	   
	(id CHAR(10) NOT NULL UNIQUE,
	status ENUM('EMPTY', 'NOT_EMPTY'),
	location CHAR(24) NOT NULL,
	area_id CHAR(10) NOT NULL,
	PRIMARY KEY (id, area_id),
	FOREIGN KEY (area_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE);   
                           
CREATE TABLE Tolls 			   
	(id CHAR(10) NOT NULL UNIQUE,
	toll_in_euros FLOAT,
	location CHAR(24) NOT NULL,
	area_id CHAR(10) NOT NULL,
	PRIMARY KEY (id, area_id),
	FOREIGN KEY (area_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE);                           

CREATE TABLE Route_Area        
	(route_id CHAR(10),
	area_id CHAR(10),
	PRIMARY KEY (route_id, area_id),
	FOREIGN KEY (route_id) REFERENCES Route(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (area_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE);                  

CREATE TABLE Neighboring_Areas 
	(area1_id CHAR(10),
	area2_id CHAR(10),
	PRIMARY KEY (area1_id, area2_id),
	FOREIGN KEY (area1_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (area2_id) REFERENCES Area(id) ON DELETE CASCADE ON UPDATE CASCADE);
    
    
-- create triggers
    
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `driver_BEFORE_INSERT` BEFORE INSERT ON `driver` FOR EACH ROW BEGIN
	IF NEW.age < 18 OR NEW.age > 100 THEN
		SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Invalid driver age';
    END IF;
END $$
DELIMITER ;   

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `driver_BEFORE_UPDATE` BEFORE UPDATE ON `driver` FOR EACH ROW BEGIN
	IF NEW.age < 18 OR NEW.age > 100 THEN
		SIGNAL SQLSTATE '15000' SET MESSAGE_TEXT = 'Invalid driver age';
    END IF;
END  $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `violation_BEFORE_INSERT` BEFORE INSERT ON `violation` FOR EACH ROW BEGIN
	IF NEW.fee_in_euros < 0 THEN
		SIGNAL SQLSTATE '20000' SET MESSAGE_TEXT = 'Invalid violation fee';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `violation_BEFORE_UPDATE` BEFORE UPDATE ON `violation` FOR EACH ROW BEGIN
	IF NEW.fee_in_euros < 0 THEN
		SIGNAL SQLSTATE '25000' SET MESSAGE_TEXT = 'Invalid violation fee';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `route_BEFORE_INSERT` BEFORE INSERT ON `route` FOR EACH ROW BEGIN
	IF NEW.duration_in_min < 0 THEN
		SIGNAL SQLSTATE '30000' SET MESSAGE_TEXT = 'Invalid route duration';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `route_BEFORE_UPDATE` BEFORE UPDATE ON `route` FOR EACH ROW BEGIN
	IF NEW.duration_in_min < 0 THEN
		SIGNAL SQLSTATE '35000' SET MESSAGE_TEXT = 'Invalid route duration';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `tolls_BEFORE_INSERT` BEFORE INSERT ON `tolls` FOR EACH ROW BEGIN
	IF NEW.toll_in_euros < 0 THEN
		SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Invalid toll';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `tolls_BEFORE_UPDATE` BEFORE UPDATE ON `tolls` FOR EACH ROW BEGIN
	IF NEW.toll_in_euros < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid toll';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `neighboring_areas_BEFORE_INSERT` BEFORE INSERT ON `neighboring_areas` FOR EACH ROW BEGIN
	IF NEW.area1_id = NEW.area2_id THEN
		SIGNAL SQLSTATE '50000' SET MESSAGE_TEXT = 'Invalid neighboring areas';
    END IF;
END $$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `neighboring_areas_BEFORE_UPDATE` BEFORE UPDATE ON `neighboring_areas` FOR EACH ROW BEGIN
	IF NEW.area1_id = NEW.area2_id THEN
		SIGNAL SQLSTATE '55000' SET MESSAGE_TEXT = 'Invalid neighboring areas';
    END IF;
END $$
DELIMITER ; 


-- create views

CREATE VIEW `Empty Parking Slots` AS
SELECT name AS 'area name', area_id AS 'area id', location AS 'parking location'
FROM (
		( 
			SELECT name, id
			FROM Area
		) AS _Area
		JOIN
		(
			SELECT area_id, location
			FROM Parking_slot
			WHERE status = 'EMPTY'
		) AS _Parking_slot
		ON _Area.id = _Parking_slot.area_id
     )
     ORDER BY _Area.name;
     
CREATE VIEW `Violators` AS
SELECT Driver.id AS 'driver id', Driver.name AS 'name', Driver.age AS 'age', Driver.gender AS 'gender', Driver.mobile_number AS 'mobile number', Violation.type AS 'violation type', Violation.fee_in_euros AS 'fee'
FROM (
		Driver
		JOIN
		Violation
		ON Driver.id = Violation.driver_id
     )
     ORDER BY Driver.id;
     