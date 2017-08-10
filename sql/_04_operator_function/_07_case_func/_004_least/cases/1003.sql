-- [er]create class and using LEAST  function with differente type

create CLASS t (b string );
insert INTO t values ('22');

SELECT LEAST (b,123) FROM t;
SELECT LEAST (sysdate,123) FROM t;

DROP t;

