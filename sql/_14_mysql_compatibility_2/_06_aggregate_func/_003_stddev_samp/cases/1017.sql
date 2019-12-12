--+ holdcas on;
--test STDDEV_SAMP function with all keyword and types int,float,double, monetary 
-- only one sample in table
create class tb (
		varchartest     varchar(20),
		sinttest        smallint,
		inttest         int,
		numerictest     numeric(38,10),
		floattest       float,
		realtest        real,
		doublepretest   double precision,
		moneytest       monetary,
		chartest        char(8),
		datetest        date,
		timetest        time,
		timestamptest   timestamp,
		bittest         bit(16),
		nchartest       nchar(20),
		ncharvartest    nchar varying(20),
		bitvartest      bit varying(20),
		stringtest      string
);

insert into tb values ( '', 45, 0, 0, 0, 0,0, 0, '', null, null, null,B'', N'', N'', B'','');

set system parameters 'compat_mode=mysql';
select STDDEV_SAMP(all inttest) from tb;
select STDDEV_SAMP(all floattest) from tb;
select STDDEV_SAMP(all realtest) from tb;
select STDDEV_SAMP(all doublepretest) from tb;
select STDDEV_SAMP(all moneytest) from tb;
set system parameters 'compat_mode=cubrid';

drop class tb;
commit;
--+ holdcas off;
