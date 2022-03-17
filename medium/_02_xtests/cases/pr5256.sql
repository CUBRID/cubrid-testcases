autocommit off;
select 	descr from   inventory_c i, product_c p
where descr = (select descr from class db_user)
and p = i.product;
select 	descr from   inventory_c i, product_c p
where p = i.product
and descr = (select descr from class db_user);
rollback;
