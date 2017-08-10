--[er]Create trigger to reject data using false logic with event_time of  "AFTER"


CREATE CLASS DCL1;	
CREATE TRIGGER DCL1	
AFTER DELETE ON DCL1	
EXECUTE REJECT;	
	

DROP CLASS DCL1;	
DROP TRIGGER DCL1;
