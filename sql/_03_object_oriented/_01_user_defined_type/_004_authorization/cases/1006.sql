--+ holdcas on;
-- create class with udt and insert data using other user

call login ('dba','') on CLASS db_user;
create USER user1;


CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

insert into company values('name1',insert into statecity values('state1','city1'),1);


grant insert  on company to user1;
GRANT insert on StateCity to user1;

call login ('user1','') on CLASS db_user;

insert into company values('name2',insert into statecity values('state2','city2'),2);

call login ('dba','') on CLASS db_user;
drop CLASS Company;
drop CLASS StateCity;

DROP USER user1;

--+ holdcas off;
