--[er]test upper function with timestamp type
select upper(to_timestamp('3/3/2003 3:3:3 am')) from db_root order by 1;