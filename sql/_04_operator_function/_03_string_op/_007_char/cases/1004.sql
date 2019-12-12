-- create class and return chr function with attribute of number type

create CLASS t (a int);
insert INTO t values (100);


SELECT CHR(a) from t;

DROP t;
