--[er]drop three serial with one drop statement
create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;

drop serial a_serial, b_serial, c_serial;
drop serial a_serial;
drop serial b_serial;
drop serial c_serial;