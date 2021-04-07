--+ holdcas on;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
--TEST Create Index failed
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed in (select Closed from bugs where SYS_TIMESTAMP >TIMESTAMP '2010-10-30 01:15:45');
--TEST Create Index failed
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE months_between(CURDATE(), CreationDate)>3;
--TEST Create Index failed
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE rand()>3;
--TEST Create Index failed
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE rand(bugID)>10;
--TEST Create Index failed
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE ABS(bugID)>0;
drop table bugs;
commit;
--+ holdcas off;
