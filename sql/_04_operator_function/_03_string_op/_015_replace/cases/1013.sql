--test replace with upper, lower function
select replace('abc', lower('AB'), '90') from db_root;
select replace('ABC', upper('ab'), '32') from db_root;
