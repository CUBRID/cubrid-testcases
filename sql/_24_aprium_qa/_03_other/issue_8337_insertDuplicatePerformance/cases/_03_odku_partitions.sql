drop table if exists a, b, c, t;
create table t(i int, j int, k int) partition by hash(i) partitions 3;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(i,j, k);

insert into t select rownum, rownum, rownum from _db_class limit 15;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 15;

insert into t (i,j, k) select i, i, s from a on duplicate key update i = a.s, k = k+1;

select i, j, k from t order by i;

drop table a;
drop table t;

create table t(i int, j int, k int) partition by hash (i) partitions 3;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(i,j, k);

insert into t select rownum, rownum, rownum from _db_class limit 15;

create table a (i int, s varchar(255));
create table b (i int, s varchar(255));
create table c (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 15;
insert into b select rownum, rownum from _db_class limit 15;
insert into c select rownum, rownum from _db_class limit 15;

insert into t (i, j, k) 
	select i, s from a
	union
	select i, s from b
	union
	select i, s from c
on duplicate key update i = a.s, j = b.s, k = k+1;

insert into t (i, j, k) select a, b, c from
	(
		select i, s, s from a union select i, s, s from b union select i, s, s from c
	) x(a, b, c)
on duplicate key update i = x.a, j = x.b, k = x.c;

select i, j, k from t order by i;

insert into t (j, k) select i+10, s from a on duplicate key update i = a.s+10, k = k+1, j = i;

select i, j, k from t order by i,j,k;

drop table a;
drop table b;
drop table c;

drop table t;

create table t(i int, j int, k int) partition by hash(i) partitions 5;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(i,j, k);

insert into t select rownum, rownum, rownum from _db_class limit 30;

create table tr_action(id int auto_increment, executed_action varchar(255), i int, j int, k int);

create trigger bef_ins_t before insert on t execute insert into tr_action(executed_action, i, j, k) values('bef_ins_t', new.i, new.j, new.k);
create trigger aft_ins_t after insert on t execute insert into tr_action(executed_action, i, j, k) values('aft_ins_t', obj.i, obj.j, obj.k);
create trigger bef_upd_t before update on t execute insert into tr_action(executed_action, i, j, k) values('bef_upd_t', new.i, new.j, new.k);
create trigger aft_upd_t after update on t execute insert into tr_action(executed_action, i, j, k) values('aft_upd_t', old.i, old.j, old.k);
create trigger bef_del_t before delete on t execute insert into tr_action(executed_action, i, j, k) values('bef_del_t', obj.i, obj.j, obj.k);;
create trigger aft_del_t after delete on t execute insert into tr_action(executed_action) values('aft_del_t');

insert into t select rownum as a, rownum as b, rownum as c from _db_class limit 5 on duplicate key update i = a + 100, j = b + 100, k = c + 100;

insert into t select a, b, c from (select /*+ NO_MERGE */ rownum as a, rownum as b, rownum as c from _db_class limit 5) x(a,b,c)
	on duplicate key update i = x.a + 100, j = x.b + 100, k = x.c + 100;

select * from tr_action order by id;
select * from t where i > 100 order by i;

truncate table t;
truncate table tr_action;

create table a(i int, j int, k int);
create table b(i int, j int, k int);

insert into a select * from t;
insert into b select * from t;

insert into t (i, j, k) select a.i, a.j, a.k from a left join b on a.i = b.i on duplicate key update i = a.i+100;

drop table a;
drop table b;


drop table t;
drop table tr_action;
