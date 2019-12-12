DROP IF EXISTS t;

CREATE TABLE t(c1 int, "int" int, "identity" int, "object" int, "none" int);
CREATE INDEX idx_t_c1 ON t(c1);
INSERT INTO t VALUES(1,2,3,4,5);

select t.int from t;
select t->int from t;
select t."int" from t;

select t.identity from t;
select t->identity from t;
select t."identity" from t;

select t.object from t;
select t->object from t;
select t."object" from t;

select * from t where c1=1 USING INDEX t.none;
select * from t where c1=1 USING INDEX t."none";
select t.none from t where c1=1;
select t->none from t where c1=1;
select t."none" from t where c1=1;

select t.* from t;

DROP IF EXISTS t;
