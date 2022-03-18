autocommit off;
select i.product.descr, j.product.descr from joe.inventory_c i, joe.inventory_c j;
select i.product.descr, j.product.descr from joe.inventory_c i, joe.inventory_c j
where  i.product.descr = j.product.descr ;
select i.product.descr, j.product.descr from joe.inventory_c i, joe.inventory_c j
where  i.product = j.product ;
select i.product.descr, j.product.descr from joe.inventory_c i, joe.inventory_c j
where  i = j ;
rollback;
