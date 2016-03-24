drop table if exists t1,t2;

CREATE TABLE t1 (id1 int);
CREATE TABLE t2 (id2 int, id1 int);

INSERT INTO t1 values(1),(2),(3);
INSERT INTO t2 values(1,1), (2,1), (3,2), (4,2), (5,3);

--CUBRID doesn't support , MySQL supports.
SELECT
t1.id1,
group_concat(id2 order by id2) as grouped_ids
FROM
t1 INNER JOIN
t2 on t2.id1=t1.id1
GROUP BY
id1
ORDER BY
id1, grouped_ids;

--CUBRID supports , MySQL supports.
SELECT
t1.id1,
group_concat(id2 order by id2) as grouped_ids
FROM
t1 INNER JOIN
t2 on t2.id1=t1.id1
GROUP BY
t1.id1
ORDER BY
t1.id1, grouped_ids;

--CUBRID supports , MySQL supports.
SELECT
t1.id1,
group_concat(id2 order by id2) as grouped_ids
FROM
t1 INNER JOIN
t2 on t2.id1=t1.id1
GROUP BY
t2.id1
ORDER BY
t2.id1, grouped_ids;

drop table if exists t1,t2;
