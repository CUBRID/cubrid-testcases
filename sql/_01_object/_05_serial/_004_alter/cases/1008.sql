-- create serial,alter serial by condition of 'INCREMENT BY -1',drop serial

CREATE SERIAL ddl_0001
	START WITH -2;
ALTER SERIAL ddl_0001
	INCREMENT BY -1;




drop serial ddl_0001;
