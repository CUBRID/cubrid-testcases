-- Test duplication error when all values in partition condition are equal

-- scenario1
drop table if exists t3;
CREATE TABLE t3 (a CHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
PARTITION a1 VALUES IN (_utf8'AEäÄ'),
PARTITION a2 VALUES IN (_utf8'ääÄ'),
PARTITION a3 VALUES IN (_utf8'ÄÄAE')
);
drop table if exists t3;

--scenario2
CREATE TABLE t3 (a CHAR(10), b int) collate utf8_de_exp_ai_ci
PARTITION BY LIST (a) (
PARTITION a1 VALUES IN (_utf8'AEAE'),
PARTITION a2 VALUES IN (_utf8'aeae')
);
drop table if exists t3;
