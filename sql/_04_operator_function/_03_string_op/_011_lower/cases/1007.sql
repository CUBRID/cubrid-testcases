--test lower function with time type
select lower(to_time('10:10:10 am')) from db_root order by 1;