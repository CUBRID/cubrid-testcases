select * from (
select to_number(null)
union all
select 1  
union all
select 1 );
