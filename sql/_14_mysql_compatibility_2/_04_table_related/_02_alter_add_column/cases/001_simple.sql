--+ holdcas on;
-- test ALTER ADD COLUMN ... NOT NULL without a default - must fill existing table records
-- with "hard default", just like mysql.

set system parameters 'add_column_update_hard_default = yes';

create table t (camp int);
insert into t values (1), (2), (3);

alter t add column i int not null, j int, k int not null default 2012;
select * from t order by camp asc;
drop table t;


create table t (camp int);

alter t add column i int not null, k int not null default 2012;
select * from t order by camp asc;
drop table t;


set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
