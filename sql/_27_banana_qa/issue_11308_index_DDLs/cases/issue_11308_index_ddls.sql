-- env preparation for test
drop table if exists tbl;

CREATE TABLE tbl (
	a INT, b INT, c INT, d INT
	);
CREATE INDEX i_a ON tbl (a);
CREATE UNIQUE INDEX u_b ON tbl (b);
CREATE REVERSE INDEX ri_c ON tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON tbl (d);

-- ddl test for index
-- negative cases(without on table keyword)
DROP INDEX i_a;
DROP UNIQUE INDEX u_b;
DROP REVERSE INDEX ri_c;
DROP REVERSE UNIQUE INDEX ru_d;

--positive cases(with on table keyword)
DROP INDEX i_a ON tbl;
DROP UNIQUE INDEX u_b ON tbl;
DROP REVERSE INDEX ri_c ON tbl;
DROP REVERSE UNIQUE INDEX ru_d ON tbl;

--clean env
drop table tbl;

