drop table if exists t1;

CREATE  TABLE  t1 (a int , b INT);
INSERT  INTO t1  VALUES (1, 1);

--test:below will throw error
SELECT 
    tb.a, 
        (SELECT MAX(ta.b + tb.a) ta_col FROM t1 ta GROUP BY ta.a ) tb_col
        FROM t1 tb
        GROUP BY tb.a;
drop table if exists t1;
