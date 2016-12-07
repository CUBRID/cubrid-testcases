drop table if exists tbl;
create table tbl(i int primary key) partition by range(i) (partition p0 values less than (20),partition p1 values less than(40),partition p2 values less than maxvalue);
insert into tbl select rownum from db_class limit 30;
alter table tbl remove partitioning;

select count(*)  from tbl;

select count (i) from tbl;

select * from tbl order by i limit 1;

drop table tbl;

create table tbl (i int unique) partition by range(i) (partition p0 values less than (20),partition p1 values less than(40),partition p2 values less than maxvalue);
insert into tbl select rownum from db_class limit 30;
alter table tbl remove partitioning;

select count(*)  from tbl;

select count (i) from tbl;

select * from tbl order by i limit 1;

drop table tbl;

create table tbl (i int, j int, unique(i,j)) partition by range(i) (partition p0 values less than (20),partition p1 values less than(40),partition p2 values less than maxvalue);
insert into tbl select rownum, rownum from db_class limit 30;
alter table tbl remove partitioning;

select count(*)  from tbl;

select count (j) from tbl;

select count (i) from tbl;

select * from tbl order by i limit 1;

drop table tbl;

create table t(i int, j int, k int, l int, s varchar(255));

create unique index u_t_i on t(i);
create unique index u_t_j on t(j);
create unique index u_t_k on t(k);
create unique index u_t_l on t(l);
create unique index u_t_s on t(s);


create unique index u_t_ij on t(i,j);
create unique index u_t_jk on t(j,k);
create unique index u_t_kl on t(k,l);
create unique index u_t_ls on t(l,s);


create unique index u_t_ijk on t(i, j, k);
create unique index u_t_jkl on t(j, k, l);
create unique index u_t_kls on t(k, l, s);

create unique index u_t_ijkl on t(i, j, k, l);
create unique index u_t_jkls on t(j, k, l, s);

create unique index u_t_ijkls on t(i, j, k, l, s);

create table a(i int auto_increment);
insert into a values(null);
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;

create index i_a_i on a(i);

insert into t (i, j, k, l, s) select i, i, i, i, i from a where i <= 100;
insert into t (i, j, k, l, s) select i, i, i, i, i from a where i>900 and i <= 1000;

update t set i = i + 2000, j = j + 2000, k = k + 2000, l = l + 2000, s = concat (s, '1') where i >= 0 and i < 100;

update t set i = i + 2000, j = j + 2000, k = k + 2000, l = l + 2000, s = concat (s, '1') where i = 98;

insert into t values(1, 1, 1, 1, 1);

drop table t;
drop table a;
