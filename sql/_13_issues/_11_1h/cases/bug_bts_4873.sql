create table t(col_float float not null );
create index i_t_float on t(col_float);
insert into t(col_float) values (1.175480e-38);

select /*+ recompile */ col_float from t;
select /*+ recompile */ col_float from t where col_float is not null;
select /*+ recompile */ col_float from t where col_float is not null order by col_float;

drop table t;

create table t(col_monetary monetary not null );
create index i_t_monetary on t(col_monetary);
insert into t(col_monetary) values (-1);
select /*+ recompile */ col_monetary from t where col_monetary is not null order by col_monetary;

drop table t;