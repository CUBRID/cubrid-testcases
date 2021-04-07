--+ holdcas on;

CREATE TABLE bugs
(
        bugID BIGINT,
        CreationDate TIMESTAMP,
        Author VARCHAR(255),
        Subject VARCHAR(255),
        Description VARCHAR(255),
        CurrentStatus INTEGER,
        Closed SMALLINT
);

--error appear as at least one index key is not null constrained
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;

--error appear as index filter expression incudes index key, but it is null
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugID is null and Closed = 0;

--success
CREATE INDEX open_bugs ON bugs(bugID) WHERE bugID >0 and Closed = 0;

--success ,as condition expression has Closed =0 to make sure it will not be null
CREATE INDEX open_bugs_1 ON bugs(bugID, Closed) WHERE Closed = 0;

insert into bugs values(null,null,'madden','fopen',null,null,0);
SET OPTIMIZATION LEVEL 513;
SELECT * FROM bugs
        WHERE Author = 'madden' AND Subject LIKE '%fopen%' AND Closed = 0;
SELECT * FROM bugs
        WHERE Author = 'madden' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs(+);
SELECT * FROM bugs
        WHERE Author = 'madden' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs_1(+);

SET OPTIMIZATION LEVEL 1;

drop bugs;
drop index open_bugs on bugs;
drop index open_bugs_1 on bugs;

CREATE TABLE bugs
(
        bugID BIGINT not null,
        CreationDate TIMESTAMP,
        Author VARCHAR(255),
        Subject VARCHAR(255),
        Description VARCHAR(255),
        CurrentStatus INTEGER,
        Closed SMALLINT
);

--success, as constrain on bugID is not null
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
insert into bugs values(null,null,'madden','fopen',null,null,0);
SET OPTIMIZATION LEVEL 513;
SELECT * FROM bugs
        WHERE Author = 'madden' AND Subject LIKE '%fopen%' AND Closed = 0;
SELECT * FROM bugs
        WHERE Author = 'madden' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs(+);

SET OPTIMIZATION LEVEL 1;

--+ holdcas off;
drop bugs;
drop index open_bugs on bugs;
commit;



--+ holdcas off;





