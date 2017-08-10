-- operate '14:24:00' with "-"


create class dummy( a int );
insert into dummy values (1);


select (time'14:24:00' - time'14:24:00' ) * 0  from dummy;

drop class dummy;