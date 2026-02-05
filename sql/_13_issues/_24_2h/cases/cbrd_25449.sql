-- This scenario varifies CBRD-25449 issue.
-- Issue Description:
-- When dropping a user, the owner in _db_authorization was not removed and remained as NULL. This verifies that the owner is correctly removed from _db_authorization.

--create user
create user u1;
create user u2;
create user u3;
--The grants for public are excluded from the output to facilitate TC management.
select * from _db_authorization where owner.name != 'PUBLIC';

--drop user
drop user u1;
drop user u2;
drop user u3;
--The grants for public are excluded from the output to facilitate TC management.
select * from _db_authorization where owner.name != 'PUBLIC';
