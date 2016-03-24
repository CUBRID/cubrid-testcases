--[er]test to_time function with timestamp type
select to_time(timestamp'1/1/2001 1:1:1 am') from db_root order by 1;