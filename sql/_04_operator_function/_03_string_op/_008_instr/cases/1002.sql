-- create class and using instr function 
create CLASS t (b string );
insert INTO t values ('22');

SELECT INSTR('Seawind Beach Resort', 'Sea') from t;
SELECT INSTR('Seawind Beach Resort', 'Resort', 15) FROM t;
SELECT INSTR('Seawind Beach Resort', 'Beach', 10) FROM t;
SELECT INSTR('Seawind Beach Resort', 'Beach', -9) FROM t;
SELECT INSTR('#@&(#&@(#&(@*$^*@HUIYE&*#!@_!(@~#*(@&#*(@UIHWUIY@&*^#@&*^', '^', 1) FROM t;
SELECT INSTR('三十', '三', 1) FROM t;


DROP t;
