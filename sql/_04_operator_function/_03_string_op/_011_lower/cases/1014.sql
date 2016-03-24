--test lower function with upeer function
select lower(upper('aBc')) from db_root order by 1;