--test to_time function with '12:00:00 am'
select to_time('12:00:00 am') from db_root order by 1;