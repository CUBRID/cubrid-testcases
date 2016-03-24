autocommit off;
create class aa (a numeric);
create class bbb (b numeric);
insert into aa values(1);
insert into bbb values(1);
select a , 0 a1 from aa union  select 0 aa, b from bbb ;
select * from  (select a , 0 a1 from aa union select 0 aa, b from bbb) as tab(a,b) ;
create view vunion1 (a, b) as select a , 0 a1 from aa union  select 0 aa, b from bbb;
select * from vunion1;
/* simple - cast */
select a, cast (0 as numeric) as a1 from aa
union
select cast (0 as numeric) as aa, b from bbb;
/* derived table - cast */
select *
from (select a, cast(0 as numeric) as a1 from aa
      union
      select cast(0 as numeric) as aa, b from bbb) as tab(a, b);

rollback;
