--+ holdcas on;
set system parameters 'create_table_reuseoid = no';
set system parameters 'add_column_update_hard_default = yes';

create table t (k string);
insert into t values ('aaa'), ('bbb'), ('ccc'), ('ddd');

alter table t add column
i int not null,
ni int,

j smallint not null,
nj smallint,

b bigint not null,
nb bigint,

f float not null,

d double not null,
nd double,

dd date not null,
t time not null,
dt datetime not null,
ts timestamp not null,
n numeric not null,
vc varchar not null,
nc nchar varying not null,
s set of int not null,
ns set of int,
ms multiset of int not null;

select * from t order by k;

create table o (useless int);

-- these should fail - illegal types
alter table t add column illegal o not null;

drop table o;
drop t;



create table t (k string);
insert into t values ('aaa'), ('bbb'), ('ccc'), ('ddd');

alter table t add column
b1 bit not null,
b2 bit varying (10) not null;

-- displaying an empty varbit
select * from t order by k;

select count(*) from t where b2 is null;

drop t;

set system parameters 'add_column_update_hard_default = no';

create table t (k string);
insert into t values ('aaa'), ('bbb'), ('ccc'), ('ddd');

alter table t add column
i int not null,
ni int,

j smallint not null,
nj smallint,

b bigint not null,
nb bigint,

f float not null,

d double not null,
nd double,

dd date not null,
t time not null,
dt datetime not null,
ts timestamp not null,
n numeric not null,
vc varchar not null,
nc nchar varying not null,
s set of int not null,
ns set of int,
ms multiset of int not null;

select * from t order by k;

create table o (useless int);

-- these should fail - illegal types
alter table t add column illegal o not null;

drop table o;
drop t;



create table t (k string);
insert into t values ('aaa'), ('bbb'), ('ccc'), ('ddd');

alter table t add column
b1 bit not null,
b2 bit varying (10) not null;

select * from t order by k;

select count(*) from t where b2 is null;

drop t;

commit;
set system parameters 'create_table_reuseoid = yes';
--+ holdcas off;
