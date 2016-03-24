--test replace function with empty character ''
select replace('aaa','','c') from db_root;
select replace('aaa','a','') from db_root;
select replace('','','') from db_root order by 1;