set system parameters 'create_table_reuseoid=no';
--buf fix for BTS 318 issue

create table xoo ( a int, b string);
insert into xoo values(10000,'yyy');

select a,b from xoo where xoo<>0;
select a,b from xoo where 1<>0;

select a,b from xoo where ;
select a, from xoo where 1=1;
select a, b from xoo where xoo = xoo;
select a, b from xoo where 1=1;

drop xoo;
set system parameters 'create_table_reuseoid=yes';
