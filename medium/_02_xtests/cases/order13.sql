autocommit off;
select * from joe.product_c a, joe.product_c b
order by a.product_code, b.product_code;
rollback;
