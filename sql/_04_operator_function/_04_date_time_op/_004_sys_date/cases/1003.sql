-- using "+" operate two '05/26/2008'


create class dummy( a int );
insert into dummy values (1);

select '05/26/2008' + '05/26/2008' from dummy;


drop class dummy;