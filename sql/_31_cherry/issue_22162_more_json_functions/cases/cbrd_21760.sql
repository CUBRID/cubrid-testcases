drop table if exists t1;

CREATE TABLE t1 (a SET (json));
INSERT INTO t1 VALUES ({'{"A":1}'});

--CBRD-21760: fail(csql crashed)
--CBRD-23503: 
--NULL is expected here. CAS cannot treat a set has multiple domains, heterogeneous set.
--In csql, it returns '{{"A":1}, {"A":2}}'. 
select a + {'{"A": 2}'} from t1;  

select a + {json'{"A": 2}'} from t1;

--CBRD-23503
select {json'{"A": 2}'}+{json'{"B": 1}'};

select {'{"A": 2}'} + {'{"B": 1}'};

select a - {'{"A": 1}'} from t1;
select a - {json'{"A": 1}'} from t1;

drop table if exists t1;
