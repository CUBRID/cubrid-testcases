-- create vclass and alter rename attribute whose type is udt

CREATE vclass StateCity(State CHAR(20), City CHAR(20));
CREATE vclass Company  (Name CHAR(20), Location StateCity, Budget FLOAT);

CREATE vclass company1 (name CHAR(20),Location StateCity,budget FLOAT);
ALTER vclass company1 rename ATTRIBUTE Location as Location1  ;


DROP vclass company1;
drop vclass Company;
drop vclass StateCity;
