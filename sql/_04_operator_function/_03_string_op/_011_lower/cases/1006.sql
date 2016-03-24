--test lower function with date type
select lower(to_date('1/1/2001')) from db_root order by 1;