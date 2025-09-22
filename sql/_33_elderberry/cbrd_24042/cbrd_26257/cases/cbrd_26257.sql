-- Verification for CBRD-26257
-- View-merge optimization is restricted when using the BETWEEN operator.
-- In Oracle-style partial range processing, view-merge is applied,
-- but BETWEEN was previously excluded. This test verifies that
-- BETWEEN is now included in the optimization.

drop table if exists ta;
create table ta(cola int, colb int);
insert into ta select rownum,rownum from db_class a, db_class b limit 1000;

evaluate '1. Range condition using AND';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn >= 0 + 1 AND rn <= 0 + 10;

evaluate '2. BETWEEN expression (constant + arithmetic)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn BETWEEN 0 + 1 AND 0 + 10;

evaluate '3. Basic BETWEEN with constant range';
SELECT /*+ recompile */  * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 1 AND 10;

evaluate '4. Range with a single row';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 100 AND 100;

evaluate '5. BETWEEN including NULL';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN NULL AND 10;

evaluate '6. Combined with additional condition (AND)';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 51 AND 60 AND colb % 2 = 0;

drop table if exists tb;
create table tb (k int primary key);
insert into tb select rownum from db_class limit 1000;

evaluate '7. BETWEEN with join';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select ta.* from ta inner join tb on ta.cola = tb.k order by ta.cola) a) Z WHERE rn BETWEEN 1 AND 10;

drop table if exists ta;
drop table if exists tb;
