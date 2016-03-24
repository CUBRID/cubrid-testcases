--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (a char(10) not null, b int not null auto_increment, primary key(a,b));
insert into t1 values ("a",NULL),("b",NULL),("c",NULL),("d",NULL),("e",NULL);
insert into t1 values ("a",1);
insert into t1 values ("b",2);
insert into t1 values ("c",3);
insert into t1 values ("d",4);
insert into t1 values ("e",5);
insert into t1 values ("x",NULL),("y",NULL),("z", NULL), ("x", 6), ("y", 7), ("z", 8);
insert into t1 values ('m', -1234567890);
insert into t1 values ('n', +1234567890);
select * from t1 order by b asc;
drop table t1;

create table t1 (ordid int not null auto_increment, ord  varchar(50) not null, primary key key1(ordid), index index1(ord,ordid)); 
insert into t1 (ordid,ord) values (NULL,'sdj'),(NULL,'sdj');
select * from t1 order by ordid asc;
drop table t1;

create table t1 (ordid int not null auto_increment, ord  varchar(50) not null, primary key key1(ord,ordid));
insert into t1 values (NULL,'a'),(NULL,'a'),(NULL,"a"),(NULL,'b'),(NULL,'b'),(NULL,'c'),(NULL,'a');
select * from t1 order by ord asc, ordid asc;
drop table t1;

---It seemed to exist problem in csql
create table t1 (sid char(5), id int NOT NULL auto_increment, primary key (sid,  id));
create table t2 (sid char(20), id int);
insert into t2 values ('skr',NULL),('skr',NULL),('test',NULL);
insert into t1(sid, id) select * from t2 order by sid asc;
select * from t1 order by sid asc, id asc;
drop table t1,t2;

create table t1 (a int, b int);
insert into t1 values (1, 1), (2,2), (3,3), (NULL,4), (NULL,5);
alter table t1 add column c int not null auto_increment primary key; 
select * from t1 order by b asc;
drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
