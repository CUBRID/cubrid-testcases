drop table if exists vc_tb1;
drop table if exists vc_tb2;
drop vclass if exists vtb1;
drop vclass if exists vtb2;

create table vc_tb1(a int, b blob,c clob);

insert into vc_tb1 values (1, bit_to_blob(B'10010'), char_to_clob('1abcdef'));

insert into vc_tb1 values (2, bit_to_blob(B'10011'), char_to_clob('2cefabc'));

create table vc_tb2(a int, b blob,c clob);

insert into vc_tb2 values (1, bit_to_blob(B'10010'), char_to_clob('1abcdef'));

insert into vc_tb2 values (4, bit_to_blob(B'10011'), char_to_clob('4cefabc'));

create vclass vtb1(
a int,
b blob,
c clob
) as select * from vc_tb1 where a>=1 union select * from vc_tb2 where a<=4;

create vclass vtb2(
a int,
b blob,
c clob
) as select * from vc_tb1 where a>=1 union all select * from vc_tb2 where a<4;

WITH cte_i36m AS (select a,blob_to_bit(b),clob_to_char(c) from vtb1 order by 1) select * from cte_i36m order by 1,2,3;

drop table if exists t21;
drop table if exists t22;
CREATE TABLE t21 (c1 INT, c2 INT);

CREATE TABLE t22 (d1 INT, d2 INT);
drop view  if exists v2;
INSERT INTO t21 VALUES (1,1);

INSERT INTO t21 VALUES (1,2);

INSERT INTO t21 VALUES (1,3);

INSERT INTO t21 VALUES (1,4);

INSERT INTO t21 VALUES (5,8);

INSERT INTO t21 VALUES (5,9);

INSERT INTO t22 VALUES (2,1);

INSERT INTO t22 VALUES (2,2);

INSERT INTO t22 VALUES (2,3);

INSERT INTO t22 VALUES (2,4);

INSERT INTO t22 VALUES (5,8);

INSERT INTO t22 VALUES (5,9);

CREATE VIEW v2 as
SELECT * FROM t21 UNION SELECT * FROM t22 order by 2 desc;
SELECT * FROM v2 order by c1,c2;

WITH cte_wD0no9WnB AS
(
SELECT c2 FROM v2
)
select * from cte_wD0no9WnB order by c2;

drop view  if exists v5;
CREATE VIEW v5 as
SELECT * FROM t21 DIFFERENCE SELECT * FROM t22 order by 2 desc;

WITH cte_IHY8oaxRs AS
(
SELECT c2 FROM v5
)
select * from cte_IHY8oaxRs order by c2;

drop table if exists t21;
drop table if exists t22;
drop view  if exists v2;
drop view  if exists v5;
drop table if exists vc_tb1;
drop table if exists vc_tb2;
drop vclass if exists vtb1;
drop vclass if exists vtb2;

