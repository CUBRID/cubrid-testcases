set system parameters 'create_table_reuseoid=no';
create table t (i int);
create table u (i int);

insert into t values (1);
insert into u values (2);

select i from (t, u) x where x in (select t from t);
select i from (t, u) x where x in (select u from u);
select i from (t, u) x where x in (select t from t union all select u from u) order by 1;

drop table t, u;
set system parameters 'create_table_reuseoid=yes';
