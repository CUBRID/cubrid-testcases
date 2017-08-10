
drop table  if exists t1;

CREATE TABLE t1(
i integer AUTO_INCREMENT,
titsh character varying(765) NOT NULL,
oes character varying(765) NOT NULL,
ajet smallint NOT NULL DEFAULT 0,
diapswzjedhe smallint NOT NULL,
nsinka integer NOT NULL DEFAULT 1,
oid integer NOT NULL
);

drop table t1;

CREATE TABLE t1(
i integer AUTO_INCREMENT,
titsh character varying(765) NOT NULL,
oes character varying(765) NOT NULL,
ajet smallint NOT NULL DEFAULT 0,
diapswzjedhe smallint NOT NULL,
nsinka integer NOT NULL DEFAULT 1,
oid integer NOT NULL
) partition by hash(i) partitions 5;

desc t1;

drop table t1;

drop table if exists t2;

CREATE TABLE "t2"(
"lid" integer AUTO_INCREMENT,
"lsjnknswaa" character varying(765) NOT NULL DEFAULT '0',
"lsjnktzph" smallint NOT NULL DEFAULT 0,
"name" character varying(765) NOT NULL DEFAULT '',
"titsh" character varying(196605) NOT NULL,
"nswaamwvh" character varying(765) NOT NULL DEFAULT '',
"aovvwez" character varying(196605) NOT NULL,
"oid" integer NOT NULL DEFAULT 0,
"oahemwvh" character varying(765) NOT NULL DEFAULT '',
"atzshid" integer NOT NULL DEFAULT 0,
"lsjnkatzsh" character varying(196605) NOT NULL,
"pingidtb" integer NOT NULL DEFAULT 0,
"pinbhiubt" integer NOT NULL DEFAULT 0,
"tweuht" character varying(765) NOT NULL DEFAULT '',
"dwthfjevwt" character varying(765) NOT NULL DEFAULT '',
"dwthofjevwt" smallint NOT NULL DEFAULT 0,
"aneipt" character varying(765) NOT NULL DEFAULT '',
"pwewv" character varying(196605) NOT NULL,
"abjgmov" integer NOT NULL DEFAULT 0,
"nwnbhtivh" integer NOT NULL DEFAULT 0,
"nwnbhtivhewmuh" character(15) NOT NULL DEFAULT '',
"pomntowsopdwth" smallint NOT NULL DEFAULT 0,
"bidhdiapswz" smallint NOT NULL DEFAULT 0,
"dwthsimh" bigint NOT NULL DEFAULT 0,
"mjtimbheithd" smallint NOT NULL DEFAULT 0,
"ialswmk" smallint NOT NULL DEFAULT 0
)
;

drop table t2;

