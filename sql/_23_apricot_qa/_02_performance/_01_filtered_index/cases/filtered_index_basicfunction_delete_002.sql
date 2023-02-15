--+ holdcas on;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
--TEST: 
ALTER TABLE bugs  DROP index open_bugs;
--TEST: 
update statistics on bugs;
SHOW INDEX IN bugs;
drop table bugs;


CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
--TEST: 
ALTER TABLE bugs  DROP index open_bugs from bugs(bugID) WHERE Closed = 0;
--TEST: 
update statistics on bugs;
SHOW INDEX IN bugs;
drop table bugs;



commit;
--+ holdcas off;
