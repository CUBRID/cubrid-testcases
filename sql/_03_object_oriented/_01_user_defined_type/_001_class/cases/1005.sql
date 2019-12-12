-- create table and alter rename attribute whose type is udt

CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

CREATE TABLE company1 (name CHAR(20),Location StateCity,budget FLOAT);
ALTER TABLE company1 rename ATTRIBUTE Location as Location1  ;


DROP table company1;
drop CLASS Company;
drop CLASS StateCity;
