drop if exists tx_serial;
CREATE TABLE tx_serial (id INT);
create serial DBTIMEZONE START WITH 1;
create serial NONE START WITH 2;              
create serial SESSIONTIMEZONE START WITH 3;         
create serial TIMEZONES START WITH 4;             

INSERT INTO tx_serial VALUES (DBTIMEZONE.NEXT_VALUE);
INSERT INTO tx_serial VALUES (NONE.NEXT_VALUE); 
INSERT INTO tx_serial VALUES (SESSIONTIMEZONE.NEXT_VALUE); 
INSERT INTO tx_serial VALUES (TIMEZONES.NEXT_VALUE); 
select * from tx_serial;
       
drop serial DBTIMEZONE;
drop serial NONE;              
drop serial SESSIONTIMEZONE;         
drop serial TIMEZONES;             

drop table tx_serial;
