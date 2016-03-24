--creating table with List type column and other types.
create class ddl_0001(
	sChar LIST(char(10)),
	sVarchar LIST(varchar(10)),
	sNchar LIST(nchar(10)),
	sNvchar LIST(nchar VARYING(10)),
	sBit LIST(bit(10)),
	sBvit LIST(bit VARYING(10)),
	sNumeric LIST(numeric),
	sInteger LIST(integer),
	sSmallint LIST(smallint),
	sMonetary LIST(monetary),
	sFloat LIST(float),
	sReal LIST(real),
	sDouble LIST(double),
	sDate LIST(date),
	sTime LIST(time),
	sTimestamp LIST(timestamp),
	sSet LIST(set),
	sMultiSet LIST(multiset),
	sList LIST(list),
	sSequence LIST(sequence)
);

drop class ddl_0001;