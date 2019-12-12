--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
insert into bugs values(2,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index failed
CREATE UNIQUE INDEX bugs_per_dev ON bugs(Author) WHERE Closed = 0;
delete  from bugs where bugID=1;
--TEST: Create Index successfully
CREATE UNIQUE INDEX bugs_per_dev ON bugs(Author) WHERE Closed = 0;
--test drop index failed
drop index bugs_per_dev on bugs;

--test drop index 
drop UNIQUE index bugs_per_dev on bugs;
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX bugs_per_dev ON bugs(Author) WHERE Closed = 0;

--TEST: alter Index failed
alter UNIQUE index bugs_per_dev on bugs (Author) WHERE Closed = 0 rebuild;
delete  from bugs where bugID=1;
--TEST: alter Index successfully
drop index bugs_per_dev on bugs;
create UNIQUE index bugs_per_dev on bugs (Author) WHERE Closed = 0;
--TEST: insert failed
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
alter UNIQUE index bugs_per_dev on bugs (bugID,Author) WHERE Closed = 0 rebuild;

drop table bugs;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
