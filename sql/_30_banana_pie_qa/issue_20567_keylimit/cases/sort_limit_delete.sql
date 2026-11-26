drop if exists u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);
CREATE INDEX i_u_j ON u(j);
INSERT INTO t SELECT ROWNUM, ROWNUM, ROWNUM FROM db_root connect by level<=100;
INSERT INTO u SELECT 1+(ROWNUM % 100), ROWNUM, ROWNUM FROM db_root connect by level<=100;
select * from u WHERE  u.j > 10 order by 1,2,3 limit 10;
drop if exists u,t;
