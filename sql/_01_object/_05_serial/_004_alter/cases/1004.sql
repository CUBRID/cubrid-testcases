-- create serial,alter this serial by conditions like'INCREMENT BY 1 MINVALUE 1 MAXVALUE 10000000000 CYCLE',drop serial

CREATE SERIAL ddl_0001;
ALTER SERIAL ddl_0001
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10000000000
	CYCLE;




drop serial ddl_0001;
