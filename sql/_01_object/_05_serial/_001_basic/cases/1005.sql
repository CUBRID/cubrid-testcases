--create a serial with conditions like START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCYCLE and drop this serial at last

CREATE SERIAL ddl_0001_serial
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOCYCLE;





DROP SERIAL ddl_0001_serial;