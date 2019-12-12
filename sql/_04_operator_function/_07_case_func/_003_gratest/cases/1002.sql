-- create class and using GREATEST function with case function

create CLASS t (b string );
insert INTO t values ('22');

SELECT GREATEST(cast (20.00 as float) , cast (15.00 as numeric(4,2))) FROM t;

DROP t;
