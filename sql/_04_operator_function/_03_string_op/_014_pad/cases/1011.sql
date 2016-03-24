--[er]test lpad, rpad function and its order of operand was wrong
select lpad('aaa', 'c', 16) from db_root;
select rpad('aaa', 'c', 16) from db_root;

select lpad(16, 'aaa', 'c') from db_root;
select rpad(16, 'aaa', 'c') from db_root;
