/*
 *      5. CREATE TABLE. ADD ATTRIBUTE AUTO_INCREMENT. CHANGE OWNER.
 */

create user u1;
create table t1;
select class_of, unique_name, class_name, owner.name from _db_class where is_system_class % 8 = 0;
call change_owner ('t1', 'u1') on class db_root;
alter table u1.t1 add attribute c1 int auto_increment;
select c.class_of, c.class_name, c.owner.name, s.name, s.owner.name from _db_class c, db_serial s where c.class_name = s.class_name;

drop table u1.t1;
drop user u1;
