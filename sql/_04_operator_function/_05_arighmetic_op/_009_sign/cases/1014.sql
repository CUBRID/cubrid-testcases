--test sign function with operators +,-,*,/
select sign(-100)*1 from db_root;
select sign(-100)-1 from db_root;
select sign(-100)+1 from db_root;
select sign(-100)/1 from db_root order by 1;