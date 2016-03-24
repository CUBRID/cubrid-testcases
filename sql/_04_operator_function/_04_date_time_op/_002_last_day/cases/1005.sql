--tests last_day with numeric type
select last_day(10.106) from db_root;
select last_day(-10.106) from db_root order by 1;