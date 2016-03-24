--[er]test lpad, rpad with date type
select lpad(to_date('5/5/2005'), 16, 'c') from db_root;
select rpad(to_date('5/5/2005'), 16, 'c') from db_root;
