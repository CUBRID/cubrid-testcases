--[er]test drop serial by drop the same serial 2 times
create serial a_serial increment by  1;

drop serial a_serial;
drop serial a_serial;
