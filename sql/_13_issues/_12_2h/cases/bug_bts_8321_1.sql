-- default values
CREATE TABLE tt1 (id integer,
m1 monetary default \TL10.15, 
m2 monetary default \KHR10.15,
m3 monetary default \IRP10.15,
m4 monetary default \RBL10.15,
m5 monetary default \AUD10.15,
m6 monetary default \CAD10.15,
m7 monetary default \BRL10.15,
m8 monetary default \RON10.15,
m9 monetary default \EUR10.15);

insert into tt1(id) values(1);
select id, m1, m2, m3, m4, m5, m6, m7, m8, m9 from tt1;
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
from tt1;

drop tt1;
