--test lpad, rpad with set type
select lpad('{1,2,3}', 10, 'a') from db_root;
select rpad('{1,2,3}', 10, 'b' ) from db_root order by 1;