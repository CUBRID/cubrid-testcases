-- type conversion

autocommit off;

CREATE  FUNCTION typetestint1() RETURN int as language java name 'SpTest3.typetestint1() return int';
CREATE  FUNCTION typetestint2() RETURN int as language java name 'SpTest3.typetestint2() return int';
CREATE  FUNCTION typetestint3() RETURN int as language java name 'SpTest3.typetestint3() return int';
CREATE  FUNCTION typetestint4() RETURN int as language java name 'SpTest3.typetestint4() return int';
CREATE  FUNCTION typetestint5() RETURN int as language java name 'SpTest3.typetestint5() return int';
CREATE  FUNCTION typetestint10() RETURN string as language java name 'SpTest3.typetestint1() return int';
CREATE  FUNCTION typetestint20() RETURN string as language java name 'SpTest3.typetestint2() return int';
CREATE  FUNCTION typetestint30() RETURN string as language java name 'SpTest3.typetestint3() return int';
CREATE  FUNCTION typetestint40() RETURN string as language java name 'SpTest3.typetestint4() return int';
CREATE  FUNCTION typetestint100() RETURN numeric(30) as language java name 'SpTest3.typetestint1() return int';
CREATE  FUNCTION typetestint200() RETURN numeric(30) as language java name 'SpTest3.typetestint2() return int';
CREATE  FUNCTION typetestint300() RETURN numeric(30) as language java name 'SpTest3.typetestint3() return int';
CREATE  FUNCTION typetestint400() RETURN numeric(30) as language java name 'SpTest3.typetestint4() return int';
CREATE  FUNCTION typetestint0() RETURN float as language java name 'SpTest3.typetestint0() return int';
CREATE  FUNCTION typetestint1000() RETURN float as language java name 'SpTest3.typetestint1() return int';
CREATE  FUNCTION typetestint2000() RETURN float as language java name 'SpTest3.typetestint2() return int';
CREATE  FUNCTION typetestint10000() RETURN double as language java name 'SpTest3.typetestint1() return int';
CREATE  FUNCTION typetestint20000() RETURN double as language java name 'SpTest3.typetestint2() return int';
CREATE  FUNCTION typetestint00() RETURN short as language java name 'SpTest3.typetestint0() return int';


call typetestint1();
call typetestint2();
call typetestint3();
call typetestint4();
call typetestint10();
call typetestint20();
call typetestint30();
call typetestint40();
call typetestint100();
call typetestint200();
call typetestint300();
call typetestint400();
call typetestint0();
call typetestint1000();
call typetestint2000();
call typetestint10000();
call typetestint20000();
call typetestint00();

CREATE  FUNCTION typetestinteger1() RETURN int as language java name 'SpTest3.typetestinteger1() return java.lang.Integer';
CREATE  FUNCTION typetestinteger2() RETURN int as language java name 'SpTest3.typetestinteger2() return java.lang.Integer';
CREATE  FUNCTION typetestinteger3() RETURN int as language java name 'SpTest3.typetestinteger3() return java.lang.Integer';
CREATE  FUNCTION typetestinteger4() RETURN int as language java name 'SpTest3.typetestinteger4() return java.lang.Integer';
CREATE  FUNCTION typetestinteger5() RETURN int as language java name 'SpTest3.typetestinteger5() return java.lang.Integer';
CREATE  FUNCTION typetestinteger10() RETURN string as language java name 'SpTest3.typetestinteger1() return java.lang.Integer';
CREATE  FUNCTION typetestinteger20() RETURN string as language java name 'SpTest3.typetestinteger2() return java.lang.Integer';
CREATE  FUNCTION typetestinteger30() RETURN string as language java name 'SpTest3.typetestinteger3() return java.lang.Integer';
CREATE  FUNCTION typetestinteger40() RETURN string as language java name 'SpTest3.typetestinteger4() return java.lang.Integer';
CREATE  FUNCTION typetestinteger100() RETURN numeric(30) as language java name 'SpTest3.typetestinteger1() return java.lang.Integer';
CREATE  FUNCTION typetestinteger200() RETURN numeric(30) as language java name 'SpTest3.typetestinteger2() return java.lang.Integer';
CREATE  FUNCTION typetestinteger300() RETURN numeric(30) as language java name 'SpTest3.typetestinteger3() return java.lang.Integer';
CREATE  FUNCTION typetestinteger400() RETURN numeric(30) as language java name 'SpTest3.typetestinteger4() return java.lang.Integer';
CREATE  FUNCTION typetestinteger0() RETURN float as language java name 'SpTest3.typetestinteger0() return java.lang.Integer';
CREATE  FUNCTION typetestinteger1000() RETURN float as language java name 'SpTest3.typetestinteger1() return java.lang.Integer';
CREATE  FUNCTION typetestinteger2000() RETURN float as language java name 'SpTest3.typetestinteger2() return java.lang.Integer';
CREATE  FUNCTION typetestinteger10000() RETURN double as language java name 'SpTest3.typetestinteger1() return java.lang.Integer';
CREATE  FUNCTION typetestinteger20000() RETURN double as language java name 'SpTest3.typetestinteger2() return java.lang.Integer';
CREATE  FUNCTION typetestinteger00() RETURN short as language java name 'SpTest3.typetestint0() return java.lang.Integer';

call typetestinteger1();
call typetestinteger2();
call typetestinteger3();
call typetestinteger4();
call typetestinteger10();
call typetestinteger20();
call typetestinteger30();
call typetestinteger40();
call typetestinteger100();
call typetestinteger200();
call typetestinteger300();
call typetestinteger400();
call typetestinteger0();
call typetestinteger1000();
call typetestinteger2000();
call typetestinteger10000();
call typetestinteger20000();
call typetestinteger00();

CREATE  FUNCTION typeteststring1() RETURN string as language java name 'SpTest3.typeteststring1() return java.lang.String';
CREATE  FUNCTION typeteststring2() RETURN int as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring20() RETURN numeric(30) as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring200() RETURN float as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring2000() RETURN double as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring20000() RETURN char(20) as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring200000() RETURN varchar(20) as language java name 'SpTest3.typeteststring2() return java.lang.String';
CREATE  FUNCTION typeteststring2000000() RETURN char(5) as language java name 'SpTest3.typeteststring2() return java.lang.String';
drop function typeteststring200000;
CREATE  FUNCTION typeteststring200000() RETURN varchar as language java name 'SpTest3.typeteststring2() return java.lang.String';

call typeteststring1();
call typeteststring2();
call typeteststring20();
call typeteststring200();
call typeteststring2000();
call typeteststring20000();
call typeteststring200000();
call typeteststring2000000();

CREATE  FUNCTION typetestdate1() RETURN date as language java name 'SpTest3.typetestdate1() return java.lang.Date';
CREATE  FUNCTION typetestdate10() RETURN string as language java name 'SpTest3.typetestdate1() return java.lang.Date';
CREATE  FUNCTION typetestdate2() RETURN date as language java name 'SpTest3.typetestdate2() return java.lang.Date';
CREATE  FUNCTION typetestdate3() RETURN date as language java name 'SpTest3.typetestdate3() return java.lang.Date';
CREATE  FUNCTION typetestdate4() RETURN date as language java name 'SpTest3.typetestdate4() return java.lang.Date';

call typetestdate1();
call typetestdate10();
call typetestdate2();
call typetestdate3();
call typetestdate4();

CREATE  FUNCTION typetesttime1() RETURN time as language java name 'SpTest3.typetesttime1() return java.lang.Time';
CREATE  FUNCTION typetesttime2() RETURN time as language java name 'SpTest3.typetesttime2() return java.lang.Time';
CREATE  FUNCTION typetesttime20() RETURN string as language java name 'SpTest3.typetesttime2() return java.lang.Time';
CREATE  FUNCTION typetesttime3() RETURN time as language java name 'SpTest3.typetesttime3() return java.lang.Time';
CREATE  FUNCTION typetesttime30() RETURN string as language java name 'SpTest3.typetesttime3() return java.lang.Time';
CREATE  FUNCTION typetesttime4() RETURN time as language java name 'SpTest3.typetesttime4() return java.lang.Time';
CREATE  FUNCTION typetesttime5() RETURN time as language java name 'SpTest3.typetesttime5() return java.lang.Time';

call typetesttime1();
call typetesttime2();
call typetesttime20();
call typetesttime3();
call typetesttime30();
call typetesttime4();
call typetesttime5();

CREATE  FUNCTION typetesttimestamp1() RETURN timestamp as language java name 'SpTest3.typetesttimestamp1() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp10() RETURN string as language java name 'SpTest3.typetesttimestamp1() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp2() RETURN timestamp as language java name 'SpTest3.typetesttimestamp2() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp20() RETURN string as language java name 'SpTest3.typetesttimestamp2() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp3() RETURN timestamp as language java name 'SpTest3.typetesttimestamp3() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp30() RETURN timestamp as language java name 'SpTest3.typetesttimestamp3() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp4() RETURN timestamp as language java name 'SpTest3.typetesttimestamp4() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp40() RETURN timestamp as language java name 'SpTest3.typetesttimestamp4() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp5() RETURN timestamp as language java name 'SpTest3.typetesttimestamp5() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp50() RETURN timestamp as language java name 'SpTest3.typetesttimestamp5() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp6() RETURN timestamp as language java name 'SpTest3.typetesttimestamp6() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp60() RETURN timestamp as language java name 'SpTest3.typetesttimestamp6() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp7() RETURN timestamp as language java name 'SpTest3.typetesttimestamp7() return java.lang.Timestamp';
CREATE  FUNCTION typetesttimestamp70() RETURN timestamp as language java name 'SpTest3.typetesttimestamp7() return java.lang.Timestamp';

call typetesttimestamp1();
call typetesttimestamp10();
call typetesttimestamp20();
call typetesttimestamp3();
call typetesttimestamp30();
call typetesttimestamp4();
call typetesttimestamp40();
call typetesttimestamp5();
call typetesttimestamp50();
call typetesttimestamp6();
call typetesttimestamp60();
call typetesttimestamp7();
call typetesttimestamp70();


CREATE  FUNCTION typetestlong1() RETURN  int as language java name 'SpTest3.typetestlong1() return java.lang.Long';
CREATE  FUNCTION typetestlong10() RETURN numeric(32) as language java name 'SpTest3.typetestlong1() return java.lang.Long';
CREATE  FUNCTION typetestlong100() RETURN  float as language java name 'SpTest3.typetestlong1() return java.lang.Long';
CREATE  FUNCTION typetestlong1000() RETURN  double as language java name 'SpTest3.typetestlong1() return java.lang.Long';
CREATE  FUNCTION typetestlong10000() RETURN  short as language java name 'SpTest3.typetestlong1() return java.lang.Long';
CREATE  FUNCTION typetestlong2() RETURN  int as language java name 'SpTest3.typetestlong2() return java.lang.Long';
CREATE  FUNCTION typetestlong20() RETURN numeric(32) as language java name 'SpTest3.typetestlong2() return java.lang.Long';
CREATE  FUNCTION typetestlong200() RETURN  float as language java name 'SpTest3.typetestlong2() return java.lang.Long';
CREATE  FUNCTION typetestlong2000() RETURN  double as language java name 'SpTest3.typetestlong2() return java.lang.Long';
CREATE  FUNCTION typetestlong20000() RETURN  short as language java name 'SpTest3.typetestlong2() return java.lang.Long';
CREATE  FUNCTION typetestlong200000() RETURN  string as language java name 'SpTest3.typetestlong2() return java.lang.Long';

call typetestlong1();
call typetestlong10();
call typetestlong100();
call typetestlong1000();
call typetestlong10000();
call typetestlong2();
call typetestlong20();
call typetestlong200();
call typetestlong2000();
call typetestlong20000();
call typetestlong200000();

CREATE  FUNCTION typetestfloat1() RETURN  int as language java name 'SpTest3.typetestfloat1() return java.lang.Float';
CREATE  FUNCTION typetestfloat10() RETURN numeric(32) as language java name 'SpTest3.typetestfloat1() return java.lang.Float';
CREATE  FUNCTION typetestfloat100() RETURN  float as language java name 'SpTest3.typetestfloat1() return java.lang.Float';
CREATE  FUNCTION typetestfloat1000() RETURN  double as language java name 'SpTest3.typetestfloat1() return java.lang.Float';
CREATE  FUNCTION typetestfloat10000() RETURN  short as language java name 'SpTest3.typetestfloat1() return java.lang.Float';
CREATE  FUNCTION typetestfloat2() RETURN  int as language java name 'SpTest3.typetestfloat2() return java.lang.Float';
CREATE  FUNCTION typetestfloat20() RETURN numeric(32) as language java name 'SpTest3.typetestfloat2() return java.lang.Float';
CREATE  FUNCTION typetestfloat200() RETURN  float as language java name 'SpTest3.typetestfloat2() return java.lang.Float';
CREATE  FUNCTION typetestfloat2000() RETURN  double as language java name 'SpTest3.typetestfloat2() return java.lang.Float';
CREATE  FUNCTION typetestfloat20000() RETURN  short as language java name 'SpTest3.typetestfloat2() return java.lang.Float';
CREATE  FUNCTION typetestfloat200000() RETURN  string as language java name 'SpTest3.typetestfloat2() return java.lang.Float';

call typetestfloat1();
call typetestfloat10();
call typetestfloat100();
call typetestfloat1000();
call typetestfloat10000();
call typetestfloat2();
call typetestfloat20();
call typetestfloat200();
call typetestfloat2000();
call typetestfloat20000();
call typetestfloat200000();

CREATE  FUNCTION typetestdouble1() RETURN  int as language java name 'SpTest3.typetestdouble1() return java.lang.Double';
CREATE  FUNCTION typetestdouble10() RETURN numeric(32) as language java name 'SpTest3.typetestdouble1() return java.lang.Double';
CREATE  FUNCTION typetestdouble100() RETURN  float as language java name 'SpTest3.typetestdouble1() return java.lang.Double';
CREATE  FUNCTION typetestdouble1000() RETURN  double as language java name 'SpTest3.typetestdouble1() return java.lang.Double';
CREATE  FUNCTION typetestdouble10000() RETURN  short as language java name 'SpTest3.typetestdouble1() return java.lang.Double';
CREATE  FUNCTION typetestdouble2() RETURN  int as language java name 'SpTest3.typetestdouble2() return java.lang.Double';
CREATE  FUNCTION typetestdouble20() RETURN numeric(32) as language java name 'SpTest3.typetestdouble2() return java.lang.Double';
CREATE  FUNCTION typetestdouble200() RETURN  float as language java name 'SpTest3.typetestdouble2() return java.lang.Double';
CREATE  FUNCTION typetestdouble2000() RETURN  double as language java name 'SpTest3.typetestdouble2() return java.lang.Double';
CREATE  FUNCTION typetestdouble20000() RETURN  short as language java name 'SpTest3.typetestdouble2() return java.lang.Double';
CREATE  FUNCTION typetestdouble200000() RETURN  string as language java name 'SpTest3.typetestdouble2() return java.lang.Double';

call typetestdouble1();
call typetestdouble10();
call typetestdouble100();
call typetestdouble1000();
call typetestdouble10000();
call typetestdouble2();
call typetestdouble20();
call typetestdouble200();
call typetestdouble2000();
call typetestdouble20000();

CREATE  FUNCTION typetestbigdecimal1() RETURN  int as language java name 'SpTest3.typetestbigdecimal1() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal10() RETURN numeric(32) as language java name 'SpTest3.typetestbigdecimal1() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal100() RETURN  float as language java name 'SpTest3.typetestbigdecimal1() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal1000() RETURN  double as language java name 'SpTest3.typetestbigdecimal1() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal10000() RETURN  short as language java name 'SpTest3.typetestbigdecimal1() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal2() RETURN  int as language java name 'SpTest3.typetestbigdecimal2() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal20() RETURN numeric(32) as language java name 'SpTest3.typetestbigdecimal2() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal200() RETURN  float as language java name 'SpTest3.typetestbigdecimal2() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal2000() RETURN  double as language java name 'SpTest3.typetestbigdecimal2() return java.lang.BigDecimal';
CREATE  FUNCTION typetestbigdecimal20000() RETURN  short as language java name 'SpTest3.typetestbigdecimal2() return java.lang.BigDecimal';


call typetestbigdecimal1();
call typetestbigdecimal10();
call typetestbigdecimal100();
call typetestbigdecimal1000();
call typetestbigdecimal10000();
call typetestbigdecimal2();
call typetestbigdecimal20();
call typetestbigdecimal200();
call typetestbigdecimal2000();
call typetestbigdecimal20000();

CREATE  FUNCTION typetestlong5() RETURN  int as language java name 'SpTest3.typetestlong5() return long';
CREATE  FUNCTION typetestlong50() RETURN numeric(30) as language java name 'SpTest3.typetestlong5() return long';
CREATE  FUNCTION typetestlong500() RETURN  float as language java name 'SpTest3.typetestlong5() return long';
CREATE  FUNCTION typetestlong5000() RETURN  double as language java name 'SpTest3.typetestlong5() return long';
CREATE  FUNCTION typetestlong50000() RETURN  short as language java name 'SpTest3.typetestlong5() return long';
CREATE  FUNCTION typetestlong6() RETURN  int as language java name 'SpTest3.typetestlong6() return long';
CREATE  FUNCTION typetestlong60() RETURN numeric(30) as language java name 'SpTest3.typetestlong6() return long';
CREATE  FUNCTION typetestlong600() RETURN  float as language java name 'SpTest3.typetestlong6() return long';
CREATE  FUNCTION typetestlong6000() RETURN  double as language java name 'SpTest3.typetestlong6() return long';
CREATE  FUNCTION typetestlong60000() RETURN  short as language java name 'SpTest3.typetestlong6() return long';
CREATE  FUNCTION typetestlong600000() RETURN  string as language java name 'SpTest3.typetestlong6() return long';

call typetestlong5();
call typetestlong50();
call typetestlong500();
call typetestlong5000();
call typetestlong50000();
call typetestlong6();
call typetestlong60();
call typetestlong600();
call typetestlong6000();
call typetestlong60000();
call typetestlong600000();

CREATE  FUNCTION typetestfloat5() RETURN  int as language java name 'SpTest3.typetestfloat5() return float';
CREATE  FUNCTION typetestfloat50() RETURN numeric(30) as language java name 'SpTest3.typetestfloat5() return float';
CREATE  FUNCTION typetestfloat500() RETURN  float as language java name 'SpTest3.typetestfloat5() return float';
CREATE  FUNCTION typetestfloat5000() RETURN  double as language java name 'SpTest3.typetestfloat5() return float';
CREATE  FUNCTION typetestfloat50000() RETURN  short as language java name 'SpTest3.typetestfloat5() return float';
CREATE  FUNCTION typetestfloat6() RETURN  int as language java name 'SpTest3.typetestfloat6() return float';
CREATE  FUNCTION typetestfloat60() RETURN numeric(30) as language java name 'SpTest3.typetestfloat6() return float';
CREATE  FUNCTION typetestfloat600() RETURN  float as language java name 'SpTest3.typetestfloat6() return float';
CREATE  FUNCTION typetestfloat6000() RETURN  double as language java name 'SpTest3.typetestfloat6() return float';
CREATE  FUNCTION typetestfloat60000() RETURN  short as language java name 'SpTest3.typetestfloat6() return float';
CREATE  FUNCTION typetestfloat600000() RETURN  string as language java name 'SpTest3.typetestfloat6() return float';

call typetestfloat5();
call typetestfloat50();
call typetestfloat500();
call typetestfloat5000();
call typetestfloat50000();
call typetestfloat6();
call typetestfloat60();
call typetestfloat600();
call typetestfloat6000();
call typetestfloat60000();
call typetestfloat600000();

CREATE  FUNCTION typetestdouble5() RETURN  int as language java name 'SpTest3.typetestdouble5() return double';
CREATE  FUNCTION typetestdouble50() RETURN numeric(30) as language java name 'SpTest3.typetestdouble5() return double';
CREATE  FUNCTION typetestdouble500() RETURN  double as language java name 'SpTest3.typetestdouble5() return double';
CREATE  FUNCTION typetestdouble5000() RETURN  double as language java name 'SpTest3.typetestdouble5() return double';
CREATE  FUNCTION typetestdouble50000() RETURN  short as language java name 'SpTest3.typetestdouble5() return double';
CREATE  FUNCTION typetestdouble6() RETURN  int as language java name 'SpTest3.typetestdouble6() return double';
CREATE  FUNCTION typetestdouble60() RETURN numeric(30) as language java name 'SpTest3.typetestdouble6() return double';
CREATE  FUNCTION typetestdouble600() RETURN  double as language java name 'SpTest3.typetestdouble6() return double';
CREATE  FUNCTION typetestdouble6000() RETURN  double as language java name 'SpTest3.typetestdouble6() return double';
CREATE  FUNCTION typetestdouble60000() RETURN  short as language java name 'SpTest3.typetestdouble6() return double';
CREATE  FUNCTION typetestdouble600000() RETURN  string as language java name 'SpTest3.typetestdouble6() return double';

call typetestdouble5();
call typetestdouble50();
call typetestdouble500();
call typetestdouble5000();
call typetestdouble50000();
call typetestdouble6();
call typetestdouble60();
call typetestdouble600();
call typetestdouble6000();
call typetestdouble60000();
call typetestdouble600000();

rollback;
autocommit on;

