--Create trigger to reject data that is inserted into class 

CREATE CLASS DCL1;	
CREATE TRIGGER DCL1	
BEFORE INSERT ON DCL1	
EXECUTE REJECT;	





DROP TRIGGER DCL1;
DROP CLASS DCL1;	
