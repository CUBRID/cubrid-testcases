
--+ holdcas on;
drop table if exists t;
create table t(a enum('a', 'b', 'c') not null);
insert into t values(1);

update t set a=default;

drop table if exists t;

--+ holdcas off;

commit;
