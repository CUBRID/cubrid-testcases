--no sort limit
DROP TABLE IF EXISTS u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);

CREATE INDEX i_u_j ON u(j);
INSERT INTO t values (1,1,1),(2,2,2);
INSERT INTO u values (NULL,1,1),(1,1,1),(2,2,2);
SELECT /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 0 ORDER BY u.j LIMIT 2;

--sort limit
DROP TABLE IF EXISTS u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int not null, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);

CREATE INDEX i_u_j ON u(j);
INSERT INTO t values (1,1,1),(2,2,2);
INSERT INTO u values (1,1,1),(1,1,1),(2,2,2);
SELECT /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 0 ORDER BY u.j LIMIT 2;

--sort limit
DROP TABLE IF EXISTS u,t;
CREATE TABLE t(i int PRIMARY KEY, j int, k int);
CREATE TABLE u(i int primary key, j int, k int);
ALTER TABLE u ADD constraint fk_t_u_i FOREIGN KEY(i) REFERENCES t(i);

CREATE INDEX i_u_j ON u(j);
INSERT INTO t values (1,1,1),(2,2,2);
INSERT INTO u values (1,1,1),(2,2,2);
SELECT /*+ RECOMPILE */ * FROM u, t WHERE u.i = t.i AND u.j > 0 ORDER BY u.j LIMIT 2;
DROP TABLE u,t;
