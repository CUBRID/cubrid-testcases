autocommit off;
select * from joe.faculty2 where 'fgh' = 'l';
select * from joe.faculty2 where 'fghijk' = 'fghijk';
select * from joe.faculty2 where {1} = {2};
select * from joe.faculty2 where {1} = {1};
select * from joe.faculty2 where set{1} = {2};
select * from joe.faculty2 where set{1} = {1};
select * from joe.faculty2 where set{1} = set{2};
select * from joe.faculty2 where set{1} = set{1};
select * from joe.faculty2 where sequence{1} = sequence{2};
select * from joe.faculty2 where sequence{1} = {1};
select * from joe.faculty2 where 1.2 = 1.21;
select * from joe.faculty2 where 1.2 = 1.2;
select * from joe.faculty2 where 1.000000002 
			   = 1.0000000021;
select * from joe.faculty2 where 1.000000002
			   = 1.000000002;
select count(*) from joe.faculty2 where 'fgh' = 'l';
select count(*) from joe.faculty2 where 'fghijk' = 'fghijk';
select count(*) from joe.faculty2 where {1} = {2};
select count(*) from joe.faculty2 where {1} = {1};
select count(*) from joe.faculty2 where set{1} = {2};
select count(*) from joe.faculty2 where set{1} = {1};
select count(*) from joe.faculty2 where set{1} = set{2};
select count(*) from joe.faculty2 where set{1} = set{1};
select count(*) from joe.faculty2 where sequence{1} = sequence{2};
select count(*) from joe.faculty2 where sequence{1} = {1};
select count(*) from joe.faculty2 where 1.2 = 1.21;
select count(*) from joe.faculty2 where 1.2 = 1.2;
select count(*) from joe.faculty2 where 1.000000002 
			   = 1.0000000021;
select count(*) from joe.faculty2 where 1.000000002
			   = 1.000000002;
select * from joe.faculty where 0 = 
	(select count(*) from joe.faculty2 where 1.2 = 1.21);
rollback;
