--+ holdcas on;
drop table if exists t1 ;

create table t1 (a integer);
insert into t1 values (1);

select 1 as a from t1 union all select 1 from db_class limit 0, 0+1;  
select 1 as a from t1 union all select 1 from db_class limit 0, 1; 
select 1 as a from t1 union all select 1 from db_class limit 0+1, 2;  
select 1 as a from t1 union all select 1 from db_class limit 1, 2; 

set @a=0;
set @b=1;
prepare stmt from 'select 1 as a from t1 union all select 1 from db_class limit ?, ?+?;';
execute stmt using 0, 0, 1 ;
execute stmt using @a, @a, @b ;
deallocate prepare stmt;

prepare stmt from 'select 1 as a from t1 union all select 1 from db_class limit ?+?, ?;';
execute stmt using 0, 1, 3 ;
execute stmt using @a, @b, @b ;

deallocate prepare stmt;
deallocate variable @a,@b;
drop table if exists t1 ;
--+ holdcas off;









