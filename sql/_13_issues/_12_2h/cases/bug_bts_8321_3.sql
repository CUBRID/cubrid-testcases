CREATE TABLE tt3 (id integer,
m1 monetary default \TL-10.15, 
m2 monetary default \KHR-10.15,
m3 monetary default \INR-10.15,
m4 monetary default \RUB-10.15,
m5 monetary default \AUD-10.15,
m6 monetary default \CAD-10.15,
m7 monetary default \BRL-10.15,
m8 monetary default \RON-10.15,
m9 monetary default \EUR-10.15);

insert into tt3(id) values(1);
select id, m1, m2, m3, m4, m5, m6, m7, m8, m9 from tt3;
select
	id,
	to_char(m1, 'SC999,999.99'),
	to_char(m2, 'SC999,999.99'),
	to_char(m3, 'SC999,999.99'),
	to_char(m4, 'SC999,999.99'),
	to_char(m5, 'SC999,999.99'),
	to_char(m6, 'SC999,999.99'),
	to_char(m7, 'SC999,999.99'),
	to_char(m8, 'SC999,999.99'),
	to_char(m9, 'SC999,999.99')
from tt3;

drop tt3;
