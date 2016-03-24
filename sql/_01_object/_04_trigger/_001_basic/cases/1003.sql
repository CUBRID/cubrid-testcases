--[er]Create trigger to reject data that is inserted into class that don't exist


CREATE TRIGGER DCL1	
BEFORE INSERT ON DCL1	
EXECUTE REJECT;	


DROP TRIGGER DCL1;
