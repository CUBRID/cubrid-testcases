--Test left outer join using condition

create class x1 ( a int, b char(1)); 
create class x2 ( a int, b char(1)); 
create class x3 ( a int, b char(1)); 

insert into x1 values(1,'1'); 
insert into x1 values(2,'2'); 
insert into x1 values(3,'3');
insert into x1 values(4,'4'); 
insert into x2 values(1,'1'); 
insert into x2 values(2,'2'); 
insert into x3 values(1,'1'); 
insert into x3 values(2,'2'); 
insert into x3 values(3,'3'); 
insert into x3 values(4,'4');

select x1.a, x2.b 
from x1 left outer join  x2 
on x1.a = x2.a and x2.b like '%' order by 1; 
select x1.a, x2.b from x1 left outer join  x2 on x1.a = x2.a where x2.b like '%' order by 1;


drop x1, x2, x3;
