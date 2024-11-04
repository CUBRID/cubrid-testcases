--+ holdcas on;
drop table if exists t1;
drop table if exists t2;
CREATE TABLE t1 (a int);
insert into t1 values (1), (2), (3), (4), (5);
CREATE TABLE t2 (a int);
insert into t2 values (1), (2), (6), (7);

-- union 
---- 5 count
SELECT * FROM ((SELECT * FROM t1 ) UNION (SELECT * FROM t1));
---- 5 count
SELECT * FROM ( SELECT * FROM t1 WHERE 'test' = 'test1' UNION SELECT * FROM t1 );
---- 5 count
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1);
---- 5 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION (SELECT * FROM t1));
---- 5 count
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 5 count
SELECT * FROM ((SELECT * FROM t1) UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ((SELECT * FROM t1 WHERE 'test' = 'test1')));
---- 6 count
SELECT * FROM ((SELECT 10 ) UNION (SELECT * FROM t1));
---- 1 count
SELECT * FROM ((SELECT 10 ) UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 6 count
SELECT * FROM ((SELECT * FROM t1) UNION (SELECT 10 ));
---- 1 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION (SELECT 10 ));


-- union all
---- 10 count
SELECT * FROM ((SELECT * FROM t1 ) UNION ALL (SELECT * FROM t1));
---- 5 count
SELECT * FROM ( SELECT * FROM t1 WHERE 'test' = 'test1' UNION ALL SELECT * FROM t1 );
---- 5 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1);
---- 5 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ALL (SELECT * FROM t1));
---- 5 count
SELECT * FROM (SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 5 count
SELECT * FROM ((SELECT * FROM t1) UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ALL ((SELECT * FROM t1 WHERE 'test' = 'test1')));
---- 6 count
SELECT * FROM ((SELECT 10 ) UNION ALL (SELECT * FROM t1));
---- 1 count
SELECT * FROM ((SELECT 10 ) UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 6 count
SELECT * FROM ((SELECT * FROM t1) UNION ALL (SELECT 10 ));
---- 1 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ALL (SELECT 10 ));

-- intersection
---- 2 count
SELECT * FROM ((SELECT * FROM t1 ) INTERSECTION (SELECT * FROM t2));
---- 0 count
SELECT * FROM ( SELECT * FROM t1 WHERE 'test' = 'test1' INTERSECTION SELECT * FROM t2 );
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t2);
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION (SELECT * FROM t2));
---- 2 count
SELECT * FROM ((SELECT * FROM t2 ) INTERSECTION (SELECT * FROM t1));
---- 0 count
SELECT * FROM (SELECT * FROM t2 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 0 count
SELECT * FROM ((SELECT * FROM t2) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 0 count
SELECT * FROM ((SELECT * FROM t2 WHERE 'test' = 'test1') INTERSECTION ((SELECT * FROM t1 WHERE 'test' = 'test1')));
---- 1 count
SELECT * FROM ((SELECT 1 ) INTERSECTION (SELECT * FROM t1));
---- 0 count
SELECT * FROM ((SELECT 1 ) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 1 count
SELECT * FROM ((SELECT * FROM t1) INTERSECTION (SELECT 1 ));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION (SELECT 1 ));
---- 0 count
SELECT * FROM ((SELECT 10 ) INTERSECTION (SELECT * FROM t1));
---- 0 count
SELECT * FROM ((SELECT 10 ) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 0 count
SELECT * FROM ((SELECT * FROM t1) INTERSECTION (SELECT 10 ));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION (SELECT 10 ));


-- difference
---- 3 count
SELECT * FROM ((SELECT * FROM t1 ) DIFFERENCE (SELECT * FROM t2));
---- 0 count
SELECT * FROM ( SELECT * FROM t1 WHERE 'test' = 'test1' DIFFERENCE SELECT * FROM t2 );
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t2);
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE (SELECT * FROM t2));
---- 2 count
SELECT * FROM ((SELECT * FROM t2 ) DIFFERENCE (SELECT * FROM t1));
---- 4 count
SELECT * FROM (SELECT * FROM t2 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY 1;
---- 4 count
SELECT * FROM ((SELECT * FROM t2) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY 1;
---- 0 count
SELECT * FROM ((SELECT * FROM t2 WHERE 'test' = 'test1') DIFFERENCE ((SELECT * FROM t1 WHERE 'test' = 'test1')));
---- 0 count
SELECT * FROM ((SELECT 1 ) DIFFERENCE (SELECT * FROM t1));
---- 1 count
SELECT * FROM ((SELECT 1 ) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 4 count
SELECT * FROM ((SELECT * FROM t1) DIFFERENCE (SELECT 1 ));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE (SELECT 1 ));
---- 1 count
SELECT * FROM ((SELECT 10 ) DIFFERENCE (SELECT * FROM t1));
---- 1 count
SELECT * FROM ((SELECT 10 ) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
---- 5 count
SELECT * FROM ((SELECT * FROM t1) DIFFERENCE (SELECT 10 ));
---- 0 count
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE (SELECT 10 ));


-- UNION test order by
---- output DESC
SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc;
---- output DESC
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc);
---- output ASCE
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1' ORDER BY t1.a desc));
---- Report Error
SELECT * FROM (SELECT * FROM t1 ORDER BY t1.a desc UNION (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
---- output DESC
SELECT * FROM ((SELECT * FROM t1 ORDER BY t1.a desc) UNION (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
---- output DESC
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY a desc;

---- output DESC
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1 ORDER BY a desc);
---- output DESC
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1) ORDER BY a desc;

---- error report, invalid relational operator
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1 ORDER BY a asce) ORDER BY a desc;

---- output DESC
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1 ORDER BY a desc) ORDER BY a desc;

---- output DESC
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc limit 1);
---- output DESC
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1 ORDER BY a desc limit 1);

---- output DESC
SELECT * FROM (SELECT * FROM t1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);
---- output DESC
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1 ORDER BY a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);

---- UNION ALL test order by
SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc;
SELECT * FROM (SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc);
SELECT * FROM (SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1' ORDER BY t1.a desc));
SELECT * FROM (SELECT * FROM t1 ORDER BY t1.a desc UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM ((SELECT * FROM t1 ORDER BY t1.a desc) UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM (SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY a desc;

SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1 ORDER BY a desc);
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1 ORDER BY a asce) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1 ORDER BY a desc) ORDER BY a desc;

SELECT * FROM (SELECT * FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc limit 1);
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1 ORDER BY a desc limit 1);
SELECT * FROM (SELECT a FROM t1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1 ORDER BY a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);


---- INTERSECTION test order by
SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc;
SELECT * FROM (SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc);
SELECT * FROM (SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1' ORDER BY t1.a desc));
SELECT * FROM (SELECT * FROM t1 ORDER BY t1.a desc  INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM ((SELECT * FROM t1 ORDER BY t1.a desc) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM (SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY a desc;

SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1 ORDER BY a desc);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1 ORDER BY a asce) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1 ORDER BY a desc) ORDER BY a desc;

SELECT * FROM (SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc limit 1);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1 ORDER BY a desc limit 1);
SELECT * FROM (SELECT * FROM t1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1 ORDER BY a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);


---- DIFFERENCE test order by
SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc;
SELECT * FROM (SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc);
SELECT * FROM (SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1' ORDER BY t1.a desc));
SELECT * FROM (SELECT * FROM t1 ORDER BY t1.a desc  DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM ((SELECT * FROM t1 ORDER BY t1.a desc) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1')) ;
SELECT * FROM (SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1')) ORDER BY a desc;

SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1 ORDER BY a desc);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1 ORDER BY a asce) ORDER BY a desc;
SELECT * FROM ((SELECT a FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1 ORDER BY a desc) ORDER BY a desc;

SELECT * FROM (SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc limit 1);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1 ORDER BY a desc limit 1);
SELECT * FROM (SELECT * FROM t1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1') ORDER BY t1.a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);
SELECT * FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1 ORDER BY a desc FOR ORDERBY_NUM() BETWEEN 1 AND 3);


-- UNION INTO 
SELECT * INTO v1 FROM t1 limit 1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1');
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * FROM (SELECT * INTO v1 FROM t1 limit 1 UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION SELECT * FROM t1) limit 1;
SELECT v1;

-- UNION ALL INTO 
SELECT * INTO v1 FROM t1 limit 1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1');
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * FROM (SELECT * INTO v1 FROM t1 limit 1 UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;

SELECT * INTO v1 FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') UNION ALL SELECT * FROM t1) limit 1;
SELECT v1;

-- INTERSECTION INTO 
SELECT * INTO v1 FROM t1 limit 1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1');
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * FROM (SELECT * INTO v1 FROM t1 limit 1 INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') INTERSECTION SELECT * FROM t1) limit 1;
SELECT v1;

-- DIFFERENCE INTO 
SELECT * INTO v1 FROM t1 limit 1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1');
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * INTO v1 FROM (SELECT * FROM t1 limit 1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;
SELECT * FROM (SELECT * INTO v1 FROM t1 limit 1 DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
SELECT v1;

SELECT * INTO v1 FROM ((SELECT * FROM t1 WHERE 'test' = 'test1') DIFFERENCE SELECT * FROM t1) limit 1;
SELECT v1;

-- UNION EVAL
SELECT * FROM ((SELECT 20 * 2 ) UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SET @v1 = 50;
SELECT a FROM ((SELECT @v1 as a ) UNION (SELECT * FROM t1 WHERE 'test' = 'test1'));

prepare prepare_stmt FROM 'SELECT a FROM ((SELECT ? as a)) UNION (select * from t1 where 0=1)';
execute prepare_stmt using 30;
deallocate prepare prepare_stmt;

-- UNION ALL EVAL
SELECT * FROM ((SELECT 20 * 2 ) UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));
SET @v1 = 50;
SELECT * FROM ((SELECT @v1 as a ) UNION ALL (SELECT * FROM t1 WHERE 'test' = 'test1'));

prepare prepare_stmt FROM 'SELECT a FROM ((SELECT ? as a)) UNION ALL (select * from t1 where 0=1)';
execute prepare_stmt using 30;
deallocate prepare prepare_stmt;

-- INTERSECTION EVAL
SELECT * FROM ((SELECT 20 * 2 ) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));
SET @v1 = 50;
SELECT * FROM ((SELECT @v1 as a ) INTERSECTION (SELECT * FROM t1 WHERE 'test' = 'test1'));

-- error happened, because INTERSECTION return null, can not be prepared
prepare prepare_stmt FROM 'SELECT a FROM ((SELECT ? as a)) INTERSECTION (select * from t1 where 0=1)';
deallocate prepare prepare_stmt;
-- execute prepare_stmt using 30;

-- DIFFERENCE EVAL
SELECT * FROM ((SELECT 20 * 2 ) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));
SET @v1 = 50;
SELECT * FROM ((SELECT @v1 as a ) DIFFERENCE (SELECT * FROM t1 WHERE 'test' = 'test1'));

prepare prepare_stmt FROM 'SELECT a FROM ((SELECT ? as a)) DIFFERENCE (select * from t1 where 0=1)';
execute prepare_stmt using 30;
deallocate prepare prepare_stmt;
drop variable @v1;

drop table if exists t1;
drop table if exists t2;

--+ holdcas off;
