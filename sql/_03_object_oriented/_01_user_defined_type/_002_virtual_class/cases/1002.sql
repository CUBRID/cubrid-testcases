-- [er]create VCLASS and add constraints to attributes whose type is udt

CREATE VCLASS StateCity(State CHAR(20), City CHAR(20));
CREATE VCLASS Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

drop VCLASS Company;
drop VCLASS StateCity;

