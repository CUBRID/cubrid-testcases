-- create class and using LEAST  function with string,attribute,time,null,and number

create CLASS t (b string );
insert INTO t values ('22');

SELECT LEAST ('str1', 'str2', 'str3') FROM t;

SELECT LEAST (b) FROM t;
SELECT LEAST (null,b) FROM t;
SELECT LEAST (null,123) FROM t;
SELECT LEAST (234,123) FROM t;
SELECT LEAST (sysdate,to_date('1000-10-10','yyyy-MM-dd')) FROM t;

SELECT LEAST (cast (20.00 as float) , cast (15.00 as numeric(4,2))) FROM t;

DROP t;
