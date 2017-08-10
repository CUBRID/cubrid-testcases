CREATE TABLE t(a double, b double)
INSERT INTO t VALUES (1,NULL);

INSERT INTO t VALUES (2,NULL);

INSERT INTO t VALUES (3,1);

create index idx1 on t(log10(a));

create index idx2 on t(log10(b));

SELECT /*+ recompile */ a, b FROM t  where log10(a)>0 START WITH log10(a)>0 and log10(b) IS NULL CONNECT BY prior log10(a)=log10(b);

drop table t;


