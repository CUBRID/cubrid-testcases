--+ holdcas on;
-- [er]create class with udt and update data using other user
set system parameters 'create_table_reuseoid=no';

call login ('dba','') on CLASS db_user;
create USER user1;

CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

insert into company values('name1',insert into statecity values('state1','city1'),1);
call login ('user1','') on CLASS db_user;

update dba.company set name='name2';

call login ('dba','') on CLASS db_user;
drop CLASS Company;
drop CLASS StateCity;

DROP USER user1;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
