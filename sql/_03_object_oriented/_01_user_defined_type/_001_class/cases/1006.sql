-- [er]create table and rename class with udt
set system parameters 'create_table_reuseoid=no';

CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

CREATE TABLE company1 (name CHAR(20),Location StateCity,budget FLOAT);
rename class company1 as company2 ;


DROP table company1;
drop table company2;
drop CLASS Company;
drop CLASS StateCity;

set system parameters 'create_table_reuseoid=yes';
