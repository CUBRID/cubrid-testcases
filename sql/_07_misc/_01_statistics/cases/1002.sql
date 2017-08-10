--Optimizing class using update statistics

CREATE CLASS DCL1(id INTEGER);	

UPDATE STATISTICS ON DCL1;	

DROP CLASS DCL1;
