--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
ALTER TABLE bugs  RENAME COLUMN bugID AS bugID1;
--TEST: 
SHOW INDEX IN bugs;
ALTER TABLE bugs  RENAME COLUMN bugID1 AS bugID;
--TEST: 
SHOW INDEX IN bugs;
drop table bugs;



set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
