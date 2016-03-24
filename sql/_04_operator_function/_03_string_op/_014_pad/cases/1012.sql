--test lpad, rpad with nchar type
select lpad(n'hello', 10, n'abc' ) from db_root;
select rpad(n'hello', 10, n'abc' ) from db_root;
