autocommit off;
 create view ff (a int) as select sum(ssn) from faculty1;
 select count(*) from ff;
 select 1 from ff;
 select * from ff;
 create vclass vsample
  (num int)
  as select sum(n)
  from(select number_of_pools
          from all accommodations
          where country = 'Jamaica'
          union all
          select number_of_restaurants
          from all accommodations
          where country = 'Bahamas') as t(n);
select * from vsample;
select count(*) from vsample;
          
create vclass vsample1
  (num int)
  as select n
  from(select number_of_pools
          from all accommodations
          where country = 'Jamaica'
          union all
          select number_of_restaurants
          from all accommodations
          where country = 'Bahamas') as t(n);
select * from vsample1 order by num;
select count(*) from vsample1;
create vclass vsample2
  (num int)
  as select n
  from(select number_of_pools
          from all accommodations
          where country = 'Bahamas') as t(n);
select * from vsample2;
select count(*) from vsample2;
create vclass vsample3
  (num int)
  as select n
  from(select number_of_pools
          from resort
          where country = 'Bahamas') as t(n);
select num from vsample3;
select count(*) from vsample3;
rollback work;
rollback;
