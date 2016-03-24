autocommit off;
select * from faculty2 where 'fgh' = 'l'
select * from faculty2 where 'fghijk' = 'fghijk'
select * from faculty2 where {1} = {2}
select * from faculty2 where {1} = {1}
select * from faculty2 where set{1} = {2}
select * from faculty2 where set{1} = {1}
select * from faculty2 where set{1} = set{2}
select * from faculty2 where set{1} = set{1}
select * from faculty2 where sequence{1} = sequence{2}
select * from faculty2 where sequence{1} = {1}
select * from faculty2 where 1.2 = 1.21
select * from faculty2 where 1.2 = 1.2
select * from faculty2 where 1.000000002 
			   = 1.0000000021
select * from faculty2 where 1.000000002
			   = 1.000000002
select count(*) from faculty2 where 'fgh' = 'l'
select count(*) from faculty2 where 'fghijk' = 'fghijk'
select count(*) from faculty2 where {1} = {2}
select count(*) from faculty2 where {1} = {1}
select count(*) from faculty2 where set{1} = {2}
select count(*) from faculty2 where set{1} = {1}
select count(*) from faculty2 where set{1} = set{2}
select count(*) from faculty2 where set{1} = set{1}
select count(*) from faculty2 where sequence{1} = sequence{2}
select count(*) from faculty2 where sequence{1} = {1}
select count(*) from faculty2 where 1.2 = 1.21
select count(*) from faculty2 where 1.2 = 1.2
select count(*) from faculty2 where 1.000000002 
			   = 1.0000000021
select count(*) from faculty2 where 1.000000002
			   = 1.000000002
select * from faculty where 0 = 
	(select count(*) from faculty2 where 1.2 = 1.21)
rollback;
