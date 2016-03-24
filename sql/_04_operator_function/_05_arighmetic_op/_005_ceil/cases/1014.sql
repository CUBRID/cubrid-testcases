--test ceil function with operators +,-,*,/
select ceil(-28)+2 from db_root;
select ceil(-28)-2 from db_root;
select ceil(-28)*2 from db_root;
select ceil(-28)/2 from db_root order by 1;