-- [er]create class and using length function with non-exisiting attribute

create CLASS t (b string );
insert INTO t values ('22');

SELECT length(a) from t;


DROP t;
