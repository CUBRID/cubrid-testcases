drop table if exists machines;

create class machines(  ip_address varchar(30) primary key);

insert  machines values('192.168.0.10');

SELECT * FROM machines
WHERE ip_address IN (VALUES('192.168.0.10'), ('192.168.0.10'), ('192.168.1.43')) order by 1;

drop table if exists machines;