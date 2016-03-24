-- [er]create a serial with an constraint error of  start with keyword
 
CREATE SERIAL ddl_0001_serial
INCREMENT BY -1
MAXVALUE 10000000
START WITH -2
MINVALUE -1000;





DROP SERIAL ddl_0001_serial;