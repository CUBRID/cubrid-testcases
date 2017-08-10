--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bugs (bugID BIGINT not null,CreationDate TIMESTAMP,Author VARCHAR(255),Subject VARCHAR(255),CurrentStatus INTEGER, Closed SMALLINT);
insert into bugs values(1,TIMESTAMP '2011-09-12 01:15:45','yin','fopen',0,0);
CREATE INDEX open_bugs ON bugs(bugID) WHERE Closed = 0;
--TEST: should not use open_bugs
SELECT /*+ recompile */* FROM bugs WHERE Author = 'yin' AND Subject LIKE '%fopen%' AND Closed = 0;
--TEST: should not  use open_bugs
SELECT /*+ recompile */* FROM bugs WHERE Author = 'yin' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs(+);
--TEST: should use open_bugs
SELECT * FROM bugs WHERE bugID>0 and Author = 'yin' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs(+);
--Test should use the cache
SELECT * FROM bugs WHERE bugID>0 and Author = 'yin' AND Subject LIKE '%fopen%' AND Closed = 0 using index open_bugs(+);

Drop table bugs;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
