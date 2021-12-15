-- Vehicles that are currently located in Area with id = THKE835612, but are not motorcycles

SELECT type AS 'Vehicle type', route_id AS 'Vehicle route'
FROM Vehicle
WHERE current_area_id = 'THKE835612' AND type != 'MOTORCYCLE'