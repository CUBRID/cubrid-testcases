--test abs function with operators +,-,*,/
select abs(-28)+2 from db_root;
select abs(-28)-2 from db_root;
select abs(-28)*2 from db_root;
select abs(-28)/2 from db_root order by 1;