--test drop serial using three serials
create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;

drop serial a_serial;
drop serial b_serial;
drop serial c_serial;
