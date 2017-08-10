--test multiple rows select using view
create class c1(a1 int, b1 int);
create class c2(a2 int, b2 int);
create vclass v(a,b) as select a1,b1 from c1 union select a2,b2 from c2;
insert into c1 values(1,1);
insert into c1 values(1,2);
insert into c2 values(1,1);
insert into c2 values(1,2);

select a,b from v order by 1;
select a from v order by 1;


drop vclass v;
drop class c1;
drop class c2;
