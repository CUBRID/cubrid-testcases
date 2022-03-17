autocommit off;
create class a (
                a1 char(4),
                a2 char(4));
insert into a (a1,a2) values ('1234','1234');
select cast (a2 as int), cast (a2 as float), 
       cast (a2 as double), cast (a2 as monetary),
       cast (a2 as numeric(8,2))
from a;
rollback;
