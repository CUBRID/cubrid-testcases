drop table if exists tab0;
drop table if exists tab1;

CREATE TABLE tab0(a INTEGER);
INSERT INTO tab0 VALUES(0);
CREATE TABLE tab1(a INTEGER);
INSERT INTO tab1 VALUES(1);
select * from ((select * from tab1) as tab11), tab0;

drop table if exists tab0;
drop table if exists tab1;
