--[er]test lpad, rpad with time type
select lpad(to_time('8:8:8 am'), 16, 'c') from db_root;
select rpad(to_time('8:8:8 am'), 16, 'c') from db_root order by 1;