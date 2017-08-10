-- [er]create class and using GREATEST function with differente type

create CLASS t (b string );
insert INTO t values ('22');

SELECT GREATEST(b,123) FROM t;
SELECT GREATEST(sysdate,123) FROM t;

DROP t;

