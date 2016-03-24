-- [er] create class using Constraints  DEFAULT -2147483649

create class t1 (
c1 int  DEFAULT -2147483649 
);
select * FROM db_attribute  WHERE class_name='t1';

drop t1;