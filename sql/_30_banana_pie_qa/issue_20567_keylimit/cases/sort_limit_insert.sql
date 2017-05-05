drop if exists u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);
CREATE INDEX i_u_j ON u(j);
INSERT INTO t select ROWNUM, ROWNUM, ROWNUM FROM db_root connect by level<=1000;
INSERT INTO u select 1+(ROWNUM % 1000), ROWNUM, ROWNUM FROM db_root connect by level<=5000;

drop if exists x;
CREATE TABLE x(i int, j int, k int,l int,m int,n int);

insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 0, 5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-2,5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-1,5*1;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-1,10/2;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 0, 5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-2,5;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-1,5*1;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 ORDER BY u.j LIMIT 2-1,10/2;
select * from x order by 1,2,3,4,5,6;
insert into x select /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 10 using index i_u_j keyLIMIT 2-1,10/2;
select * from x order by 1,2,3,4,5,6;
select count(*) from x;

drop if exists u,t,x;
