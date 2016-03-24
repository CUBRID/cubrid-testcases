-- create a serial,alter this serial with an error that the maxvalue is less than minvalue 

CREATE SERIAL ddl_0001;
ALTER SERIAL ddl_0001
	INCREMENT BY 100
	MINVALUE 101
	MAXVALUE 99
	CYCLE;





drop serial ddl_0001;