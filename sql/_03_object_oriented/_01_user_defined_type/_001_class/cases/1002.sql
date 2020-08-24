-- create class and add constraints to attributes whose type is udt
set system parameters 'create_table_reuseoid=no';

CREATE TABLE StateCity(State CHAR(20), City CHAR(20));
CREATE TABLE Company  (Name CHAR(20), Location StateCity not null primary KEY, Budget FLOAT);

drop CLASS Company;
drop CLASS StateCity;

set system parameters 'create_table_reuseoid=yes';
