-- create class and using GREATEST function with string,attribute,time,null,and number

create CLASS t (b string );
insert INTO t values ('22');

SELECT GREATEST('str1', 'str2', 'str3') FROM t;

SELECT GREATEST(b) FROM t;
SELECT GREATEST(null,b) FROM t;
SELECT GREATEST(null,123) FROM t;
SELECT GREATEST(234,123) FROM t;
SELECT GREATEST('01/01/2000',to_date('1000-10-10','yyyy-MM-dd')) FROM t;

SELECT GREATEST(cast (20.00 as float) , cast (15.00 as numeric(4,2))) FROM t;

DROP t;
