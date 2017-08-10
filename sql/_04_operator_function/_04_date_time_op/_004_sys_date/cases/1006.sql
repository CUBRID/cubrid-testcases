--+ holdcas on;
-- operate '14:24:00 05/26/2008' with "+" and "-" operator


create class dummy( a int );
insert into dummy values (1);


select '14:24:00 05/26/2008' + 1 - 1 - '14:24:00 05/26/2008' + 10 from dummy ;

drop class dummy;

set system parameters 'compat_mode=mysql';

create class dummy( a int );
insert into dummy values (1);


select '14:24:00 05/26/2008' + 1 - 1 - '14:24:00 05/26/2008' + 10 from dummy ;

drop class dummy;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
