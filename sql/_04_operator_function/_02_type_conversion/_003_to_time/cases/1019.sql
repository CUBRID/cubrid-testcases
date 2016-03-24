--[er]test to_time function with time type
select to_time(time'1:1:1 am') from db_root order by 1;