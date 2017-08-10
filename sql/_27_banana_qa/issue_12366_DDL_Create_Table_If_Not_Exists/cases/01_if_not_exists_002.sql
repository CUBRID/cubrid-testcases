--01_if_not_exists_002.sql

--scenario 1: general
drop class if exists t12366;
create class t12366(a varchar(10), b int not null);
drop class t12366;
create class if not exists t12366(a varchar(10), b int not null);
desc t12366;
--run this command again, should success
create class if not exists t12366(a varchar(11), b int not null);
desc t12366;

drop class if exists t12366;
