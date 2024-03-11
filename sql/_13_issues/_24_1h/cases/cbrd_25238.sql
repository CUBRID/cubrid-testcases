-- This test case verifies CBRD-25238 issue.
-- It checks for the problem with outer joined views being merged.

drop table if exists a_test;
drop table if exists a_test_prof;
drop table if exists a_test_mbr;

CREATE TABLE a_test (seq int, title varchar(100));
CREATE TABLE a_test_prof (seq int, sno int, title varchar(100));
CREATE TABLE a_test_mbr (sno int, name varchar(100));


select 'left outer join where a subquery is used as the join condition.';
--@queryplan
SELECT /*+ recompile */ *
 FROM (
SELECT a.seq, (SELECT MAX(sno) FROM a_test_prof x WHERE x.seq = a.seq) AS prof_sno
   FROM a_test a
 ) a
,a_test_mbr c
WHERE  a.prof_sno = c.sno(+);

-- ANSI
--@queryplan
SELECT /*+ recompile */ *
FROM (
    SELECT a.seq, (SELECT MAX(sno) FROM a_test_prof x WHERE x.seq = a.seq) AS prof_sno
    FROM a_test a
) AS a
LEFT JOIN a_test_mbr c ON a.prof_sno = c.sno;


select 'right outer join where a subquery is used as the join condition.';
--@queryplan
SELECT /*+ recompile */ *
 FROM (
SELECT a.seq, (SELECT MAX(sno) FROM a_test_prof x WHERE x.seq = a.seq) AS prof_sno
   FROM a_test a
 ) a
,a_test_mbr c
WHERE  a.prof_sno (+) = c.sno;

-- ANSI
--@queryplan
SELECT /*+ recompile */ *
FROM (
    SELECT a.seq, (SELECT MAX(sno) FROM a_test_prof x WHERE x.seq = a.seq) AS prof_sno
    FROM a_test a
) AS a
RIGHT JOIN a_test_mbr c ON a.prof_sno = c.sno;


drop a_test;
drop a_test_prof;
drop a_test_mbr;
