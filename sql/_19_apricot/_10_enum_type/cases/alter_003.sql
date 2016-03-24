--Alter table to drop columns of enum type;
create table t1(e1 enum('a', 'b'), i int, e2 enum('Yes', 'No', 'Cancel'), e3 enum('Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri', 'Sambata', 'Duminica'));
describe t1;

alter table t1 add column e4 enum('a', 'b', 'c', 'd');
describe t1;

alter table t1 drop column e2;
describe t1;

alter table t1 drop column e1;
describe t1;

alter table t1 add column e1 enum('x', 'y', 'z');
describe t1;

alter table t1 drop column e4;
describe t1;

alter table t1 add column e4 enum('a', 'b', 'c', 'd');
describe t1;

drop table t1;