--+ holdcas on;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID);
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed = 0;
CREATE INDEX open_bugs2 ON bugs(bugID) WHERE bugID is not null;
drop table bugs;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugID is not null;
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed = 0;
drop table bugs ;



CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE  Closed >=0 ;
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed = 0;
drop table bugs ;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed =0 and CreationDate > '2010-10-30 01:15:45';
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed =0 and CreationDate > '2010-10-29 01:15:45';
drop table bugs ;

CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed =0 and CreationDate > '2010-10-30 01:15:45';
CREATE INDEX open_bugs1 ON bugs(bugID) WHERE Closed =0 and CreationDate <= '2010-10-30 01:15:45';

CREATE INDEX open_bugs2 ON bugs(bugID) WHERE Closed <>0 and CreationDate <= '2010-10-30 01:15:45';

CREATE INDEX open_bugs2 ON bugs(bugID) WHERE Closed <>0 and CreationDate > '2010-10-30 01:15:45';
drop table bugs ;
commit;
--+ holdcas off;
