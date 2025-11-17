-- Verification for CBRD-26257 and CBRD-26313
-- Issue summary:
--   CBRD-26257 : Extends view-merge optimization to include the BETWEEN operator.
--   CBRD-26313 : Fixes an issue where view-merge was applied even when
--                   additional filters existed beyond the ROWNUM condition.
--                   (Only test case #2 applies to this issue.)
-- Note:
--   - Only CBRD-26313 is included in the 11.3.4 backport.
--   - The rest of the test cases belong to CBRD-26257 (feature extension).

drop table if exists ta;
create table ta(cola int, colb int);
insert into ta select rownum,rownum from db_class a, db_class b limit 1000;

evaluate '1. Range condition using AND';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn >= 0 + 1 AND rn <= 0 + 10;

-- [CBRD-26313] Case: View-merge applied with extra filter beyond ROWNUM condition.
evaluate '2. Condition with additional filters (excluding ROWNUM)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn >= 0 + 1 AND rn <= 0 + 10 AND colb % 2 = 0;

evaluate '3. BETWEEN expression (constant + arithmetic)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn BETWEEN 0 + 1 AND 0 + 10;

evaluate '4. Basic BETWEEN with constant range';
SELECT /*+ recompile */  * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 1 AND 10;

evaluate '5. Single-row range (BETWEEN same values)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 100 AND 100;

evaluate '6. BETWEEN including NULL';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN NULL AND 10;

evaluate '7. Combined with additional condition (filter first)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE colb % 2 = 0 AND rn BETWEEN 51 AND 60;

evaluate '8. Combined with additional condition (between first)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 51 AND 60 AND colb % 2 = 0;

evaluate '9. Two BETWEEN predicates (ROWNUM + column)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE rn BETWEEN 11 AND 20 AND cola BETWEEN 15 AND 18;

evaluate '10. BETWEEN in WHERE + HAVING (groupby_num)';
SELECT /*+ recompile */ cola FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE rn BETWEEN 1 AND 20 GROUP BY cola DESC HAVING groupby_num() BETWEEN 2 AND 4;

evaluate '11. Reversed BETWEEN boundaries';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 10 AND 1;

evaluate '12. BETWEEN with negative and positive range';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN -5 and 5;

evaluate '13. BETWEEN combined with OR condition';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 1 AND 10 OR colb BETWEEN 50 AND 60;

drop table if exists tb;
create table tb (
  k int primary key
);
insert into tb select rownum from db_class limit 1000;

evaluate '14. BETWEEN with join';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select ta.* from ta inner join tb on ta.cola = tb.k order by ta.cola) a) Z WHERE rn BETWEEN 1 AND 10;

evaluate '15. BETWEEN with expressions instead of constants';
SELECT /*+ recompile */ * 
FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z 
WHERE rn BETWEEN (select min(k) from tb) AND (select max(k) from tb);

evaluate '16. Prepared statement with AND range';
prepare sa from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn >= ? AND rn <= ?';
--@queryplan
execute sa using 1, 10;
deallocate prepare sa;

evaluate '17. Prepared statement with BETWEEN expression';
prepare sb from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn BETWEEN ? AND ?';
--@queryplan
execute sb using 1, 10;
deallocate prepare sb;

evaluate '18. Prepared statement with BETWEEN + additional filter';
prepare sc from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn BETWEEN ? AND ? AND colb % 2 = 0';
--@queryplan
execute sc using 51, 60;
deallocate prepare sc;

drop table if exists ta;
drop table if exists tb;
