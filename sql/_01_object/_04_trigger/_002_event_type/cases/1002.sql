--[er]Create trigger using false event_type with keyword of comit

CREATE TRIGGER DCL1	
DEFERRED COMIT	
EXECUTE REJECT;	
	

DROP TRIGGER DCL1;
