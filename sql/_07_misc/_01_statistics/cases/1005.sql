--[er]Optimizing superclass using update statistics with "all" key  

CREATE CLASS DCL1 (id INTEGER);	
CREATE CLASS DCL2 UNDER DCL1 (id2 INTEGER);	

UPDATE STATISTICS ON ALL DCL1;	

DROP CLASS DCL1;	
DROP CLASS DCL2;
