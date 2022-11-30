CREATE TABLE bugs (bugID BIGINT,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,1);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 1;
CREATE INDEX i_bugs_bugid_creationdate  ON bugs(bugID,CreationDate) WHERE Closed = 1;
CREATE INDEX i_bugs_creationdate  ON bugs(CreationDate) WHERE Closed = 1;
CREATE INDEX i_bugs_subject  ON bugs(Subject) WHERE Subject is not null;
CREATE INDEX idx1 ON bugs(ln(bugID));
CREATE INDEX idx2 ON bugs(ln(Closed));
CREATE INDEX idx3 ON bugs(ln(bugID),Closed);
update statistics on bugs;
show index in bugs;
ALTER TABLE bugs  DROP COLUMN Closed;
update statistics bugs;
show index in bugs;
drop table bugs;

