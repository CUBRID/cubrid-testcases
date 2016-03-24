--test lpad, rpad with null
select lpad(null, 6, 'c') from db_root;
select lpad('aaa', 6, null) from db_root;
select lpad('aaa', null, 'c') from db_root;
select lpad(null, null, null) from db_root;

select rpad(null, 6, 'c') from db_root;
select rpad('aaa', 6, null) from db_root;
select rpad('aaa', null, 'c') from db_root;
select rpad(null, null, null) from db_root order by 1;