--[er]test to_time function with '24:00:00 am'
select to_time('24:00:00 am') from db_root order by 1;