--test length function with time type
select length(to_time('8:8:8 am')) from db_root order by 1;