--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
RENAME TABLE bugs AS bugs1;
--TEST: 
SHOW INDEX IN bugs1;
RENAME TABLE bugs1 to bugs;
--TEST: 
SHOW INDEX IN bugs;
drop table bugs;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugs.Closed = 0;
RENAME TABLE bugs AS bugs1;
--TEST: 
SHOW INDEX IN bugs1;
RENAME TABLE bugs1 to bugs;
--TEST: 
SHOW INDEX IN bugs;
drop table bugs;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
