--index_skip_scan
drop if exists t1,t2;
CREATE TABLE t1 (id INT , a INT, b INT, c INT);
CREATE TABLE t2 (id INT , a INT, b INT, c INT);
CREATE INDEX i_t1_ac ON t1(a,c);
CREATE INDEX i_t2_ac ON t2(a,c);
INSERT INTO t1 select rownum, rownum, rownum, rownum FROM db_root connect by level<=100;
INSERT INTO t2 select id, a%5, b, c FROM t1;
drop if exists x;
CREATE TABLE x (id INT , a INT, b INT, c INT,d int ,e int,f int,g int);


insert into x select /*+ INDEX_SS(t1) */ * 
 FROM t1, t2
 WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
 USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 0+0,2-1;

select * from x order by 1,2,3,4,5,6,7,8;
insert into x select /*+ INDEX_SS */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 1, i_t2_ac keylimit 1;
select * from x order by 1,2,3,4,5,6,7,8;

insert into x select /*+ INDEX_SS */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 0,1, i_t2_ac keylimit 0,1;
select * from x order by 1,2,3,4,5,6,7,8;

insert into x select /*+ INDEX_SS */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keylimit 0,0+1;
select * from x order by 1,2,3,4,5,6,7,8;


insert into x select /*+ INDEX_SS(t1) */ * 
 FROM t1, t2
 WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
 USING INDEX i_t1_ac keylimit 0,1, i_t2_ac keyLIMIT 0,1;
select * from x order by 1,2,3,4,5,6,7,8;
 
 insert into x select /*+ INDEX_SS(t1) */ * 
 FROM t1, t2
 WHERE t1.b<5 AND t1.c<5 AND t2.c<5  
 USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 1;

select * from x order by 1,2,3,4,5,6,7,8;
insert into x select /*+ INDEX_SS */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac limit 0,0+1;
select * from x order by 1,2,3,4,5,6,7,8;

insert into x select /*+ INDEX_SS */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keylimit 0,0+1;
select * from x order by 1,2,3,4,5,6,7,8;

insert into x select /*+ INDEX_SS(t1) */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keyLIMIT 0+0,2-1;
select * from x order by 1,2,3,4,5,6,7,8;
insert into x select /*+ INDEX_SS(t1) */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keylimit 1, i_t2_ac keyLIMIT 0+0,2-1;
select * from x order by 1,2,3,4,5,6,7,8;
insert into x select /*+ INDEX_SS(t1) */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keyLIMIT 0+0,2-1, i_t2_ac keyLIMIT 0+0,2-1;
select * from x order by 1,2,3,4,5,6,7,8;

insert into x select /*+ INDEX_SS(t1, t2) */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac, i_t2_ac keyLIMIT 9-9,1*1;
select * from x order by 1,2,3,4,5,6,7,8;
insert into x select /*+ INDEX_SS(t1, t2) */ *
FROM t1, t2
WHERE t1.b<5 AND t1.c<5 AND t2.c<5
USING INDEX i_t1_ac keyLIMIT 9-9,1*1 , i_t2_ac keyLIMIT 9-9,1*1;
select * from x order by 1,2,3,4,5,6,7,8;
prepare stmt from 'insert into x select /*+ INDEX_SS(t1, t2) */ * 
FROM t1, t2 WHERE t1.b<5 AND t1.c<5 AND t2.c<5 
USING INDEX i_t1_ac keyLIMIT 9-9,1*1 , i_t2_ac keyLIMIT ?-?,?*?';
execute stmt using 9,9,1,1;
deallocate prepare stmt;
drop if exists t1,t2;
