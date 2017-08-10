create table t1
(
id1 CHARACTER VARYING(20) NOT NULL,
id2 CHARACTER VARYING(20) NOT NULL,
id3 CHARACTER VARYING(20) NOT NULL,
s SMALLINT NOT NULL,
c CHARACTER VARYING(300),
c1 CHARACTER VARYING(100) NOT NULL,
c2 CHARACTER VARYING(100),
c3 CHARACTER VARYING(100),
c4 CHARACTER VARYING(100),
yn CHARACTER VARYING(1) NOT NULL,
id4 CHARACTER VARYING(20),
ts1 TIMESTAMP,
id5 CHARACTER VARYING(20),
ts2 TIMESTAMP
);

UPDATE /* updateCateUseNotStartCate */ t1
SET yn = 'N',
id5 = '',
ts2 = systimestamp
WHERE id1 IN(SELECT ID
FROM (SELECT rownum,id1 AS ID,
id2 AS prnt_id,
s,
yn
FROM t1
) t
WHERE yn = 'Y'
START WITH ID = 'COSC000002'
CONNECT BY NOCYCLE PRIOR ID = prnt_id
ORDER SIBLINGS BY s);

UPDATE /* updateCateUseNotStartCate */ t1
SET yn = 'N',
id5 = '',
ts2 = systimestamp
WHERE id1 IN(SELECT ID
FROM (SELECT rownum,id1 AS ID,
id2 AS prnt_id,
s,
yn
FROM t1
) t
WHERE yn = 'Y'
);


UPDATE /*+ RECOMPILE updateCateUseNotStartCate */ t1
SET yn = 'N',
id5 = '',
ts2 = systimestamp
WHERE id1 in (
  SELECT id
  FROM (
    SELECT ID, s
    FROM (
      SELECT rownum,id1 AS ID,
      id2 AS prnt_id,
      s,
      yn
      FROM t1
      UNION ALL
      SELECT rownum,id1 AS ID,
      id2 AS prnt_id,
      s,
      yn
      FROM t1
    ) t
    WHERE yn = 'Y'
    START WITH ID = 'COSC000002'
    CONNECT BY NOCYCLE PRIOR ID = prnt_id
    ORDER SIBLINGS BY s
  ) tt
);
drop table t1;
