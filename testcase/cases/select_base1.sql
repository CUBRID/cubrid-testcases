drop table if exists foo,bitvar_tbl;
CREATE TABLE bitvar_tbl(a1 BIT VARYING, a2 BIT VARYING(8));
INSERT INTO bitvar_tbl VALUES (B'1', B'1');
INSERT INTO bitvar_tbl VALUES (0b1010, 0b1010);
INSERT INTO bitvar_tbl VALUES (0xaa, 0xaa);
INSERT INTO bitvar_tbl(a1) VALUES (0xaaa);

create table foo1 as
with cte as( 
SELECT sum(*) FROM bitvar_tbl order by a2
) select * from cte;

create table foo as
with cte as( 
SELECT * FROM bitvar_tbl group by a2
) select * from cte;
select * from foo;

drop table if exists foo,bit_tbl;
