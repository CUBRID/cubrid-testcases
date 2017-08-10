CREATE TABLE t(a varchar,b int, c double)
INSERT INTO t VALUES ('SQL',1,10);
create index idx1 on t(lower(a));
create index idx2 on t(log10(c));
SELECT /*+ recompile */ * FROM t where lower(a)>'0';
SELECT /*+ recompile */ * FROM t where log10(c)=1;
SELECT /*+ recompile */ * FROM t where lower(a)>'0' and log10(c)=1;
SELECT /*+ recompile */ * FROM t where log10(c)=1 and lower(a)>'0';
drop table t;

