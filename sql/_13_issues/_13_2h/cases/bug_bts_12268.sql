--+ holdcas on;
drop table if exists t1;
create table t1 ( s1 char(2) charset utf8);
insert into t1 values (repeat(chr(15052985 using utf8),2));
select s1, length(s1) from t1 order by 1;

set system parameters 'alter_table_change_type_strict=yes';
alter table t1 change s1 s char(3) charset utf8;

select s, length(s) from t1 order by 1;

drop table t1;
set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;
