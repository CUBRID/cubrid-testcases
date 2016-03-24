--test length function with timestamp type
select length(to_timestamp('5/5/2005 8:8:8 am')) from db_root order by 1;