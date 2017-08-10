-- create class having attribute whose type is user defined type(udt) and then drop them
CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity, Budget FLOAT);
CREATE TABLE Activity (Name CHAR(20), NumPlayers INTEGER);
CREATE TABLE Employee (Name CHAR(20), Job CHAR(20), Salary FLOAT, Hobby Activity, WorksFor Company);

DROP CLASS Employee;
drop CLASS Activity;
drop CLASS Company;
drop CLASS StateCity;
