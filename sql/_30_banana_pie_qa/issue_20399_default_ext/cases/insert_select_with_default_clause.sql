drop table if exists t5;
create table t5(col1 int not null primary key auto_increment, col2 varchar(30) not null default to_char(CURDATE(), 'YYYY-MM-DD'), col3 varchar(100) not null default to_char(SYS_TIMESTAMP, 'HH24:MI:SS YYYY-MM-DD TZR'), col4 varchar(1000) not null default to_char(LOCALTIMESTAMP (), 'HH:MI:SS AM MM/DD/YYYY TZR'));

insert into t5(col2,col3,col4) select to_char(CURDATE(), 'YYYY-MM-DD'), to_char(SYS_TIMESTAMP, 'HH24:MI:SS YYYY-MM-DD TZR'), to_char(LOCALTIMESTAMP (), 'HH:MI:SS AM MM/DD/YYYY TZR') from db_class a, db_class b;
insert into t5(col2,col3,col4) select default(col2), default(col3), default(col4) from db_class a, db_class b;
update t5 set col2=default(col3), col3=default(col4), col4=default(col2);
update t5 set col2=default, col3=default, col4=default;
 
select /*+ recompile */ count(1) from t5 where col1>0 order by 1;
select /*+ recompile */ count(1) from (select  default(col2), col2, col4 from t5) t;

drop table t5;
