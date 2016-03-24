-- env preparation for test
drop table if exists tbl;

CREATE TABLE tbl (
	a INT, b INT, c INT, d INT
	);
CREATE INDEX i_a ON tbl (a);
CREATE UNIQUE INDEX u_b ON tbl (b);
CREATE REVERSE INDEX ri_c ON tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON tbl (d);

-- ddl test for index with rebuild

-- negative cases(without on table keyword)
ALTER INDEX i_a REBUILD;
ALTER UNIQUE INDEX u_b REBUILD;
ALTER REVERSE INDEX ri_c REBUILD;
ALTER REVERSE UNIQUE INDEX ru_d REBUILD;

--positive cases(with on table keyword)
ALTER INDEX i_a ON tbl REBUILD;
ALTER UNIQUE INDEX u_b ON tbl REBUILD;
ALTER REVERSE INDEX ri_c ON tbl REBUILD;
ALTER REVERSE UNIQUE INDEX ru_d ON tbl REBUILD;

--clean env
drop table tbl;

