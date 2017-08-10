--TEST: Query result is incorrect when select with BETWEEN and OR condition.

drop table if exists tab0;
CREATE TABLE tab0(pk INTEGER PRIMARY KEY, col1 int);

INSERT INTO tab0 VALUES(0,514);
INSERT INTO tab0 VALUES(1,698);

--Result is incorrect
SELECT /*+ recompile */ * FROM tab0 WHERE (col1 BETWEEN 9 AND 2) OR (col1 BETWEEN 5 AND 4);

drop table tab0;
