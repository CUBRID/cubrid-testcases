--test floor function with operators +,-,*,/
select floor(-28)+2 from db_root;
select floor(-28)-2 from db_root;
select floor(-28)*2 from db_root;
select floor(-28)/2 from db_root order by 1;