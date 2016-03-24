autocommit off;
create table bigindexunique(a int unique not null, b char(40) unique not null);
create table medindexunique(a int unique not null, b char(40) unique not null);
insert into bigindexunique select * from big;
insert into medindexunique select * from med;
select count(*) from bigindexunique;
rollback;
