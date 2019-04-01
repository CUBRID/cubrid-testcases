
create table select_t1 (nr int primary key not null auto_increment, b blob, c clob, str varchar(10) );
insert into select_t1 values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into select_t1 values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into select_t1 values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');

--1 test of FULL JOIN with blob/clob;
select * from select_t1, select_t1 as select_t1 order by select_t1.nr,t2.nr;
--2 test LIKE/NOT LIKE predicate;
select * from select_t1 where c = 'aaa';
select * from select_t1 where b = X'10111';
select nr, str from select_t1 where c like char_to_clob('aaa');
select nr, str from select_t1 where c like char_to_clob('aaa%');
select * from select_t1 where b like bit_to_blob(X'10111');
select * from select_t1 where b like bit_to_blob(X'10111%');
select nr, str from select_t1 where c not like char_to_clob('aaa') order by 1;
select nr, str from select_t1 where c not like char_to_clob('aaa%') order by 1;
select * from select_t1 where b not like bit_to_blob(X'10111');
select * from select_t1 where b not like bit_to_blob(X'10111%');
-- 3 test ORDER BY on blob/clob column;
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 order by str;
select * from select_t1 order by b;
select * from select_t1 order by c;
-- 4 test DISTINCT / UNIQUE /DISTINCTROW on blob/clob column;
select distinct str from select_t1 order by 1;
select distinct blob_to_bit(b) from select_t1 order by 1;
select distinct clob_to_char(c) from select_t1 order by 1;

select DISTINCTROW str from select_t1 order by 1;
select DISTINCTROW blob_to_bit(b) from select_t1 order by 1;
select DISTINCTROW clob_to_char(c) from select_t1 order by 1;
-- 5 test GROUP BY on blob/clob column;
select str from select_t1 group by str order by 1;
select str,count(*) from select_t1 group by str order by 1;
select b from select_t1 group by b;
select c from select_t1 group by c;
-- 6 test UNION ALL / UNION 
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1
union all 
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 order by nr; 
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1
UNION 
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1
UNION 
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 order by nr;

-- 7 select ALL + where condition with blob column
select all nr,blob_to_bit(b),clob_to_char(c),str from select_t1 order by 1; 
select all all nr,blob_to_bit(b),clob_to_char(c),str from select_t1;
select all distinct nr,blob_to_bit(b),clob_to_char(c),str from select_t1;
select ALL distinct nr,blob_to_bit(b),clob_to_char(c),str from select_t1;
select ALL nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where blob=char_to_clob('aaa');


-- 8 AVG;MAX;MIN;SUM;COUNT;
select avg(b) from select_t1;
select avg(c) from select_t1;
select max(b) from select_t1;
select max(c) from select_t1;
select min(b) from select_t1;
select min(c) from select_t1;
select sum(b) from select_t1;
select sum(c) from select_t1;
select count(b) from select_t1;
select count(c) from select_t1;

-- 9 subquery in FROM clause
select nr,blob_to_bit(b),clob_to_char(c),str,blob_to_bit(bb) from select_t1 , (select b from select_t1 )  as t(bb) order by 1,2,3,5;
--   subquery in SELECT clause
select nr,(select blob_to_bit(b) from select_t1 where nr=2) as tempb from select_t1 where nr=1;
--   subquery in WHERE clause
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where b = (select b from select_t1 where nr=1);
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where b in (select b from select_t1 where nr=1);
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where b in (select blob_to_bit(b) from select_t1 where nr=1);
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where blob_to_bit(b) in (select blob_to_bit(b) from select_t1 where nr=1);

-- 10 EXISTS clause in where.
select nr,blob_to_bit(b),clob_to_char(c),str from select_t1 where exists (select * from select_t1 where rownum=2) order by 1,2,3;
-- 11 select + where codition with >, <, >=, <= operators
select * from select_t1 where b > 10;
select * from select_t1 where b < 10;
select * from select_t1 where b = 10;
select * from select_t1 where b >= 10;
select * from select_t1 where b <= 10;
select * from select_t1 where c > 10;
select * from select_t1 where c < 10;
select * from select_t1 where c = 10;
select * from select_t1 where c >= 10;
select * from select_t1 where c <= 10;

-- 12  using HINT int select clause.
create index idx1 on select_t1(nr desc);
select /*+ USE_IDX */ nr,blob_to_bit(b),clob_to_char(c),str from select_t1 order by nr; 

delete from select_t1;
drop select_t1;





