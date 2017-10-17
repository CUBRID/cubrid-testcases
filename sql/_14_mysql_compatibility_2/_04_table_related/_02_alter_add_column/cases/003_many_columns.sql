--+ holdcas on;
set system parameters 'add_column_update_hard_default = yes';

create table t (i int primary key auto_increment, j int);

insert into t (j) values (1);
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;
insert into t (j) select j from t;

select count(*) from t;

alter table t
add column col01 numeric not null,
add column col02 numeric not null,
add column col03 numeric not null,
add column col04 numeric not null,
add column col05 numeric not null,
add column col06 numeric not null,
add column col07 numeric not null,
add column col08 numeric not null,
drop column col08,
drop column col07,
drop column col06;

select sum(col01+col02+col03+col04+col05) as mustbezero from t;

drop table t;

set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
