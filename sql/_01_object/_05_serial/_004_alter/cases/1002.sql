-- create serial,alter this serial with an error like 'Syntax: Specify alter serial option'

CREATE SERIAL ddl_0001;
ALTER SERIAL ddl_0001
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10000000000
	NOCYCLE;




drop serial ddl_0001;