
drop table if exists foo;
prepare st from 'create table foo as with cte as (select 1 x union all select x + ? from cte where x < 10) select *from cte';
execute st using 2;
drop table foo;

execute st using '2';

drop table if exists foo;


prepare st2 from
'create table foo as with recursive  testval(dept, val) as( 
      select ?,  ? 
      UNION ALL 
      select dept + 1, val + 1 from testval where dept <= ?
   ) 
select val from testval order by dept desc limit 1';

execute st2 using '2', '2', 10;
select * from foo order by 1;
drop table foo;

execute st2 using 2, 2, 10;
select * from foo order by 1;

drop table if exists foo;
prepare st3 from
'create table foo as with recursive  testval(dept, val) as( 
      select cast(? as decimal(5,2)),  cast(? as decimal(5,2)) 
      UNION ALL 
      select dept + 1, val + 1 from testval where dept <= ?
   ) 
select val from testval order by dept desc limit 1';

execute st2 using '2', '2', 10;


deallocate prepare st;
deallocate prepare st2;
deallocate prepare st3;

drop table if exists foo;
