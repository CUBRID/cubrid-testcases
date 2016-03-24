--creating table with SEQUENCE type column and other types.
create class ddl_0001(
	sChar SEQUENCE(char(10)),
	sVarchar SEQUENCE(varchar(10)),
	sNchar SEQUENCE(nchar(10)),
	sNvchar SEQUENCE(nchar VARYING(10)),
	sBit SEQUENCE(bit(10)),
	sBvit SEQUENCE(bit VARYING(10)),
	sNumeric SEQUENCE(numeric),
	sInteger SEQUENCE(integer),
	sSmallint SEQUENCE(smallint),
	sMonetary SEQUENCE(monetary),
	sFloat SEQUENCE(float),
	sReal SEQUENCE(real),
	sDouble SEQUENCE(double),
	sDate SEQUENCE(date),
	sTime SEQUENCE(time),
	sTimestamp SEQUENCE(timestamp),
	sSet SEQUENCE(set),
	sMultiSet SEQUENCE(multiset),
	sList SEQUENCE(list),
	sSequence SEQUENCE(sequence)
);

drop class ddl_0001;