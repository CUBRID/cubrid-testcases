-- create serial,alter serial with conditions like 'INCREMENT BY 1 MINVALUE 1 MAXVALUE 10000000000',drop serial

CREATE SERIAL ddl_0001;
ALTER SERIAL ddl_0001
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10000000000;




drop serial ddl_0001;
