-- operate '05/26/2008' and cast its integer result to date


create class dummy( a int );
insert into dummy values (1);


select cast('05/26/2008' -111-'05/26/2008'  as date) from dummy;

drop class dummy;