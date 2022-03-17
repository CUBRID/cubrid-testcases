autocommit off;
create vclass invmax(s string, p int) as
           select max(product.descr), product.product_code
            from inventory_c i
            group by product.product_code;
select * from invmax;
rollback;
