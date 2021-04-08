--+ holdcas on;
--Test
create table t3(id1 integer, index idx1(id1 ASC) where id1 > 1);

SHOW INDEXES FROM t3;
--Test
alter table t3 drop index idx1;

SHOW INDEXES FROM t3;
--Test
create table t4(id1 integer, index idx1(id1 ASC) where id1 > 1, id2 varchar(255), index idx2(id2 desc) where id2 > 'x');

SHOW INDEXES FROM t4;
--Test
alter table t4 drop index idx1;
alter table t4 drop index idx2;
--Test
SHOW INDEXES FROM t4;

CREATE TABLE const_tbl3(id INT, INDEX i_index(id ASC) where id > 1, id2 double, INDEX i_index1(sqrt(id2) ASC));
--Test
SHOW INDEXES FROM const_tbl3;

alter table const_tbl3 drop index i_index;
alter table const_tbl3 drop index i_index1;
--Test
SHOW INDEXES FROM const_tbl3;

drop table const_tbl3;
drop table t3;
drop table t4;
commit;
--+ holdcas off;
