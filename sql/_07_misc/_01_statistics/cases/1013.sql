--[er]Optimizing column using update statistics

CREATE CLASS DCL1 (id INTEGER);	

UPDATE STATISTICS ON id;	

DROP CLASS DCL1;
