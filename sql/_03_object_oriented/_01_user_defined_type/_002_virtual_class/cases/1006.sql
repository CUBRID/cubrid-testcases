-- [er]create vclass and rename vclass with udt

CREATE vclass StateCity(State CHAR(20), City CHAR(20));
CREATE vclass Company  (Name CHAR(20), Location StateCity, Budget FLOAT);

CREATE vclass company1 (name CHAR(20),Location StateCity,budget FLOAT);
rename vclass company1 as company2 ;


DROP vclass company1;
DROP vclass company2;
drop vclass Company;
drop vclass StateCity;
