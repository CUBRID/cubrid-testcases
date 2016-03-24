--[er]test random with char type and operator ||
select decode( random()+'abc' , null, 1, 0) from db_oot order by 1;