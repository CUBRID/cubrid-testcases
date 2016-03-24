--[er]test drop serial using drop statement without serial keyword
create serial a_serial increment by  1;

drop a_serial;
drop serial a_serial;
