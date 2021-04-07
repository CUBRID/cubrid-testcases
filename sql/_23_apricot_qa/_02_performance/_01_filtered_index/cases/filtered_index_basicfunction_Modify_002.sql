--+ holdcas on;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(10,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugID > 0;
--TEST: 
ALTER TABLE bugs CHANGE bugID bugID INTEGER FIRST;
SHOW INDEX IN bugs;
--TEST: 
ALTER TABLE bugs CHANGE bugID bugID1 VARCHAR(255);
SHOW INDEX IN bugs;

--TEST: 
ALTER TABLE bugs CHANGE bugID1 bugID BIGINT;
SHOW INDEX IN bugs;

drop table bugs;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(10,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
--TEST: 
ALTER TABLE bugs CHANGE bugID bugID INTEGER FIRST;
SHOW INDEX IN bugs;
--TEST: 
ALTER TABLE bugs CHANGE bugID bugID1 VARCHAR(255);
SHOW INDEX IN bugs;

--TEST: 
ALTER TABLE bugs CHANGE bugID1 bugID BIGINT;
SHOW INDEX IN bugs;

drop table bugs;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(10,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
--TEST: 
ALTER TABLE bugs MODIFY bugID  INTEGER FIRST;
SHOW INDEX IN bugs;
--TEST: 
ALTER TABLE bugs MODIFY bugID  VARCHAR(255);
SHOW INDEX IN bugs;

--TEST: 
ALTER TABLE bugs MODIFY bugID  BIGINT;
SHOW INDEX IN bugs;

drop table bugs;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(10,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST: Create Index successfully
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugID > 0;
--TEST: 
ALTER TABLE bugs MODIFY bugID  INTEGER FIRST;
SHOW INDEX IN bugs;
--TEST: 
ALTER TABLE bugs MODIFY bugID  VARCHAR(255);
SHOW INDEX IN bugs;

--TEST: 
ALTER TABLE bugs MODIFY bugID  BIGINT;
SHOW INDEX IN bugs;

drop table bugs;
commit;
--+ holdcas off;
