-- [er]create class and using GREATEST function with black para

create CLASS t (b string );
insert INTO t values ('22');

SELECT GREATEST() FROM t;

DROP t;
