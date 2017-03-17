--http://jira.cubrid.org/browse/CBRD-21074

drop table if exists t;
CREATE TABLE t (id INTEGER AUTO_INCREMENT (1, 1) PRIMARY KEY, a INTEGER, b INTEGER, c INTEGER, d INTEGER, INDEX i_t_a_b (a, b));
insert into t (a,b,c,d) values (2, null, null, null);
insert into t (a,b,c,d) values (3, null, null, null);
insert into t (a,b,c,d) values (3, 3, null, null);
SELECT  * FROM t WHERE a =3 ORDER BY a desc ,b desc LIMIT 5;
drop table if exists t;
