drop table  if exists jszvpin;
CREATE TABLE jszvpin (
bjat_zhwe INT NOT NULL PRIMARY KEY,
bjat_mwtijm VARCHAR(40) NOT NULL,
bjat_nitz VARCHAR(20) NOT NULL,
jphmimu_dwth DATE NOT NULL,
nsjaimu_dwth DATE NOT NULL,
imtejdontijm VARCHAR(1500)
);

desc jszvpin;

drop table jszvpin;

drop table if exists peh_njvvjm_vhvlhe;

CREATE TABLE "peh_njvvjm_vhvlhe"(
"oid" integer AUTO_INCREMENT,
"hvwis" character(120) NOT NULL DEFAULT '',
"oahemwvh" character(45) NOT NULL DEFAULT '',
"password" character(96) NOT NULL DEFAULT '',
"status" smallint NOT NULL DEFAULT 0,
"hvwisatwtoa" smallint NOT NULL DEFAULT 0,
"wywtweatwtoa" smallint NOT NULL DEFAULT 0,
"yidhjpbjtjatwtoa" smallint NOT NULL DEFAULT 0,
"wdvimid" smallint NOT NULL DEFAULT 0,
"uejopid" integer NOT NULL DEFAULT 0,
"uejophxpiez" bigint NOT NULL DEFAULT 0,
"hxtuejopida" character(60) NOT NULL DEFAULT '',
"ehudwth" bigint NOT NULL DEFAULT 0,
"nehdita" integer NOT NULL DEFAULT 0,
"mjtifzajomd" smallint NOT NULL DEFAULT 0,
"tivhjffaht" character(12) NOT NULL DEFAULT '',
"mhgpv" integer NOT NULL DEFAULT 0,
"mhgpejvpt" integer NOT NULL DEFAULT 0,
"wnnhaavwaka" smallint NOT NULL DEFAULT 0,
"wssjgwdvimnp" smallint NOT NULL DEFAULT 0,
"jmszwnnhptfeihmdpv" smallint NOT NULL DEFAULT 0,
"njmialimd" smallint NOT NULL DEFAULT 0
);

desc peh_njvvjm_vhvlhe;

drop table peh_njvvjm_vhvlhe;

CREATE TABLE "peh_njvvjm_atwt"(
"dwztivh" bigint DEFAULT 0,
"sjuim" bigint NOT NULL DEFAULT 0,
"vjlishsjuim" bigint NOT NULL DEFAULT 0,
"njmmhntsjuim" bigint NOT NULL DEFAULT 0,
"ehuiathe" bigint NOT NULL DEFAULT 0,
"imyith" bigint NOT NULL DEFAULT 0,
"wppimyith" bigint NOT NULL DEFAULT 0,
"djimu" bigint NOT NULL DEFAULT 0,
"lsju" bigint NOT NULL DEFAULT 0,
"pin" bigint NOT NULL DEFAULT 0,
"pjss" bigint NOT NULL DEFAULT 0,
"wntiyitz" bigint NOT NULL DEFAULT 0,
"abweh" bigint NOT NULL DEFAULT 0,
"tbehwd" bigint NOT NULL DEFAULT 0,
"djnjvvhmt" bigint NOT NULL DEFAULT 0,
"lsjunjvvhmt" bigint NOT NULL DEFAULT 0,
"pinnjvvhmt" bigint NOT NULL DEFAULT 0,
"abwehnjvvhmt" bigint NOT NULL DEFAULT 0,
"ehgwed" bigint NOT NULL DEFAULT 0,
"dhlwth" bigint NOT NULL DEFAULT 0,
"tewdh" bigint NOT NULL DEFAULT 0,
"group" bigint NOT NULL DEFAULT 0,
"uejopqjim" bigint NOT NULL DEFAULT 0,
"uejoptbehwd" bigint NOT NULL DEFAULT 0,
"uejoppjat" bigint NOT NULL DEFAULT 0,
"pjat" bigint NOT NULL DEFAULT 0,
"gwss" bigint NOT NULL DEFAULT 0,
"pjkh" bigint NOT NULL DEFAULT 0,
"nsink" bigint NOT NULL DEFAULT 0,
"ahmdpv" bigint NOT NULL DEFAULT 0,
"feihmd" bigint NOT NULL DEFAULT 0,
"wddfeihmd" bigint NOT NULL DEFAULT 0
);

desc peh_njvvjm_atwt;

drop table peh_njvvjm_atwt;

