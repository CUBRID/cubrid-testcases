--test to_time function with '1:00:00' and '1:00:00 am'
select to_time('1:00:00 ') from db_root;
select to_time('1:00:00 am') from db_root;
