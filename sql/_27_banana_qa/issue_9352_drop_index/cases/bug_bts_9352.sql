--basic test,drop index xx on table
drop table if exists base_tbl;
CREATE TABLE base_tbl (
	a INT, b INT, c INT, d INT
);
CREATE INDEX i_a ON base_tbl (a desc);
CREATE UNIQUE INDEX u_b ON base_tbl (b asc);
CREATE REVERSE INDEX ri_c ON base_tbl (c,d);
CREATE REVERSE UNIQUE INDEX ru_d ON base_tbl (d);


DROP INDEX i_a;
DROP INDEX u_b;
DROP INDEX ri_c ON base_tbl;
DROP INDEX ru_d ON base_tbl;

--basic test alter table xx drop index
drop table if exists base_tbl;
CREATE TABLE base_tbl (
	a INT, b INT, c INT, d INT
);
CREATE INDEX i_a ON base_tbl (a);
CREATE UNIQUE INDEX u_b ON base_tbl (b);
CREATE REVERSE INDEX ri_c ON base_tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON base_tbl (d);
ALTER TABLE base_tbl DROP INDEX i_a;
ALTER CLASS base_tbl DROP INDEX u_b;
ALTER CLASS base_tbl DROP INDEX ri_c;
ALTER TABLE base_tbl DROP INDEX ru_d;
drop table if exists base_tbl;

--backward compatibility1 
CREATE TABLE base_tbl (
	a INT, b INT, c INT, d INT,e INT
);
CREATE INDEX i_a ON base_tbl (a);
CREATE UNIQUE INDEX u_b ON base_tbl (b);
CREATE REVERSE INDEX ri_c ON base_tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON base_tbl (d);

DROP UNIQUE INDEX i_a ON base_tbl;
DROP REVERSE INDEX i_a ON base_tbl;
DROP REVERSE UNIQUE INDEX  u_b ON base_tbl;
DROP REVERSE UNIQUE INDEX  ri_c ON base_tbl;
DROP INDEX i_a ON base_tbl;
DROP UNIQUE INDEX u_b ON base_tbl;
DROP REVERSE INDEX ri_c ON base_tbl;
DROP REVERSE UNIQUE INDEX ru_d ON base_tbl;
drop table if exists base_tbl;

--backward compatibility2
CREATE TABLE base_tbl (
	a INT, b INT, c INT, d INT,e INT
);
CREATE INDEX i_a ON base_tbl (a);
CREATE UNIQUE INDEX u_b ON base_tbl (b);
CREATE REVERSE INDEX ri_c ON base_tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON base_tbl (d);
CREATE UNIQUE INDEX u_e ON base_tbl (e);

ALTER TABLE base_tbl DROP UNIQUE INDEX i_a;
ALTER TABLE base_tbl DROP REVERSE INDEX i_a;
ALTER TABLE base_tbl DROP REVERSE UNIQUE INDEX  u_b;
ALTER TABLE base_tbl DROP REVERSE UNIQUE INDEX  ri_c;
ALTER TABLE base_tbl DROP REVERSE INDEX  ru_d;
ALTER TABLE base_tbl DROP INDEX i_a;
ALTER TABLE base_tbl DROP UNIQUE INDEX u_b;
ALTER TABLE base_tbl DROP REVERSE INDEX ri_c;
ALTER TABLE base_tbl DROP REVERSE UNIQUE INDEX ru_d;
alter table base_tbl  drop  constraint u_e;
drop table if exists base_tbl;

--inherited table
drop table if exists inherit_tbl;
CREATE TABLE base_tbl (a INT, b INT);
CREATE UNIQUE INDEX u_a ON base_tbl (a);

CREATE TABLE inherit_tbl UNDER base_tbl;
CREATE INDEX i_b ON inherit_tbl (b);

DROP INDEX u_a;
DROP INDEX u_a ON inherit_tbl; 
DROP INDEX u_a ON base_tbl; 
ALTER TABLE inherit_tbl DROP INDEX i_b;
drop table if exists inherit_tbl;
drop table if exists base_tbl;

--partition
drop table if exists partition_tbl;
CREATE TABLE partition_tbl (elem INT, elem2 INT) PARTITION BY LIST (elem) (
	PARTITION p0 VALUES IN (1, 2),
	PARTITION p1 VALUES IN (3, 4),
	PARTITION p2 VALUES IN (5, 6)
);
INSERT INTO partition_tbl VALUES(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);
CREATE INDEX i_elem ON partition_tbl (elem);
CREATE INDEX i_elem2 ON partition_tbl (elem2);

DROP INDEX i_elem ON partition_tbl__p__p0; 
ALTER TABLE partition_tbl DROP UNIQUE INDEX i_elem;
ALTER TABLE partition_tbl DROP INDEX i_elem;
DROP INDEX i_elem2 ON partition_tbl;
drop table if exists partition_tbl;

--like
drop table if exists inherit_tbl;
drop table if exists base_tbl;
CREATE TABLE base_tbl (a INT, b INT);
CREATE UNIQUE INDEX u_a ON base_tbl (a);

CREATE TABLE inherit_tbl like base_tbl;
CREATE INDEX i_b ON inherit_tbl (b);

DROP INDEX u_a;
DROP INDEX u_a ON inherit_tbl; 
DROP INDEX u_a ON base_tbl; 
ALTER TABLE base_tbl DROP INDEX i_b;
ALTER TABLE inherit_tbl DROP INDEX i_b;
drop table if exists inherit_tbl;
drop table if exists base_tbl;

--subclass
--CREATE TABLE base_tbl (a INT, b INT);
--CREATE UNIQUE INDEX u_a ON base_tbl (a);

--CREATE TABLE inherit_tbl as subclass of base_tbl;
--CREATE INDEX i_b ON inherit_tbl (b);

--DROP INDEX u_a;
--DROP INDEX u_a ON inherit_tbl; 
--DROP INDEX u_a ON base_tbl; 
--ALTER TABLE inherit_tbl DROP INDEX i_b;
--drop table if exists inherit_tbl
--drop table if exists base_tbl;

--alter index
CREATE TABLE base_tbl (
	a INT, b INT, c INT, d INT,e INT
);
CREATE INDEX i_a ON base_tbl (a);
CREATE UNIQUE INDEX u_b ON base_tbl (b);
CREATE REVERSE INDEX ri_c ON base_tbl (c);
CREATE REVERSE UNIQUE INDEX ru_d ON base_tbl (d);
alter index i_a on base_tbl rebuild;
alter index u_b on base_tbl rebuild;
alter index ri_c on base_tbl rebuild;
alter index ru_d on base_tbl rebuild;
drop index i_a on base_tbl;
drop index u_b on base_tbl;
alter table base_tbl drop index ri_c;
alter table base_tbl drop index ru_d;
drop table if exists base_tbl;
