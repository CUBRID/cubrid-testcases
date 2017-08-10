-- create class having attribute whose type is user defined type(udt) and then drop them
CREATE VCLASS StateCity(State CHAR(20), City CHAR(20));
CREATE VCLASS Company  (Name CHAR(20), Location StateCity, Budget FLOAT);
CREATE VCLASS Activity (Name CHAR(20), NumPlayers INTEGER);
CREATE VCLASS Employee (Name CHAR(20), Job CHAR(20), Salary FLOAT, Hobby Activity, WorksFor Company);



DROP VCLASS Employee;
drop VCLASS Activity;
drop VCLASS Company;
drop VCLASS StateCity;
