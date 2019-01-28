drop table if exists foo,sales_mon_tbl;
CREATE TABLE sales_mon_tbl (
    yyyy INT,
    mm INT,
    sales_sum INT
);

INSERT INTO sales_mon_tbl VALUES
    (2000, 1, 1000), (2000, 2, 770), (2000, 3, 630), (2000, 4, 890),
    (2000, 5, 500), (2000, 6, 900), (2000, 7, 1300), (2000, 8, 1800),
    (2000, 9, 2100), (2000, 10, 1300), (2000, 11, 1500), (2000, 12, 1610),
    (2001, 1, 1010), (2001, 2, 700), (2001, 3, 600), (2001, 4, 900),
    (2001, 5, 1200), (2001, 6, 1400), (2001, 7, 1700), (2001, 8, 1110),
    (2001, 9, 970), (2001, 10, 690), (2001, 11, 710), (2001, 12, 880),
    (2002, 1, 980), (2002, 2, 750), (2002, 3, 730), (2002, 4, 980),
    (2002, 5, 1110), (2002, 6, 570), (2002, 7, 1630), (2002, 8, 1890),
    (2002, 9, 2120), (2002, 10, 970), (2002, 11, 420), (2002, 12, 1300);


create table foo as
with cte as( 
SELECT yyyy, mm, sales_sum, RANK() OVER (PARTITION BY yyyy ORDER BY sales_sum DESC) AS rnk
FROM sales_mon_tbl
) select * from cte;

select * from foo;

INSERT INTO bitvar_tbl(a2) VALUES (0xaaa);

drop table if exists foo,sales_mon_tbl;
