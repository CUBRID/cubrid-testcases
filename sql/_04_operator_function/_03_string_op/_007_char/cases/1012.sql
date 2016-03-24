--[er]test chr function with time type
select CHR(to_time('8:8:8 am')) from db_root order by 1;