--Create trigger to invalidate transaction when insert data into specifical class


CREATE CLASS DCL1;	
CREATE TRIGGER DCL1	
DEFERRED INSERT ON DCL1	
EXECUTE INVALIDATE TRANSACTION;	

DROP TRIGGER DCL1;
DROP CLASS DCL1;	
