DROP DATABASE IF EXISTS smart_traffic_management;
CREATE DATABASE IF NOT EXISTS smart_traffic_management;
USE smart_traffic_management;

CREATE TABLE user (id CHAR(10) NOT NULL,
				   name VARCHAR(30) NOT NULL,
                   age INT NOT NULL,
				   gender ENUM('MALE', 'FEMALE') NOT NULL,
                   mobile_number CHAR(10) NOT NULL UNIQUE,
				   PRIMARY KEY (id));
                   
CREATE TABLE vehicle (licence_plate CHAR(10) NOT NULL UNIQUE,
				      type ENUM('CAR', 'MOTORCYCLE', 'TRUCK') NOT NULL,
                      user_id CHAR(10) NOT NULL,
					  route_id CHAR(10),
                      current_area_id CHAR(10),
                      starting_area_id CHAR(10),
                      destination_area_id CHAR(10),
                      PRIMARY KEY (licence_plate, user_id),
                      FOREIGN KEY (user_id) REFERENCES user(id));
                  
INSERT INTO user VALUES('U-00000001', 'MAKIS', 33, 'MALE', '6980381852');
INSERT INTO user VALUES('U-00000002', 'NTINA', 23, 'FEMALE', '6980383817');
INSERT INTO user VALUES('U-00000003', 'ANNA', 41, 'FEMALE', '6984313157');

-- SELECT * 
-- FROM user
-- WHERE gender = 'FEMALE';                  

INSERT INTO vehicle VALUES('V-00000001', 'CAR', 'U-00000001', NULL, NULL, NULL, NULL);
INSERT INTO vehicle VALUES('V-00000002', 'CAR', 'U-00000002', NULL, NULL, NULL, NULL);
INSERT INTO vehicle VALUES('V-00000003', 'MOTORCYCLE', 'U-00000001', NULL, NULL, NULL, NULL);

SELECT licence_plate, type 
FROM vehicle
WHERE user_id = 'U-00000001';
