--[er]Create trigger using false event_time with error keyword  "bepore"


CREATE CLASS DCL1;	
CREATE TRIGGER DCL1	
BEPORE DELETE ON DCL1	
EXECUTE REJECT;	
	

DROP CLASS DCL1;	
DROP TRIGGER DCL1;
