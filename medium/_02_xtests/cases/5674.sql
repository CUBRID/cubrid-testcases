--+ holdcas on;
autocommit off;
select x into p1 from joe.product_c x where product_code = 6;
select self(p1) from joe.product_c y where product_code <4;
select self(p1).product_code from joe.product_c y where product_code <4;
select self(p1), self(p1).product_code, self(y).product_code from joe.product_c y where product_code <4;
insert into joe.product_c(product_code) values(add_int(p1, p1.product_code, self(p1).product_code));
select * from joe.product_c where product_code > 7;
select x into p2 from joe.product_c x where product_code = 3;
--evaluate {p1, p2} to p3;
select c into p3 from (select cast({p1,p2} as set) c);
select p, p.product_code from table(p3) as t(p);
rollback;

--+ holdcas off;
