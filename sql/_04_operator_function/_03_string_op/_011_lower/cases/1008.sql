--[er]test lower function with timestamp type
select lower(to_timestamp('10:10:10 am')) from db_root order by 1;