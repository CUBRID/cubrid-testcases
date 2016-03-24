--[er]test chr function with timestamp type
select CHR(to_timestamp('5/5/2005 8:8:8 am')) from db_root order by 1;