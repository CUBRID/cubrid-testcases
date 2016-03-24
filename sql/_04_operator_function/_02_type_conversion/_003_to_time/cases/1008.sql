--test to_time function with '13:00:00 am' and '1:00:00 pm'
select to_time('1:00:00 pm') from db_root;
select to_time('13:00:00 pm') from db_root;
