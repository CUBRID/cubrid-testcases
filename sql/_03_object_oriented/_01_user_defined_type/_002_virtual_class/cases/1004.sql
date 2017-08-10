-- create VCLASS and alter drop attribute whose type is udt

CREATE VCLASS StateCity(State CHAR(20), City CHAR(20));
CREATE VCLASS Company  (Name CHAR(20), Location StateCity, Budget FLOAT);

CREATE VCLASS company1 (name CHAR(20),Location StateCity,budget FLOAT);
ALTER VCLASS company1 drop ATTRIBUTE Location  ;


DROP VCLASS company1;
drop VCLASS Company;
drop VCLASS StateCity;
