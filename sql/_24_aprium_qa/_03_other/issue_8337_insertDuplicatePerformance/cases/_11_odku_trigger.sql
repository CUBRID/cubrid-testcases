drop table if exists tt, t,t1,t2,tr_action;
create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 10;

create table tr_action(id int auto_increment, executed_action varchar(255), i int, j int, k int);

create trigger bef_ins_t before insert on t execute insert into tr_action(executed_action, i, j, k) values('bef_ins_t', new.i, new.j, new.k);
create trigger aft_ins_t after insert on t execute insert into tr_action(executed_action, i, j, k) values('aft_ins_t', obj.i, obj.j, obj.k);
create trigger bef_upd_t before update on t execute insert into tr_action(executed_action, i, j, k) values('bef_upd_t', new.i, new.j, new.k);
create trigger aft_upd_t after update on t execute insert into tr_action(executed_action, i, j, k) values('aft_upd_t', old.i, old.j, old.k);
create trigger bef_del_t before delete on t execute insert into tr_action(executed_action, i, j, k) values('bef_del_t', obj.i, obj.j, obj.k);;
create trigger aft_del_t after delete on t execute insert into tr_action(executed_action) values('aft_del_t');


select * from t order by i;
insert into t select rownum as a, rownum as b, rownum as c from _db_class limit 5 on duplicate key update i = a + 100, j = b + 100, k = c + 100;

insert into t select a, b, c from (select /*+ NO_MERGE */ rownum as a, rownum as b, rownum as c from _db_class limit 5) x(a,b,c)
	on duplicate key update i = x.a + 100, j = x.b + 100, k = x.c + 100;

rollback;


select * from tr_action order by id;
select * from t  order by i;

truncate table t;
truncate table tr_action;

create table a(i int, j int, k int);
create table b(i int, j int, k int);

insert into a select * from t;
insert into b select * from t;
select * from t order by i;

insert into t (i, j, k) select a.i, a.j, a.k from a left join b on a.i = b.i on duplicate key update i = a.i+100;
rollback;
select * from t order by i;
insert into t (i, j, k) select a.i, a.j, a.k from a left join b on a.i = b.i on duplicate key update i = a.i+100;
commit;
select * from t order by i;
drop table a;
drop table b;


drop table t;
drop table tr_action;
