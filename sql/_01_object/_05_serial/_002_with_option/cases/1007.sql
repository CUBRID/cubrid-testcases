-- [er]create a serial with an error like 'Minimum value is invalid'

CREATE SERIAL ddl_0001_serial
START WITH 100
INCREMENT BY 100
MINVALUE 101
MAXVALUE 99
CYCLE;





DROP SERIAL ddl_0001_serial;