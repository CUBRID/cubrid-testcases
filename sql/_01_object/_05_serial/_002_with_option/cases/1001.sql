-- [er]create a serial named ddl_0001_serial, then create the other serial named ddl_0001_serial.they have the same name and then report existing error

CREATE SERIAL ddl_0001_serial
START WITH 1000000
INCREMENT BY -1
NOCYCLE;
CREATE SERIAL ddl_0001_serial
START WITH -2
INCREMENT BY -1;





DROP SERIAL ddl_0001_serial;