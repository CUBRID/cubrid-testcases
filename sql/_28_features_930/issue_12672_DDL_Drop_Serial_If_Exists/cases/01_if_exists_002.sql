
--01_if_exists_002.sql
--+ holdcas on;

--basic02

drop serial if exists a_serial;
drop serial if exists b_serial;
drop serial if exists c_serial;
drop serial if exists d_serial;
drop serial if exists e_serial;

create serial a_serial increment by  1;
create serial b_serial increment by  2;
create serial c_serial increment by  3;
create serial d_serial increment by  4;
create serial e_serial increment by  5;

--this will fail,by design
drop serial if exists a_serial,b_serial,c_serial,d_serial,e_serial;

--these will success
drop serial if exists a_serial;
drop serial if exists b_serial;
drop serial if exists c_serial;
drop serial if exists d_serial;
drop serial if exists e_serial;


--+ holdcas off;
commit;
