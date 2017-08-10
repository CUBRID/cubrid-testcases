-- [er]create table and rename class with udt

CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

CREATE TABLE company1 (name CHAR(20),Location StateCity,budget FLOAT);
rename class company1 as company2 ;


DROP table company1;
drop table company2;
drop CLASS Company;
drop CLASS StateCity;
