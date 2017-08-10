--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
select * from bugs where bugid>0 using index open_bugs(+);
show index from bugs;
ALTER TABLE bugs  DROP COLUMN Author;
select * from bugs where bugid>0 using index open_bugs(+);
ALTER TABLE bugs  DROP COLUMN Closed;
select * from bugs where bugid>0 using index open_bugs(+);
show index from bugs;
ALTER TABLE bugs  DROP COLUMN bugID;
SHOW INDEX IN bugs;
SHOW INDEX IN bugs;
drop table bugs;



set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
