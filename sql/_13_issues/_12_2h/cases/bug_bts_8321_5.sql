CREATE TABLE tt5 (id integer,
m1 monetary default $10.15,
m2 monetary default $-10.15,
m3 monetary default \CZK-10.15,
m4 monetary default \PLN-10.15,
m5 monetary default \SEK-10.15,
m6 monetary default \HRK-10.15,
m7 monetary default \RSD-10.15,
m8 monetary default \&-10.15);

insert into tt5(id) values(1);
select id, m1, m2, m3, m4, m5, m6, m7, m8 from tt5;
select
	id,
	to_char(m1, 'SC999,999.99'),
	to_char(m2, 'SC999,999.99'),
	to_char(m3, 'SC999,999.99'),
	to_char(m4, 'SC999,999.99'),
	to_char(m5, 'SC999,999.99'),
	to_char(m6, 'SC999,999.99'),
	to_char(m7, 'SC999,999.99'),
	to_char(m8, 'SC999,999.99')
from tt5;

drop tt5;