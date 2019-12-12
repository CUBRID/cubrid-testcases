--test bit_and function
drop table if exists bit_tbl;
CREATE TABLE bit_tbl(id int);
INSERT INTO bit_tbl VALUES (1), (2), (3), (4), (5);
SELECT 1&3&5, BIT_AND(id) FROM bit_tbl WHERE id in(1,3,5);

-- test bit_xor function
SELECT 1^3^5, BIT_XOR(id) FROM bit_tbl WHERE id in(1,3,5);

-- test bit_or function
SELECT 1|3|5, BIT_OR(id) FROM bit_tbl WHERE id in(1,3,5);

-- test bit_count function
SELECT BIT_COUNT(id) FROM bit_tbl WHERE id in(1,3,5) order by 1 desc;

select 17&3;
select 17|3;
select 17^3;
select ~17;
select 17>>3;
select 17<<3;

drop bit_tbl;

