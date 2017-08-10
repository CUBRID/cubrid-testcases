-- [er]create class and return chr function with attribute of string type

create CLASS t (a int,b string );
insert INTO t values (90,'22');


SELECT CHR(a),chr(b) from t;

DROP t;
