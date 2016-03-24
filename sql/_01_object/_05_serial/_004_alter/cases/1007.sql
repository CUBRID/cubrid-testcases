-- create serial,alter serial with conditions like 'INCREMENT BY -1 NOCYCLE', drop serial
CREATE SERIAL ddl_0001
	START WITH 1000000;
ALTER SERIAL ddl_0001
	INCREMENT BY -1
	NOCYCLE;




drop serial ddl_0001;
