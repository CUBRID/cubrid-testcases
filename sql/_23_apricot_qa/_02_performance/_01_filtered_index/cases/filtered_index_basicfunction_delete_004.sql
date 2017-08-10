autocommit off;
set  system parameters 'dont_reuse_heap_file=yes';
autocommit off;
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,0);
insert into bugs values(1,TIMESTAMP '2010-10-31 01:15:45','yin','test',1,1);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
select * from bugs where bugid>0 using index open_bugs(+);
show index from bugs;
ALTER TABLE bugs  Modify Closed char(10);
select * from bugs where bugid>0 using index open_bugs(+);
show index from bugs;
savepoint sp1;
ALTER TABLE bugs  DROP COLUMN bugID;
SHOW INDEX IN bugs;
rollback to savepoint sp1;
SHOW INDEX IN bugs;


select * from bugs where bugId>0 and closed=0 using index open_bugs(+);
select * from bugs where bugId>0 and closed=1 using index open_bugs(+);

select /*+ recompile */ * from bugs where bugId>0 and closed=0 using index open_bugs keylimit 0,1;
select /*+ recompile */ * from bugs where bugId>0 and closed=1 using index open_bugs;


select /*+ recompile */ * from bugs where bugId>0 and closed=0 using index open_bugs;
select /*+ recompile */ * from bugs where bugId>0 and closed=1 using index open_bugs;

select /*+ recompile */ * from bugs force index (open_bugs) where bugId>0 and closed=0 ;
select /*+ recompile */ * from bugs force index (open_bugs) where bugId>0 and closed=1 ;

drop index open_bugs on bugs;
CREATE INDEX open_bugs ON bugs(bugID);
prepare stmt from 'select * from bugs where bugId>0 and closed=? using index open_bugs(+)';
execute stmt using 0;
execute stmt using 1;

drop prepare stmt;

drop table bugs;

set  system parameters 'dont_reuse_heap_file=no';
commit;
autocommit on;
