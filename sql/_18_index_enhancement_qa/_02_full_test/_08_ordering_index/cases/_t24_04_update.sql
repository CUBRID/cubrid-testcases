--+ holdcas on;
create table t (a int, b varchar(10) not null, c char(10), d timestamp);

create index i_t_b_c_d on t(b,c,d);

insert into t select rownum, cast(rownum as varchar(10)), cast(rownum%2 as char(10)), sys_timestamp from db_class a limit 10;

select /*+ recompile */ b,c from t where c='1' order by b,d;

update t set c='1' where c='1' order by b,d;

drop table t;

commit;
--+ holdcas off;
