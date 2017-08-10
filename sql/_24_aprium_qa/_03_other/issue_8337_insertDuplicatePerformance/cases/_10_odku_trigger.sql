drop table if exists tt, t,t1,t2,tr_action;
create table t(i bigint auto_increment(1,1) primary key, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200) ) partition by hash(i) partitions 5 ;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
create unique index u_t_i_k on t(j, k,i);
create unique index u_t_l_k on t(j, k,i,l);
create unique index u_t_m_k on t(j, k,i,l,m);
create unique index u_t_n_k on t(j, k,i,l,m,n);

create table tr_action(executed_action varchar(20),i bigint auto_increment(1,1), j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(150) );

create trigger bef_ins_t before insert on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('bef_ins_t', new.i, new.j, new.k, new.l, new.m, new.n);

create trigger aft_ins_t after insert on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('aft_ins_t', obj.i, obj.j, obj.k,obj.l,obj.m,obj.n);

create trigger bef_upd_t before update on t execute insert into tr_action(executed_action,i, j, k,l,m,n) values('bef_upd_t', new.i, new.j, new.k, new.l, new.m, new.n);

create trigger aft_upd_t after update on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('aft_upd_t', old.i, old.j, obj.k,obj.l,obj.m,obj.n);

create trigger bef_del_t before delete on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('bef_del_t', obj.i, obj.j, obj.k,obj.l,obj.m,obj.n);

create trigger aft_del_t after delete on t execute insert into tr_action(executed_action) values('aft_del_t');

insert into t select null, rownum, rownum,rownum, TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

select * from t order by 1;

select * from tr_action order by 1;

update t set i=i+1 where i>3;

delete from t  where i>3;

select * from t order by 1 limit 10;

select * from tr_action order by 1,2 limit 10;

--insert into t (j,i, k,l,m,n) select * from t on duplicate key update i = i-1, k = k+1;

drop table if exists tt;

create table tt(i int, j int, k int,l int,m date,n char(250)) partition by hash(j) partitions 5 ;

insert into tt select rownum, rownum, rownum,rownum,TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = i-1, k = k+1;

insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = t.i, k = k+1;

drop table if exists tt, t,t1,t2,tr_action;
create table t(i bigint auto_increment(1,1) primary key, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200) ) partition by hash(i) partitions 5 ;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
create unique index u_t_i_k on t(j, k,i);
create unique index u_t_l_k on t(j, k,i,l);
create unique index u_t_m_k on t(j, k,i,l,m);
create unique index u_t_n_k on t(j, k,i,l,m,n);

create table tr_action(executed_action varchar(20),i bigint auto_increment(1,1), j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(150) );

create trigger bef_ins_t before insert on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('bef_ins_t', new.i, new.j, new.k, new.l, new.m, new.n);

create trigger aft_ins_t after insert on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('aft_ins_t', obj.i, obj.j, obj.k,obj.l,obj.m,obj.n);

create trigger bef_upd_t before update on t execute insert into tr_action(executed_action,i, j, k,l,m,n) values('bef_upd_t', new.i, new.j, new.k, new.l, new.m, new.n);

create trigger aft_upd_t after update on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('aft_upd_t', old.i, old.j, obj.k,obj.l,obj.m,obj.n);

create trigger bef_del_t before delete on t execute insert into tr_action(executed_action, i, j, k,l,m,n) values('bef_del_t', obj.i, obj.j, obj.k,obj.l,obj.m,obj.n);

create trigger aft_del_t after delete on t execute insert into tr_action(executed_action) values('aft_del_t');

insert into t select null, rownum, rownum,rownum, TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

select * from t order by 1;

select * from tr_action order by 1;

update t set i=i+1 where i>3;

delete from t  where i>3;

select * from t order by 1 limit 10;

select * from tr_action order by 1,2 limit 10;

--insert into t (j,i, k,l,m,n) select * from t on duplicate key update i = i-1, k = k+1;

create table tt(i int, j int, k int,l int,m date,n char(250)) partition by hash(j) partitions 5 ;

insert into tt select rownum, rownum, rownum,rownum,TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = i-1, k = k+1;

insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = t.i, k = k+1;

drop table if exists tt, t,tr_action;