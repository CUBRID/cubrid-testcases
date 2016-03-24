--test sign function with normal use 
select sign(-3) from db_root;
select sign(3) from db_root;
select sign(0) from db_root;

select sign(-3.88) from db_root;
select sign(3.66) from db_root;
select sign(0.00) from db_root;

select sign(null) from db_root order by 1;