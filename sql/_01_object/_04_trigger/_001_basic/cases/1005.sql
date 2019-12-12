--Create trigger to invalidate transaction using many trigger condition when insert data into specifical class

CREATE CLASS DCL1(id INTEGER);	
CREATE TRIGGER DCL1	
BEFORE INSERT ON DCL1	
IF id <> 2 and id = 2	
EXECUTE INVALIDATE TRANSACTION;;	

DROP TRIGGER DCL1;
DROP CLASS DCL1;	
