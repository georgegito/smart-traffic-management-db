DROP DATABASE IF EXISTS smart_traffic_management;
CREATE DATABASE IF NOT EXISTS smart_traffic_management;
USE smart_traffic_management;

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

INSERT INTO Area VALUES('A-00000001', 'FALIRO', NULL);
INSERT INTO Area VALUES('A-00000002', 'TOUMPA', NULL);
                  
INSERT INTO Driver VALUES('U-00000001', 'MAKIS', 33, 'MALE', '6980381852');
INSERT INTO Driver VALUES('U-00000002', 'NTINA', 23, 'FEMALE', '6980383817');
INSERT INTO Driver VALUES('U-00000003', 'ANNA', 41, 'FEMALE', '6984313157');

INSERT INTO Vehicle VALUES('V-00000001', 'CAR', 'U-00000001', NULL, 'A-00000001', NULL, NULL);
INSERT INTO Vehicle VALUES('V-00000002', 'CAR', 'U-00000002', NULL, NULL, 'A-00000001', NULL);
INSERT INTO Vehicle VALUES('V-00000003', 'MOTORCYCLE', 'U-00000001', NULL, NULL, NULL, 'A-00000001');

INSERT INTO Route VALUES('R-00000001', 15);

INSERT INTO Route_Area VALUES('R-00000001', 'A-00000001');

INSERT INTO Neighboring_Areas VALUES('A-00000001', 'A-00000002');

-- DELETE FROM Area WHERE name='TOUMPA';

-- DELETE FROM Neighboring_Areas WHERE area1_id='A-00000001';

--  UPDATE Driver SET id='U-00000005' WHERE name='MAKIS';
--  DELETE FROM Driver WHERE name='MAKIS';

-- UPDATE Area SET id='A-00000004' WHERE name='FALIRO';
-- DELETE FROM Area WHERE name='FALIRO';

-- -- SELECT * 
-- -- FROM user
-- -- WHERE gender = 'FEMALE';  
                
-- SELECT licence_plate, type 
-- FROM Vehicle
-- WHERE user_id = 'U-00000001';