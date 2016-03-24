-- CREATE SERIAL  with duplicate same attribute : all test should fails
create serial s start with 1 start with 2;
drop serial s;

create serial s increment by 1 increment by 2;
drop serial s;

create serial s minvalue 1 minvalue 2;
drop serial s;

create serial s maxvalue 1 maxvalue 2;
drop serial s;

create serial s cycle nocycle;
drop serial s;

create serial s cache 1 nocache;
drop serial s;