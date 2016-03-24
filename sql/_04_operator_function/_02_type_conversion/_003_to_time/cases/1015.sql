--[er]test to_time function with set type
select to_time({1,2,3}) from db_root order by 1;