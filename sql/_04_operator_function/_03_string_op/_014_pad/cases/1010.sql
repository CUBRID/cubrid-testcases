--[er]test lpad, rpad with timestamp type
select lpad(to_timestamp('5/5/2005 8:8:8 am'), 16, 'c') from db_root;
select rpad(to_timestamp('5/5/2005 8:8:8 am'), 16, 'c') from db_root order by 1;