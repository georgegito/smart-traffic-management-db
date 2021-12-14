SELECT parking_slot.location
FROM area JOIN parking_slot ON area.id = parking_slot.area_id
WHERE status = 'EMPTY' AND area.name = 'Faliro'