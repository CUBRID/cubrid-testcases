-- [er]create a serial with an error like 'Maximum value is invalid'

CREATE SERIAL ddl_0001_serial
START WITH 100
MINVALUE 1
MAXVALUE 10
CYCLE;





DROP SERIAL ddl_0001_serial;