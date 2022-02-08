select 1;
select all 1;
select distinct 1;
select distinctrow 1;
select all 1 from db_class limit 10;
select distinct 1 from db_class limit 11;
select distinctrow 1 from db_class limit 3;
select all 1 from db_class where 1<>0 limit 4;
select all 1 from db_class where 1<>0 order by 1 desc limit 4;
select all 1,class_name from db_class where 1<>0 order by 2  limit 4;

select 'a';
select all 'a';
select all 'a' from db_class limit 10;
select all 'a' from db_class where 1<>0 limit 4;

select all 0;
select all -0;
select all 0.3232;
select all 10.3232;

select 211 as v;
select all 211 as v;
select 211 as v from db_class limit 3;
