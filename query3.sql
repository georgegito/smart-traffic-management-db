SELECT Driver.mobile_number
FROM Violation JOIN Driver ON Driver.id = Violation.driver_id 
WHERE Violation.id = 'SA9312IK54'