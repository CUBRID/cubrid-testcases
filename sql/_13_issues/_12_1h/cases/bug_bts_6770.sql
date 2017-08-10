CREATE TABLE bugs (bugID BIGINT,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus 

INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
alter index open_bugs on bugs(bugID) where CreationDate>SYS_TIMESTAMP rebuild;
drop table bugs;

