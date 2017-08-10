--+ holdcas on;
-- retrieve by show format of '14:24:00','05/26/2008' and '14:24:00 05/26/2008' by "?" and do operate with '05/26/2008'



create class dummy( a int );
insert into dummy values (1);


select  translate(to_char(time'14:24:00'),'0123456789AP','????????????'),
        translate(to_char(date'05/26/2008'),'0123456789AP','????????????'),
        translate(to_char(timestamp'14:24:00 05/26/2008'),'0123456789AP','????????????')
from dummy;
select date'05/26/2008' - date'05/26/2008' from dummy  ;
select date'05/26/2008' + 1 - 1 - date'05/26/2008' + 10 from dummy; 
select cast(date'05/26/2008' -111-date'05/26/2008' + 111 as int) from dummy;

drop class dummy;


set system parameters 'compat_mode=mysql';

create class dummy( a int );
insert into dummy values (1);


select  translate(to_char(time'14:24:00'),'0123456789AP','????????????'),
        translate(to_char(date'05/26/2008'),'0123456789AP','????????????'),
        translate(to_char(timestamp'14:24:00 05/26/2008'),'0123456789AP','????????????')
from dummy;
select date'05/26/2008' - date'05/26/2008' from dummy  ;
select date'05/26/2008' + 1 - 1 - date'05/26/2008' + 10 from dummy; 
select cast(date'05/26/2008' -111-date'05/26/2008' + 111 as int) from dummy;

drop class dummy;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
