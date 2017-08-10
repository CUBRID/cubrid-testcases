--+ holdcas on;
set system parameters 'add_column_update_hard_default = yes';

create table t (i int);
insert into t values (1), (2), (3);

alter table t rename to tt, add column s string not null, rename to t;
select * from t order by i;

alter table t drop column s, add column s string not null, drop column s, add column s string;
select * from t order by i;

drop table t;



-- partitions
create table big (i int auto_increment, j int) partition by hash(i) partitions 32;
insert into big(j) values (1);
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;
insert into big(j) select j from big;

-- this should take a while :)
alter table big add column nn int not null;

select count(*) as mustbezero from big where nn is null;

drop big;


create table t ([from] int, [to] int);
insert into t  values (1,2) ,(3,4);
alter table t add column [where] string not null, [select] int not null;
select * from t order by [from];
drop table t;




set system parameters 'add_column_update_hard_default = no';


commit;
--+ holdcas off;
