drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile */ t2.* from t1, t2;
delete /*+ recompile */ t1.* from t1, t2;
delete /*+ recompile */ t1.*, t2.* from t1, t2;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;




create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile */ t2 from t1, t2;
delete /*+ recompile */ t1 from t1, t2;
delete /*+ recompile */ t1,t2 from t1, t2;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;



create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile */ t1, t1.* from t1, t2;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create index i_t1_a on t1(a);
create index i_t1_b on t1(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile */ t1, s1.* from t1, t1 as s1;
drop table t1;


create table t1(a int, b int);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
select t1.*, s1.* from t1, t1 as s1 where t1.a=s1.a+1 order by 1;
delete /*+ recompile */ t1, s1.* from t1, t1 as s1 where t1.a=s1.a+1;
select count(*) from t1;
drop table t1;


create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a) where a>=40;
create index i_t2_a on t2(a) where a<60;
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile */ t1.*, t2.* from t1, t2 where t1.a=t2.a and t1.a>0 and t2.a >0 using index i_t1_a,i_t2_a;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a) where a>=40;
create index i_t2_a on t2(a) where a<60;
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile ordered */ t1.*, t2.* from t1, t2 where t1.a=t2.a and t1.a>0 and t2.a >0 using index i_t1_a keylimit 10,10,i_t2_a keylimit 1, 1;
delete /*+ recompile ordered */ t1.*, t2.* from t1, t2 where t1.a=t2.a and t1.a>0 and t2.a >0 using index i_t1_a keylimit 10,10,i_t2_a keylimit 10,10;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 select rownum, rownum from db_class x1, db_class x2 limit 100;
insert into t2 select rownum, rownum from db_class x1, db_class x2 limit 100;
delete /*+ recompile ordered */ t1.*, t2.* from t1, t2 where t1.a in (select t2.a from t2 where t2.a%2=1);
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2),(3,3);
delete /*+ recompile ordered */ t1.*, t2.* from t1 left join t2 on t1.a=t2.a left join t1 t1_1 on t1_1.a<3 left join t2 as t2_1 on t2_1.a<3;
select count(*) from t1;
select count(*) from t2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 left join t2 on t1.a=t2.a where t2.a is null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;




create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 left join t2 on t1.a=t2.a where t2.a is not null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;

create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 inner join t2 on t1.a=t2.a where t1.a is not null and t2.a is null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 right join t2 on t1.a=t2.a where t1.a is not null;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;



create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 left join t2 on t1.a=t2.a  where t1.a is not null limit 1;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;





create table t1(a int, b int);
create table t2(a int, b int);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create index i_t1_b on t1(b);
create index i_t2_b on t2(b);
insert into t1 values (1,1), (2,2),(3,3);
insert into t2 values (1,1), (2,2);
delete /*+ recompile ordered */ t1.*, t2.* from t1 left join t2 on t1.a=t2.a  where t1.a is not null order by a desc;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;
drop table t1;
drop table t2;


create table t1(a int, b int, index i(a,b));
insert into t1 values (1,1),(2,2),(3,3);
delete t1 from t1 inner join (select * from t1 where a>1 using index i_t1_a_b keylimit 1,1) v1 on t1.a=v1.a;
select * from t1 order by 1, 2;
drop table t1;


create table t1(a int, b int, index i(a));
create table t2(a int, b int, index i(a));
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_before_update after update on t1 execute delete t1.*, t2.* from t1, t2 where t1.a=t2.a;
update t1 join t2 on t1.a=t2.a set t1.a=3, t2.a=3 where t1.a=2;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;
drop trigger tri_t1_before_update;


create table t1(a int, b int);
create index i_t1_a on t1 (a) where a>=4;
create trigger tri_t1_after_delete after insert on t1 if 2 = (select count(*) from t1 where a>=3 using index i_t1_a) execute  update t1 set b=-obj.a where a=obj.a;
insert into t1 values (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
select * from t1 order by 1,2;
drop table t1;


create table t1(a varchar(10) default USER, b varchar(10) default USER, index i_t1_a(a));
create table t2 like t1;
insert into t1(a, b) values (2,2), (3,3), (6,6), (7,7), (8,8);
insert into t2(a,b) values (2,2), (3,3), (4,4),(5,5),(9,9),(10,10), (6,6);
update t1 join t2 on t1.a=t2.a set t1.a=default, t2.a=default, t1.b=default(t1.b), t2.b=default(t2.b);
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;

create table t1(a varchar(10) default USER, b varchar(10) default USER, index i_t1_a(a));
create table t2 like t1;
insert into t1(a, b) values (2,2), (3,3), (6,6), (7,7), (8,8);
insert into t2(a,b) values (2,2), (3,3), (4,4),(5,5),(9,9),(10,10), (6,6);
update /*+ recompile */ t1 join t2 on t1.a=t2.a set t1.a=default, t2.a=default, t1.b=default(t1.b), t2.b=default(t2.b) where t1.a>=0 using index t1.i_t1_a(+) keylimit 1,1, t2.i_t1_a(+) keylimit 0,1;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t1;
drop table t2;


create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON DELETE CASCADE);
insert into t1(id, a, b) values (2,2,2),(3,3,3),(6,6,6),(7,7,7),(8,8,8);
insert into t2(id, a,b, pid) values (2,2,2,7),(3,3,3,2),(4,4,4,3),(5,5,5,3),(9,9,9,8),(10,10,10,6), (6,6,6,7);
delete t1, t2 from t1, t2 where t1.id=t2.id;
delete t1, t2 from t1, t2 where t1.id=t2.id;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;


create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON DELETE RESTRICT);
insert into t1(id, a, b) values (2,2,2),(3,3,3),(6,6,6),(7,7,7),(8,8,8);
insert into t2(id, a,b, pid) values (2,2,2,7),(3,3,3,2),(4,4,4,3),(5,5,5,3),(9,9,9,8),(10,10,10,6), (6,6,6,7);
delete t1, t2 from t1, t2 where t1.id=t2.id;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;


create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON DELETE set null);
insert into t1(id, a, b) values (2,2,2),(3,3,3),(6,6,6),(7,7,7),(8,8,8);
insert into t2(id, a,b, pid) values (2,2,2,7),(3,3,3,2),(4,4,4,3),(5,5,5,3),(9,9,9,8),(10,10,10,6), (6,6,6,7);
delete t1, t2 from t1, t2 where t1.id=t2.id;
delete t1, t2 from t1, t2 where t1.id=t2.id;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;

create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON DELETE NO ACTION);
insert into t1(id, a, b) values (2,2,2),(3,3,3),(6,6,6),(7,7,7),(8,8,8);
insert into t2(id, a,b, pid) values (2,2,2,7),(3,3,3,2),(4,4,4,3),(5,5,5,3),(9,9,9,8),(10,10,10,6), (6,6,6,7);
delete t1, t2 from t1, t2 where t1.id=t2.id;
delete t1, t2 from t1, t2 where t1.id=t2.id;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;


create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON UPDATE set NULL);
insert into t1(id, a, b) values (1,1,1),(3,3,3);
insert into t2(id, a, b, pid) values (1,1,1,3),(3,3,3,3);
update t1 inner join t2 on t1.id=t2.id set t1.id=2 where t1.id=3;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;


create table t1(id clob, a int, b int);
create table t2(id clob, a int, b int, pid int);
insert into t1(id, a, b) values (char_to_clob('2'),2,2),(char_to_clob('3'),3,3),(char_to_clob('6'),6,6),(char_to_clob('7'),7,7),(char_to_clob('8'),8,8);
insert into t2(id, a,b, pid) values (char_to_clob('2'),2,2,7),(char_to_clob('3'),3,3,2),(char_to_clob('4'),4,4,3),(char_to_clob('5'),5,5,3),(char_to_clob('9'),9,9,8),(char_to_clob('10'),10,10,6), (char_to_clob('6'),6,6,7);
update t1 inner join t2 on clob_to_char(t1.id)=clob_to_char(t2.id) set t1.b=t1.b+1000 ;
select a,b from t1 order by b;
select a,b from t2 order by b;
drop table t2;
drop table t1;




create table t1(id int primary key, a int, b int);
create table t2(id int primary key, a int, b int, pid int, CONSTRAINT cons_t1_id FOREIGN KEY(pid)REFERENCES t1(id) ON UPDATE set NULL);
insert into t1(id, a, b) values (2,2,2),(3,3,3),(6,6,6),(7,7,7),(8,8,8);
insert into t2(id, a,b, pid) values (2,2,2,7),(3,3,3,2),(4,4,4,3),(5,5,5,3),(9,9,9,8),(10,10,10,6), (6,6,6,7);
update t1 inner join t2 on t1.id=t2.id set t1.a=(select count(*) from t2 s2 where s2.b=999), t2.a=(select count(*) from t1 s1 where s1.b=999), t2.b=999, t1.b=999;
delete t1.*, t2.* from t1 inner join t2 on t1.a=(select count(*) from t2 s2 where s2.b=999) and t2.a=(select count(*) from t1 s1 where s1.b=999), t2.b=999, t1.b=999;
select * from t1 order by 1,2;
select * from t2 order by 1,2;
drop table t2;
drop table t1;

