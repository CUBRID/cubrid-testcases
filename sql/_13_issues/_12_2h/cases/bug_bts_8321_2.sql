CREATE TABLE tt2 (id integer,
m1 monetary default \CHF10.15,
m2 monetary default \DKK10.15,
m3 monetary default \NOK10.15,
m4 monetary default \BGN10.15,
m5 monetary default \USD10.15,
m6 monetary default \JPY10.15,
m7 monetary default \GBP10.15,
m8 monetary default \KRW10.15,
m9 monetary default \VND10.15,
m10 monetary default \CZK10.15,
m11 monetary default \PLN10.15,
m12 monetary default \SEK10.15,
m13 monetary default \HRK10.15,
m14 monetary default \RSD10.15);

insert into tt2(id) values(1);
select id, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14 from tt2;
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
	to_char(m9, 'SC999,999.99'), 
	to_char(m10, 'SC999,999.99'), 
	to_char(m11, 'SC999,999.99'), 
	to_char(m12, 'SC999,999.99'), 
	to_char(m13, 'SC999,999.99'), 
	to_char(m14, 'SC999,999.99')
from tt2;

drop tt2;
