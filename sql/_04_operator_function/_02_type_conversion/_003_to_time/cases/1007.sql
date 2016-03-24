--[er]test to_time function with '13:00:00 am'
select to_time('13:00:00 am') from db_root order by 1;