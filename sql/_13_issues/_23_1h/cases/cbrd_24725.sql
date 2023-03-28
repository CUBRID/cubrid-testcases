DROP TABLE IF EXISTS tb_stats_download_update;
DROP TABLE IF EXISTS tb_school;
DROP TABLE IF EXISTS tb_stats_download;

CREATE TABLE [tb_stats_download_update] (
	[seq] BIGINT NOT NULL,
	[user_id] CHARACTER VARYING (64),
	[book_full_seq] CHARACTER VARYING (128),
	[book_chapter_id] CHARACTER VARYING (128),
	[ex_school_code] CHARACTER VARYING (64),
	[ex_school_grade] CHARACTER VARYING (32),
	[platform] CHARACTER VARYING (64),
	[whenauth] CHARACTER(8),
	[create_date] DATETIME,
	[hh] CHARACTER(2),
	[ex_location] CHARACTER VARYING (32),
	[ex_sclyy] CHARACTER(8),
	[ex_type] CHARACTER(8),
	CONSTRAINT [pk_tb_stats_download_update_seq] PRIMARY KEY([seq]),
	INDEX [tb_stats_download_update_when] ([whenauth] DESC, [book_full_seq] DESC),
	INDEX [idx_tb_stats_download_update_02] ([book_full_seq], [whenauth]),
	INDEX [idx_tb_stats_download_update_01] ([whenauth], [book_chapter_id])
)
REUSE_OID,
COLLATE utf8_bin

CREATE TABLE [tb_school] (
	[code] CHARACTER VARYING (10) NOT NULL,
	[name] CHARACTER VARYING (120),
	[location] CHARACTER VARYING (120),
	[ex_schgrade] CHARACTER VARYING (50),
	[ex_eduofficecode] CHARACTER VARYING (10),
	[ex_eduofficename] CHARACTER VARYING (120),
	[ex_addr] CHARACTER VARYING (256),
	[ex_schgrade_code] CHARACTER(2),
	[endschst] CHARACTER VARYING (40),
	[wireless] CHARACTER VARYING (10),
	[closed_yn] CHARACTER VARYING (10),
	CONSTRAINT [pk_tb_school] PRIMARY KEY([code]),
	INDEX [i_tb_school_ex_schgrade_code] ([ex_schgrade_code]),
	INDEX [i_tb_school_ex_schgrade_ex_schgrade_code] ([ex_schgrade], [ex_schgrade_code]),
	INDEX [i_tb_school_location] ([location]),
	INDEX [idx_tb_school_01] ([name], [code])
)
REUSE_OID,
COLLATE utf8_bin

CREATE TABLE [tb_stats_download] (
	[id] BIGINT AUTO_INCREMENT(1, 1) NOT NULL,
	[book_full_id] CHARACTER VARYING (128),
	[book_chapter_id] CHARACTER VARYING (128),
	[yyyymmdd] CHARACTER(8),
	[hh] CHARACTER(2),
	[user_id] CHARACTER VARYING (64),
	[user_ex_type] CHARACTER(8),
	[user_ex_sclyy] CHARACTER(8),
	[user_ex_school_code] CHARACTER VARYING (64),
	[user_ex_school_grade] CHARACTER VARYING (32),
	[user_ex_location] CHARACTER VARYING (32),
	[device_platform] CHARACTER VARYING (64),
	[regdate] TIMESTAMP,
	[book_full_seq] INTEGER,
	[book_full_name] CHARACTER VARYING (128),
	[browser] CHARACTER VARYING (50),
	CONSTRAINT [pk_tb_stats_download_temp_id] PRIMARY KEY([id]),
	INDEX [idx_tb_stats_download_01] ([yyyymmdd], [book_chapter_id]),
	INDEX [idx_tb_stats_download_02] ([book_full_seq], [yyyymmdd]),
	INDEX [i_tb_stats_download_yyyymmdd_user_ex_location_book_full_seq] ([yyyymmdd], [user_ex_location], [book_full_seq]),
	INDEX [i_tb_stats_download_yyyymmdd_hh_book_full_seq] ([yyyymmdd], [hh], [book_full_seq]),
	INDEX [i_tb_stats_download_yyyymmdd] ([yyyymmdd], [book_full_seq]),
	INDEX [idx_tb_stats_download_03] ([yyyymmdd], [user_ex_school_grade]),
	INDEX [idx_tb_stat_download_04] ([book_full_seq])
)
REUSE_OID,
COLLATE utf8_bin

INSERT INTO TB_STATS_DOWNLOAD_UPDATE 
SELECT ROWNUM, ROWNUM, rownum%10, ROWNUM, rownum%100, ROWNUM, ROWNUM, '20230322', SYSDATE, 'a', ROWNUM, ROWNUM, ROWNUM FROM db_class a, db_class b;

INSERT INTO TB_SCHOOL
SELECT rownum, '02', '02', '02', '02', '02', '02', '02', '02', '02', 'a' FROM db_class a, db_class b;

INSERT INTO TB_STATS_DOWNLOAD 
SELECT ROWNUM, 'a', 'a',  '20230322', 'a', 'a', 'a','a', rownum%50, 'a', 'a', 'a', sysdate,rownum%50, 'a','a' FROM db_class a, db_class b;


SELECT
	ROWNUM,
	A.*
FROM
	(
		SELECT
			NVL(A.NAME, '기타') AS "NAME",
			NVL(A.CODE, '없음') AS "CODE",
			NVL(A.EX_EDUOFFICENAME, '기타') AS "EX_EDUOFFICENAME",
			NVL(A.EX_SCHGRADE, '기타') AS EX_SCHGRADE,
			SUM(NVL("2585", 0)) AS "2585",
			SUM(NVL("2585_up", 0)) AS "2585_up",
			SUM(NVL("2586", 0)) AS "2586",
			SUM(NVL("2586_up", 0)) AS "2586_up",
			SUM(NVL("2591", 0)) AS "2591",
			SUM(NVL("2591_up", 0)) AS "2591_up",
			SUM(NVL("2592", 0)) AS "2592",
			SUM(NVL("2592_up", 0)) AS "2592_up",
			SUM(NVL("2598", 0)) AS "2598",
			SUM(NVL("2598_up", 0)) AS "2598_up",
			SUM(NVL("2599", 0)) AS "2599",
			SUM(NVL("2599_up", 0)) AS "2599_up",
			SUM(NVL("2601", 0)) AS "2601",
			SUM(NVL("2601_up", 0)) AS "2601_up",
			SUM(NVL("2608", 0)) AS "2608",
			SUM(NVL("2608_up", 0)) AS "2608_up",
			SUM(NVL("2617", 0)) AS "2617",
			SUM(NVL("2617_up", 0)) AS "2617_up",
			SUM(NVL("2625", 0)) AS "2625",
			SUM(NVL("2625_up", 0)) AS "2625_up",
			SUM(NVL("2631", 0)) AS "2631",
			SUM(NVL("2631_up", 0)) AS "2631_up",
			SUM(NVL("2632", 0)) AS "2632",
			SUM(NVL("2632_up", 0)) AS "2632_up",
			SUM(NVL("2633", 0)) AS "2633",
			SUM(NVL("2633_up", 0)) AS "2633_up",
			SUM(NVL("2634", 0)) AS "2634",
			SUM(NVL("2634_up", 0)) AS "2634_up",
			SUM(NVL("2635", 0)) AS "2635",
			SUM(NVL("2635_up", 0)) AS "2635_up",
			SUM(NVL("2638", 0)) AS "2638",
			SUM(NVL("2638_up", 0)) AS "2638_up",
			SUM(NVL("2639", 0)) AS "2639",
			SUM(NVL("2639_up", 0)) AS "2639_up",
			SUM(NVL("2640", 0)) AS "2640",
			SUM(NVL("2640_up", 0)) AS "2640_up",
			SUM(NVL("2641", 0)) AS "2641",
			SUM(NVL("2641_up", 0)) AS "2641_up",
			SUM(NVL("2642", 0)) AS "2642",
			SUM(NVL("2642_up", 0)) AS "2642_up",
			SUM(NVL("2644", 0)) AS "2644",
			SUM(NVL("2644_up", 0)) AS "2644_up",
			SUM(NVL("2656", 0)) AS "2656",
			SUM(NVL("2656_up", 0)) AS "2656_up",
			SUM(NVL("2657", 0)) AS "2657",
			SUM(NVL("2657_up", 0)) AS "2657_up",
			SUM(NVL("2658", 0)) AS "2658",
			SUM(NVL("2658_up", 0)) AS "2658_up",
			SUM(NVL("2659", 0)) AS "2659",
			SUM(NVL("2659_up", 0)) AS "2659_up",
			SUM(NVL("2661", 0)) AS "2661",
			SUM(NVL("2661_up", 0)) AS "2661_up",
			SUM(NVL("2662", 0)) AS "2662",
			SUM(NVL("2662_up", 0)) AS "2662_up",
			SUM(NVL("2663", 0)) AS "2663",
			SUM(NVL("2663_up", 0)) AS "2663_up",
			SUM(NVL("2667", 0)) AS "2667",
			SUM(NVL("2667_up", 0)) AS "2667_up",
			SUM(NVL("2668", 0)) AS "2668",
			SUM(NVL("2668_up", 0)) AS "2668_up",
			SUM(NVL("2670", 0)) AS "2670",
			SUM(NVL("2670_up", 0)) AS "2670_up",
			SUM(NVL("2672", 0)) AS "2672",
			SUM(NVL("2672_up", 0)) AS "2672_up",
			SUM(NVL("2673", 0)) AS "2673",
			SUM(NVL("2673_up", 0)) AS "2673_up",
			SUM(NVL("2674", 0)) AS "2674",
			SUM(NVL("2674_up", 0)) AS "2674_up",
			SUM(NVL("2675", 0)) AS "2675",
			SUM(NVL("2675_up", 0)) AS "2675_up",
			SUM(NVL("2677", 0)) AS "2677",
			SUM(NVL("2677_up", 0)) AS "2677_up",
			SUM(NVL("2680", 0)) AS "2680",
			SUM(NVL("2680_up", 0)) AS "2680_up",
			SUM(NVL("2685", 0)) AS "2685",
			SUM(NVL("2685_up", 0)) AS "2685_up",
			SUM(NVL("2687", 0)) AS "2687",
			SUM(NVL("2687_up", 0)) AS "2687_up",
			SUM(NVL("2688", 0)) AS "2688",
			SUM(NVL("2688_up", 0)) AS "2688_up",
			SUM(NVL("2689", 0)) AS "2689",
			SUM(NVL("2689_up", 0)) AS "2689_up",
			SUM(NVL("2692", 0)) AS "2692",
			SUM(NVL("2692_up", 0)) AS "2692_up",
			SUM(NVL("2694", 0)) AS "2694",
			SUM(NVL("2694_up", 0)) AS "2694_up",
			SUM(NVL("2695", 0)) AS "2695",
			SUM(NVL("2695_up", 0)) AS "2695_up",
			SUM(NVL("2696", 0)) AS "2696",
			SUM(NVL("2696_up", 0)) AS "2696_up",
			SUM(NVL("2697", 0)) AS "2697",
			SUM(NVL("2697_up", 0)) AS "2697_up",
			SUM(NVL("2699", 0)) AS "2699",
			SUM(NVL("2699_up", 0)) AS "2699_up",
			SUM(NVL("2701", 0)) AS "2701",
			SUM(NVL("2701_up", 0)) AS "2701_up",
			SUM(NVL("2707", 0)) AS "2707",
			SUM(NVL("2707_up", 0)) AS "2707_up",
			SUM(NVL("2708", 0)) AS "2708",
			SUM(NVL("2708_up", 0)) AS "2708_up",
			SUM(NVL("2710", 0)) AS "2710",
			SUM(NVL("2710_up", 0)) AS "2710_up",
			SUM(NVL("2711", 0)) AS "2711",
			SUM(NVL("2711_up", 0)) AS "2711_up",
			SUM(NVL("2719", 0)) AS "2719",
			SUM(NVL("2719_up", 0)) AS "2719_up",
			SUM(NVL("2726", 0)) AS "2726",
			SUM(NVL("2726_up", 0)) AS "2726_up",
			SUM(NVL("2728", 0)) AS "2728",
			SUM(NVL("2728_up", 0)) AS "2728_up",
			SUM(NVL("2729", 0)) AS "2729",
			SUM(NVL("2729_up", 0)) AS "2729_up",
			SUM(NVL("2733", 0)) AS "2733",
			SUM(NVL("2733_up", 0)) AS "2733_up",
			SUM(NVL("2734", 0)) AS "2734",
			SUM(NVL("2734_up", 0)) AS "2734_up",
			SUM(NVL("2736", 0)) AS "2736",
			SUM(NVL("2736_up", 0)) AS "2736_up",
			SUM(NVL("2737", 0)) AS "2737",
			SUM(NVL("2737_up", 0)) AS "2737_up",
			SUM(NVL("2739", 0)) AS "2739",
			SUM(NVL("2739_up", 0)) AS "2739_up",
			SUM(NVL("2740", 0)) AS "2740",
			SUM(NVL("2740_up", 0)) AS "2740_up",
			SUM(NVL("2743", 0)) AS "2743",
			SUM(NVL("2743_up", 0)) AS "2743_up",
			SUM(NVL("2745", 0)) AS "2745",
			SUM(NVL("2745_up", 0)) AS "2745_up",
			SUM(NVL("2746", 0)) AS "2746",
			SUM(NVL("2746_up", 0)) AS "2746_up",
			SUM(NVL("2747", 0)) AS "2747",
			SUM(NVL("2747_up", 0)) AS "2747_up",
			SUM(NVL("2748", 0)) AS "2748",
			SUM(NVL("2748_up", 0)) AS "2748_up",
			SUM(NVL("2817", 0)) AS "2817",
			SUM(NVL("2817_up", 0)) AS "2817_up",
			SUM(NVL("2965", 0)) AS "2965",
			SUM(NVL("2965_up", 0)) AS "2965_up",
			SUM(NVL("2966", 0)) AS "2966",
			SUM(NVL("2966_up", 0)) AS "2966_up",
			SUM(NVL("2967", 0)) AS "2967",
			SUM(NVL("2967_up", 0)) AS "2967_up",
			SUM(NVL("2968", 0)) AS "2968",
			SUM(NVL("2968_up", 0)) AS "2968_up",
			SUM(NVL("2969", 0)) AS "2969",
			SUM(NVL("2969_up", 0)) AS "2969_up",
			SUM(NVL("3084", 0)) AS "3084",			
                        SUM(NVL("3084_up", 0)) AS "3084_up",
			SUM(NVL("3085", 0)) AS "3085",
			SUM(NVL("3085_up", 0)) AS "3085_up",
			SUM(NVL("3102", 0)) AS "3102",
			SUM(NVL("3102_up", 0)) AS "3102_up",
			SUM(NVL("3103", 0)) AS "3103",
			SUM(NVL("3103_up", 0)) AS "3103_up",
			SUM(NVL("3104", 0)) AS "3104",
			SUM(NVL("3104_up", 0)) AS "3104_up",
			SUM(NVL("3105", 0)) AS "3105",
			SUM(NVL("3105_up", 0)) AS "3105_up",
			SUM(NVL("3106", 0)) AS "3106",
			SUM(NVL("3106_up", 0)) AS "3106_up",
			SUM(NVL("3107", 0)) AS "3107",
			SUM(NVL("3107_up", 0)) AS "3107_up",
			SUM(NVL("3108", 0)) AS "3108",
			SUM(NVL("3108_up", 0)) AS "3108_up",
			SUM(NVL("3109", 0)) AS "3109",
			SUM(NVL("3109_up", 0)) AS "3109_up",
			SUM(NVL("3111", 0)) AS "3111",
			SUM(NVL("3111_up", 0)) AS "3111_up",
			SUM(NVL("3112", 0)) AS "3112",
			SUM(NVL("3112_up", 0)) AS "3112_up",
			SUM(NVL("3114", 0)) AS "3114",
			SUM(NVL("3114_up", 0)) AS "3114_up",
			SUM(NVL("3115", 0)) AS "3115",
			SUM(NVL("3115_up", 0)) AS "3115_up",
			SUM(NVL("3116", 0)) AS "3116",
			SUM(NVL("3116_up", 0)) AS "3116_up",
			SUM(NVL("3117", 0)) AS "3117",
			SUM(NVL("3117_up", 0)) AS "3117_up",
			SUM(NVL("3118", 0)) AS "3118",
			SUM(NVL("3118_up", 0)) AS "3118_up",
			SUM(NVL("3119", 0)) AS "3119",
			SUM(NVL("3119_up", 0)) AS "3119_up",
			SUM(NVL("3120", 0)) AS "3120",
			SUM(NVL("3120_up", 0)) AS "3120_up",
			SUM(NVL("3121", 0)) AS "3121",
			SUM(NVL("3121_up", 0)) AS "3121_up",
			SUM(NVL("3122", 0)) AS "3122",
			SUM(NVL("3122_up", 0)) AS "3122_up",
			SUM(NVL("3123", 0)) AS "3123",
			SUM(NVL("3123_up", 0)) AS "3123_up",
			SUM(NVL("3124", 0)) AS "3124",
			SUM(NVL("3124_up", 0)) AS "3124_up",
			SUM(NVL("3125", 0)) AS "3125",
			SUM(NVL("3125_up", 0)) AS "3125_up",
			SUM(NVL("3126", 0)) AS "3126",
			SUM(NVL("3126_up", 0)) AS "3126_up",
			SUM(NVL("3128", 0)) AS "3128",
			SUM(NVL("3128_up", 0)) AS "3128_up",
			SUM(NVL("3129", 0)) AS "3129",
			SUM(NVL("3129_up", 0)) AS "3129_up",
			SUM(NVL("3130", 0)) AS "3130",
			SUM(NVL("3130_up", 0)) AS "3130_up",
			SUM(NVL("3133", 0)) AS "3133",
			SUM(NVL("3133_up", 0)) AS "3133_up",
			SUM(NVL("3134", 0)) AS "3134",
			SUM(NVL("3134_up", 0)) AS "3134_up",
			SUM(NVL("3323", 0)) AS "3323",
			SUM(NVL("3323_up", 0)) AS "3323_up",
			SUM(NVL("3329", 0)) AS "3329",
			SUM(NVL("3329_up", 0)) AS "3329_up",
			SUM(NVL("3332", 0)) AS "3332",
			SUM(NVL("3332_up", 0)) AS "3332_up",
			SUM(NVL("3334", 0)) AS "3334",
			SUM(NVL("3334_up", 0)) AS "3334_up",
			SUM(NVL("3335", 0)) AS "3335",
			SUM(NVL("3335_up", 0)) AS "3335_up",
			SUM(NVL("3336", 0)) AS "3336",
			SUM(NVL("3336_up", 0)) AS "3336_up",
			SUM(NVL("3338", 0)) AS "3338",
			SUM(NVL("3338_up", 0)) AS "3338_up",
			SUM(NVL("3339", 0)) AS "3339",
			SUM(NVL("3339_up", 0)) AS "3339_up",
			SUM(NVL("3340", 0)) AS "3340",
			SUM(NVL("3340_up", 0)) AS "3340_up",
			SUM(NVL("3341", 0)) AS "3341",
			SUM(NVL("3341_up", 0)) AS "3341_up",
			SUM(NVL("3342", 0)) AS "3342",
			SUM(NVL("3342_up", 0)) AS "3342_up",
			SUM(NVL("3343", 0)) AS "3343",
			SUM(NVL("3343_up", 0)) AS "3343_up",
			SUM(NVL("3344", 0)) AS "3344",
			SUM(NVL("3344_up", 0)) AS "3344_up",
			SUM(NVL("3345", 0)) AS "3345",
			SUM(NVL("3345_up", 0)) AS "3345_up",
			SUM(NVL("3346", 0)) AS "3346",
			SUM(NVL("3346_up", 0)) AS "3346_up",
			SUM(NVL("3347", 0)) AS "3347",
			SUM(NVL("3347_up", 0)) AS "3347_up",
			SUM(NVL("3349", 0)) AS "3349",
			SUM(NVL("3349_up", 0)) AS "3349_up",
			SUM(NVL("3350", 0)) AS "3350",
			SUM(NVL("3350_up", 0)) AS "3350_up",
			SUM(NVL("3351", 0)) AS "3351",
			SUM(NVL("3351_up", 0)) AS "3351_up",
			SUM(NVL("3352", 0)) AS "3352",
			SUM(NVL("3352_up", 0)) AS "3352_up",
			SUM(NVL("3353", 0)) AS "3353",			
            SUM(NVL("3353_up", 0)) AS "3353_up",
			SUM(NVL("3369", 0)) AS "3369",
			SUM(NVL("3369_up", 0)) AS "3369_up",
			SUM(NVL("3370", 0)) AS "3370",
			SUM(NVL("3370_up", 0)) AS "3370_up",
			SUM(NVL("3385", 0)) AS "3385",
			SUM(NVL("3385_up", 0)) AS "3385_up",
			SUM(NVL("3386", 0)) AS "3386",
			SUM(NVL("3386_up", 0)) AS "3386_up",
			SUM(NVL("3387", 0)) AS "3387",
			SUM(NVL("3387_up", 0)) AS "3387_up",
			SUM(NVL("3388", 0)) AS "3388",
			SUM(NVL("3388_up", 0)) AS "3388_up",
			SUM(NVL("3389", 0)) AS "3389",
			SUM(NVL("3389_up", 0)) AS "3389_up",
			SUM(NVL("3390", 0)) AS "3390",
			SUM(NVL("3390_up", 0)) AS "3390_up",
			SUM(NVL("3391", 0)) AS "3391",
			SUM(NVL("3391_up", 0)) AS "3391_up",
			SUM(NVL("3392", 0)) AS "3392",
			SUM(NVL("3392_up", 0)) AS "3392_up",
			SUM(NVL("3393", 0)) AS "3393",
			SUM(NVL("3393_up", 0)) AS "3393_up",
			SUM(NVL("3394", 0)) AS "3394",
			SUM(NVL("3394_up", 0)) AS "3394_up",
			SUM(NVL("3395", 0)) AS "3395",
			SUM(NVL("3395_up", 0)) AS "3395_up",
			SUM(NVL("3396", 0)) AS "3396",
			SUM(NVL("3396_up", 0)) AS "3396_up",
			SUM(NVL("3397", 0)) AS "3397",
			SUM(NVL("3397_up", 0)) AS "3397_up",
			SUM(NVL("3398", 0)) AS "3398",
			SUM(NVL("3398_up", 0)) AS "3398_up",
			SUM(NVL("3399", 0)) AS "3399",
			SUM(NVL("3399_up", 0)) AS "3399_up",
			SUM(NVL("3400", 0)) AS "3400",
			SUM(NVL("3400_up", 0)) AS "3400_up",
			SUM(NVL("3401", 0)) AS "3401",
			SUM(NVL("3401_up", 0)) AS "3401_up",
			SUM(NVL("3402", 0)) AS "3402",
			SUM(NVL("3402_up", 0)) AS "3402_up",
			SUM(NVL("3403", 0)) AS "3403",
			SUM(NVL("3403_up", 0)) AS "3403_up",
			SUM(NVL("3408", 0)) AS "3408",
			SUM(NVL("3408_up", 0)) AS "3408_up",
			SUM(NVL("3409", 0)) AS "3409",
			SUM(NVL("3409_up", 0)) AS "3409_up",
			SUM(NVL("3410", 0)) AS "3410",
			SUM(NVL("3410_up", 0)) AS "3410_up",
			SUM(NVL("3411", 0)) AS "3411",
			SUM(NVL("3411_up", 0)) AS "3411_up",
			SUM(NVL("3412", 0)) AS "3412",
			SUM(NVL("3412_up", 0)) AS "3412_up",
			SUM(NVL("3413", 0)) AS "3413",
			SUM(NVL("3413_up", 0)) AS "3413_up",
			SUM(NVL("3414", 0)) AS "3414",
			SUM(NVL("3414_up", 0)) AS "3414_up",
			SUM(NVL("3415", 0)) AS "3415",
			SUM(NVL("3415_up", 0)) AS "3415_up",
			SUM(NVL("3416", 0)) AS "3416",
			SUM(NVL("3416_up", 0)) AS "3416_up",
			SUM(NVL("3417", 0)) AS "3417",
			SUM(NVL("3417_up", 0)) AS "3417_up",
			SUM(NVL("3418", 0)) AS "3418",
			SUM(NVL("3418_up", 0)) AS "3418_up",
			SUM(NVL("3419", 0)) AS "3419",
			SUM(NVL("3419_up", 0)) AS "3419_up",
			SUM(NVL("3420", 0)) AS "3420",
			SUM(NVL("3420_up", 0)) AS "3420_up",
			SUM(NVL("3421", 0)) AS "3421",
			SUM(NVL("3421_up", 0)) AS "3421_up",
			SUM(NVL("3422", 0)) AS "3422",
			SUM(NVL("3422_up", 0)) AS "3422_up",
			SUM(NVL("3423", 0)) AS "3423",
			SUM(NVL("3423_up", 0)) AS "3423_up",
			SUM(NVL("3424", 0)) AS "3424",
			SUM(NVL("3424_up", 0)) AS "3424_up",
			SUM(NVL("3425", 0)) AS "3425",
			SUM(NVL("3425_up", 0)) AS "3425_up",
			SUM(NVL("3426", 0)) AS "3426",
			SUM(NVL("3426_up", 0)) AS "3426_up",
			SUM(NVL("3427", 0)) AS "3427",
			SUM(NVL("3427_up", 0)) AS "3427_up",
			SUM(NVL("3428", 0)) AS "3428",
			SUM(NVL("3428_up", 0)) AS "3428_up",
			SUM(NVL("3429", 0)) AS "3429",
			SUM(NVL("3429_up", 0)) AS "3429_up",
			SUM(NVL("3430", 0)) AS "3430",
			SUM(NVL("3430_up", 0)) AS "3430_up",
			SUM(NVL("3431", 0)) AS "3431",
			SUM(NVL("3431_up", 0)) AS "3431_up",
			SUM(NVL("3432", 0)) AS "3432",
			SUM(NVL("3432_up", 0)) AS "3432_up",
			SUM(NVL("3433", 0)) AS "3433",
			SUM(NVL("3433_up", 0)) AS "3433_up",
			SUM(NVL("3434", 0)) AS "3434",
			SUM(NVL("3434_up", 0)) AS "3434_up",
			SUM(NVL("3435", 0)) AS "3435",
			SUM(NVL("3435_up", 0)) AS "3435_up",
			SUM(NVL("3436", 0)) AS "3436",
			SUM(NVL("3436_up", 0)) AS "3436_up",
			SUM(NVL("3437", 0)) AS "3437",
			SUM(NVL("3437_up", 0)) AS "3437_up",
			SUM(NVL("3438", 0)) AS "3438",
			SUM(NVL("3438_up", 0)) AS "3438_up",
			SUM(NVL("3439", 0)) AS "3439",
			SUM(NVL("3439_up", 0)) AS "3439_up",
			SUM(NVL("3440", 0)) AS "3440",
			SUM(NVL("3440_up", 0)) AS "3440_up",
			SUM(NVL("3441", 0)) AS "3441",
			SUM(NVL("3441_up", 0)) AS "3441_up",
			SUM(NVL("3442", 0)) AS "3442",
			SUM(NVL("3442_up", 0)) AS "3442_up",
			SUM(NVL("3443", 0)) AS "3443",
			SUM(NVL("3443_up", 0)) AS "3443_up",
			SUM(NVL("3444", 0)) AS "3444",
			SUM(NVL("3444_up", 0)) AS "3444_up",
			SUM(NVL("3471", 0)) AS "3471",
			SUM(NVL("3471_up", 0)) AS "3471_up",
			SUM(NVL("3473", 0)) AS "3473",
			SUM(NVL("3473_up", 0)) AS "3473_up",
			SUM(NVL("3505", 0)) AS "3505",
			SUM(NVL("3505_up", 0)) AS "3505_up",
			SUM(NVL("3506", 0)) AS "3506",
			SUM(NVL("3506_up", 0)) AS "3506_up",
			SUM(NVL("3508", 0)) AS "3508",
			SUM(NVL("3508_up", 0)) AS "3508_up",
			SUM(NVL("3509", 0)) AS "3509",
			SUM(NVL("3509_up", 0)) AS "3509_up",
			SUM(NVL("3511", 0)) AS "3511",
			SUM(NVL("3511_up", 0)) AS "3511_up",
			SUM(NVL("3512", 0)) AS "3512",
			SUM(NVL("3512_up", 0)) AS "3512_up",
			SUM(NVL("3513", 0)) AS "3513",
			SUM(NVL("3513_up", 0)) AS "3513_up",
			SUM(NVL("3514", 0)) AS "3514",
			SUM(NVL("3514_up", 0)) AS "3514_up",
			SUM(NVL("3515", 0)) AS "3515",
			SUM(NVL("3515_up", 0)) AS "3515_up",
			SUM(NVL("3517", 0)) AS "3517",
			SUM(NVL("3517_up", 0)) AS "3517_up",
			SUM(NVL("3518", 0)) AS "3518",
			SUM(NVL("3518_up", 0)) AS "3518_up",
			SUM(NVL("3519", 0)) AS "3519",
			SUM(NVL("3519_up", 0)) AS "3519_up",
			SUM(NVL("3535", 0)) AS "3535",
			SUM(NVL("3535_up", 0)) AS "3535_up",
			SUM(NVL("3537", 0)) AS "3537",
			SUM(NVL("3537_up", 0)) AS "3537_up",
			SUM(NVL("3538", 0)) AS "3538",
			SUM(NVL("3538_up", 0)) AS "3538_up",
			SUM(NVL("3539", 0)) AS "3539",
			SUM(NVL("3539_up", 0)) AS "3539_up",
			SUM(NVL("3540", 0)) AS "3540",
			SUM(NVL("3540_up", 0)) AS "3540_up",
			SUM(NVL("3541", 0)) AS "3541",
			SUM(NVL("3541_up", 0)) AS "3541_up",
			SUM(NVL("3542", 0)) AS "3542",
			SUM(NVL("3542_up", 0)) AS "3542_up",
			SUM(NVL("3543", 0)) AS "3543",
			SUM(NVL("3543_up", 0)) AS "3543_up",
			SUM(NVL("3544", 0)) AS "3544",
			SUM(NVL("3544_up", 0)) AS "3544_up",
			SUM(NVL("3545", 0)) AS "3545",
			SUM(NVL("3545_up", 0)) AS "3545_up",
			SUM(NVL("3546", 0)) AS "3546",
			SUM(NVL("3546_up", 0)) AS "3546_up",
			SUM(NVL("3547", 0)) AS "3547",
			SUM(NVL("3547_up", 0)) AS "3547_up",
			SUM(NVL("3548", 0)) AS "3548",
			SUM(NVL("3548_up", 0)) AS "3548_up",
			SUM(NVL("3549", 0)) AS "3549",
			SUM(NVL("3549_up", 0)) AS "3549_up",
			SUM(NVL("3550", 0)) AS "3550",
			SUM(NVL("3550_up", 0)) AS "3550_up",
			SUM(NVL("3551", 0)) AS "3551",
			SUM(NVL("3551_up", 0)) AS "3551_up",
			SUM(NVL("3552", 0)) AS "3552",
			SUM(NVL("3552_up", 0)) AS "3552_up",
			SUM(NVL("3553", 0)) AS "3553",
			SUM(NVL("3553_up", 0)) AS "3553_up",
			SUM(NVL("3554", 0)) AS "3554",
			SUM(NVL("3554_up", 0)) AS "3554_up",
			SUM(NVL("3555", 0)) AS "3555",
			SUM(NVL("3555_up", 0)) AS "3555_up",
			SUM(NVL("3557", 0)) AS "3557",
			SUM(NVL("3557_up", 0)) AS "3557_up",
			SUM(NVL("3559", 0)) AS "3559",
			SUM(NVL("3559_up", 0)) AS "3559_up",
			SUM(NVL("3560", 0)) AS "3560",
			SUM(NVL("3560_up", 0)) AS "3560_up",
			SUM(NVL("3561", 0)) AS "3561",
			SUM(NVL("3561_up", 0)) AS "3561_up",
			SUM(NVL("3562", 0)) AS "3562",
			SUM(NVL("3562_up", 0)) AS "3562_up",
			SUM(NVL("3563", 0)) AS "3563",
			SUM(NVL("3563_up", 0)) AS "3563_up",
			SUM(NVL("3564", 0)) AS "3564",
			SUM(NVL("3564_up", 0)) AS "3564_up",
			SUM(NVL("3565", 0)) AS "3565",
			SUM(NVL("3565_up", 0)) AS "3565_up",
			SUM(NVL("3566", 0)) AS "3566",
			SUM(NVL("3566_up", 0)) AS "3566_up",
			SUM(NVL("3567", 0)) AS "3567",
			SUM(NVL("3567_up", 0)) AS "3567_up",
			SUM(NVL("3568", 0)) AS "3568",
			SUM(NVL("3568_up", 0)) AS "3568_up",
			SUM(NVL("3569", 0)) AS "3569",
			SUM(NVL("3569_up", 0)) AS "3569_up",
			SUM(NVL("3570", 0)) AS "3570",
			SUM(NVL("3570_up", 0)) AS "3570_up",
			SUM(NVL("3571", 0)) AS "3571",
			SUM(NVL("3571_up", 0)) AS "3571_up",
			SUM(NVL("3572", 0)) AS "3572",
			SUM(NVL("3572_up", 0)) AS "3572_up",
			SUM(NVL("3573", 0)) AS "3573",
			SUM(NVL("3573_up", 0)) AS "3573_up",
			SUM(NVL("3574", 0)) AS "3574",
			SUM(NVL("3574_up", 0)) AS "3574_up",
			SUM(NVL("3575", 0)) AS "3575",
			SUM(NVL("3575_up", 0)) AS "3575_up",
			SUM(NVL("3576", 0)) AS "3576",
			SUM(NVL("3576_up", 0)) AS "3576_up",
			SUM(NVL("3577", 0)) AS "3577",
			SUM(NVL("3577_up", 0)) AS "3577_up",
			SUM(NVL("3579", 0)) AS "3579",
			SUM(NVL("3579_up", 0)) AS "3579_up",
			SUM(NVL("3583", 0)) AS "3583",
			SUM(NVL("3583_up", 0)) AS "3583_up",
			SUM(NVL("3584", 0)) AS "3584",
			SUM(NVL("3584_up", 0)) AS "3584_up",
			SUM(NVL("3585", 0)) AS "3585",
			SUM(NVL("3585_up", 0)) AS "3585_up",
			SUM(NVL("3586", 0)) AS "3586",
			SUM(NVL("3586_up", 0)) AS "3586_up",
			SUM(NVL("3587", 0)) AS "3587",
			SUM(NVL("3587_up", 0)) AS "3587_up",
			SUM(NVL("3588", 0)) AS "3588",
			SUM(NVL("3588_up", 0)) AS "3588_up",
			SUM(NVL("3590", 0)) AS "3590",
			SUM(NVL("3590_up", 0)) AS "3590_up",
			SUM(NVL("3591", 0)) AS "3591",
			SUM(NVL("3591_up", 0)) AS "3591_up",
			SUM(NVL("3592", 0)) AS "3592",
			SUM(NVL("3592_up", 0)) AS "3592_up",
			SUM(NVL("3593", 0)) AS "3593",
			SUM(NVL("3593_up", 0)) AS "3593_up",
			SUM(NVL("3594", 0)) AS "3594",
			SUM(NVL("3594_up", 0)) AS "3594_up",
			SUM(NVL("3595", 0)) AS "3595",			
            SUM(NVL("3595_up", 0)) AS "3595_up",
			SUM(NVL("3596", 0)) AS "3596",
			SUM(NVL("3596_up", 0)) AS "3596_up",
			SUM(NVL("3597", 0)) AS "3597",
			SUM(NVL("3597_up", 0)) AS "3597_up",
			SUM(NVL("3598", 0)) AS "3598",
			SUM(NVL("3598_up", 0)) AS "3598_up",
			SUM(NVL("3599", 0)) AS "3599",
			SUM(NVL("3599_up", 0)) AS "3599_up",
			SUM(NVL("3600", 0)) AS "3600",
			SUM(NVL("3600_up", 0)) AS "3600_up",
			SUM(NVL("3601", 0)) AS "3601",
			SUM(NVL("3601_up", 0)) AS "3601_up",
			SUM(NVL("3602", 0)) AS "3602",
			SUM(NVL("3602_up", 0)) AS "3602_up",
			SUM(NVL("3603", 0)) AS "3603",
			SUM(NVL("3603_up", 0)) AS "3603_up",
			SUM(NVL("3604", 0)) AS "3604",
			SUM(NVL("3604_up", 0)) AS "3604_up",
			SUM(NVL("3605", 0)) AS "3605",
			SUM(NVL("3605_up", 0)) AS "3605_up",
			SUM(NVL("3606", 0)) AS "3606",
			SUM(NVL("3606_up", 0)) AS "3606_up",
			SUM(NVL("3607", 0)) AS "3607",
			SUM(NVL("3607_up", 0)) AS "3607_up",
			SUM(NVL("3608", 0)) AS "3608",
			SUM(NVL("3608_up", 0)) AS "3608_up",
			SUM(NVL("3609", 0)) AS "3609",
			SUM(NVL("3609_up", 0)) AS "3609_up",
			SUM(NVL("3610", 0)) AS "3610",
			SUM(NVL("3610_up", 0)) AS "3610_up",
			SUM(NVL("3611", 0)) AS "3611",
			SUM(NVL("3611_up", 0)) AS "3611_up",
			SUM(NVL("3612", 0)) AS "3612",
			SUM(NVL("3612_up", 0)) AS "3612_up",
			SUM(NVL("3613", 0)) AS "3613",
			SUM(NVL("3613_up", 0)) AS "3613_up",
			SUM(NVL("3614", 0)) AS "3614",
			SUM(NVL("3614_up", 0)) AS "3614_up",
			SUM(NVL("3615", 0)) AS "3615",
			SUM(NVL("3615_up", 0)) AS "3615_up",
			SUM(NVL("3616", 0)) AS "3616",
			SUM(NVL("3616_up", 0)) AS "3616_up",
			SUM(NVL("3617", 0)) AS "3617",
			SUM(NVL("3617_up", 0)) AS "3617_up",
			SUM(NVL("3618", 0)) AS "3618",
			SUM(NVL("3618_up", 0)) AS "3618_up",
			SUM(NVL("3619", 0)) AS "3619",
			SUM(NVL("3619_up", 0)) AS "3619_up",
			SUM(NVL("3620", 0)) AS "3620",
			SUM(NVL("3620_up", 0)) AS "3620_up",
			SUM(NVL("3621", 0)) AS "3621",
			SUM(NVL("3621_up", 0)) AS "3621_up",
			SUM(NVL("3622", 0)) AS "3622",
			SUM(NVL("3622_up", 0)) AS "3622_up",
			SUM(NVL("3655", 0)) AS "3655",
			SUM(NVL("3655_up", 0)) AS "3655_up",
			SUM(NVL("3656", 0)) AS "3656",
			SUM(NVL("3656_up", 0)) AS "3656_up",
			SUM(NVL("3657", 0)) AS "3657",
			SUM(NVL("3657_up", 0)) AS "3657_up",
			SUM(NVL("3658", 0)) AS "3658",
			SUM(NVL("3658_up", 0)) AS "3658_up",
			SUM(NVL("3674", 0)) AS "3674",
			SUM(NVL("3674_up", 0)) AS "3674_up",
			SUM(NVL("3675", 0)) AS "3675",
			SUM(NVL("3675_up", 0)) AS "3675_up",
			SUM(NVL("3676", 0)) AS "3676",
			SUM(NVL("3676_up", 0)) AS "3676_up",
			SUM(NVL("3677", 0)) AS "3677",
			SUM(NVL("3677_up", 0)) AS "3677_up"
		FROM
			(
				SELECT
					CODE,
					NAME AS "NAME",
					EX_EDUOFFICENAME,
					EX_SCHGRADE
				FROM
					TB_SCHOOL
				WHERE
					1 = 1
					AND ex_schgrade_code IN (
						'02',
						'03',
						'04',
						'06'
					)
				ORDER BY
					NAME
			) A
			RIGHT OUTER JOIN (
				SELECT
					*
				FROM
					(
						SELECT
							USER_EX_SCHOOL_CODE,
							NVL(SUM("2585"), 0) AS "2585",
							NVL(SUM("2585_up"), 0) AS "2585_up",
							NVL(SUM("2586"), 0) AS "2586",
							NVL(SUM("2586_up"), 0) AS "2586_up",
							NVL(SUM("2591"), 0) AS "2591",
							NVL(SUM("2591_up"), 0) AS "2591_up",
							NVL(SUM("2592"), 0) AS "2592",
							NVL(SUM("2592_up"), 0) AS "2592_up",
							NVL(SUM("2598"), 0) AS "2598",
							NVL(SUM("2598_up"), 0) AS "2598_up",
							NVL(SUM("2599"), 0) AS "2599",
							NVL(SUM("2599_up"), 0) AS "2599_up",
							NVL(SUM("2601"), 0) AS "2601",
							NVL(SUM("2601_up"), 0) AS "2601_up",
							NVL(SUM("2608"), 0) AS "2608",
							NVL(SUM("2608_up"), 0) AS "2608_up",
							NVL(SUM("2617"), 0) AS "2617",
							NVL(SUM("2617_up"), 0) AS "2617_up",
							NVL(SUM("2625"), 0) AS "2625",
							NVL(SUM("2625_up"), 0) AS "2625_up",
							NVL(SUM("2631"), 0) AS "2631",							
                            NVL(SUM("2631_up"), 0) AS "2631_up",
							NVL(SUM("2632"), 0) AS "2632",
							NVL(SUM("2632_up"), 0) AS "2632_up",
							NVL(SUM("2633"), 0) AS "2633",
							NVL(SUM("2633_up"), 0) AS "2633_up",
							NVL(SUM("2634"), 0) AS "2634",							
                            NVL(SUM("2634_up"), 0) AS "2634_up",
							NVL(SUM("2635"), 0) AS "2635",
							NVL(SUM("2635_up"), 0) AS "2635_up",
							NVL(SUM("2638"), 0) AS "2638",
							NVL(SUM("2638_up"), 0) AS "2638_up",
							NVL(SUM("2639"), 0) AS "2639",
							NVL(SUM("2639_up"), 0) AS "2639_up",
							NVL(SUM("2640"), 0) AS "2640",
							NVL(SUM("2640_up"), 0) AS "2640_up",
							NVL(SUM("2641"), 0) AS "2641",
							NVL(SUM("2641_up"), 0) AS "2641_up",
							NVL(SUM("2642"), 0) AS "2642",
							NVL(SUM("2642_up"), 0) AS "2642_up",
							NVL(SUM("2644"), 0) AS "2644",
							NVL(SUM("2644_up"), 0) AS "2644_up",
							NVL(SUM("2656"), 0) AS "2656",
							NVL(SUM("2656_up"), 0) AS "2656_up",
							NVL(SUM("2657"), 0) AS "2657",
							NVL(SUM("2657_up"), 0) AS "2657_up",
							NVL(SUM("2658"), 0) AS "2658",
							NVL(SUM("2658_up"), 0) AS "2658_up",
							NVL(SUM("2659"), 0) AS "2659",
							NVL(SUM("2659_up"), 0) AS "2659_up",
							NVL(SUM("2661"), 0) AS "2661",
							NVL(SUM("2661_up"), 0) AS "2661_up",
							NVL(SUM("2662"), 0) AS "2662",
							NVL(SUM("2662_up"), 0) AS "2662_up",
							NVL(SUM("2663"), 0) AS "2663",
							NVL(SUM("2663_up"), 0) AS "2663_up",
							NVL(SUM("2667"), 0) AS "2667",
							NVL(SUM("2667_up"), 0) AS "2667_up",
							NVL(SUM("2668"), 0) AS "2668",
							NVL(SUM("2668_up"), 0) AS "2668_up",
							NVL(SUM("2670"), 0) AS "2670",
							NVL(SUM("2670_up"), 0) AS "2670_up",
							NVL(SUM("2672"), 0) AS "2672",
							NVL(SUM("2672_up"), 0) AS "2672_up",
							NVL(SUM("2673"), 0) AS "2673",
							NVL(SUM("2673_up"), 0) AS "2673_up",
							NVL(SUM("2674"), 0) AS "2674",
							NVL(SUM("2674_up"), 0) AS "2674_up",
							NVL(SUM("2675"), 0) AS "2675",
							NVL(SUM("2675_up"), 0) AS "2675_up",
							NVL(SUM("2677"), 0) AS "2677",
							NVL(SUM("2677_up"), 0) AS "2677_up",
							NVL(SUM("2680"), 0) AS "2680",
							NVL(SUM("2680_up"), 0) AS "2680_up",
							NVL(SUM("2685"), 0) AS "2685",
							NVL(SUM("2685_up"), 0) AS "2685_up",
							NVL(SUM("2687"), 0) as "2687",
							NVL(SUM("2687_up"), 0) AS "2687_up",
							NVL(SUM("2688"), 0) AS "2688",
							NVL(SUM("2688_up"), 0) AS "2688_up",
							NVL(SUM("2689"), 0) AS "2689",
							NVL(SUM("2689_up"), 0) AS "2689_up",
							NVL(SUM("2692"), 0) AS "2692",
							NVL(SUM("2692_up"), 0) AS "2692_up",
							NVL(SUM("2694"), 0) AS "2694",
							NVL(SUM("2694_up"), 0) AS "2694_up",
							NVL(SUM("2695"), 0) AS "2695",
							NVL(SUM("2695_up"), 0) AS "2695_up",
							NVL(SUM("2696"), 0) AS "2696",
							NVL(SUM("2696_up"), 0) AS "2696_up",
							NVL(SUM("2697"), 0) AS "2697",
							NVL(SUM("2697_up"), 0) AS "2697_up",
							NVL(SUM("2699"), 0) AS "2699",
							NVL(SUM("2699_up"), 0) AS "2699_up",
							NVL(SUM("2701"), 0) AS "2701",
							NVL(SUM("2701_up"), 0) AS "2701_up",
							NVL(SUM("2707"), 0) AS "2707",
							NVL(SUM("2707_up"), 0) AS "2707_up",
							NVL(SUM("2708"), 0) AS "2708",
							NVL(SUM("2708_up"), 0) AS "2708_up",
							NVL(SUM("2710"), 0) AS "2710",							
                            NVL(SUM("2710_up"), 0) AS "2710_up",
							NVL(SUM("2711"), 0) AS "2711",
							NVL(SUM("2711_up"), 0) AS "2711_up",
							NVL(SUM("2719"), 0) AS "2719",
							NVL(SUM("2719_up"), 0) AS "2719_up",
							NVL(SUM("2726"), 0) AS "2726",
							NVL(SUM("2726_up"), 0) AS "2726_up",
							NVL(SUM("2728"), 0) AS "2728",
							NVL(SUM("2728_up"), 0) AS "2728_up",
							NVL(SUM("2729"), 0) AS "2729",
							NVL(SUM("2729_up"), 0) AS "2729_up",
							NVL(SUM("2733"), 0) AS "2733",
							NVL(SUM("2733_up"), 0) AS "2733_up",
							NVL(SUM("2734"), 0) AS "2734",
							NVL(SUM("2734_up"), 0) AS "2734_up",
							NVL(SUM("2736"), 0) AS "2736",
							NVL(SUM("2736_up"), 0) AS "2736_up",
							NVL(SUM("2737"), 0) AS "2737",
							NVL(SUM("2737_up"), 0) AS "2737_up",
							NVL(SUM("2739"), 0) AS "2739",
							NVL(SUM("2739_up"), 0) AS "2739_up",
							NVL(SUM("2740"), 0) AS "2740",
							NVL(SUM("2740_up"), 0) AS "2740_up",
							NVL(SUM("2743"), 0) AS "2743",
							NVL(SUM("2743_up"), 0) AS "2743_up",
							NVL(SUM("2745"), 0) AS "2745",
							NVL(SUM("2745_up"), 0) AS "2745_up",
							NVL(SUM("2746"), 0) AS "2746",
							NVL(SUM("2746_up"), 0) AS "2746_up",
							NVL(SUM("2747"), 0) AS "2747",
							NVL(SUM("2747_up"), 0) AS "2747_up",
							NVL(SUM("2748"), 0) AS "2748",
							NVL(SUM("2748_up"), 0) AS "2748_up",
							NVL(SUM("2817"), 0) AS "2817",
							NVL(SUM("2817_up"), 0) AS "2817_up",
							NVL(SUM("2965"), 0) AS "2965",
							NVL(SUM("2965_up"), 0) AS "2965_up",
							NVL(SUM("2966"), 0) AS "2966",
							NVL(SUM("2966_up"), 0) AS "2966_up",
							NVL(SUM("2967"), 0) AS "2967",
							NVL(SUM("2967_up"), 0) AS "2967_up",
							NVL(SUM("2968"), 0) AS "2968",
							NVL(SUM("2968_up"), 0) AS "2968_up",
							NVL(SUM("2969"), 0) AS "2969",
							NVL(SUM("2969_up"), 0) AS "2969_up",
							NVL(SUM("3084"), 0) AS "3084",
							NVL(SUM("3084_up"), 0) AS "3084_up",
							NVL(SUM("3085"), 0) AS "3085",
							NVL(SUM("3085_up"), 0) AS "3085_up",
							NVL(SUM("3102"), 0) AS "3102",
							NVL(SUM("3102_up"), 0) AS "3102_up",
							NVL(SUM("3103"), 0) AS "3103",
							NVL(SUM("3103_up"), 0) AS "3103_up",
							NVL(SUM("3104"), 0) AS "3104",
							NVL(SUM("3104_up"), 0) AS "3104_up",
							NVL(SUM("3105"), 0) as "3105",
							NVL(SUM("3105_up"), 0) AS "3105_up",
							NVL(SUM("3106"), 0) AS "3106",
							NVL(SUM("3106_up"), 0) AS "3106_up",
							NVL(SUM("3107"), 0) AS "3107",
							NVL(SUM("3107_up"), 0) AS "3107_up",
							NVL(SUM("3108"), 0) AS "3108",
							NVL(SUM("3108_up"), 0) AS "3108_up",
							NVL(SUM("3109"), 0) AS "3109",
							NVL(SUM("3109_up"), 0) AS "3109_up",
							NVL(SUM("3111"), 0) AS "3111",
							NVL(SUM("3111_up"), 0) AS "3111_up",
							NVL(SUM("3112"), 0) AS "3112",
							NVL(SUM("3112_up"), 0) AS "3112_up",
							NVL(SUM("3114"), 0) AS "3114",
							NVL(SUM("3114_up"), 0) AS "3114_up",
							NVL(SUM("3115"), 0) AS "3115",
							NVL(SUM("3115_up"), 0) AS "3115_up",
							NVL(SUM("3116"), 0) AS "3116",
							NVL(SUM("3116_up"), 0) AS "3116_up",
							NVL(SUM("3117"), 0) AS "3117",
							NVL(SUM("3117_up"), 0) AS "3117_up",
							NVL(SUM("3118"), 0) AS "3118",
							NVL(SUM("3118_up"), 0) AS "3118_up",
							NVL(SUM("3119"), 0) AS "3119",
							NVL(SUM("3119_up"), 0) AS "3119_up",
							NVL(SUM("3120"), 0) AS "3120",
							NVL(SUM("3120_up"), 0) AS "3120_up",
							NVL(SUM("3121"), 0) AS "3121",
							NVL(SUM("3121_up"), 0) AS "3121_up",
							NVL(SUM("3122"), 0) AS "3122",
							NVL(SUM("3122_up"), 0) AS "3122_up",
							NVL(SUM("3123"), 0) AS "3123",
							NVL(SUM("3123_up"), 0) AS "3123_up",
							NVL(SUM("3124"), 0) AS "3124",
							NVL(SUM("3124_up"), 0) AS "3124_up",
							NVL(SUM("3125"), 0) AS "3125",
							NVL(SUM("3125_up"), 0) AS "3125_up",
							NVL(SUM("3126"), 0) AS "3126",
							NVL(SUM("3126_up"), 0) AS "3126_up",
							NVL(SUM("3128"), 0) AS "3128",
							NVL(SUM("3128_up"), 0) AS "3128_up",
							NVL(SUM("3129"), 0) AS "3129",
							NVL(SUM("3129_up"), 0) AS "3129_up",
							NVL(SUM("3130"), 0) AS "3130",
							NVL(SUM("3130_up"), 0) AS "3130_up",
							NVL(SUM("3133"), 0) AS "3133",
							NVL(SUM("3133_up"), 0) AS "3133_up",
							NVL(SUM("3134"), 0) AS "3134",
							NVL(SUM("3134_up"), 0) AS "3134_up",
							NVL(SUM("3323"), 0) AS "3323",
							NVL(SUM("3323_up"), 0) AS "3323_up",
							NVL(SUM("3329"), 0) AS "3329",
							NVL(SUM("3329_up"), 0) AS "3329_up",
							NVL(SUM("3332"), 0) AS "3332",
							NVL(SUM("3332_up"), 0) AS "3332_up",
							NVL(SUM("3334"), 0) AS "3334",
							NVL(SUM("3334_up"), 0) AS "3334_up",
							NVL(SUM("3335"), 0) AS "3335",
							NVL(SUM("3335_up"), 0) AS "3335_up",
							NVL(SUM("3336"), 0) AS "3336",
							NVL(SUM("3336_up"), 0) AS "3336_up",
							NVL(SUM("3338"), 0) AS "3338",
							NVL(SUM("3338_up"), 0) AS "3338_up",
							NVL(SUM("3339"), 0) AS "3339",
							NVL(SUM("3339_up"), 0) AS "3339_up",
							NVL(SUM("3340"), 0) AS "3340",
							NVL(SUM("3340_up"), 0) AS "3340_up",
							NVL(SUM("3341"), 0) AS "3341",
							NVL(SUM("3341_up"), 0) AS "3341_up",
							NVL(SUM("3342"), 0) AS "3342",
							NVL(SUM("3342_up"), 0) AS "3342_up",
							NVL(SUM("3343"), 0) AS "3343",
							NVL(SUM("3343_up"), 0) AS "3343_up",
							NVL(SUM("3344"), 0) AS "3344",
							NVL(SUM("3344_up"), 0) AS "3344_up",
							NVL(SUM("3345"), 0) AS "3345",
							NVL(SUM("3345_up"), 0) AS "3345_up",
							NVL(SUM("3346"), 0) AS "3346",
							NVL(SUM("3346_up"), 0) AS "3346_up",
							NVL(SUM("3347"), 0) as "3347",
							NVL(SUM("3347_up"), 0) AS "3347_up",
							NVL(SUM("3349"), 0) AS "3349",
							NVL(SUM("3349_up"), 0) AS "3349_up",
							NVL(SUM("3350"), 0) AS "3350",
							NVL(SUM("3350_up"), 0) AS "3350_up",
							NVL(SUM("3351"), 0) AS "3351",
							NVL(SUM("3351_up"), 0) AS "3351_up",
							NVL(SUM("3352"), 0) AS "3352",
							NVL(SUM("3352_up"), 0) AS "3352_up",
							NVL(SUM("3353"), 0) AS "3353",
							NVL(SUM("3353_up"), 0) AS "3353_up",
							NVL(SUM("3369"), 0) AS "3369",
							NVL(SUM("3369_up"), 0) AS "3369_up",
							NVL(SUM("3370"), 0) AS "3370",
							NVL(SUM("3370_up"), 0) AS "3370_up",
							NVL(SUM("3385"), 0) AS "3385",
							NVL(SUM("3385_up"), 0) AS "3385_up",
							NVL(SUM("3386"), 0) AS "3386",
							NVL(SUM("3386_up"), 0) AS "3386_up",
							NVL(SUM("3387"), 0) AS "3387",
							NVL(SUM("3387_up"), 0) AS "3387_up",
							NVL(SUM("3388"), 0) AS "3388",
							NVL(SUM("3388_up"), 0) AS "3388_up",
							NVL(SUM("3389"), 0) AS "3389",
							NVL(SUM("3389_up"), 0) AS "3389_up",
							NVL(SUM("3390"), 0) AS "3390",
							NVL(SUM("3390_up"), 0) AS "3390_up",
							NVL(SUM("3391"), 0) AS "3391",
							NVL(SUM("3391_up"), 0) AS "3391_up",
							NVL(SUM("3392"), 0) AS "3392",
							NVL(SUM("3392_up"), 0) AS "3392_up",
							NVL(SUM("3393"), 0) AS "3393",
							NVL(SUM("3393_up"), 0) AS "3393_up",
							NVL(SUM("3394"), 0) AS "3394",
							NVL(SUM("3394_up"), 0) AS "3394_up",
							NVL(SUM("3395"), 0) AS "3395",
							NVL(SUM("3395_up"), 0) AS "3395_up",
							NVL(SUM("3396"), 0) AS "3396",
							NVL(SUM("3396_up"), 0) AS "3396_up",
							NVL(SUM("3397"), 0) AS "3397",
							NVL(SUM("3397_up"), 0) AS "3397_up",
							NVL(SUM("3398"), 0) AS "3398",
							NVL(SUM("3398_up"), 0) AS "3398_up",
							NVL(SUM("3399"), 0) AS "3399",
							NVL(SUM("3399_up"), 0) AS "3399_up",
							NVL(SUM("3400"), 0) AS "3400",
							NVL(SUM("3400_up"), 0) AS "3400_up",
							NVL(SUM("3401"), 0) AS "3401",
							NVL(SUM("3401_up"), 0) AS "3401_up",
							NVL(SUM("3402"), 0) AS "3402",
							NVL(SUM("3402_up"), 0) AS "3402_up",
							NVL(SUM("3403"), 0) AS "3403",
							NVL(SUM("3403_up"), 0) AS "3403_up",
							NVL(SUM("3408"), 0) AS "3408",
							NVL(SUM("3408_up"), 0) AS "3408_up",
							NVL(SUM("3409"), 0) AS "3409",
							NVL(SUM("3409_up"), 0) AS "3409_up",
							NVL(SUM("3410"), 0) AS "3410",
							NVL(SUM("3410_up"), 0) AS "3410_up",
							NVL(SUM("3411"), 0) AS "3411",
							NVL(SUM("3411_up"), 0) AS "3411_up",
							NVL(SUM("3412"), 0) AS "3412",
							NVL(SUM("3412_up"), 0) AS "3412_up",
							NVL(SUM("3413"), 0) AS "3413",
							NVL(SUM("3413_up"), 0) AS "3413_up",
							NVL(SUM("3414"), 0) AS "3414",
							NVL(SUM("3414_up"), 0) AS "3414_up",
							NVL(SUM("3415"), 0) AS "3415",
							NVL(SUM("3415_up"), 0) AS "3415_up",
							NVL(SUM("3416"), 0) AS "3416",
							NVL(SUM("3416_up"), 0) AS "3416_up",
							NVL(SUM("3417"), 0) AS "3417",
							NVL(SUM("3417_up"), 0) AS "3417_up",
							NVL(SUM("3418"), 0) AS "3418",
							NVL(SUM("3418_up"), 0) AS "3418_up",
							NVL(SUM("3419"), 0) AS "3419",
							NVL(SUM("3419_up"), 0) AS "3419_up",
							NVL(SUM("3420"), 0) AS "3420",
							NVL(SUM("3420_up"), 0) AS "3420_up",
							NVL(SUM("3421"), 0) as "3421",
							NVL(SUM("3421_up"), 0) AS "3421_up",
							NVL(SUM("3422"), 0) AS "3422",
							NVL(SUM("3422_up"), 0) AS "3422_up",
							NVL(SUM("3423"), 0) AS "3423",
							NVL(SUM("3423_up"), 0) AS "3423_up",
							NVL(SUM("3424"), 0) AS "3424",
							NVL(SUM("3424_up"), 0) AS "3424_up",
							NVL(SUM("3425"), 0) AS "3425",
							NVL(SUM("3425_up"), 0) AS "3425_up",
							NVL(SUM("3426"), 0) AS "3426",
							NVL(SUM("3426_up"), 0) AS "3426_up",
							NVL(SUM("3427"), 0) AS "3427",
							NVL(SUM("3427_up"), 0) AS "3427_up",
							NVL(SUM("3428"), 0) AS "3428",
							NVL(SUM("3428_up"), 0) AS "3428_up",
							NVL(SUM("3429"), 0) AS "3429",
							NVL(SUM("3429_up"), 0) AS "3429_up",
							NVL(SUM("3430"), 0) AS "3430",
							NVL(SUM("3430_up"), 0) AS "3430_up",
							NVL(SUM("3431"), 0) AS "3431",
							NVL(SUM("3431_up"), 0) AS "3431_up",
							NVL(SUM("3432"), 0) AS "3432",
							NVL(SUM("3432_up"), 0) AS "3432_up",
							NVL(SUM("3433"), 0) AS "3433",
							NVL(SUM("3433_up"), 0) AS "3433_up",
							NVL(SUM("3434"), 0) AS "3434",
							NVL(SUM("3434_up"), 0) AS "3434_up",
							NVL(SUM("3435"), 0) AS "3435",
							NVL(SUM("3435_up"), 0) AS "3435_up",
							NVL(SUM("3436"), 0) AS "3436",
							NVL(SUM("3436_up"), 0) AS "3436_up",
							NVL(SUM("3437"), 0) AS "3437",
							NVL(SUM("3437_up"), 0) AS "3437_up",
							NVL(SUM("3438"), 0) AS "3438",
							NVL(SUM("3438_up"), 0) AS "3438_up",
							NVL(SUM("3439"), 0) AS "3439",
							NVL(SUM("3439_up"), 0) AS "3439_up",
							NVL(SUM("3440"), 0) AS "3440",
							NVL(SUM("3440_up"), 0) AS "3440_up",
							NVL(SUM("3441"), 0) AS "3441",
							NVL(SUM("3441_up"), 0) AS "3441_up",
							NVL(SUM("3442"), 0) AS "3442",
							NVL(SUM("3442_up"), 0) AS "3442_up",
							NVL(SUM("3443"), 0) AS "3443",
							NVL(SUM("3443_up"), 0) AS "3443_up",
							NVL(SUM("3444"), 0) AS "3444",
							NVL(SUM("3444_up"), 0) AS "3444_up",
							NVL(SUM("3471"), 0) AS "3471",
							NVL(SUM("3471_up"), 0) AS "3471_up",
							NVL(SUM("3473"), 0) AS "3473",
							NVL(SUM("3473_up"), 0) AS "3473_up",
							NVL(SUM("3505"), 0) AS "3505",
							NVL(SUM("3505_up"), 0) AS "3505_up",
							NVL(SUM("3506"), 0) AS "3506",
							NVL(SUM("3506_up"), 0) AS "3506_up",
							NVL(SUM("3508"), 0) AS "3508",
							NVL(SUM("3508_up"), 0) AS "3508_up",
							NVL(SUM("3509"), 0) AS "3509",
							NVL(SUM("3509_up"), 0) AS "3509_up",
							NVL(SUM("3511"), 0) AS "3511",
							NVL(SUM("3511_up"), 0) AS "3511_up",
							NVL(SUM("3512"), 0) AS "3512",
							NVL(SUM("3512_up"), 0) AS "3512_up",
							NVL(SUM("3513"), 0) AS "3513",
							NVL(SUM("3513_up"), 0) AS "3513_up",
							NVL(SUM("3514"), 0) AS "3514",
							NVL(SUM("3514_up"), 0) AS "3514_up",
							NVL(SUM("3515"), 0) AS "3515",
							NVL(SUM("3515_up"), 0) AS "3515_up",
							NVL(SUM("3517"), 0) AS "3517",
							NVL(SUM("3517_up"), 0) AS "3517_up",
							NVL(SUM("3518"), 0) AS "3518",
							NVL(SUM("3518_up"), 0) AS "3518_up",
							NVL(SUM("3519"), 0) AS "3519",
							NVL(SUM("3519_up"), 0) AS "3519_up",
							NVL(SUM("3535"), 0) AS "3535",
							NVL(SUM("3535_up"), 0) AS "3535_up",
							NVL(SUM("3537"), 0) AS "3537",
							NVL(SUM("3537_up"), 0) AS "3537_up",
							NVL(SUM("3538"), 0) as "3538",
							NVL(SUM("3538_up"), 0) AS "3538_up",
							NVL(SUM("3539"), 0) AS "3539",
							NVL(SUM("3539_up"), 0) AS "3539_up",
							NVL(SUM("3540"), 0) AS "3540",
							NVL(SUM("3540_up"), 0) AS "3540_up",
							NVL(SUM("3541"), 0) AS "3541",
							NVL(SUM("3541_up"), 0) AS "3541_up",
							NVL(SUM("3542"), 0) AS "3542",
							NVL(SUM("3542_up"), 0) AS "3542_up",
							NVL(SUM("3543"), 0) AS "3543",
							NVL(SUM("3543_up"), 0) AS "3543_up",
							NVL(SUM("3544"), 0) AS "3544",
							NVL(SUM("3544_up"), 0) AS "3544_up",
							NVL(SUM("3545"), 0) AS "3545",
							NVL(SUM("3545_up"), 0) AS "3545_up",
							NVL(SUM("3546"), 0) AS "3546",
							NVL(SUM("3546_up"), 0) AS "3546_up",
							NVL(SUM("3547"), 0) AS "3547",
							NVL(SUM("3547_up"), 0) AS "3547_up",
							NVL(SUM("3548"), 0) AS "3548",
							NVL(SUM("3548_up"), 0) AS "3548_up",
							NVL(SUM("3549"), 0) AS "3549",
							NVL(SUM("3549_up"), 0) AS "3549_up",
							NVL(SUM("3550"), 0) AS "3550",
							NVL(SUM("3550_up"), 0) AS "3550_up",
							NVL(SUM("3551"), 0) AS "3551",
							NVL(SUM("3551_up"), 0) AS "3551_up",
							NVL(SUM("3552"), 0) AS "3552",
							NVL(SUM("3552_up"), 0) AS "3552_up",
							NVL(SUM("3553"), 0) AS "3553",
							NVL(SUM("3553_up"), 0) AS "3553_up",
							NVL(SUM("3554"), 0) AS "3554",
							NVL(SUM("3554_up"), 0) AS "3554_up",
							NVL(SUM("3555"), 0) AS "3555",
							NVL(SUM("3555_up"), 0) AS "3555_up",
							NVL(SUM("3557"), 0) AS "3557",
							NVL(SUM("3557_up"), 0) AS "3557_up",
							NVL(SUM("3559"), 0) AS "3559",
							NVL(SUM("3559_up"), 0) AS "3559_up",
							NVL(SUM("3560"), 0) AS "3560",
							NVL(SUM("3560_up"), 0) AS "3560_up",
							NVL(SUM("3561"), 0) AS "3561",
							NVL(SUM("3561_up"), 0) AS "3561_up",
							NVL(SUM("3562"), 0) AS "3562",
							NVL(SUM("3562_up"), 0) AS "3562_up",
							NVL(SUM("3563"), 0) AS "3563",
							NVL(SUM("3563_up"), 0) AS "3563_up",
							NVL(SUM("3564"), 0) AS "3564",
							NVL(SUM("3564_up"), 0) AS "3564_up",
							NVL(SUM("3565"), 0) AS "3565",
							NVL(SUM("3565_up"), 0) AS "3565_up",
							NVL(SUM("3566"), 0) AS "3566",
							NVL(SUM("3566_up"), 0) AS "3566_up",
							NVL(SUM("3567"), 0) AS "3567",
							NVL(SUM("3567_up"), 0) AS "3567_up",
							NVL(SUM("3568"), 0) AS "3568",
							NVL(SUM("3568_up"), 0) AS "3568_up",
							NVL(SUM("3569"), 0) AS "3569",
							NVL(SUM("3569_up"), 0) AS "3569_up",
							NVL(SUM("3570"), 0) AS "3570",
							NVL(SUM("3570_up"), 0) AS "3570_up",
							NVL(SUM("3571"), 0) AS "3571",
							NVL(SUM("3571_up"), 0) AS "3571_up",
							NVL(SUM("3572"), 0) AS "3572",
							NVL(SUM("3572_up"), 0) AS "3572_up",
							NVL(SUM("3573"), 0) AS "3573",
							NVL(SUM("3573_up"), 0) AS "3573_up",
							NVL(SUM("3574"), 0) AS "3574",
							NVL(SUM("3574_up"), 0) AS "3574_up",
							NVL(SUM("3575"), 0) AS "3575",
							NVL(SUM("3575_up"), 0) AS "3575_up",
							NVL(SUM("3576"), 0) AS "3576",
							NVL(SUM("3576_up"), 0) AS "3576_up",
							NVL(SUM("3577"), 0) AS "3577",
							NVL(SUM("3577_up"), 0) AS "3577_up",
							NVL(SUM("3579"), 0) AS "3579",
							NVL(SUM("3579_up"), 0) AS "3579_up",
							NVL(SUM("3583"), 0) AS "3583",
							NVL(SUM("3583_up"), 0) AS "3583_up",
							NVL(SUM("3584"), 0) as "3584",
							NVL(SUM("3584_up"), 0) AS "3584_up",
							NVL(SUM("3585"), 0) AS "3585",
							NVL(SUM("3585_up"), 0) AS "3585_up",
							NVL(SUM("3586"), 0) AS "3586",
							NVL(SUM("3586_up"), 0) AS "3586_up",
							NVL(SUM("3587"), 0) AS "3587",
							NVL(SUM("3587_up"), 0) AS "3587_up",
							NVL(SUM("3588"), 0) AS "3588",
							NVL(SUM("3588_up"), 0) AS "3588_up",
							NVL(SUM("3590"), 0) AS "3590",
							NVL(SUM("3590_up"), 0) AS "3590_up",
							NVL(SUM("3591"), 0) AS "3591",
							NVL(SUM("3591_up"), 0) AS "3591_up",
							NVL(SUM("3592"), 0) AS "3592",
							NVL(SUM("3592_up"), 0) AS "3592_up",
							NVL(SUM("3593"), 0) AS "3593",
							NVL(SUM("3593_up"), 0) AS "3593_up",
							NVL(SUM("3594"), 0) AS "3594",
							NVL(SUM("3594_up"), 0) AS "3594_up",
							NVL(SUM("3595"), 0) AS "3595",
							NVL(SUM("3595_up"), 0) AS "3595_up",
							NVL(SUM("3596"), 0) AS "3596",
							NVL(SUM("3596_up"), 0) AS "3596_up",
							NVL(SUM("3597"), 0) AS "3597",
							NVL(SUM("3597_up"), 0) AS "3597_up",
							NVL(SUM("3598"), 0) AS "3598",
							NVL(SUM("3598_up"), 0) AS "3598_up",
							NVL(SUM("3599"), 0) AS "3599",
							NVL(SUM("3599_up"), 0) AS "3599_up",
							NVL(SUM("3600"), 0) AS "3600",
							NVL(SUM("3600_up"), 0) AS "3600_up",
							NVL(SUM("3601"), 0) AS "3601",
							NVL(SUM("3601_up"), 0) AS "3601_up",
							NVL(SUM("3602"), 0) AS "3602",
							NVL(SUM("3602_up"), 0) AS "3602_up",
							NVL(SUM("3603"), 0) AS "3603",
							NVL(SUM("3603_up"), 0) AS "3603_up",
							NVL(SUM("3604"), 0) AS "3604",
							NVL(SUM("3604_up"), 0) AS "3604_up",
							NVL(SUM("3605"), 0) AS "3605",
							NVL(SUM("3605_up"), 0) AS "3605_up",
							NVL(SUM("3606"), 0) AS "3606",
							NVL(SUM("3606_up"), 0) AS "3606_up",
							NVL(SUM("3607"), 0) AS "3607",
							NVL(SUM("3607_up"), 0) AS "3607_up",
							NVL(SUM("3608"), 0) AS "3608",
							NVL(SUM("3608_up"), 0) AS "3608_up",
							NVL(SUM("3609"), 0) AS "3609",
							NVL(SUM("3609_up"), 0) AS "3609_up",
							NVL(SUM("3610"), 0) AS "3610",
							NVL(SUM("3610_up"), 0) AS "3610_up",
							NVL(SUM("3611"), 0) AS "3611",
							NVL(SUM("3611_up"), 0) AS "3611_up",
							NVL(SUM("3612"), 0) AS "3612",
							NVL(SUM("3612_up"), 0) AS "3612_up",
							NVL(SUM("3613"), 0) AS "3613",
							NVL(SUM("3613_up"), 0) AS "3613_up",
							NVL(SUM("3614"), 0) AS "3614",
							NVL(SUM("3614_up"), 0) AS "3614_up",
							NVL(SUM("3615"), 0) AS "3615",
							NVL(SUM("3615_up"), 0) AS "3615_up",
							NVL(SUM("3616"), 0) AS "3616",
							NVL(SUM("3616_up"), 0) AS "3616_up",
							NVL(SUM("3617"), 0) AS "3617",
							NVL(SUM("3617_up"), 0) AS "3617_up",
							NVL(SUM("3618"), 0) AS "3618",
							NVL(SUM("3618_up"), 0) AS "3618_up",
							NVL(SUM("3619"), 0) AS "3619",
							NVL(SUM("3619_up"), 0) AS "3619_up",
							NVL(SUM("3620"), 0) AS "3620",
							NVL(SUM("3620_up"), 0) AS "3620_up",
							NVL(SUM("3621"), 0) AS "3621",
							NVL(SUM("3621_up"), 0) AS "3621_up",
							NVL(SUM("3622"), 0) AS "3622",
							NVL(SUM("3622_up"), 0) AS "3622_up",
							NVL(SUM("3655"), 0) AS "3655",
							NVL(SUM("3655_up"), 0) AS "3655_up",
							NVL(SUM("3656"), 0) AS "3656",
							NVL(SUM("3656_up"), 0) AS "3656_up",
							NVL(SUM("3657"), 0) as "3657",
							NVL(SUM("3657_up"), 0) AS "3657_up",
							NVL(SUM("3658"), 0) AS "3658",
							NVL(SUM("3658_up"), 0) AS "3658_up",
							NVL(SUM("3674"), 0) AS "3674",
							NVL(SUM("3674_up"), 0) AS "3674_up",
							NVL(SUM("3675"), 0) AS "3675",
							NVL(SUM("3675_up"), 0) AS "3675_up",
							NVL(SUM("3676"), 0) AS "3676",
							NVL(SUM("3676_up"), 0) AS "3676_up",
							NVL(SUM("3677"), 0) AS "3677",
							NVL(SUM("3677_up"), 0) AS "3677_up"
						FROM
							(
								SELECT
									USER_EX_SCHOOL_CODE AS "USER_EX_SCHOOL_CODE",
									NVL(SUM("2585"), 0) AS "2585",
									NVL(SUM("2585_up"), 0) AS "2585_up",
									NVL(SUM("2586"), 0) AS "2586",
									NVL(SUM("2586_up"), 0) AS "2586_up",
									NVL(SUM("2591"), 0) AS "2591",
									NVL(SUM("2591_up"), 0) AS "2591_up",
									NVL(SUM("2592"), 0) AS "2592",
									NVL(SUM("2592_up"), 0) AS "2592_up",
									NVL(SUM("2598"), 0) AS "2598",
									NVL(SUM("2598_up"), 0) AS "2598_up",
									NVL(SUM("2599"), 0) AS "2599",
									NVL(SUM("2599_up"), 0) AS "2599_up",
									NVL(SUM("2601"), 0) AS "2601",
									NVL(SUM("2601_up"), 0) AS "2601_up",
									NVL(SUM("2608"), 0) AS "2608",
									NVL(SUM("2608_up"), 0) AS "2608_up",
									NVL(SUM("2617"), 0) AS "2617",
									NVL(SUM("2617_up"), 0) AS "2617_up",
									NVL(SUM("2625"), 0) AS "2625",
									NVL(SUM("2625_up"), 0) AS "2625_up",
									NVL(SUM("2631"), 0) AS "2631",
									NVL(SUM("2631_up"), 0) AS "2631_up",
									NVL(SUM("2632"), 0) AS "2632",
									NVL(SUM("2632_up"), 0) AS "2632_up",
									NVL(SUM("2633"), 0) AS "2633",
									NVL(SUM("2633_up"), 0) AS "2633_up",
									NVL(SUM("2634"), 0) AS "2634",
									NVL(SUM("2634_up"), 0) AS "2634_up",
									NVL(SUM("2635"), 0) AS "2635",
									NVL(SUM("2635_up"), 0) AS "2635_up",
									NVL(SUM("2638"), 0) AS "2638",
									NVL(SUM("2638_up"), 0) AS "2638_up",
									NVL(SUM("2639"), 0) AS "2639",
									NVL(SUM("2639_up"), 0) AS "2639_up",
									NVL(SUM("2640"), 0) AS "2640",									
                                    NVL(SUM("2640_up"), 0) AS "2640_up",
									NVL(SUM("2641"), 0) AS "2641",
									NVL(SUM("2641_up"), 0) AS "2641_up",
									NVL(SUM("2642"), 0) AS "2642",
									NVL(SUM("2642_up"), 0) AS "2642_up",
									NVL(SUM("2644"), 0) AS "2644",
									NVL(SUM("2644_up"), 0) AS "2644_up",
									NVL(SUM("2656"), 0) AS "2656",
									NVL(SUM("2656_up"), 0) AS "2656_up",
									NVL(SUM("2657"), 0) AS "2657",
									NVL(SUM("2657_up"), 0) AS "2657_up",
									NVL(SUM("2658"), 0) AS "2658",
									NVL(SUM("2658_up"), 0) AS "2658_up",
									NVL(SUM("2659"), 0) AS "2659",
									NVL(SUM("2659_up"), 0) AS "2659_up",
									NVL(SUM("2661"), 0) AS "2661",
									NVL(SUM("2661_up"), 0) AS "2661_up",
									NVL(SUM("2662"), 0) AS "2662",
									NVL(SUM("2662_up"), 0) AS "2662_up",
									NVL(SUM("2663"), 0) AS "2663",
									NVL(SUM("2663_up"), 0) AS "2663_up",
									NVL(SUM("2667"), 0) AS "2667",
									NVL(SUM("2667_up"), 0) AS "2667_up",
									NVL(SUM("2668"), 0) AS "2668",
									NVL(SUM("2668_up"), 0) AS "2668_up",
									NVL(SUM("2670"), 0) AS "2670",
									NVL(SUM("2670_up"), 0) AS "2670_up",
									NVL(SUM("2672"), 0) AS "2672",
									NVL(SUM("2672_up"), 0) AS "2672_up",
									NVL(SUM("2673"), 0) AS "2673",
									NVL(SUM("2673_up"), 0) AS "2673_up",
									NVL(SUM("2674"), 0) AS "2674",
									NVL(SUM("2674_up"), 0) AS "2674_up",
									NVL(SUM("2675"), 0) AS "2675",
									NVL(SUM("2675_up"), 0) AS "2675_up",
									NVL(SUM("2677"), 0) AS "2677",
									NVL(SUM("2677_up"), 0) AS "2677_up",
									NVL(SUM("2680"), 0) AS "2680",
									NVL(SUM("2680_up"), 0) AS "2680_up",
									NVL(SUM("2685"), 0) AS "2685",
									NVL(SUM("2685_up"), 0) AS "2685_up",
									NVL(SUM("2687"), 0) AS "2687",
									NVL(SUM("2687_up"), 0) AS "2687_up",
									NVL(SUM("2688"), 0) AS "2688",
									NVL(SUM("2688_up"), 0) AS "2688_up",
									NVL(SUM("2689"), 0) AS "2689",
									NVL(SUM("2689_up"), 0) AS "2689_up",
									NVL(SUM("2692"), 0) AS "2692",
									NVL(SUM("2692_up"), 0) AS "2692_up",
									NVL(SUM("2694"), 0) AS "2694",
									NVL(SUM("2694_up"), 0) AS "2694_up",
									NVL(SUM("2695"), 0) AS "2695",
									NVL(SUM("2695_up"), 0) AS "2695_up",
									NVL(SUM("2696"), 0) AS "2696",
									NVL(SUM("2696_up"), 0) AS "2696_up",
									NVL(SUM("2697"), 0) AS "2697",
									NVL(SUM("2697_up"), 0) AS "2697_up",
									NVL(SUM("2699"), 0) AS "2699",
									NVL(SUM("2699_up"), 0) AS "2699_up",
									NVL(SUM("2701"), 0) AS "2701",
									NVL(SUM("2701_up"), 0) AS "2701_up",
									NVL(SUM("2707"), 0) AS "2707",
									NVL(SUM("2707_up"), 0) AS "2707_up",
									NVL(SUM("2708"), 0) AS "2708",
									NVL(SUM("2708_up"), 0) AS "2708_up",
									NVL(SUM("2710"), 0) AS "2710",
									NVL(SUM("2710_up"), 0) AS "2710_up",
									NVL(SUM("2711"), 0) AS "2711",
									NVL(SUM("2711_up"), 0) AS "2711_up",
									NVL(SUM("2719"), 0) AS "2719",
									NVL(SUM("2719_up"), 0) AS "2719_up",
									NVL(SUM("2726"), 0) AS "2726",
									NVL(SUM("2726_up"), 0) AS "2726_up",
									NVL(SUM("2728"), 0) AS "2728",
									NVL(SUM("2728_up"), 0) AS "2728_up",
									NVL(SUM("2729"), 0) AS "2729",
									NVL(SUM("2729_up"), 0) AS "2729_up",
									NVL(SUM("2733"), 0) AS "2733",
									NVL(SUM("2733_up"), 0) AS "2733_up",
									NVL(SUM("2734"), 0) AS "2734",
									NVL(SUM("2734_up"), 0) AS "2734_up",
									NVL(SUM("2736"), 0) AS "2736",
									NVL(SUM("2736_up"), 0) AS "2736_up",
									NVL(SUM("2737"), 0) AS "2737",
									NVL(SUM("2737_up"), 0) AS "2737_up",
									NVL(SUM("2739"), 0) AS "2739",
									NVL(SUM("2739_up"), 0) AS "2739_up",
									NVL(SUM("2740"), 0) AS "2740",
									NVL(SUM("2740_up"), 0) AS "2740_up",
									NVL(SUM("2743"), 0) AS "2743",
									NVL(SUM("2743_up"), 0) AS "2743_up",
									NVL(SUM("2745"), 0) AS "2745",
									NVL(SUM("2745_up"), 0) AS "2745_up",
									NVL(SUM("2746"), 0) AS "2746",
									NVL(SUM("2746_up"), 0) AS "2746_up",
									NVL(SUM("2747"), 0) AS "2747",
									NVL(SUM("2747_up"), 0) AS "2747_up",
									NVL(SUM("2748"), 0) AS "2748",
									NVL(SUM("2748_up"), 0) AS "2748_up",
									NVL(SUM("2817"), 0) AS "2817",
									NVL(SUM("2817_up"), 0) AS "2817_up",
									NVL(SUM("2965"), 0) AS "2965",
									NVL(SUM("2965_up"), 0) AS "2965_up",
									NVL(SUM("2966"), 0) AS "2966",
									NVL(SUM("2966_up"), 0) AS "2966_up",
									NVL(SUM("2967"), 0) AS "2967",
									NVL(SUM("2967_up"), 0) AS "2967_up",
									NVL(SUM("2968"), 0) AS "2968",
									NVL(SUM("2968_up"), 0) AS "2968_up",
									NVL(SUM("2969"), 0) AS "2969",
									NVL(SUM("2969_up"), 0) AS "2969_up",
									NVL(SUM("3084"), 0) AS "3084",
									NVL(SUM("3084_up"), 0) AS "3084_up",
									NVL(SUM("3085"), 0) AS "3085",
									NVL(SUM("3085_up"), 0) AS "3085_up",
									NVL(SUM("3102"), 0) AS "3102",
									NVL(SUM("3102_up"), 0) AS "3102_up",
									NVL(SUM("3103"), 0) AS "3103",
									NVL(SUM("3103_up"), 0) AS "3103_up",
									NVL(SUM("3104"), 0) AS "3104",
									NVL(SUM("3104_up"), 0) AS "3104_up",
									NVL(SUM("3105"), 0) AS "3105",
									NVL(SUM("3105_up"), 0) AS "3105_up",
									NVL(SUM("3106"), 0) AS "3106",
									NVL(SUM("3106_up"), 0) AS "3106_up",
									NVL(SUM("3107"), 0) AS "3107",
									NVL(SUM("3107_up"), 0) AS "3107_up",
									NVL(SUM("3108"), 0) AS "3108",
									NVL(SUM("3108_up"), 0) AS "3108_up",
									NVL(SUM("3109"), 0) AS "3109",
									NVL(SUM("3109_up"), 0) AS "3109_up",
									NVL(SUM("3111"), 0) AS "3111",
									NVL(SUM("3111_up"), 0) AS "3111_up",
									NVL(SUM("3112"), 0) AS "3112",
									NVL(SUM("3112_up"), 0) AS "3112_up",
									NVL(SUM("3114"), 0) AS "3114",
									NVL(SUM("3114_up"), 0) AS "3114_up",
									NVL(SUM("3115"), 0) AS "3115",
									NVL(SUM("3115_up"), 0) AS "3115_up",
									NVL(SUM("3116"), 0) AS "3116",
									NVL(SUM("3116_up"), 0) AS "3116_up",
									NVL(SUM("3117"), 0) AS "3117",
									NVL(SUM("3117_up"), 0) AS "3117_up",
									NVL(SUM("3118"), 0) AS "3118",
									NVL(SUM("3118_up"), 0) AS "3118_up",
									NVL(SUM("3119"), 0) AS "3119",
									NVL(SUM("3119_up"), 0) AS "3119_up",
									NVL(SUM("3120"), 0) AS "3120",
									NVL(SUM("3120_up"), 0) AS "3120_up",
									NVL(SUM("3121"), 0) AS "3121",
									NVL(SUM("3121_up"), 0) AS "3121_up",
									NVL(SUM("3122"), 0) AS "3122",
									NVL(SUM("3122_up"), 0) AS "3122_up",
									NVL(SUM("3123"), 0) AS "3123",
									NVL(SUM("3123_up"), 0) AS "3123_up",
									NVL(SUM("3124"), 0) AS "3124",
									NVL(SUM("3124_up"), 0) AS "3124_up",
									NVL(SUM("3125"), 0) AS "3125",
									NVL(SUM("3125_up"), 0) AS "3125_up",
									NVL(SUM("3126"), 0) AS "3126",
									NVL(SUM("3126_up"), 0) AS "3126_up",
									NVL(SUM("3128"), 0) AS "3128",
									NVL(SUM("3128_up"), 0) AS "3128_up",
									NVL(SUM("3129"), 0) AS "3129",
									NVL(SUM("3129_up"), 0) AS "3129_up",
									NVL(SUM("3130"), 0) AS "3130",
									NVL(SUM("3130_up"), 0) AS "3130_up",
									NVL(SUM("3133"), 0) AS "3133",
									NVL(SUM("3133_up"), 0) AS "3133_up",
									NVL(SUM("3134"), 0) AS "3134",
									NVL(SUM("3134_up"), 0) AS "3134_up",
									NVL(SUM("3323"), 0) AS "3323",
									NVL(SUM("3323_up"), 0) AS "3323_up",
									NVL(SUM("3329"), 0) AS "3329",
									NVL(SUM("3329_up"), 0) AS "3329_up",
									NVL(SUM("3332"), 0) AS "3332",
									NVL(SUM("3332_up"), 0) AS "3332_up",
									NVL(SUM("3334"), 0) AS "3334",
									NVL(SUM("3334_up"), 0) AS "3334_up",
									NVL(SUM("3335"), 0) AS "3335",
									NVL(SUM("3335_up"), 0) AS "3335_up",
									NVL(SUM("3336"), 0) AS "3336",
									NVL(SUM("3336_up"), 0) AS "3336_up",
									NVL(SUM("3338"), 0) AS "3338",
									NVL(SUM("3338_up"), 0) AS "3338_up",
									NVL(SUM("3339"), 0) AS "3339",
									NVL(SUM("3339_up"), 0) AS "3339_up",
									NVL(SUM("3340"), 0) AS "3340",
									NVL(SUM("3340_up"), 0) AS "3340_up",
									NVL(SUM("3341"), 0) AS "3341",
									NVL(SUM("3341_up"), 0) AS "3341_up",
									NVL(SUM("3342"), 0) AS "3342",
									NVL(SUM("3342_up"), 0) AS "3342_up",
									NVL(SUM("3343"), 0) AS "3343",
									NVL(SUM("3343_up"), 0) AS "3343_up",
									NVL(SUM("3344"), 0) AS "3344",
									NVL(SUM("3344_up"), 0) AS "3344_up",
									NVL(SUM("3345"), 0) AS "3345",
									NVL(SUM("3345_up"), 0) AS "3345_up",
									NVL(SUM("3346"), 0) AS "3346",
									NVL(SUM("3346_up"), 0) AS "3346_up",
									NVL(SUM("3347"), 0) AS "3347",
									NVL(SUM("3347_up"), 0) AS "3347_up",
									NVL(SUM("3349"), 0) AS "3349",
									NVL(SUM("3349_up"), 0) AS "3349_up",
									NVL(SUM("3350"), 0) AS "3350",
									NVL(SUM("3350_up"), 0) AS "3350_up",
									NVL(SUM("3351"), 0) AS "3351",
									NVL(SUM("3351_up"), 0) AS "3351_up",
									NVL(SUM("3352"), 0) AS "3352",
									NVL(SUM("3352_up"), 0) AS "3352_up",
									NVL(SUM("3353"), 0) AS "3353",
									NVL(SUM("3353_up"), 0) AS "3353_up",
									NVL(SUM("3369"), 0) AS "3369",
									NVL(SUM("3369_up"), 0) AS "3369_up",
									NVL(SUM("3370"), 0) AS "3370",
									NVL(SUM("3370_up"), 0) AS "3370_up",
									NVL(SUM("3385"), 0) AS "3385",
									NVL(SUM("3385_up"), 0) AS "3385_up",
									NVL(SUM("3386"), 0) AS "3386",
									NVL(SUM("3386_up"), 0) AS "3386_up",
									NVL(SUM("3387"), 0) AS "3387",
									NVL(SUM("3387_up"), 0) AS "3387_up",
									NVL(SUM("3388"), 0) AS "3388",
									NVL(SUM("3388_up"), 0) AS "3388_up",
									NVL(SUM("3389"), 0) AS "3389",
									NVL(SUM("3389_up"), 0) AS "3389_up",
									NVL(SUM("3390"), 0) AS "3390",
									NVL(SUM("3390_up"), 0) AS "3390_up",
									NVL(SUM("3391"), 0) AS "3391",
									NVL(SUM("3391_up"), 0) AS "3391_up",
									NVL(SUM("3392"), 0) AS "3392",
									NVL(SUM("3392_up"), 0) AS "3392_up",
									NVL(SUM("3393"), 0) AS "3393",
									NVL(SUM("3393_up"), 0) AS "3393_up",
									NVL(SUM("3394"), 0) AS "3394",
									NVL(SUM("3394_up"), 0) AS "3394_up",
									NVL(SUM("3395"), 0) AS "3395",
									NVL(SUM("3395_up"), 0) AS "3395_up",
									NVL(SUM("3396"), 0) AS "3396",
									NVL(SUM("3396_up"), 0) AS "3396_up",
									NVL(SUM("3397"), 0) AS "3397",
									NVL(SUM("3397_up"), 0) AS "3397_up",
									NVL(SUM("3398"), 0) AS "3398",
									NVL(SUM("3398_up"), 0) AS "3398_up",
									NVL(SUM("3399"), 0) AS "3399",
									NVL(SUM("3399_up"), 0) AS "3399_up",
									NVL(SUM("3400"), 0) AS "3400",
									NVL(SUM("3400_up"), 0) AS "3400_up",
									NVL(SUM("3401"), 0) AS "3401",
									NVL(SUM("3401_up"), 0) AS "3401_up",
									NVL(SUM("3402"), 0) AS "3402",
									NVL(SUM("3402_up"), 0) AS "3402_up",
									NVL(SUM("3403"), 0) AS "3403",
									NVL(SUM("3403_up"), 0) AS "3403_up",
									NVL(SUM("3408"), 0) AS "3408",
									NVL(SUM("3408_up"), 0) AS "3408_up",
									NVL(SUM("3409"), 0) AS "3409",
									NVL(SUM("3409_up"), 0) AS "3409_up",
									NVL(SUM("3410"), 0) AS "3410",
									NVL(SUM("3410_up"), 0) AS "3410_up",
									NVL(SUM("3411"), 0) AS "3411",
									NVL(SUM("3411_up"), 0) AS "3411_up",
									NVL(SUM("3412"), 0) AS "3412",
									NVL(SUM("3412_up"), 0) AS "3412_up",
									NVL(SUM("3413"), 0) AS "3413",
									NVL(SUM("3413_up"), 0) AS "3413_up",
									NVL(SUM("3414"), 0) AS "3414",
									NVL(SUM("3414_up"), 0) AS "3414_up",
									NVL(SUM("3415"), 0) AS "3415",
									NVL(SUM("3415_up"), 0) AS "3415_up",
									NVL(SUM("3416"), 0) AS "3416",
									NVL(SUM("3416_up"), 0) AS "3416_up",
									NVL(SUM("3417"), 0) AS "3417",
									NVL(SUM("3417_up"), 0) AS "3417_up",
									NVL(SUM("3418"), 0) AS "3418",
									NVL(SUM("3418_up"), 0) AS "3418_up",
									NVL(SUM("3419"), 0) AS "3419",
									NVL(SUM("3419_up"), 0) AS "3419_up",
									NVL(SUM("3420"), 0) AS "3420",
									NVL(SUM("3420_up"), 0) AS "3420_up",
									NVL(SUM("3421"), 0) AS "3421",
									NVL(SUM("3421_up"), 0) AS "3421_up",
									NVL(SUM("3422"), 0) AS "3422",
									NVL(SUM("3422_up"), 0) AS "3422_up",
									NVL(SUM("3423"), 0) AS "3423",
									NVL(SUM("3423_up"), 0) AS "3423_up",
									NVL(SUM("3424"), 0) AS "3424",
									NVL(SUM("3424_up"), 0) AS "3424_up",
									NVL(SUM("3425"), 0) AS "3425",
									NVL(SUM("3425_up"), 0) AS "3425_up",
									NVL(SUM("3426"), 0) AS "3426",
									NVL(SUM("3426_up"), 0) AS "3426_up",
									NVL(SUM("3427"), 0) AS "3427",
									NVL(SUM("3427_up"), 0) AS "3427_up",
									NVL(SUM("3428"), 0) AS "3428",
									NVL(SUM("3428_up"), 0) AS "3428_up",
									NVL(SUM("3429"), 0) AS "3429",
									NVL(SUM("3429_up"), 0) AS "3429_up",
									NVL(SUM("3430"), 0) AS "3430",
									NVL(SUM("3430_up"), 0) AS "3430_up",
									NVL(SUM("3431"), 0) AS "3431",
									NVL(SUM("3431_up"), 0) AS "3431_up",
									NVL(SUM("3432"), 0) AS "3432",
									NVL(SUM("3432_up"), 0) AS "3432_up",
									NVL(SUM("3433"), 0) AS "3433",
									NVL(SUM("3433_up"), 0) AS "3433_up",
									NVL(SUM("3434"), 0) AS "3434",
									NVL(SUM("3434_up"), 0) AS "3434_up",
									NVL(SUM("3435"), 0) AS "3435",
									NVL(SUM("3435_up"), 0) AS "3435_up",
									NVL(SUM("3436"), 0) AS "3436",
									NVL(SUM("3436_up"), 0) AS "3436_up",
									NVL(SUM("3437"), 0) AS "3437",
									NVL(SUM("3437_up"), 0) AS "3437_up",
									NVL(SUM("3438"), 0) AS "3438",
									NVL(SUM("3438_up"), 0) AS "3438_up",
									NVL(SUM("3439"), 0) AS "3439",
									NVL(SUM("3439_up"), 0) AS "3439_up",
									NVL(SUM("3440"), 0) AS "3440",
									NVL(SUM("3440_up"), 0) AS "3440_up",
									NVL(SUM("3441"), 0) AS "3441",
									NVL(SUM("3441_up"), 0) AS "3441_up",
									NVL(SUM("3442"), 0) AS "3442",
									NVL(SUM("3442_up"), 0) AS "3442_up",
									NVL(SUM("3443"), 0) AS "3443",
									NVL(SUM("3443_up"), 0) AS "3443_up",
									NVL(SUM("3444"), 0) AS "3444",
									NVL(SUM("3444_up"), 0) AS "3444_up",
									NVL(SUM("3471"), 0) AS "3471",
									NVL(SUM("3471_up"), 0) AS "3471_up",
									NVL(SUM("3473"), 0) AS "3473",
									NVL(SUM("3473_up"), 0) AS "3473_up",
									NVL(SUM("3505"), 0) AS "3505",
									NVL(SUM("3505_up"), 0) AS "3505_up",
									NVL(SUM("3506"), 0) AS "3506",
									NVL(SUM("3506_up"), 0) AS "3506_up",
									NVL(SUM("3508"), 0) AS "3508",
									NVL(SUM("3508_up"), 0) AS "3508_up",
									NVL(SUM("3509"), 0) AS "3509",
									NVL(SUM("3509_up"), 0) AS "3509_up",
									NVL(SUM("3511"), 0) AS "3511",
									NVL(SUM("3511_up"), 0) AS "3511_up",
									NVL(SUM("3512"), 0) AS "3512",
									NVL(SUM("3512_up"), 0) AS "3512_up",
									NVL(SUM("3513"), 0) AS "3513",
									NVL(SUM("3513_up"), 0) AS "3513_up",
									NVL(SUM("3514"), 0) AS "3514",
									NVL(SUM("3514_up"), 0) AS "3514_up",
									NVL(SUM("3515"), 0) AS "3515",
									NVL(SUM("3515_up"), 0) AS "3515_up",
									NVL(SUM("3517"), 0) AS "3517",
									NVL(SUM("3517_up"), 0) AS "3517_up",
									NVL(SUM("3518"), 0) AS "3518",
									NVL(SUM("3518_up"), 0) AS "3518_up",
									NVL(SUM("3519"), 0) AS "3519",
									NVL(SUM("3519_up"), 0) AS "3519_up",
									NVL(SUM("3535"), 0) AS "3535",
									NVL(SUM("3535_up"), 0) AS "3535_up",
									NVL(SUM("3537"), 0) AS "3537",
									NVL(SUM("3537_up"), 0) AS "3537_up",
									NVL(SUM("3538"), 0) AS "3538",
									NVL(SUM("3538_up"), 0) AS "3538_up",
									NVL(SUM("3539"), 0) AS "3539",
									NVL(SUM("3539_up"), 0) AS "3539_up",
									NVL(SUM("3540"), 0) AS "3540",
									NVL(SUM("3540_up"), 0) AS "3540_up",
									NVL(SUM("3541"), 0) AS "3541",
									NVL(SUM("3541_up"), 0) AS "3541_up",
									NVL(SUM("3542"), 0) AS "3542",
									NVL(SUM("3542_up"), 0) AS "3542_up",
									NVL(SUM("3543"), 0) AS "3543",
									NVL(SUM("3543_up"), 0) AS "3543_up",
									NVL(SUM("3544"), 0) AS "3544",
									NVL(SUM("3544_up"), 0) AS "3544_up",
									NVL(SUM("3545"), 0) AS "3545",
									NVL(SUM("3545_up"), 0) AS "3545_up",
									NVL(SUM("3546"), 0) AS "3546",
									NVL(SUM("3546_up"), 0) AS "3546_up",
									NVL(SUM("3547"), 0) AS "3547",
									NVL(SUM("3547_up"), 0) AS "3547_up",
									NVL(SUM("3548"), 0) AS "3548",
									NVL(SUM("3548_up"), 0) AS "3548_up",
									NVL(SUM("3549"), 0) AS "3549",
									NVL(SUM("3549_up"), 0) AS "3549_up",
									NVL(SUM("3550"), 0) AS "3550",
									NVL(SUM("3550_up"), 0) AS "3550_up",
									NVL(SUM("3551"), 0) AS "3551",
									NVL(SUM("3551_up"), 0) AS "3551_up",
									NVL(SUM("3552"), 0) AS "3552",
									NVL(SUM("3552_up"), 0) AS "3552_up",
									NVL(SUM("3553"), 0) AS "3553",
									NVL(SUM("3553_up"), 0) AS "3553_up",
									NVL(SUM("3554"), 0) AS "3554",
									NVL(SUM("3554_up"), 0) AS "3554_up",
									NVL(SUM("3555"), 0) AS "3555",
									NVL(SUM("3555_up"), 0) AS "3555_up",
									NVL(SUM("3557"), 0) AS "3557",
									NVL(SUM("3557_up"), 0) AS "3557_up",
									NVL(SUM("3559"), 0) AS "3559",
									NVL(SUM("3559_up"), 0) AS "3559_up",
									NVL(SUM("3560"), 0) AS "3560",
									NVL(SUM("3560_up"), 0) AS "3560_up",
									NVL(SUM("3561"), 0) AS "3561",
									NVL(SUM("3561_up"), 0) AS "3561_up",
									NVL(SUM("3562"), 0) AS "3562",
									NVL(SUM("3562_up"), 0) AS "3562_up",
									NVL(SUM("3563"), 0) AS "3563",
									NVL(SUM("3563_up"), 0) AS "3563_up",
									NVL(SUM("3564"), 0) AS "3564",
									NVL(SUM("3564_up"), 0) AS "3564_up",
									NVL(SUM("3565"), 0) AS "3565",
									NVL(SUM("3565_up"), 0) AS "3565_up",
									NVL(SUM("3566"), 0) AS "3566",
									NVL(SUM("3566_up"), 0) AS "3566_up",
									NVL(SUM("3567"), 0) AS "3567",
									NVL(SUM("3567_up"), 0) AS "3567_up",
									NVL(SUM("3568"), 0) AS "3568",
									NVL(SUM("3568_up"), 0) AS "3568_up",
									NVL(SUM("3569"), 0) AS "3569",
									NVL(SUM("3569_up"), 0) AS "3569_up",
									NVL(SUM("3570"), 0) AS "3570",
									NVL(SUM("3570_up"), 0) AS "3570_up",
									NVL(SUM("3571"), 0) AS "3571",
									NVL(SUM("3571_up"), 0) AS "3571_up",
									NVL(SUM("3572"), 0) AS "3572",
									NVL(SUM("3572_up"), 0) AS "3572_up",
									NVL(SUM("3573"), 0) AS "3573",
									NVL(SUM("3573_up"), 0) AS "3573_up",
									NVL(SUM("3574"), 0) AS "3574",
									NVL(SUM("3574_up"), 0) AS "3574_up",
									NVL(SUM("3575"), 0) AS "3575",
									NVL(SUM("3575_up"), 0) AS "3575_up",
									NVL(SUM("3576"), 0) AS "3576",
									NVL(SUM("3576_up"), 0) AS "3576_up",
									NVL(SUM("3577"), 0) AS "3577",
									NVL(SUM("3577_up"), 0) AS "3577_up",
									NVL(SUM("3579"), 0) AS "3579",
									NVL(SUM("3579_up"), 0) AS "3579_up",
									NVL(SUM("3583"), 0) AS "3583",
									NVL(SUM("3583_up"), 0) AS "3583_up",
									NVL(SUM("3584"), 0) AS "3584",
									NVL(SUM("3584_up"), 0) AS "3584_up",
									NVL(SUM("3585"), 0) AS "3585",
									NVL(SUM("3585_up"), 0) AS "3585_up",
									NVL(SUM("3586"), 0) AS "3586",
									NVL(SUM("3586_up"), 0) AS "3586_up",
									NVL(SUM("3587"), 0) AS "3587",
									NVL(SUM("3587_up"), 0) AS "3587_up",
									NVL(SUM("3588"), 0) AS "3588",
									NVL(SUM("3588_up"), 0) AS "3588_up",
									NVL(SUM("3590"), 0) AS "3590",
									NVL(SUM("3590_up"), 0) AS "3590_up",
									NVL(SUM("3591"), 0) AS "3591",
									NVL(SUM("3591_up"), 0) AS "3591_up",
									NVL(SUM("3592"), 0) AS "3592",
									NVL(SUM("3592_up"), 0) AS "3592_up",
									NVL(SUM("3593"), 0) AS "3593",
									NVL(SUM("3593_up"), 0) AS "3593_up",
									NVL(SUM("3594"), 0) AS "3594",
									NVL(SUM("3594_up"), 0) AS "3594_up",
									NVL(SUM("3595"), 0) AS "3595",
									NVL(SUM("3595_up"), 0) AS "3595_up",
									NVL(SUM("3596"), 0) AS "3596",
									NVL(SUM("3596_up"), 0) AS "3596_up",
									NVL(SUM("3597"), 0) AS "3597",
									NVL(SUM("3597_up"), 0) AS "3597_up",
									NVL(SUM("3598"), 0) AS "3598",
									NVL(SUM("3598_up"), 0) AS "3598_up",
									NVL(SUM("3599"), 0) AS "3599",
									NVL(SUM("3599_up"), 0) AS "3599_up",
									NVL(SUM("3600"), 0) AS "3600",
									NVL(SUM("3600_up"), 0) AS "3600_up",
									NVL(SUM("3601"), 0) AS "3601",
									NVL(SUM("3601_up"), 0) AS "3601_up",
									NVL(SUM("3602"), 0) AS "3602",
									NVL(SUM("3602_up"), 0) AS "3602_up",
									NVL(SUM("3603"), 0) AS "3603",
									NVL(SUM("3603_up"), 0) AS "3603_up",
									NVL(SUM("3604"), 0) AS "3604",
									NVL(SUM("3604_up"), 0) AS "3604_up",
									NVL(SUM("3605"), 0) AS "3605",
									NVL(SUM("3605_up"), 0) AS "3605_up",
									NVL(SUM("3606"), 0) AS "3606",
									NVL(SUM("3606_up"), 0) AS "3606_up",
									NVL(SUM("3607"), 0) AS "3607",
									NVL(SUM("3607_up"), 0) AS "3607_up",
									NVL(SUM("3608"), 0) AS "3608",
									NVL(SUM("3608_up"), 0) AS "3608_up",
									NVL(SUM("3609"), 0) AS "3609",
									NVL(SUM("3609_up"), 0) AS "3609_up",
									NVL(SUM("3610"), 0) AS "3610",
									NVL(SUM("3610_up"), 0) AS "3610_up",
									NVL(SUM("3611"), 0) AS "3611",
									NVL(SUM("3611_up"), 0) AS "3611_up",
									NVL(SUM("3612"), 0) AS "3612",
									NVL(SUM("3612_up"), 0) AS "3612_up",
									NVL(SUM("3613"), 0) AS "3613",
									NVL(SUM("3613_up"), 0) AS "3613_up",
									NVL(SUM("3614"), 0) AS "3614",
									NVL(SUM("3614_up"), 0) AS "3614_up",
									NVL(SUM("3615"), 0) AS "3615",
									NVL(SUM("3615_up"), 0) AS "3615_up",
									NVL(SUM("3616"), 0) AS "3616",
									NVL(SUM("3616_up"), 0) AS "3616_up",
									NVL(SUM("3617"), 0) AS "3617",
									NVL(SUM("3617_up"), 0) AS "3617_up",
									NVL(SUM("3618"), 0) AS "3618",
									NVL(SUM("3618_up"), 0) AS "3618_up",
									NVL(SUM("3619"), 0) AS "3619",
									NVL(SUM("3619_up"), 0) AS "3619_up",
									NVL(SUM("3620"), 0) AS "3620",
									NVL(SUM("3620_up"), 0) AS "3620_up",
									NVL(SUM("3621"), 0) AS "3621",
									NVL(SUM("3621_up"), 0) AS "3621_up",
									NVL(SUM("3622"), 0) AS "3622",
									NVL(SUM("3622_up"), 0) AS "3622_up",
									NVL(SUM("3655"), 0) AS "3655",
									NVL(SUM("3655_up"), 0) AS "3655_up",
									NVL(SUM("3656"), 0) AS "3656",
									NVL(SUM("3656_up"), 0) AS "3656_up",
									NVL(SUM("3657"), 0) AS "3657",
									NVL(SUM("3657_up"), 0) AS "3657_up",
									NVL(SUM("3658"), 0) AS "3658",
									NVL(SUM("3658_up"), 0) AS "3658_up",
									NVL(SUM("3674"), 0) AS "3674",
									NVL(SUM("3674_up"), 0) AS "3674_up",
									NVL(SUM("3675"), 0) AS "3675",
									NVL(SUM("3675_up"), 0) AS "3675_up",
									NVL(SUM("3676"), 0) AS "3676",
									NVL(SUM("3676_up"), 0) AS "3676_up",
									NVL(SUM("3677"), 0) AS "3677",
									NVL(SUM("3677_up"), 0) AS "3677_up"
								FROM
									(
										SELECT /*+ USE_MERGE */
											USER_EX_SCHOOL_CODE AS "USER_EX_SCHOOL_CODE",
											NVL(SUM("2585"), 0) AS "2585",
											0 AS "2585_up",
											NVL(SUM("2586"), 0) AS "2586",
											0 AS "2586_up",
											NVL(SUM("2591"), 0) AS "2591",
											0 AS "2591_up",
											NVL(SUM("2592"), 0) AS "2592",
											0 AS "2592_up",
											NVL(SUM("2598"), 0) AS "2598",
											0 AS "2598_up",
											NVL(SUM("2599"), 0) AS "2599",
											0 AS "2599_up",
											NVL(SUM("2601"), 0) AS "2601",
											0 AS "2601_up",
											NVL(SUM("2608"), 0) AS "2608",
											0 AS "2608_up",
											NVL(SUM("2617"), 0) AS "2617",
											0 AS "2617_up",
											NVL(SUM("2625"), 0) AS "2625",
											0 AS "2625_up",
											NVL(SUM("2631"), 0) AS "2631",
											0 AS "2631_up",
											NVL(SUM("2632"), 0) AS "2632",
											0 AS "2632_up",
											NVL(SUM("2633"), 0) AS "2633",
											0 AS "2633_up",
											NVL(SUM("2634"), 0) AS "2634",
											0 AS "2634_up",
											NVL(SUM("2635"), 0) AS "2635",
											0 AS "2635_up",
											NVL(SUM("2638"), 0) AS "2638",
											0 AS "2638_up",
											NVL(SUM("2639"), 0) AS "2639",
											0 AS "2639_up",
											NVL(SUM("2640"), 0) AS "2640",
											0 AS "2640_up",
											NVL(SUM("2641"), 0) AS "2641",
											0 AS "2641_up",
											NVL(SUM("2642"), 0) AS "2642",
											0 AS "2642_up",
											NVL(SUM("2644"), 0) AS "2644",
											0 AS "2644_up",
											NVL(SUM("2656"), 0) AS "2656",
											0 AS "2656_up",
											NVL(SUM("2657"), 0) AS "2657",
											0 AS "2657_up",
											NVL(SUM("2658"), 0) AS "2658",
											0 AS "2658_up",
											NVL(SUM("2659"), 0) AS "2659",
											0 AS "2659_up",
											NVL(SUM("2661"), 0) AS "2661",
											0 AS "2661_up",
											NVL(SUM("2662"), 0) AS "2662",
											0 AS "2662_up",
											NVL(SUM("2663"), 0) AS "2663",
											0 AS "2663_up",
											NVL(SUM("2667"), 0) AS "2667",
											0 AS "2667_up",
											NVL(SUM("2668"), 0) AS "2668",
											0 AS "2668_up",
											NVL(SUM("2670"), 0) AS "2670",
											0 AS "2670_up",
											NVL(SUM("2672"), 0) AS "2672",
											0 AS "2672_up",
											NVL(SUM("2673"), 0) AS "2673",
											0 AS "2673_up",
											NVL(SUM("2674"), 0) AS "2674",
											0 AS "2674_up",
											NVL(SUM("2675"), 0) AS "2675",
											0 AS "2675_up",
											NVL(SUM("2677"), 0) AS "2677",
											0 AS "2677_up",
											NVL(SUM("2680"), 0) AS "2680",
											0 AS "2680_up",
											NVL(SUM("2685"), 0) AS "2685",
											0 AS "2685_up",
											NVL(SUM("2687"), 0) AS "2687",
											0 AS "2687_up",
											NVL(SUM("2688"), 0) AS "2688",
											0 AS "2688_up",
											NVL(SUM("2689"), 0) AS "2689",
											0 AS "2689_up",
											NVL(SUM("2692"), 0) AS "2692",
											0 AS "2692_up",
											NVL(SUM("2694"), 0) AS "2694",
											0 AS "2694_up",
											NVL(SUM("2695"), 0) AS "2695",
											0 AS "2695_up",
											NVL(SUM("2696"), 0) AS "2696",
											0 AS "2696_up",
											NVL(SUM("2697"), 0) AS "2697",
											0 AS "2697_up",
											NVL(SUM("2699"), 0) AS "2699",
											0 AS "2699_up",
											NVL(SUM("2701"), 0) AS "2701",
											0 AS "2701_up",
											NVL(SUM("2707"), 0) AS "2707",
											0 AS "2707_up",
											NVL(SUM("2708"), 0) AS "2708",
											0 AS "2708_up",
											NVL(SUM("2710"), 0) AS "2710",
											0 AS "2710_up",
											NVL(SUM("2711"), 0) AS "2711",
											0 AS "2711_up",
											NVL(SUM("2719"), 0) AS "2719",
											0 AS "2719_up",
											NVL(SUM("2726"), 0) AS "2726",
											0 AS "2726_up",
											NVL(SUM("2728"), 0) AS "2728",
											0 AS "2728_up",
											NVL(SUM("2729"), 0) AS "2729",
											0 AS "2729_up",
											NVL(SUM("2733"), 0) AS "2733",
											0 AS "2733_up",
											NVL(SUM("2734"), 0) AS "2734",
											0 AS "2734_up",
											NVL(SUM("2736"), 0) AS "2736",
											0 AS "2736_up",
											NVL(SUM("2737"), 0) AS "2737",
											0 AS "2737_up",
											NVL(SUM("2739"), 0) AS "2739",
											0 AS "2739_up",
											NVL(SUM("2740"), 0) AS "2740",
											0 AS "2740_up",
											NVL(SUM("2743"), 0) AS "2743",
											0 AS "2743_up",
											NVL(SUM("2745"), 0) AS "2745",
											0 AS "2745_up",
											NVL(SUM("2746"), 0) AS "2746",
											0 AS "2746_up",
											NVL(SUM("2747"), 0) AS "2747",
											0 AS "2747_up",
											NVL(SUM("2748"), 0) AS "2748",
											0 AS "2748_up",
											NVL(SUM("2817"), 0) AS "2817",
											0 AS "2817_up",
											NVL(SUM("2965"), 0) AS "2965",
											0 AS "2965_up",
											NVL(SUM("2966"), 0) AS "2966",
											0 AS "2966_up",
											NVL(SUM("2967"), 0) AS "2967",
											0 AS "2967_up",
											NVL(SUM("2968"), 0) AS "2968",
											0 AS "2968_up",
											NVL(SUM("2969"), 0) AS "2969",
											0 AS "2969_up",
											NVL(SUM("3084"), 0) AS "3084",
											0 AS "3084_up",
											NVL(SUM("3085"), 0) AS "3085",
											0 AS "3085_up",
											NVL(SUM("3102"), 0) AS "3102",
											0 AS "3102_up",
											NVL(SUM("3103"), 0) AS "3103",
											0 AS "3103_up",
											NVL(SUM("3104"), 0) AS "3104",
											0 AS "3104_up",
											NVL(SUM("3105"), 0) AS "3105",
											0 AS "3105_up",
											NVL(SUM("3106"), 0) AS "3106",
											0 AS "3106_up",
											NVL(SUM("3107"), 0) AS "3107",
											0 AS "3107_up",
											NVL(SUM("3108"), 0) AS "3108",
											0 AS "3108_up",
											NVL(SUM("3109"), 0) AS "3109",
											0 AS "3109_up",
											NVL(SUM("3111"), 0) AS "3111",
											0 AS "3111_up",
											NVL(SUM("3112"), 0) AS "3112",
											0 AS "3112_up",
											NVL(SUM("3114"), 0) AS "3114",
											0 AS "3114_up",
											NVL(SUM("3115"), 0) AS "3115",
											0 AS "3115_up",
											NVL(SUM("3116"), 0) AS "3116",
											0 AS "3116_up",
											NVL(SUM("3117"), 0) AS "3117",
											0 AS "3117_up",
											NVL(SUM("3118"), 0) AS "3118",
											0 AS "3118_up",
											NVL(SUM("3119"), 0) AS "3119",
											0 AS "3119_up",
											NVL(SUM("3120"), 0) AS "3120",
											0 AS "3120_up",
											NVL(SUM("3121"), 0) AS "3121",
											0 AS "3121_up",
											NVL(SUM("3122"), 0) AS "3122",
											0 AS "3122_up",
											NVL(SUM("3123"), 0) AS "3123",
											0 AS "3123_up",
											NVL(SUM("3124"), 0) AS "3124",
											0 AS "3124_up",
											NVL(SUM("3125"), 0) AS "3125",
											0 AS "3125_up",
											NVL(SUM("3126"), 0) AS "3126",
											0 AS "3126_up",
											NVL(SUM("3128"), 0) AS "3128",
											0 AS "3128_up",
											NVL(SUM("3129"), 0) AS "3129",
											0 AS "3129_up",
											NVL(SUM("3130"), 0) AS "3130",
											0 AS "3130_up",
											NVL(SUM("3133"), 0) AS "3133",
											0 AS "3133_up",
											NVL(SUM("3134"), 0) AS "3134",
											0 AS "3134_up",
											NVL(SUM("3323"), 0) AS "3323",
											0 AS "3323_up",
											NVL(SUM("3329"), 0) AS "3329",
											0 AS "3329_up",
											NVL(SUM("3332"), 0) AS "3332",
											0 AS "3332_up",
											NVL(SUM("3334"), 0) AS "3334",
											0 AS "3334_up",
											NVL(SUM("3335"), 0) AS "3335",
											0 AS "3335_up",
											NVL(SUM("3336"), 0) AS "3336",
											0 AS "3336_up",
											NVL(SUM("3338"), 0) AS "3338",
											0 AS "3338_up",
											NVL(SUM("3339"), 0) AS "3339",
											0 AS "3339_up",
											NVL(SUM("3340"), 0) AS "3340",
											0 AS "3340_up",
											NVL(SUM("3341"), 0) AS "3341",
											0 AS "3341_up",
											NVL(SUM("3342"), 0) AS "3342",
											0 AS "3342_up",
											NVL(SUM("3343"), 0) AS "3343",
											0 AS "3343_up",
											NVL(SUM("3344"), 0) AS "3344",
											0 AS "3344_up",
											NVL(SUM("3345"), 0) AS "3345",
											0 AS "3345_up",
											NVL(SUM("3346"), 0) AS "3346",
											0 AS "3346_up",
											NVL(SUM("3347"), 0) AS "3347",
											0 AS "3347_up",
											NVL(SUM("3349"), 0) AS "3349",
											0 AS "3349_up",
											NVL(SUM("3350"), 0) AS "3350",
											0 AS "3350_up",
											NVL(SUM("3351"), 0) AS "3351",
											0 AS "3351_up",
											NVL(SUM("3352"), 0) AS "3352",
											0 AS "3352_up",
											NVL(SUM("3353"), 0) AS "3353",
											0 AS "3353_up",
											NVL(SUM("3369"), 0) AS "3369",
											0 AS "3369_up",
											NVL(SUM("3370"), 0) AS "3370",
											0 AS "3370_up",
											NVL(SUM("3385"), 0) AS "3385",
											0 AS "3385_up",
											NVL(SUM("3386"), 0) AS "3386",
											0 AS "3386_up",
											NVL(SUM("3387"), 0) AS "3387",
											0 AS "3387_up",
											NVL(SUM("3388"), 0) AS "3388",
											0 AS "3388_up",
											NVL(SUM("3389"), 0) AS "3389",
											0 AS "3389_up",
											NVL(SUM("3390"), 0) AS "3390",
											0 AS "3390_up",
											NVL(SUM("3391"), 0) AS "3391",
											0 AS "3391_up",
											NVL(SUM("3392"), 0) AS "3392",
											0 AS "3392_up",
											NVL(SUM("3393"), 0) AS "3393",
											0 AS "3393_up",
											NVL(SUM("3394"), 0) AS "3394",
											0 AS "3394_up",
											NVL(SUM("3395"), 0) AS "3395",
											0 AS "3395_up",
											NVL(SUM("3396"), 0) AS "3396",
											0 AS "3396_up",
											NVL(SUM("3397"), 0) AS "3397",
											0 AS "3397_up",
											NVL(SUM("3398"), 0) AS "3398",
											0 AS "3398_up",
											NVL(SUM("3399"), 0) AS "3399",
											0 AS "3399_up",
											NVL(SUM("3400"), 0) AS "3400",
											0 AS "3400_up",
											NVL(SUM("3401"), 0) AS "3401",
											0 AS "3401_up",
											NVL(SUM("3402"), 0) AS "3402",
											0 AS "3402_up",
											NVL(SUM("3403"), 0) AS "3403",
											0 AS "3403_up",
											NVL(SUM("3408"), 0) AS "3408",
											0 AS "3408_up",
											NVL(SUM("3409"), 0) AS "3409",
											0 AS "3409_up",
											NVL(SUM("3410"), 0) AS "3410",
											0 AS "3410_up",
											NVL(SUM("3411"), 0) AS "3411",
											0 AS "3411_up",
											NVL(SUM("3412"), 0) AS "3412",
											0 AS "3412_up",
											NVL(SUM("3413"), 0) AS "3413",
											0 AS "3413_up",
											NVL(SUM("3414"), 0) AS "3414",
											0 AS "3414_up",
											NVL(SUM("3415"), 0) AS "3415",
											0 AS "3415_up",
											NVL(SUM("3416"), 0) AS "3416",
											0 AS "3416_up",
											NVL(SUM("3417"), 0) AS "3417",
											0 AS "3417_up",
											NVL(SUM("3418"), 0) AS "3418",
											0 AS "3418_up",
											NVL(SUM("3419"), 0) AS "3419",
											0 AS "3419_up",
											NVL(SUM("3420"), 0) AS "3420",
											0 AS "3420_up",
											NVL(SUM("3421"), 0) AS "3421",
											0 AS "3421_up",
											NVL(SUM("3422"), 0) AS "3422",
											0 AS "3422_up",
											NVL(SUM("3423"), 0) AS "3423",
											0 AS "3423_up",
											NVL(SUM("3424"), 0) AS "3424",
											0 AS "3424_up",
											NVL(SUM("3425"), 0) AS "3425",
											0 AS "3425_up",
											NVL(SUM("3426"), 0) AS "3426",
											0 AS "3426_up",
											NVL(SUM("3427"), 0) AS "3427",
											0 AS "3427_up",
											NVL(SUM("3428"), 0) AS "3428",
											0 AS "3428_up",
											NVL(SUM("3429"), 0) AS "3429",
											0 AS "3429_up",
											NVL(SUM("3430"), 0) AS "3430",
											0 AS "3430_up",
											NVL(SUM("3431"), 0) AS "3431",
											0 AS "3431_up",
											NVL(SUM("3432"), 0) AS "3432",
											0 AS "3432_up",
											NVL(SUM("3433"), 0) AS "3433",
											0 AS "3433_up",
											NVL(SUM("3434"), 0) AS "3434",
											0 AS "3434_up",
											NVL(SUM("3435"), 0) AS "3435",
											0 AS "3435_up",
											NVL(SUM("3436"), 0) AS "3436",
											0 AS "3436_up",
											NVL(SUM("3437"), 0) AS "3437",
											0 AS "3437_up",
											NVL(SUM("3438"), 0) AS "3438",
											0 AS "3438_up",
											NVL(SUM("3439"), 0) AS "3439",
											0 AS "3439_up",
											NVL(SUM("3440"), 0) AS "3440",
											0 AS "3440_up",
											NVL(SUM("3441"), 0) AS "3441",
											0 AS "3441_up",
											NVL(SUM("3442"), 0) AS "3442",
											0 AS "3442_up",
											NVL(SUM("3443"), 0) AS "3443",
											0 AS "3443_up",
											NVL(SUM("3444"), 0) AS "3444",
											0 AS "3444_up",
											NVL(SUM("3471"), 0) AS "3471",
											0 AS "3471_up",
											NVL(SUM("3473"), 0) AS "3473",
											0 AS "3473_up",
											NVL(SUM("3505"), 0) AS "3505",
											0 AS "3505_up",
											NVL(SUM("3506"), 0) AS "3506",
											0 AS "3506_up",
											NVL(SUM("3508"), 0) AS "3508",
											0 AS "3508_up",
											NVL(SUM("3509"), 0) AS "3509",
											0 AS "3509_up",
											NVL(SUM("3511"), 0) AS "3511",
											0 AS "3511_up",
											NVL(SUM("3512"), 0) AS "3512",
											0 AS "3512_up",
											NVL(SUM("3513"), 0) AS "3513",
											0 AS "3513_up",
											NVL(SUM("3514"), 0) AS "3514",
											0 AS "3514_up",
											NVL(SUM("3515"), 0) AS "3515",
											0 AS "3515_up",
											NVL(SUM("3517"), 0) AS "3517",
											0 AS "3517_up",
											NVL(SUM("3518"), 0) AS "3518",
											0 AS "3518_up",
											NVL(SUM("3519"), 0) AS "3519",
											0 AS "3519_up",
											NVL(SUM("3535"), 0) AS "3535",
											0 AS "3535_up",
											NVL(SUM("3537"), 0) AS "3537",
											0 AS "3537_up",
											NVL(SUM("3538"), 0) AS "3538",
											0 AS "3538_up",
											NVL(SUM("3539"), 0) AS "3539",
											0 AS "3539_up",
											NVL(SUM("3540"), 0) AS "3540",
											0 AS "3540_up",
											NVL(SUM("3541"), 0) AS "3541",
											0 AS "3541_up",
											NVL(SUM("3542"), 0) AS "3542",
											0 AS "3542_up",
											NVL(SUM("3543"), 0) AS "3543",
											0 AS "3543_up",
											NVL(SUM("3544"), 0) AS "3544",
											0 AS "3544_up",
											NVL(SUM("3545"), 0) AS "3545",
											0 AS "3545_up",
											NVL(SUM("3546"), 0) AS "3546",
											0 AS "3546_up",
											NVL(SUM("3547"), 0) AS "3547",
											0 AS "3547_up",
											NVL(SUM("3548"), 0) AS "3548",
											0 AS "3548_up",
											NVL(SUM("3549"), 0) AS "3549",
											0 AS "3549_up",
											NVL(SUM("3550"), 0) AS "3550",
											0 AS "3550_up",
											NVL(SUM("3551"), 0) AS "3551",
											0 AS "3551_up",
											NVL(SUM("3552"), 0) AS "3552",
											0 AS "3552_up",
											NVL(SUM("3553"), 0) AS "3553",
											0 AS "3553_up",
											NVL(SUM("3554"), 0) AS "3554",
											0 AS "3554_up",
											NVL(SUM("3555"), 0) AS "3555",
											0 AS "3555_up",
											NVL(SUM("3557"), 0) AS "3557",
											0 AS "3557_up",
											NVL(SUM("3559"), 0) AS "3559",
											0 AS "3559_up",
											NVL(SUM("3560"), 0) AS "3560",
											0 AS "3560_up",
											NVL(SUM("3561"), 0) AS "3561",
											0 AS "3561_up",
											NVL(SUM("3562"), 0) AS "3562",
											0 AS "3562_up",
											NVL(SUM("3563"), 0) AS "3563",
											0 AS "3563_up",
											NVL(SUM("3564"), 0) AS "3564",
											0 AS "3564_up",
											NVL(SUM("3565"), 0) AS "3565",
											0 AS "3565_up",
											NVL(SUM("3566"), 0) AS "3566",
											0 AS "3566_up",
											NVL(SUM("3567"), 0) AS "3567",
											0 AS "3567_up",
											NVL(SUM("3568"), 0) AS "3568",
											0 AS "3568_up",
											NVL(SUM("3569"), 0) AS "3569",
											0 AS "3569_up",
											NVL(SUM("3570"), 0) AS "3570",
											0 AS "3570_up",
											NVL(SUM("3571"), 0) AS "3571",
											0 AS "3571_up",
											NVL(SUM("3572"), 0) AS "3572",
											0 AS "3572_up",
											NVL(SUM("3573"), 0) AS "3573",
											0 AS "3573_up",
											NVL(SUM("3574"), 0) AS "3574",
											0 AS "3574_up",
											NVL(SUM("3575"), 0) AS "3575",
											0 AS "3575_up",
											NVL(SUM("3576"), 0) AS "3576",
											0 AS "3576_up",
											NVL(SUM("3577"), 0) AS "3577",
											0 AS "3577_up",
											NVL(SUM("3579"), 0) AS "3579",
											0 AS "3579_up",
											NVL(SUM("3583"), 0) AS "3583",
											0 AS "3583_up",
											NVL(SUM("3584"), 0) AS "3584",
											0 AS "3584_up",
											NVL(SUM("3585"), 0) AS "3585",
											0 AS "3585_up",
											NVL(SUM("3586"), 0) AS "3586",
											0 AS "3586_up",
											NVL(SUM("3587"), 0) AS "3587",
											0 AS "3587_up",
											NVL(SUM("3588"), 0) AS "3588",
											0 AS "3588_up",
											NVL(SUM("3590"), 0) AS "3590",
											0 AS "3590_up",
											NVL(SUM("3591"), 0) AS "3591",
											0 AS "3591_up",
											NVL(SUM("3592"), 0) AS "3592",
											0 AS "3592_up",
											NVL(SUM("3593"), 0) AS "3593",
											0 AS "3593_up",
											NVL(SUM("3594"), 0) AS "3594",
											0 AS "3594_up",
											NVL(SUM("3595"), 0) AS "3595",
											0 AS "3595_up",
											NVL(SUM("3596"), 0) AS "3596",
											0 AS "3596_up",
											NVL(SUM("3597"), 0) AS "3597",
											0 AS "3597_up",
											NVL(SUM("3598"), 0) AS "3598",
											0 AS "3598_up",
											NVL(SUM("3599"), 0) AS "3599",
											0 AS "3599_up",
											NVL(SUM("3600"), 0) AS "3600",
											0 AS "3600_up",
											NVL(SUM("3601"), 0) AS "3601",
											0 AS "3601_up",
											NVL(SUM("3602"), 0) AS "3602",
											0 AS "3602_up",
											NVL(SUM("3603"), 0) AS "3603",
											0 AS "3603_up",
											NVL(SUM("3604"), 0) AS "3604",
											0 AS "3604_up",
											NVL(SUM("3605"), 0) AS "3605",
											0 AS "3605_up",
											NVL(SUM("3606"), 0) AS "3606",
											0 AS "3606_up",
											NVL(SUM("3607"), 0) AS "3607",
											0 AS "3607_up",
											NVL(SUM("3608"), 0) AS "3608",
											0 AS "3608_up",
											NVL(SUM("3609"), 0) AS "3609",
											0 AS "3609_up",
											NVL(SUM("3610"), 0) AS "3610",
											0 AS "3610_up",
											NVL(SUM("3611"), 0) AS "3611",
											0 AS "3611_up",
											NVL(SUM("3612"), 0) AS "3612",
											0 AS "3612_up",
											NVL(SUM("3613"), 0) AS "3613",
											0 AS "3613_up",
											NVL(SUM("3614"), 0) AS "3614",
											0 AS "3614_up",
											NVL(SUM("3615"), 0) AS "3615",
											0 AS "3615_up",
											NVL(SUM("3616"), 0) AS "3616",
											0 AS "3616_up",
											NVL(SUM("3617"), 0) AS "3617",
											0 AS "3617_up",
											NVL(SUM("3618"), 0) AS "3618",
											0 AS "3618_up",
											NVL(SUM("3619"), 0) AS "3619",
											0 AS "3619_up",
											NVL(SUM("3620"), 0) AS "3620",
											0 AS "3620_up",
											NVL(SUM("3621"), 0) AS "3621",
											0 AS "3621_up",
											NVL(SUM("3622"), 0) AS "3622",
											0 AS "3622_up",
											NVL(SUM("3655"), 0) AS "3655",
											0 AS "3655_up",
											NVL(SUM("3656"), 0) AS "3656",
											0 AS "3656_up",
											NVL(SUM("3657"), 0) AS "3657",
											0 AS "3657_up",
											NVL(SUM("3658"), 0) AS "3658",
											0 AS "3658_up",
											NVL(SUM("3674"), 0) AS "3674",
											0 AS "3674_up",
											NVL(SUM("3675"), 0) AS "3675",
											0 AS "3675_up",
											NVL(SUM("3676"), 0) AS "3676",
											0 AS "3676_up",
											NVL(SUM("3677"), 0) AS "3677",
											0 AS "3677_up"
										FROM
											(
												SELECT
													USER_EX_SCHOOL_CODE,
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2585 THEN CNT
													END), 0) AS "2585",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2586 THEN CNT
													END), 0) AS "2586",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2591 THEN CNT
													END), 0) AS "2591",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2592 THEN CNT
													END), 0) AS "2592",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2598 THEN CNT
													END), 0) AS "2598",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2599 THEN CNT
													END), 0) AS "2599",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2601 THEN CNT
													END), 0) AS "2601",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2608 THEN CNT
													END), 0) AS "2608",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2617 THEN CNT
													END), 0) AS "2617",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2625 THEN CNT
													END), 0) AS "2625",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2631 THEN CNT
													END), 0) AS "2631",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2632 THEN CNT
													END), 0) AS "2632",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2633 THEN CNT
													END), 0) AS "2633",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2634 THEN CNT
													END), 0) AS "2634",
													NVL(SUM(CASE 
														WHEN BOOK_FULL_SEQ = 2635 THEN CNT
													END), 0) AS "2635",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2638 THEN CNT
													END), 0) AS "2638",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2639 THEN CNT
													END), 0) AS "2639",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2640 THEN CNT
													END), 0) AS "2640",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2641 THEN CNT
													END), 0) AS "2641",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2642 THEN CNT
													END), 0) AS "2642",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2644 THEN CNT
													END), 0) AS "2644",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2656 THEN CNT
													END), 0) AS "2656",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2657 THEN CNT
													END), 0) AS "2657",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2658 THEN CNT
													END), 0) AS "2658",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2659 THEN CNT
													END), 0) AS "2659",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2661 THEN CNT
													END), 0) AS "2661",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2662 THEN CNT
													END), 0) AS "2662",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2663 THEN CNT
													END), 0) AS "2663",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2667 THEN CNT
													END), 0) AS "2667",
													NVL(SUM(CasE
													WHEN BOOK_FULL_SEQ = 2668 THEN CNT END), 0) AS "2668",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2670 THEN CNT
													END), 0) AS "2670",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2672 THEN CNT
													END), 0) AS "2672",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2673 THEN CNT
													END), 0) AS "2673",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2674 THEN CNT
													END), 0) AS "2674",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2675 THEN CNT
													END), 0) AS "2675",
													NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 2677 THEN CNT
													END), 0) AS "2677",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2680 THEN CNT
													END), 0) AS "2680",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2685 THEN CNT
													END), 0) AS "2685",
													NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 2687 THEN CNT
													END), 0) AS "2687",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2688 THEN CNT
													END), 0) AS "2688",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2689 THEN CNT
													END), 0) AS "2689",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2692 THEN CNT
													END), 0) AS "2692",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2694 THEN CNT
													END), 0) AS "2694",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2695 THEN CNT
													END), 0) AS "2695",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2696 THEN CNT
													END), 0) AS "2696",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2697 THEN CNT
													END), 0) AS "2697",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2699 THEN CNT
													END), 0) AS "2699",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2701 THEN CNT
													END), 0) AS "2701",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2707 THEN CNT
													END), 0) AS "2707",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2708 THEN CNT
													END), 0) AS "2708",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2710 THEN CNT
													END), 0) AS "2710",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2711 THEN CNT
													END), 0) AS "2711",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2719 THEN CNT
													END), 0) AS "2719",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2726 THEN CNT
													END), 0) AS "2726",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2728 THEN CNT
													END), 0) AS "2728",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2729 THEN CNT
													END), 0) AS "2729",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2733 THEN CNT
													END), 0) AS "2733",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2734 THEN CNT
													END), 0) AS "2734",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2736 THEN CNT
													END), 0) AS "2736",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2737 THEN CNT
													END), 0) AS "2737",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2739 THEN CNT
													END), 0) AS "2739",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2740 THEN CNT
													END), 0) AS "2740",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2743 THEN CNT
													END), 0) AS "2743",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2745 THEN CNT
													END), 0) AS "2745",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2746 THEN CNT
													END), 0) AS "2746",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2747 THEN CNT
													END), 0) AS "2747",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2748 THEN CNT
													END), 0) AS "2748",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2817 THEN CNT
													END), 0) AS "2817",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2965 THEN CNT
													END), 0) AS "2965",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2966 THEN CNT
													END), 0) AS "2966",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2967 THEN CNT
													END), 0) AS "2967",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2968 THEN CNT
													END), 0) AS "2968",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 2969 THEN CNT
													END), 0) AS "2969",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3084 THEN CNT
													END), 0) AS "3084",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3085 THEN CNT
													END), 0) AS "3085",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3102 THEN CNT
													END), 0) AS "3102",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3103 THEN CNT
													END), 0) AS "3103",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3104 THEN CNT
													END), 0) AS "3104",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3105 THEN CNT
													END), 0) AS "3105",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3106 THEN CNT
													END), 0) AS "3106",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3107 THEN CNT
													END), 0) AS "3107",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3108 THEN CNT
													END), 0) AS "3108",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3109 THEN CNT
													END), 0) AS "3109",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3111 THEN CNT
													END), 0) AS "3111",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3112 THEN CNT
													END), 0) AS "3112",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3114 THEN CNT
													END), 0) AS "3114",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3115 THEN CNT
													END), 0) AS "3115",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3116 THEN CNT
													END), 0) AS "3116",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3117 THEN CNT
													END), 0) AS "3117",
													NVL(SUM(CASE
														WHEN BOOK_FULL_SEQ = 3118 THEN CNT END ), 0 ) AS "3118", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3119 THEN CNT
															END), 0) AS "3119", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3120 THEN CNT
															END), 0) AS "3120", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3121 THEN CNT
															END), 0) AS "3121", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3122 THEN CNT
															END), 0) AS "3122", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3123 THEN CNT
															END), 0) AS "3123", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3124 THEN CNT
															END), 0) AS "3124", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3125 THEN CNT
															END), 0) AS "3125", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3126 THEN CNT
															END), 0) AS "3126", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3128 THEN CNT
															END), 0) as "3128", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3129 THEN CNT
															END), 0) AS "3129", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3130 THEN CNT
															END), 0) AS "3130", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3133 THEN CNT
															END), 0) AS "3133", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3134 THEN CNT
															END), 0) AS "3134", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3323 THEN CNT
															END), 0) AS "3323", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3329 THEN CNT
															END), 0) AS "3329", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3332 THEN CNT
															END), 0) AS "3332", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3334 THEN CNT
															END), 0) AS "3334", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3335 THEN CNT
															END), 0) AS "3335", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3336 THEN CNT
															END), 0) AS "3336", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3338 THEN CNT
															END), 0) AS "3338", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3339 THEN CNT
															END), 0) AS "3339", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3340 THEN CNT
															END), 0) AS "3340", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3341 THEN CNT
															END), 0) AS "3341", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3342 THEN CNT
															END), 0) AS "3342", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3343 THEN CNT
															END), 0) AS "3343", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3344 THEN CNT
															END), 0) AS "3344", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3345 THEN CNT
															END), 0) AS "3345", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3346 THEN CNT
															END), 0) AS "3346", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3347 THEN CNT
															END), 0) AS "3347", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3349 THEN CNT
															END), 0) AS "3349", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3350 THEN CNT
															END), 0) AS "3350", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3351 THEN CNT
															END), 0) AS "3351", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3352 THEN CNT
															END), 0) AS "3352", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3353 THEN CNT
															END), 0) AS "3353", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3369 THEN CNT
															END), 0) AS "3369", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3370 THEN CNT
															END), 0) AS "3370", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3385 THEN CNT
															END), 0) AS "3385", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3386 THEN CNT
															END), 0) AS "3386", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3387 THEN CNT
															END), 0) AS "3387", NVL(SUM(CasE
															WHEN BOOK_FULL_SEQ = 3388 THEN CNT END), 0) AS "3388", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3389 THEN CNT
															END), 0) AS "3389", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3390 THEN CNT
															END), 0) AS "3390", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3391 THEN CNT
															END), 0) AS "3391", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3392 THEN CNT
															END), 0) AS "3392", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3393 THEN CNT
															END), 0) AS "3393", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3394 THEN CNT
															END), 0) AS "3394", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3395 THEN CNT
															END), 0) AS "3395", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3396 THEN CNT
															END), 0) AS "3396", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3397 THEN CNT
															END), 0) AS "3397", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3398 THEN CNT
															END), 0) AS "3398", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3399 THEN CNT
															END), 0) AS "3399", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3400 THEN CNT
															END), 0) AS "3400", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3401 THEN CNT
															END), 0) AS "3401", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3402 THEN CNT
															END), 0) AS "3402", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3403 THEN CNT
															END), 0) AS "3403", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3408 THEN CNT
															END), 0) AS "3408", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3409 THEN CNT
															END), 0) AS "3409", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3410 THEN CNT
															END), 0) AS "3410", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3411 THEN CNT
															END), 0) AS "3411", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3412 THEN CNT
															END), 0) AS "3412", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3413 THEN CNT
															END), 0) AS "3413", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3414 THEN CNT
															END), 0) AS "3414", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3415 THEN CNT
															END), 0) AS "3415", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3416 THEN CNT
															END), 0) AS "3416", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3417 THEN CNT
															END), 0) AS "3417", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3418 THEN CNT
															END), 0) AS "3418", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3419 THEN CNT
															END), 0) AS "3419", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3420 THEN CNT
															END), 0) AS "3420", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3421 THEN CNT
															END), 0) AS "3421", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3422 THEN CNT
															END), 0) AS "3422", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3423 THEN CNT
															END), 0) AS "3423", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3424 THEN CNT
															END), 0) AS "3424", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3425 THEN CNT
															END), 0) AS "3425", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3426 THEN CNT
															END), 0) AS "3426", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3427 THEN CNT
															END), 0) AS "3427", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3428 THEN CNT
															END), 0) AS "3428", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3429 THEN CNT
															END), 0) AS "3429", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3430 THEN CNT
															END), 0) AS "3430", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3431 THEN CNT
															END), 0) AS "3431", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3432 THEN CNT
															END), 0) AS "3432", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3433 THEN CNT
															END), 0) AS "3433", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3434 THEN CNT
															END), 0) AS "3434", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3435 THEN CNT
															END), 0) AS "3435", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3436 THEN CNT
															END), 0) AS "3436", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3437 THEN CNT
															END), 0) AS "3437", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3438 THEN CNT
															END), 0) AS "3438", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3439 THEN CNT
															END), 0) AS "3439", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3440 THEN CNT
															END), 0) AS "3440", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3441 THEN CNT
															END), 0) AS "3441", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3442 THEN CNT
															END), 0) AS "3442", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3443 THEN CNT
															END), 0) AS "3443", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3444 THEN CNT
															END), 0) AS "3444", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3471 THEN CNT
															END), 0) AS "3471", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3473 THEN CNT
															END), 0) AS "3473", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3505 THEN CNT
															END), 0) AS "3505", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3506 THEN CNT
															END), 0) AS "3506", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3508 THEN CNT
															END), 0) AS "3508", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3509 THEN CNT
															END), 0) AS "3509", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3511 THEN CNT
															END), 0) AS "3511", NVL(SUM(CASE
																WHEN BOOK_FULL_SEQ = 3512 THEN CNT END ), 0 ) AS "3512", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3513 THEN CNT
																	END), 0) AS "3513", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3514 THEN CNT
																	END), 0) AS "3514", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3515 THEN CNT
																	END), 0) AS "3515", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3517 THEN CNT
																	END), 0) AS "3517", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3518 THEN CNT
																	END), 0) AS "3518", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3519 THEN CNT
																	END), 0) AS "3519", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3535 THEN CNT
																	END), 0) AS "3535", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3537 THEN CNT
																	END), 0) AS "3537", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3538 THEN CNT
																	END), 0) as "3538", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3539 THEN CNT
																	END), 0) AS "3539", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3540 THEN CNT
																	END), 0) AS "3540", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3541 THEN CNT
																	END), 0) AS "3541", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3542 THEN CNT
																	END), 0) AS "3542", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3543 THEN CNT
																	END), 0) AS "3543", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3544 THEN CNT
																	END), 0) AS "3544", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3545 THEN CNT
																	END), 0) AS "3545", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3546 THEN CNT
																	END), 0) AS "3546", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3547 THEN CNT
																	END), 0) AS "3547", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3548 THEN CNT
																	END), 0) AS "3548", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3549 THEN CNT
																	END), 0) AS "3549", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3550 THEN CNT
																	END), 0) AS "3550", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3551 THEN CNT
																	END), 0) AS "3551", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3552 THEN CNT
																	END), 0) AS "3552", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3553 THEN CNT
																	END), 0) AS "3553", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3554 THEN CNT
																	END), 0) AS "3554", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3555 THEN CNT
																	END), 0) AS "3555", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3557 THEN CNT
																	END), 0) AS "3557", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3559 THEN CNT
																	END), 0) AS "3559", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3560 THEN CNT
																	END), 0) AS "3560", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3561 THEN CNT
																	END), 0) AS "3561", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3562 THEN CNT
																	END), 0) AS "3562", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3563 THEN CNT
																	END), 0) AS "3563", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3564 THEN CNT
																	END), 0) AS "3564", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3565 THEN CNT
																	END), 0) AS "3565", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3566 THEN CNT
																	END), 0) AS "3566", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3567 THEN CNT
																	END), 0) AS "3567", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3568 THEN CNT
																	END), 0) AS "3568", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3569 THEN CNT
																	END), 0) AS "3569", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3570 THEN CNT
																	END), 0) AS "3570", NVL(SUM(CasE
																	WHEN BOOK_FULL_SEQ = 3571 THEN CNT END), 0) AS "3571", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3572 THEN CNT
																	END), 0) AS "3572", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3573 THEN CNT
																	END), 0) AS "3573", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3574 THEN CNT
																	END), 0) AS "3574", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3575 THEN CNT
																	END), 0) AS "3575", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3576 THEN CNT
																	END), 0) AS "3576", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3577 THEN CNT
																	END), 0) AS "3577", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3579 THEN CNT
																	END), 0) AS "3579", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3583 THEN CNT
																	END), 0) AS "3583", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3584 THEN CNT
																	END), 0) AS "3584", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3585 THEN CNT
																	END), 0) AS "3585", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3586 THEN CNT
																	END), 0) AS "3586", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3587 THEN CNT
																	END), 0) AS "3587", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3588 THEN CNT
																	END), 0) AS "3588", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3590 THEN CNT
																	END), 0) AS "3590", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3591 THEN CNT
																	END), 0) AS "3591", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3592 THEN CNT
																	END), 0) AS "3592", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3593 THEN CNT
																	END), 0) AS "3593", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3594 THEN CNT
																	END), 0) AS "3594", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3595 THEN CNT
																	END), 0) AS "3595", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3596 THEN CNT
																	END), 0) AS "3596", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3597 THEN CNT
																	END), 0) AS "3597", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3598 THEN CNT
																	END), 0) AS "3598", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3599 THEN CNT
																	END), 0) AS "3599", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3600 THEN CNT
																	END), 0) AS "3600", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3601 THEN CNT
																	END), 0) AS "3601", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3602 THEN CNT
																	END), 0) AS "3602", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3603 THEN CNT
																	END), 0) AS "3603", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3604 THEN CNT
																	END), 0) AS "3604", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3605 THEN CNT
																	END), 0) AS "3605", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3606 THEN CNT
																	END), 0) AS "3606", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3607 THEN CNT
																	END), 0) AS "3607", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3608 THEN CNT
																	END), 0) AS "3608", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3609 THEN CNT
																	END), 0) AS "3609", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3610 THEN CNT
																	END), 0) AS "3610", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3611 THEN CNT
																	END), 0) AS "3611", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3612 THEN CNT
																	END), 0) AS "3612", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3613 THEN CNT
																	END), 0) AS "3613", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3614 THEN CNT
																	END), 0) AS "3614", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3615 THEN CNT
																	END), 0) AS "3615", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3616 THEN CNT
																	END), 0) AS "3616", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3617 THEN CNT
																	END), 0) AS "3617", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3618 THEN CNT
																	END), 0) AS "3618", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3619 THEN CNT
																	END), 0) AS "3619", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3620 THEN CNT
																	END), 0) AS "3620", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3621 THEN CNT
																	END), 0) AS "3621", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3622 THEN CNT
																	END), 0) AS "3622", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3655 THEN CNT
																	END), 0) AS "3655", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3656 THEN CNT
																	END), 0) AS "3656", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3657 THEN CNT
																	END), 0) AS "3657", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3658 THEN CNT
																	END), 0) AS "3658", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3674 THEN CNT
																	END), 0) AS "3674", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3675 THEN CNT
																	END), 0) AS "3675", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3676 THEN CNT
																	END), 0) AS "3676", NVL(SUM(CASE
																		WHEN BOOK_FULL_SEQ = 3677 THEN CNT
																	END), 0) AS "3677"
																	FROM
																		(
																			SELECT
																				USER_EX_SCHOOL_CODE,
																				BOOK_FULL_SEQ,
																				COUNT(1) AS cnt
																			FROM
																				TB_STATS_DOWNLOAD tb_dwn,
																				TB_SCHOOL tb_sch
																			WHERE
																				tb_dwn.USER_EX_SCHOOL_CODE = tb_sch.code
																				AND tb_sch.ex_schgrade_code IN (
																					'02',
																					'03',
																					'04',
																					'06'
																				)
																				AND tb_dwn.YYYYMMDD >= '20100301'
																				AND tb_dwn.YYYYMMDD <= '20230322'
																			GROUP BY
																				tb_dwn.USER_EX_SCHOOL_CODE,
																				tb_dwn.BOOK_FULL_SEQ
																		) GROUP BY USER_EX_SCHOOL_CODE )
																	GROUP BY
																		USER_EX_SCHOOL_CODE
																	UNION ALL
																	SELECT
																		USER_EX_SCHOOL_CODE AS "USER_EX_SCHOOL_CODE",
																		0 AS "2585",
																		NVL(SUM("2585_up"), 0) AS "2585_up",
																		0 AS "2586",
																		NVL(SUM("2586_up"), 0) AS "2586_up",
																		0 AS "2591",
																		NVL(SUM("2591_up"), 0) AS "2591_up",
																		0 AS "2592",
																		NVL(SUM("2592_up"), 0) AS "2592_up",
																		0 AS "2598",
																		NVL(SUM("2598_up"), 0) AS "2598_up",
																		0 AS "2599",
																		NVL(SUM("2599_up"), 0) AS "2599_up",
																		0 AS "2601",
																		NVL(SUM("2601_up"), 0) AS "2601_up",
																		0 AS "2608",
																		NVL(SUM("2608_up"), 0) AS "2608_up",
																		0 AS "2617",
																		NVL(SUM("2617_up"), 0) AS "2617_up",
																		0 AS "2625",
																		NVL(SUM("2625_up"), 0) AS "2625_up",
																		0 AS "2631",
																		NVL(SUM("2631_up"), 0) AS "2631_up",
																		0 AS "2632",
																		NVL(SUM("2632_up"), 0) AS "2632_up",
																		0 AS "2633",
																		NVL(SUM("2633_up"), 0) AS "2633_up",
																		0 AS "2634",
																		NVL(SUM("2634_up"), 0) AS "2634_up",
																		0 AS "2635",
																		NVL(SUM("2635_up"), 0) AS "2635_up",
																		0 AS "2638",
																		NVL(SUM("2638_up"), 0) AS "2638_up",
																		0 AS "2639",
																		NVL(SUM("2639_up"), 0) AS "2639_up",
																		0 AS "2640",
																		NVL(SUM("2640_up"), 0) AS "2640_up",
																		0 AS "2641",
																		NVL(SUM("2641_up"), 0) AS "2641_up",
																		0 AS "2642",
																		NVL(SUM("2642_up"), 0) AS "2642_up",
																		0 AS "2644",
																		NVL(SUM("2644_up"), 0) AS "2644_up",
																		0 AS "2656",
																		NVL(SUM("2656_up"), 0) AS "2656_up",
																		0 AS "2657",
																		NVL(SUM("2657_up"), 0) AS "2657_up",
																		0 AS "2658",
																		NVL(SUM("2658_up"), 0) AS "2658_up",
																		0 AS "2659",
																		NVL(SUM("2659_up"), 0) AS "2659_up",
																		0 AS "2661",
																		NVL(SUM("2661_up"), 0) AS "2661_up",
																		0 AS "2662",
																		NVL(SUM("2662_up"), 0) AS "2662_up",
																		0 AS "2663",
																		NVL(SUM("2663_up"), 0) AS "2663_up",
																		0 AS "2667",
																		NVL(SUM("2667_up"), 0) AS "2667_up",
																		0 AS "2668",
																		NVL(SUM("2668_up"), 0) AS "2668_up",
																		0 AS "2670",
																		NVL(SUM("2670_up"), 0) AS "2670_up",
																		0 AS "2672",
																		NVL(SUM("2672_up"), 0) AS "2672_up",
																		0 AS "2673",
																		NVL(SUM("2673_up"), 0) AS "2673_up",
																		0 AS "2674",
																		NVL(SUM("2674_up"), 0) AS "2674_up",
																		0 AS "2675",
																		NVL(SUM("2675_up"), 0) AS "2675_up",
																		0 AS "2677",
																		NVL(SUM("2677_up"), 0) AS "2677_up",
																		0 AS "2680",
																		NVL(SUM("2680_up"), 0) AS "2680_up",
																		0 AS "2685",
																		NVL(SUM("2685_up"), 0) AS "2685_up",
																		0 AS "2687",
																		NVL(SUM("2687_up"), 0) AS "2687_up",
																		0 AS "2688",
																		NVL(SUM("2688_up"), 0) AS "2688_up",
																		0 AS "2689",
																		NVL(SUM("2689_up"), 0) AS "2689_up",
																		0 AS "2692",
																		NVL(SUM("2692_up"), 0) AS "2692_up",
																		0 AS "2694",
																		NVL(SUM("2694_up"), 0) AS "2694_up",
																		0 AS "2695",
																		NVL(SUM("2695_up"), 0) AS "2695_up",
																		0 AS "2696",
																		NVL(SUM("2696_up"), 0) AS "2696_up",
																		0 AS "2697",
																		NVL(SUM("2697_up"), 0) AS "2697_up",
																		0 AS "2699",
																		NVL(SUM("2699_up"), 0) AS "2699_up",
																		0 AS "2701",
																		NVL(SUM("2701_up"), 0) AS "2701_up",
																		0 AS "2707",
																		NVL(SUM("2707_up"), 0) AS "2707_up",
																		0 AS "2708",
																		NVL(SUM("2708_up"), 0) AS "2708_up",
																		0 AS "2710",
																		NVL(SUM("2710_up"), 0) AS "2710_up",
																		0 AS "2711",
																		NVL(SUM("2711_up"), 0) AS "2711_up",
																		0 AS "2719",
																		NVL(SUM("2719_up"), 0) AS "2719_up",
																		0 AS "2726",
																		NVL(SUM("2726_up"), 0) AS "2726_up",
																		0 AS "2728",
																		NVL(SUM("2728_up"), 0) AS "2728_up",
																		0 AS "2729",
																		NVL(SUM("2729_up"), 0) AS "2729_up",
																		0 AS "2733",
																		NVL(SUM("2733_up"), 0) AS "2733_up",
																		0 AS "2734",
																		NVL(SUM("2734_up"), 0) AS "2734_up",
																		0 AS "2736",
																		NVL(SUM("2736_up"), 0) AS "2736_up",
																		0 AS "2737",
																		NVL(SUM("2737_up"), 0) AS "2737_up",
																		0 AS "2739",
																		NVL(SUM("2739_up"), 0) AS "2739_up",
																		0 AS "2740",
																		NVL(SUM("2740_up"), 0) AS "2740_up",
																		0 AS "2743",
																		NVL(SUM("2743_up"), 0) AS "2743_up",
																		0 AS "2745",
																		NVL(SUM("2745_up"), 0) AS "2745_up",
																		0 AS "2746",
																		NVL(SUM("2746_up"), 0) AS "2746_up",
																		0 AS "2747",
																		NVL(SUM("2747_up"), 0) AS "2747_up",
																		0 AS "2748",
																		NVL(SUM("2748_up"), 0) AS "2748_up",
																		0 AS "2817",
																		NVL(SUM("2817_up"), 0) AS "2817_up",
																		0 AS "2965",
																		NVL(SUM("2965_up"), 0) AS "2965_up",
																		0 AS "2966",
																		NVL(SUM("2966_up"), 0) AS "2966_up",
																		0 AS "2967",
																		NVL(SUM("2967_up"), 0) AS "2967_up",
																		0 AS "2968",
																		NVL(SUM("2968_up"), 0) AS "2968_up",
																		0 AS "2969",
																		NVL(SUM("2969_up"), 0) AS "2969_up",
																		0 AS "3084",
																		NVL(SUM("3084_up"), 0) AS "3084_up",
																		0 AS "3085",
																		NVL(SUM("3085_up"), 0) AS "3085_up",
																		0 AS "3102",
																		NVL(SUM("3102_up"), 0) AS "3102_up",
																		0 AS "3103",
																		NVL(SUM("3103_up"), 0) AS "3103_up",
																		0 AS "3104",
																		NVL(SUM("3104_up"), 0) AS "3104_up",
																		0 AS "3105",
																		NVL(SUM("3105_up"), 0) AS "3105_up",
																		0 AS "3106",
																		NVL(SUM("3106_up"), 0) AS "3106_up",
																		0 AS "3107",
																		NVL(SUM("3107_up"), 0) AS "3107_up",
																		0 AS "3108",
																		NVL(SUM("3108_up"), 0) AS "3108_up",
																		0 AS "3109",
																		NVL(SUM("3109_up"), 0) AS "3109_up",
																		0 AS "3111",
																		NVL(SUM("3111_up"), 0) AS "3111_up",
																		0 AS "3112",
																		NVL(SUM("3112_up"), 0) AS "3112_up",
																		0 AS "3114",
																		NVL(SUM("3114_up"), 0) AS "3114_up",
																		0 AS "3115",
																		NVL(SUM("3115_up"), 0) AS "3115_up",
																		0 AS "3116",
																		NVL(SUM("3116_up"), 0) AS "3116_up",
																		0 AS "3117",
																		NVL(SUM("3117_up"), 0) AS "3117_up",
																		0 AS "3118",
																		NVL(SUM("3118_up"), 0) AS "3118_up",
																		0 AS "3119",
																		NVL(SUM("3119_up"), 0) AS "3119_up",
																		0 AS "3120",
																		NVL(SUM("3120_up"), 0) AS "3120_up",
																		0 AS "3121",
																		NVL(SUM("3121_up"), 0) AS "3121_up",
																		0 AS "3122",
																		NVL(SUM("3122_up"), 0) AS "3122_up",
																		0 AS "3123",
																		NVL(SUM("3123_up"), 0) AS "3123_up",
																		0 AS "3124",
																		NVL(SUM("3124_up"), 0) AS "3124_up",
																		0 AS "3125",
																		NVL(SUM("3125_up"), 0) AS "3125_up",
																		0 AS "3126",
																		NVL(SUM("3126_up"), 0) AS "3126_up",
																		0 AS "3128",
																		NVL(SUM("3128_up"), 0) AS "3128_up",
																		0 AS "3129",
																		NVL(SUM("3129_up"), 0) AS "3129_up",
																		0 AS "3130",
																		NVL(SUM("3130_up"), 0) AS "3130_up",
																		0 AS "3133",
																		NVL(SUM("3133_up"), 0) AS "3133_up",
																		0 AS "3134",
																		NVL(SUM("3134_up"), 0) AS "3134_up",
																		0 AS "3323",
																		NVL(SUM("3323_up"), 0) AS "3323_up",
																		0 AS "3329",
																		NVL(SUM("3329_up"), 0) AS "3329_up",
																		0 AS "3332",
																		NVL(SUM("3332_up"), 0) AS "3332_up",
																		0 AS "3334",
																		NVL(SUM("3334_up"), 0) AS "3334_up",
																		0 AS "3335",
																		NVL(SUM("3335_up"), 0) AS "3335_up",
																		0 AS "3336",
																		NVL(SUM("3336_up"), 0) AS "3336_up",
																		0 AS "3338",
																		NVL(SUM("3338_up"), 0) AS "3338_up",
																		0 AS "3339",
																		NVL(SUM("3339_up"), 0) AS "3339_up",
																		0 AS "3340",
																		NVL(SUM("3340_up"), 0) AS "3340_up",
																		0 AS "3341",
																		NVL(SUM("3341_up"), 0) AS "3341_up",
																		0 AS "3342",
																		NVL(SUM("3342_up"), 0) AS "3342_up",
																		0 AS "3343",
																		NVL(SUM("3343_up"), 0) AS "3343_up",
																		0 AS "3344",
																		NVL(SUM("3344_up"), 0) AS "3344_up",
																		0 AS "3345",
																		NVL(SUM("3345_up"), 0) AS "3345_up",
																		0 AS "3346",
																		NVL(SUM("3346_up"), 0) AS "3346_up",
																		0 AS "3347",
																		NVL(SUM("3347_up"), 0) AS "3347_up",
																		0 AS "3349",
																		NVL(SUM("3349_up"), 0) AS "3349_up",
																		0 AS "3350",
																		NVL(SUM("3350_up"), 0) AS "3350_up",
																		0 AS "3351",
																		NVL(SUM("3351_up"), 0) AS "3351_up",
																		0 AS "3352",
																		NVL(SUM("3352_up"), 0) AS "3352_up",
																		0 AS "3353",
																		NVL(SUM("3353_up"), 0) AS "3353_up",
																		0 AS "3369",
																		NVL(SUM("3369_up"), 0) AS "3369_up",
																		0 AS "3370",
																		NVL(SUM("3370_up"), 0) AS "3370_up",
																		0 AS "3385",
																		NVL(SUM("3385_up"), 0) AS "3385_up",
																		0 AS "3386",
																		NVL(SUM("3386_up"), 0) AS "3386_up",
																		0 AS "3387",
																		NVL(SUM("3387_up"), 0) AS "3387_up",
																		0 AS "3388",
																		NVL(SUM("3388_up"), 0) AS "3388_up",
																		0 AS "3389",
																		NVL(SUM("3389_up"), 0) AS "3389_up",
																		0 AS "3390",
																		NVL(SUM("3390_up"), 0) AS "3390_up",
																		0 AS "3391",
																		NVL(SUM("3391_up"), 0) AS "3391_up",
																		0 AS "3392",
																		NVL(SUM("3392_up"), 0) AS "3392_up",
																		0 AS "3393",
																		NVL(SUM("3393_up"), 0) AS "3393_up",
																		0 AS "3394",
																		NVL(SUM("3394_up"), 0) AS "3394_up",
																		0 AS "3395",
																		NVL(SUM("3395_up"), 0) AS "3395_up",
																		0 AS "3396",
																		NVL(SUM("3396_up"), 0) AS "3396_up",
																		0 AS "3397",
																		NVL(SUM("3397_up"), 0) AS "3397_up",
																		0 AS "3398",
																		NVL(SUM("3398_up"), 0) AS "3398_up",
																		0 AS "3399",
																		NVL(SUM("3399_up"), 0) AS "3399_up",
																		0 AS "3400",
																		NVL(SUM("3400_up"), 0) AS "3400_up",
																		0 AS "3401",
																		NVL(SUM("3401_up"), 0) AS "3401_up",
																		0 AS "3402",
																		NVL(SUM("3402_up"), 0) AS "3402_up",
																		0 AS "3403",
																		NVL(SUM("3403_up"), 0) AS "3403_up",
																		0 AS "3408",
																		NVL(SUM("3408_up"), 0) AS "3408_up",
																		0 AS "3409",
																		NVL(SUM("3409_up"), 0) AS "3409_up",
																		0 AS "3410",
																		NVL(SUM("3410_up"), 0) AS "3410_up",
																		0 AS "3411",
																		NVL(SUM("3411_up"), 0) AS "3411_up",
																		0 AS "3412",
																		NVL(SUM("3412_up"), 0) AS "3412_up",
																		0 AS "3413",
																		NVL(SUM("3413_up"), 0) AS "3413_up",
																		0 AS "3414",
																		NVL(SUM("3414_up"), 0) AS "3414_up",
																		0 AS "3415",
																		NVL(SUM("3415_up"), 0) AS "3415_up",
																		0 AS "3416",
																		NVL(SUM("3416_up"), 0) AS "3416_up",
																		0 AS "3417",
																		NVL(SUM("3417_up"), 0) AS "3417_up",
																		0 AS "3418",
																		NVL(SUM("3418_up"), 0) AS "3418_up",
																		0 AS "3419",
																		NVL(SUM("3419_up"), 0) AS "3419_up",
																		0 AS "3420",
																		NVL(SUM("3420_up"), 0) AS "3420_up",
																		0 AS "3421",
																		NVL(SUM("3421_up"), 0) AS "3421_up",
																		0 AS "3422",
																		NVL(SUM("3422_up"), 0) AS "3422_up",
																		0 AS "3423",
																		NVL(SUM("3423_up"), 0) AS "3423_up",
																		0 AS "3424",
																		NVL(SUM("3424_up"), 0) AS "3424_up",
																		0 AS "3425",
																		NVL(SUM("3425_up"), 0) AS "3425_up",
																		0 AS "3426",
																		NVL(SUM("3426_up"), 0) AS "3426_up",
																		0 AS "3427",
																		NVL(SUM("3427_up"), 0) AS "3427_up",
																		0 AS "3428",
																		NVL(SUM("3428_up"), 0) AS "3428_up",
																		0 AS "3429",
																		NVL(SUM("3429_up"), 0) AS "3429_up",
																		0 AS "3430",
																		NVL(SUM("3430_up"), 0) AS "3430_up",
																		0 AS "3431",
																		NVL(SUM("3431_up"), 0) AS "3431_up",
																		0 AS "3432",
																		NVL(SUM("3432_up"), 0) AS "3432_up",
																		0 AS "3433",
																		NVL(SUM("3433_up"), 0) AS "3433_up",
																		0 AS "3434",
																		NVL(SUM("3434_up"), 0) AS "3434_up",
																		0 AS "3435",
																		NVL(SUM("3435_up"), 0) AS "3435_up",
																		0 AS "3436",
																		NVL(SUM("3436_up"), 0) AS "3436_up",
																		0 AS "3437",
																		NVL(SUM("3437_up"), 0) AS "3437_up",
																		0 AS "3438",
																		NVL(SUM("3438_up"), 0) AS "3438_up",
																		0 AS "3439",
																		NVL(SUM("3439_up"), 0) AS "3439_up",
																		0 AS "3440",
																		NVL(SUM("3440_up"), 0) AS "3440_up",
																		0 AS "3441",
																		NVL(SUM("3441_up"), 0) AS "3441_up",
																		0 AS "3442",
																		NVL(SUM("3442_up"), 0) AS "3442_up",
																		0 AS "3443",
																		NVL(SUM("3443_up"), 0) AS "3443_up",
																		0 AS "3444",
																		NVL(SUM("3444_up"), 0) AS "3444_up",
																		0 AS "3471",
																		NVL(SUM("3471_up"), 0) AS "3471_up",
																		0 AS "3473",
																		NVL(SUM("3473_up"), 0) AS "3473_up",
																		0 AS "3505",
																		NVL(SUM("3505_up"), 0) AS "3505_up",
																		0 AS "3506",
																		NVL(SUM("3506_up"), 0) AS "3506_up",
																		0 AS "3508",
																		NVL(SUM("3508_up"), 0) AS "3508_up",
																		0 AS "3509",
																		NVL(SUM("3509_up"), 0) AS "3509_up",
																		0 AS "3511",
																		NVL(SUM("3511_up"), 0) AS "3511_up",
																		0 AS "3512",
																		NVL(SUM("3512_up"), 0) AS "3512_up",
																		0 AS "3513",
																		NVL(SUM("3513_up"), 0) AS "3513_up",
																		0 AS "3514",
																		NVL(SUM("3514_up"), 0) AS "3514_up",
																		0 AS "3515",
																		NVL(SUM("3515_up"), 0) AS "3515_up",
																		0 AS "3517",
																		NVL(SUM("3517_up"), 0) AS "3517_up",
																		0 AS "3518",
																		NVL(SUM("3518_up"), 0) AS "3518_up",
																		0 AS "3519",
																		NVL(SUM("3519_up"), 0) AS "3519_up",
																		0 AS "3535",
																		NVL(SUM("3535_up"), 0) AS "3535_up",
																		0 AS "3537",
																		NVL(SUM("3537_up"), 0) AS "3537_up",
																		0 AS "3538",
																		NVL(SUM("3538_up"), 0) AS "3538_up",
																		0 AS "3539",
																		NVL(SUM("3539_up"), 0) AS "3539_up",
																		0 AS "3540",
																		NVL(SUM("3540_up"), 0) AS "3540_up",
																		0 AS "3541",
																		NVL(SUM("3541_up"), 0) AS "3541_up",
																		0 AS "3542",
																		NVL(SUM("3542_up"), 0) AS "3542_up",
																		0 AS "3543",
																		NVL(SUM("3543_up"), 0) AS "3543_up",
																		0 AS "3544",
																		NVL(SUM("3544_up"), 0) AS "3544_up",
																		0 AS "3545",
																		NVL(SUM("3545_up"), 0) AS "3545_up",
																		0 AS "3546",
																		NVL(SUM("3546_up"), 0) AS "3546_up",
																		0 AS "3547",
																		NVL(SUM("3547_up"), 0) AS "3547_up",
																		0 AS "3548",
																		NVL(SUM("3548_up"), 0) AS "3548_up",
																		0 AS "3549",
																		NVL(SUM("3549_up"), 0) AS "3549_up",
																		0 AS "3550",
																		NVL(SUM("3550_up"), 0) AS "3550_up",
																		0 AS "3551",
																		NVL(SUM("3551_up"), 0) AS "3551_up",
																		0 AS "3552",
																		NVL(SUM("3552_up"), 0) AS "3552_up",
																		0 AS "3553",
																		NVL(SUM("3553_up"), 0) AS "3553_up",
																		0 AS "3554",
																		NVL(SUM("3554_up"), 0) AS "3554_up",
																		0 AS "3555",
																		NVL(SUM("3555_up"), 0) AS "3555_up",
																		0 AS "3557",
																		NVL(SUM("3557_up"), 0) AS "3557_up",
																		0 AS "3559",
																		NVL(SUM("3559_up"), 0) AS "3559_up",
																		0 AS "3560",
																		NVL(SUM("3560_up"), 0) AS "3560_up",
																		0 AS "3561",
																		NVL(SUM("3561_up"), 0) AS "3561_up",
																		0 AS "3562",
																		NVL(SUM("3562_up"), 0) AS "3562_up",
																		0 AS "3563",
																		NVL(SUM("3563_up"), 0) AS "3563_up",
																		0 AS "3564",
																		NVL(SUM("3564_up"), 0) AS "3564_up",
																		0 AS "3565",
																		NVL(SUM("3565_up"), 0) AS "3565_up",
																		0 AS "3566",
																		NVL(SUM("3566_up"), 0) AS "3566_up",
																		0 AS "3567",
																		NVL(SUM("3567_up"), 0) AS "3567_up",
																		0 AS "3568",
																		NVL(SUM("3568_up"), 0) AS "3568_up",
																		0 AS "3569",
																		NVL(SUM("3569_up"), 0) AS "3569_up",
																		0 AS "3570",
																		NVL(SUM("3570_up"), 0) AS "3570_up",
																		0 AS "3571",
																		NVL(SUM("3571_up"), 0) AS "3571_up",
																		0 AS "3572",
																		NVL(SUM("3572_up"), 0) AS "3572_up",
																		0 AS "3573",
																		NVL(SUM("3573_up"), 0) AS "3573_up",
																		0 AS "3574",
																		NVL(SUM("3574_up"), 0) AS "3574_up",
																		0 AS "3575",
																		NVL(SUM("3575_up"), 0) AS "3575_up",
																		0 AS "3576",
																		NVL(SUM("3576_up"), 0) AS "3576_up",
																		0 AS "3577",
																		NVL(SUM("3577_up"), 0) AS "3577_up",
																		0 AS "3579",
																		NVL(SUM("3579_up"), 0) AS "3579_up",
																		0 AS "3583",
																		NVL(SUM("3583_up"), 0) AS "3583_up",
																		0 AS "3584",
																		NVL(SUM("3584_up"), 0) AS "3584_up",
																		0 AS "3585",
																		NVL(SUM("3585_up"), 0) AS "3585_up",
																		0 AS "3586",
																		NVL(SUM("3586_up"), 0) AS "3586_up",
																		0 AS "3587",
																		NVL(SUM("3587_up"), 0) AS "3587_up",
																		0 AS "3588",
																		NVL(SUM("3588_up"), 0) AS "3588_up",
																		0 AS "3590",
																		NVL(SUM("3590_up"), 0) AS "3590_up",
																		0 AS "3591",
																		NVL(SUM("3591_up"), 0) AS "3591_up",
																		0 AS "3592",
																		NVL(SUM("3592_up"), 0) AS "3592_up",
																		0 AS "3593",
																		NVL(SUM("3593_up"), 0) AS "3593_up",
																		0 AS "3594",
																		NVL(SUM("3594_up"), 0) AS "3594_up",
																		0 AS "3595",
																		NVL(SUM("3595_up"), 0) AS "3595_up",
																		0 AS "3596",
																		NVL(SUM("3596_up"), 0) AS "3596_up",
																		0 AS "3597",
																		NVL(SUM("3597_up"), 0) AS "3597_up",
																		0 AS "3598",
																		NVL(SUM("3598_up"), 0) AS "3598_up",
																		0 AS "3599",
																		NVL(SUM("3599_up"), 0) AS "3599_up",
																		0 AS "3600",
																		NVL(SUM("3600_up"), 0) AS "3600_up",
																		0 AS "3601",
																		NVL(SUM("3601_up"), 0) AS "3601_up",
																		0 AS "3602",
																		NVL(SUM("3602_up"), 0) AS "3602_up",
																		0 AS "3603",
																		NVL(SUM("3603_up"), 0) AS "3603_up",
																		0 AS "3604",
																		NVL(SUM("3604_up"), 0) AS "3604_up",
																		0 AS "3605",
																		NVL(SUM("3605_up"), 0) AS "3605_up",
																		0 AS "3606",
																		NVL(SUM("3606_up"), 0) AS "3606_up",
																		0 AS "3607",
																		NVL(SUM("3607_up"), 0) AS "3607_up",
																		0 AS "3608",
																		NVL(SUM("3608_up"), 0) AS "3608_up",
																		0 AS "3609",
																		NVL(SUM("3609_up"), 0) AS "3609_up",
																		0 AS "3610",
																		NVL(SUM("3610_up"), 0) AS "3610_up",
																		0 AS "3611",
																		NVL(SUM("3611_up"), 0) AS "3611_up",
																		0 AS "3612",
																		NVL(SUM("3612_up"), 0) AS "3612_up",
																		0 AS "3613",
																		NVL(SUM("3613_up"), 0) AS "3613_up",
																		0 AS "3614",
																		NVL(SUM("3614_up"), 0) AS "3614_up",
																		0 AS "3615",
																		NVL(SUM("3615_up"), 0) AS "3615_up",
																		0 AS "3616",
																		NVL(SUM("3616_up"), 0) AS "3616_up",
																		0 AS "3617",
																		NVL(SUM("3617_up"), 0) AS "3617_up",
																		0 AS "3618",
																		NVL(SUM("3618_up"), 0) AS "3618_up",
																		0 AS "3619",
																		NVL(SUM("3619_up"), 0) AS "3619_up",
																		0 AS "3620",
																		NVL(SUM("3620_up"), 0) AS "3620_up",
																		0 AS "3621",
																		NVL(SUM("3621_up"), 0) AS "3621_up",
																		0 AS "3622",
																		NVL(SUM("3622_up"), 0) AS "3622_up",
																		0 AS "3655",
																		NVL(SUM("3655_up"), 0) AS "3655_up",
																		0 AS "3656",
																		NVL(SUM("3656_up"), 0) AS "3656_up",
																		0 AS "3657",
																		NVL(SUM("3657_up"), 0) AS "3657_up",
																		0 AS "3658",
																		NVL(SUM("3658_up"), 0) AS "3658_up",
																		0 AS "3674",
																		NVL(SUM("3674_up"), 0) AS "3674_up",
																		0 AS "3675",
																		NVL(SUM("3675_up"), 0) AS "3675_up",
																		0 AS "3676",
																		NVL(SUM("3676_up"), 0) AS "3676_up",
																		0 AS "3677",
																		NVL(SUM("3677_up"), 0) AS "3677_up"
																	FROM
																		(
																			SELECT
																				EX_SCHOOL_CODE AS USER_EX_SCHOOL_CODE,
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2585 THEN CNT
																				END), 0) AS "2585_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2586 THEN CNT
																				END), 0) AS "2586_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2591 THEN CNT
																				END), 0) AS "2591_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2592 THEN CNT
																				END), 0) AS "2592_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2598 THEN CNT
																				END), 0) AS "2598_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2599 THEN CNT
																				END), 0) AS "2599_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2601 THEN CNT
																				END), 0) AS "2601_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2608 THEN CNT
																				END), 0) AS "2608_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2617 THEN CNT
																				END), 0) AS "2617_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2625 THEN CNT
																				END), 0) AS "2625_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2631 THEN CNT
																				END), 0) AS "2631_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2632 THEN CNT
																				END), 0) AS "2632_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2633 THEN CNT
																				END), 0) AS "2633_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2634 THEN CNT
																				END), 0) AS "2634_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2635 THEN CNT
																				END), 0) AS "2635_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2638 THEN CNT
																				END), 0) AS "2638_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2639 THEN CNT
																				END), 0) AS "2639_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2640 THEN CNT
																				END), 0) AS "2640_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2641 THEN CNT
																				END), 0) AS "2641_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2642 THEN CNT
																				END), 0) AS "2642_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2644 THEN CNT
																				END), 0) AS "2644_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2656 THEN CNT
																				END), 0) AS "2656_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2657 THEN CNT
																				END), 0) AS "2657_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2658 THEN CNT
																				END), 0) AS "2658_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2659 THEN CNT
																				END), 0) AS "2659_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2661 THEN CNT
																				END), 0) AS "2661_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2662 THEN CNT
																				END), 0) AS "2662_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2663 THEN CNT
																				END), 0) AS "2663_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2667 THEN CNT
																				END), 0) AS "2667_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2668 THEN CNT
																				END), 0) AS "2668_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2670 THEN CNT
																				END), 0) AS "2670_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2672 THEN CNT
																				END), 0) AS "2672_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2673 THEN CNT
																				END), 0) AS "2673_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2674 THEN CNT
																				END), 0) AS "2674_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2675 THEN CNT
																				END), 0) AS "2675_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2677 THEN CNT
																				END), 0) AS "2677_up",
																				NVL(SUM(CASE
																				WHEN BOOK_FULL_SEQ = 2680 THEN CNT END), 0) AS "2680_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2685 THEN CNT
																				END), 0) AS "2685_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2687 THEN CNT
																				END), 0) AS "2687_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2688 THEN CNT
																				END), 0) AS "2688_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2689 THEN CNT
																				END), 0) AS "2689_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2692 THEN CNT
																				END), 0) AS "2692_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2694 THEN CNT
																				END), 0) AS "2694_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2695 THEN CNT
																				END), 0) AS "2695_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2696 THEN CNT
																				END), 0) AS "2696_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2697 THEN CNT
																				END), 0) AS "2697_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2699 THEN CNT
																				END), 0) AS "2699_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2701 THEN CNT
																				END), 0) AS "2701_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2707 THEN CNT
																				END), 0) AS "2707_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2708 THEN CNT
																				END), 0) AS "2708_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2710 THEN CNT
																				END), 0) AS "2710_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2711 THEN CNT
																				END), 0) AS "2711_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2719 THEN CNT
																				END), 0) AS "2719_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2726 THEN CNT
																				END), 0) AS "2726_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2728 THEN CNT
																				END), 0) AS "2728_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2729 THEN CNT
																				END), 0) AS "2729_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2733 THEN CNT
																				END), 0) AS "2733_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2734 THEN CNT
																				END), 0) AS "2734_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2736 THEN CNT
																				END), 0) AS "2736_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2737 THEN CNT
																				END), 0) AS "2737_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2739 THEN CNT
																				END), 0) AS "2739_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2740 THEN CNT
																				END), 0) AS "2740_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2743 THEN CNT
																				END), 0) AS "2743_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2745 THEN CNT
																				END), 0) AS "2745_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2746 THEN CNT
																				END), 0) AS "2746_up",
																				NVL(SUM(CasE
																				WHEN BOOK_FULL_SEQ = 2747 THEN CNT END), 0) AS "2747_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2748 THEN CNT
																				END), 0) AS "2748_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2817 THEN CNT
																				END), 0) AS "2817_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2965 THEN CNT
																				END), 0) AS "2965_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2966 THEN CNT
																				END), 0) AS "2966_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2967 THEN CNT
																				END), 0) AS "2967_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2968 THEN CNT
																				END), 0) AS "2968_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 2969 THEN CNT
																				END), 0) AS "2969_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3084 THEN CNT
																				END), 0) AS "3084_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3085 THEN CNT
																				END), 0) AS "3085_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3102 THEN CNT
																				END), 0) AS "3102_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3103 THEN CNT
																				END), 0) AS "3103_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3104 THEN CNT
																				END), 0) AS "3104_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3105 THEN CNT
																				END), 0) AS "3105_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3106 THEN CNT
																				END), 0) AS "3106_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3107 THEN CNT
																				END), 0) AS "3107_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3108 THEN CNT
																				END), 0) AS "3108_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3109 THEN CNT
																				END), 0) AS "3109_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3111 THEN CNT
																				END), 0) AS "3111_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3112 THEN CNT
																				END), 0) AS "3112_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3114 THEN CNT
																				END), 0) AS "3114_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3115 THEN CNT
																				END), 0) AS "3115_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3116 THEN CNT
																				END), 0) AS "3116_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3117 THEN CNT
																				END), 0) AS "3117_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3118 THEN CNT
																				END), 0) AS "3118_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3119 THEN CNT
																				END), 0) AS "3119_up",
																				NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3120 THEN CNT
																				END), 0) AS "3120_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3121 THEN CNT
																				END), 0) AS "3121_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3122 THEN CNT
																				END), 0) AS "3122_up",
																				NVL(SUM(CASE
																				WHEN BOOK_FULL_SEQ = 3123 THEN CNT END), 0) AS "3123_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3124 THEN CNT
																				END), 0) AS "3124_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3125 THEN CNT
																				END), 0) AS "3125_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3126 THEN CNT
																				END), 0) AS "3126_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3128 THEN CNT
																				END), 0) AS "3128_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3129 THEN CNT
																				END), 0) AS "3129_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3130 THEN CNT
																				END), 0) AS "3130_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3133 THEN CNT
																				END), 0) AS "3133_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3134 THEN CNT
																				END), 0) AS "3134_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3323 THEN CNT
																				END), 0) AS "3323_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3329 THEN CNT
																				END), 0) AS "3329_up",
																				NVL(SUM(CASE
																					WHEN BOOK_FULL_SEQ = 3332 THEN CNT END ), 0 ) AS "3332_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3334 THEN CNT
																						END), 0) AS "3334_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3335 THEN CNT
																						END), 0) AS "3335_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3336 THEN CNT
																						END), 0) AS "3336_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3338 THEN CNT
																						END), 0) AS "3338_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3339 THEN CNT
																						END), 0) AS "3339_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3340 THEN CNT
																						END), 0) AS "3340_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3341 THEN CNT
																						END), 0) AS "3341_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3342 THEN CNT
																						END), 0) AS "3342_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3343 THEN CNT
																						END), 0) AS "3343_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3344 THEN CNT
																						END), 0) AS "3344_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3345 THEN CNT
																						END), 0) AS "3345_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3346 THEN CNT
																						END), 0) AS "3346_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3347 THEN CNT
																						END), 0) AS "3347_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3349 THEN CNT
																						END), 0) AS "3349_up", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3350 THEN CNT
																						END), 0) AS "3350_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3351 THEN CNT
																						END), 0) AS "3351_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3352 THEN CNT
																						END), 0) AS "3352_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3353 THEN CNT
																						END), 0) AS "3353_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3369 THEN CNT
																						END), 0) AS "3369_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3370 THEN CNT
																						END), 0) AS "3370_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3385 THEN CNT
																						END), 0) AS "3385_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3386 THEN CNT
																						END), 0) AS "3386_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3387 THEN CNT
																						END), 0) AS "3387_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3388 THEN CNT
																						END), 0) AS "3388_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3389 THEN CNT
																						END), 0) AS "3389_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3390 THEN CNT
																						END), 0) as "3390_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3391 THEN CNT
																						END), 0) AS "3391_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3392 THEN CNT
																						END), 0) AS "3392_up", NVL(SUM(CASE
																							WHEN BOOK_FULL_SEQ = 3393 THEN CNT END ), 0 ) AS "3393_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3394 THEN CNT
																								END), 0) AS "3394_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3395 THEN CNT
																								END), 0) AS "3395_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3396 THEN CNT
																								END), 0) AS "3396_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3397 THEN CNT
																								END), 0) AS "3397_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3398 THEN CNT
																								END), 0) AS "3398_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3399 THEN CNT
																								END), 0) AS "3399_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3400 THEN CNT
																								END), 0) AS "3400_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3401 THEN CNT
																								END), 0) AS "3401_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3402 THEN CNT
																								END), 0) AS "3402_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3403 THEN CNT
																								END), 0) AS "3403_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3408 THEN CNT
																								END), 0) AS "3408_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3409 THEN CNT
																								END), 0) AS "3409_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3410 THEN CNT
																								END), 0) AS "3410_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3411 THEN CNT
																								END), 0) AS "3411_up", NVL(SUM(CASE WHEN BOOK_FULL_SEQ = 3412 THEN CNT
																								END), 0) AS "3412_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3413 THEN CNT
																								END), 0) AS "3413_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3414 THEN CNT
																								END), 0) AS "3414_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3415 THEN CNT
																								END), 0) AS "3415_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3416 THEN CNT
																								END), 0) AS "3416_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3417 THEN CNT
																								END), 0) AS "3417_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3418 THEN CNT
																								END), 0) AS "3418_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3419 THEN CNT
																								END), 0) AS "3419_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3420 THEN CNT
																								END), 0) AS "3420_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3421 THEN CNT
																								END), 0) AS "3421_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3422 THEN CNT
																								END), 0) AS "3422_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3423 THEN CNT
																								END), 0) AS "3423_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3424 THEN CNT
																								END), 0) AS "3424_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3425 THEN CNT
																								END), 0) AS "3425_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3426 THEN CNT
																								END), 0) AS "3426_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3427 THEN CNT
																								END), 0) AS "3427_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3428 THEN CNT
																								END), 0) AS "3428_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3429 THEN CNT
																								END), 0) AS "3429_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3430 THEN CNT
																								END), 0) AS "3430_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3431 THEN CNT
																								END), 0) AS "3431_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3432 THEN CNT
																								END), 0) AS "3432_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3433 THEN CNT
																								END), 0) AS "3433_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3434 THEN CNT
																								END), 0) AS "3434_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3435 THEN CNT
																								END), 0) AS "3435_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3436 THEN CNT
																								END), 0) AS "3436_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3437 THEN CNT
																								END), 0) AS "3437_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3438 THEN CNT
																								END), 0) AS "3438_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3439 THEN CNT
																								END), 0) AS "3439_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3440 THEN CNT
																								END), 0) AS "3440_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3441 THEN CNT
																								END), 0) AS "3441_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3442 THEN CNT
																								END), 0) AS "3442_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3443 THEN CNT
																								END), 0) AS "3443_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3444 THEN CNT
																								END), 0) AS "3444_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3471 THEN CNT
																								END), 0) AS "3471_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3473 THEN CNT
																								END), 0) AS "3473_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3505 THEN CNT
																								END), 0) AS "3505_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3506 THEN CNT
																								END), 0) AS "3506_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3508 THEN CNT
																								END), 0) AS "3508_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3509 THEN CNT
																								END), 0) AS "3509_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3511 THEN CNT
																								END), 0) AS "3511_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3512 THEN CNT
																								END), 0) AS "3512_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3513 THEN CNT
																								END), 0) AS "3513_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3514 THEN CNT
																								END), 0) AS "3514_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3515 THEN CNT
																								END), 0) AS "3515_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3517 THEN CNT
																								END), 0) AS "3517_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3518 THEN CNT
																								END), 0) AS "3518_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3519 THEN CNT
																								END), 0) AS "3519_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3535 THEN CNT
																								END), 0) AS "3535_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3537 THEN CNT
																								END), 0) AS "3537_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3538 THEN CNT
																								END), 0) AS "3538_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3539 THEN CNT
																								END), 0) AS "3539_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3540 THEN CNT
																								END), 0) AS "3540_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3541 THEN CNT
																								END), 0) AS "3541_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3542 THEN CNT
																								END), 0) AS "3542_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3543 THEN CNT
																								END), 0) AS "3543_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3544 THEN CNT
																								END), 0) AS "3544_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3545 THEN CNT
																								END), 0) AS "3545_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3546 THEN CNT
																								END), 0) AS "3546_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3547 THEN CNT
																								END), 0) AS "3547_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3548 THEN CNT
																								END), 0) AS "3548_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3549 THEN CNT
																								END), 0) AS "3549_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3550 THEN CNT
																								END), 0) AS "3550_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3551 THEN CNT
																								END), 0) AS "3551_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3552 THEN CNT
																								END), 0) AS "3552_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3553 THEN CNT
																								END), 0) AS "3553_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3554 THEN CNT
																								END), 0) AS "3554_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3555 THEN CNT
																								END), 0) AS "3555_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3557 THEN CNT
																								END), 0) AS "3557_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3559 THEN CNT
																								END), 0) AS "3559_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3560 THEN CNT
																								END), 0) AS "3560_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3561 THEN CNT
																								END), 0) AS "3561_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3562 THEN CNT
																								END), 0) AS "3562_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3563 THEN CNT
																								END), 0) AS "3563_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3564 THEN CNT
																								END), 0) AS "3564_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3565 THEN CNT
																								END), 0) AS "3565_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3566 THEN CNT
																								END), 0) AS "3566_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3567 THEN CNT
																								END), 0) AS "3567_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3568 THEN CNT
																								END), 0) AS "3568_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3569 THEN CNT
																								END), 0) AS "3569_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3570 THEN CNT
																								END), 0) AS "3570_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3571 THEN CNT
																								END), 0) AS "3571_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3572 THEN CNT
																								END), 0) AS "3572_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3573 THEN CNT
																								END), 0) AS "3573_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3574 THEN CNT
																								END), 0) AS "3574_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3575 THEN CNT
																								END), 0) AS "3575_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3576 THEN CNT
																								END), 0) AS "3576_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3577 THEN CNT
																								END), 0) AS "3577_up", NVL(SUM(CASE
																								WHEN BOOK_FULL_SEQ = 3579 THEN CNT END), 0) AS "3579_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3583 THEN CNT
																								END), 0) AS "3583_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3584 THEN CNT
																								END), 0) AS "3584_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3585 THEN CNT
																								END), 0) AS "3585_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3586 THEN CNT
																								END), 0) AS "3586_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3587 THEN CNT
																								END), 0) AS "3587_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3588 THEN CNT
																								END), 0) AS "3588_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3590 THEN CNT
																								END), 0) AS "3590_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3591 THEN CNT
																								END), 0) AS "3591_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3592 THEN CNT
																								END), 0) AS "3592_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3593 THEN CNT
																								END), 0) AS "3593_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3594 THEN CNT
																								END), 0) AS "3594_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3595 THEN CNT
																								END), 0) AS "3595_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3596 THEN CNT
																								END), 0) AS "3596_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3597 THEN CNT
																								END), 0) AS "3597_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3598 THEN CNT
																								END), 0) AS "3598_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3599 THEN CNT
																								END), 0) AS "3599_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3600 THEN CNT
																								END), 0) AS "3600_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3601 THEN CNT
																								END), 0) AS "3601_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3602 THEN CNT
																								END), 0) AS "3602_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3603 THEN CNT
																								END), 0) AS "3603_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3604 THEN CNT
																								END), 0) AS "3604_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3605 THEN CNT
																								END), 0) AS "3605_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3606 THEN CNT
																								END), 0) AS "3606_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3607 THEN CNT
																								END), 0) AS "3607_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3608 THEN CNT
																								END), 0) AS "3608_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3609 THEN CNT
																								END), 0) AS "3609_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3610 THEN CNT
																								END), 0) AS "3610_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3611 THEN CNT
																								END), 0) AS "3611_up", NVL(SUM(CasE
																								WHEN BOOK_FULL_SEQ = 3612 THEN CNT END), 0) AS "3612_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3613 THEN CNT
																								END), 0) AS "3613_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3614 THEN CNT
																								END), 0) AS "3614_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3615 THEN CNT
																								END), 0) AS "3615_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3616 THEN CNT
																								END), 0) AS "3616_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3617 THEN CNT
																								END), 0) AS "3617_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3618 THEN CNT
																								END), 0) AS "3618_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3619 THEN CNT
																								END), 0) AS "3619_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3620 THEN CNT
																								END), 0) AS "3620_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3621 THEN CNT
																								END), 0) AS "3621_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3622 THEN CNT
																								END), 0) AS "3622_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3655 THEN CNT
																								END), 0) AS "3655_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3656 THEN CNT
																								END), 0) AS "3656_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3657 THEN CNT
																								END), 0) AS "3657_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3658 THEN CNT
																								END), 0) AS "3658_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3674 THEN CNT
																								END), 0) AS "3674_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3675 THEN CNT
																								END), 0) AS "3675_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3676 THEN CNT
																								END), 0) AS "3676_up", NVL(SUM(CASE
																									WHEN BOOK_FULL_SEQ = 3677 THEN CNT
																								END), 0) AS "3677_up"
																								FROM
																									(
																										SELECT
																											EX_SCHOOL_CODE,
																											BOOK_FULL_SEQ,
																											COUNT(1) AS cnt
																										FROM
																											TB_STATS_DOWNLOAD_UPDATE tb_dwn_up,
																											TB_SCHOOL tb_sch
																										WHERE
																											tb_dwn_up.EX_SCHOOL_CODE = tb_sch.code
																											AND tb_sch.ex_schgrade_code IN (
																												'02',
																												'03',
																												'04',
																												'06'
																											)
																											AND tb_dwn_up.WHENAUTH >= '20100301'
																											AND tb_dwn_up.WHENAUTH <= '20230322'
																										GROUP BY
																											tb_dwn_up.EX_SCHOOL_CODE,
																											tb_dwn_up.BOOK_FULL_SEQ
																									)
																								GROUP BY
																									EX_SCHOOL_CODE )
																								GROUP BY
																									USER_EX_SCHOOL_CODE )
																								GROUP BY
																									USER_EX_SCHOOL_CODE )
																								GROUP BY
																									USER_EX_SCHOOL_CODE ) ) B ON A.CODE = B.USER_EX_SCHOOL_CODE
																								GROUP BY
																									NVL(A.NAME, '기타'),
																									NVL(B.USER_EX_SCHOOL_CODE, '없음'),
																									NVL(A.EX_EDUOFFICENAME, '기타'),
																									NVL(A.EX_SCHGRADE, '기타')
																								ORDER BY
																									A.NAME ) A
																								WHERE
																									ROWNUM BETWEEN 1 AND 30 + 1

DROP TABLE IF EXISTS tb_stats_download_update;
DROP TABLE IF EXISTS tb_school;
DROP TABLE IF EXISTS tb_stats_download;
