drop table if exists t1;
CREATE TABLE t1 (id int PRIMARY KEY, b char(16), INDEX i_t1_b (b(4)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--throw exception "ERROR: No error message available."
SELECT MAX(b) FROM t1;

drop table t1;

CREATE TABLE t1 (id int PRIMARY KEY, b varchar(16), INDEX i_t1_b (b(4)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--result is not correct.
SELECT MAX(b) FROM t1;

drop table if exists t1;
CREATE TABLE t1 (id int PRIMARY KEY, b char(16), INDEX i_t1_b (b(8)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--throw exception "ERROR: No error message available."
SELECT min(b) FROM t1;

drop table t1;

CREATE TABLE t1 (id int PRIMARY KEY, b varchar(16), INDEX i_t1_b (b(8)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--result is not correct.
SELECT min(b) FROM t1;

drop table if exists t1;
CREATE TABLE t1 (id int PRIMARY KEY, b String, INDEX i_t1_b (b(8)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--throw exception "ERROR: No error message available."
SELECT min(b) FROM t1;

drop table t1;

CREATE TABLE t1 (id int PRIMARY KEY, b character varying(765), INDEX i_t1_b (b(8)));
INSERT INTO t1 VALUES (1, 'xxxxbbbb'), (2, 'xxxxaaaa');
--result is not correct.
SELECT min(b) FROM t1;

drop table t1;


