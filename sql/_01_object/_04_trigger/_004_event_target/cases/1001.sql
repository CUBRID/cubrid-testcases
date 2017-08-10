--[er]Create trigger to reject data that is updated in the class,but attribute don't exist


CREATE CLASS DCL1;	
CREATE TRIGGER DCL1	
BEFORE UPDATE ON DCL1(id)	
EXECUTE REJECT;	
	

DROP CLASS DCL1;	
DROP TRIGGER DCL1;
