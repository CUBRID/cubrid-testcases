--creating vclass with multiset type column and other types.
create vclass ddl_0001(
	sChar multiset(char(10)),
	sVarchar multiset(varchar(10)),
	sNchar multiset(nchar(10)),
	sNvchar multiset(nchar VARYING(10)),
	sBit multiset(bit(10)),
	sBvit multiset(bit VARYING(10)),
	sNumeric multiset(numeric),
	sInteger multiset(integer),
	sSmallint multiset(smallint),
	sMonetary multiset(monetary),
	sFloat multiset(float),
	sReal multiset(real),
	sDouble multiset(double),
	sDate multiset(date),
	sTime multiset(time),
	sTimestamp multiset(timestamp),
	sSet multiset(set),
	sMultiSet multiset(multiset),
	sList multiset(list),
	sSequence multiset(sequence)
);

drop vclass ddl_0001;