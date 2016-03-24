drop table if exists tree;
create table tree(node int,parentnode int,name varchar(30));
insert into tree values (1, NULL,'1');
insert into tree values (2, 1,'2');
insert into tree values (3, 1,'3');
insert into tree values (4, 1,'4');
insert into tree values (5, 2,'5');
insert into tree values (6, 5,'6');
insert into tree values (7, 5,'7');
insert into tree values (8, 3,'8');
insert into tree values (9, 8,'9');
insert into tree values (10,9,'10');
drop vclass if exists v;
create vclass v as select parentnode,node,name from tree start with parentnode is null connect by parentnode=prior node order by node;
show heap header of v;
drop tree,v;

drop table if exists t1;
create table t1(i int);
insert into t1 values (1);
insert into t1 values (2);
insert into t1 values (3);
insert into t1 values (4);
drop vclass if exists v;
create vclass v as select * from t1;
show heap capacity of v;
 show heap header of db_class;
show heap capacity of db_class;
drop t1,v;

drop  view if exists b_view;
drop table if exists a_tbl;
CREATE TABLE a_tbl(
id INT NOT NULL,
phone VARCHAR(10));
INSERT INTO a_tbl VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);
CREATE VIEW b_view AS SELECT * FROM a_tbl WHERE phone IS NOT NULL WITH CHECK OPTION;
show heap header of  b_view;
show heap capacity of b_view;
drop view if exists b_view;
drop table if exists a_tbl ;


drop table if exists t1;
create table t1(a int, b varchar(5));
create index index_a on t1(a ASC);
create vclass v2 as select * from t1;
show all indexes header of v2;
show all indexes capacity of v2; 
show all indexes header of db_root;
show all indexes header of db_class;
drop t1,v2;

drop table if exists t1;
create table t1(a int, b varchar(5));
create index index_a on t1(a ASC);
create view v2 as select * from t1;
show all indexes header of v2;
show all indexes capacity of v2; 
show all indexes header of db_root;
show all indexes header of db_class;
drop t1,v2;



