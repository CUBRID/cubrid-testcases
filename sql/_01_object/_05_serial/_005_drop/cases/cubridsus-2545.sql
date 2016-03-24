--test case for CUBRIDSUS 2545

create serial se1 ;
select se1.next_value from db_root ;
drop serial se1 ;
create serial se1;
select se1.next_value from db_root ;
select se1.next_value from db_root ;
select se1.current_value from db_root ;
select se1.current_value from db_root ;
drop serial se1;
