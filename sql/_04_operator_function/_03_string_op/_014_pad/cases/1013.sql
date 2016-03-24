--test lpad, rpad with bit type
select lpad(b'0001', 10, b'01' ) from db_root;
select rpad(b'0001', 10, b'01' ) from db_root order by 1;