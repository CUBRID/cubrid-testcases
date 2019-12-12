--Parsing a TIME from a string using CAST

-- The time part is recognized from certain datetime or time-date strings --
SELECT CAST('2009-10-12 22:44:02' AS TIME);
SELECT CAST('2010&&8&&30& &22&&44%%02' AS TIME);
SELECT CAST('8&&30_ _22&&44&&02' AS TIME);
SELECT CAST('8/30_ _22&@@@@@44^@@@@@@@@@02' AS TIME);
SELECT CAST('8/20 12:10:22.90432543' AS TIME);
SELECT CAST('2018-10-12 22:4' AS TIME);
SELECT CAST('2018-10-12 22' AS TIME);
SELECT CAST('22 2018-10-12' AS TIME);
SELECT CAST('11pm 2012-10-12' AS TIME);
SELECT CAST('11:02                                   PM                         2012-10-12' AS TIME);
SELECT CAST('11:::::::::02PM 2012-10-12' AS TIME);
SELECT CAST('11:::::::::02:10.2343PM 2012-10-12' AS TIME);
SELECT CAST(':22 10-12' AS TIME);
SELECT CAST(':22:10 12/10' AS TIME);

-- Time is also read from simple time strings --
SELECT CAST('22:02:44.56788' AS TIME);
SELECT CAST('22:02:44' AS TIME);
SELECT CAST('22:02' AS TIME);
SELECT CAST(':02' AS TIME);
SELECT CAST(':02:44' AS TIME);
SELECT CAST(':02:44.3' AS TIME);
SELECT CAST(':02:.3' AS TIME);

-- "am"/"pm" strings, in either the English locale, or the server current locale, may follow any time value
SELECT CAST('2009-10-12 11:44:02 PM' AS TIME);
SELECT CAST('2010&&8&&30& &11&&44%%02&&&pm' AS TIME);
SELECT CAST('8&&30_ _12&&44&&02 am' AS TIME);
SELECT CAST('8/30_ _10&@@@@@44^@@@@@@@@@02AM' AS TIME);
SELECT CAST('8/20 11:10:22.90432543 pm' AS TIME);
SELECT CAST('2018-10-12 11:4: pm' AS TIME);
SELECT CAST('2018-10-12 11pM' AS TIME);
SELECT CAST('10:02:44.56788 pm' AS TIME);
SELECT CAST('11:02:44 pm' AS TIME);
SELECT CAST('08:02 am' AS TIME);
SELECT CAST(':02: pm' AS TIME);
SELECT CAST(':02:44: pm' AS TIME);
SELECT CAST(':02:44:.3 pm' AS TIME);
SELECT CAST(':02:.3 PM' AS TIME);

-- "pm" strings with an hour value greater than 12 are ignored --
SELECT CAST('2009-10-12 22:44:02 pm' AS TIME);
SELECT CAST('2010&&8&&30& &22&&44%%02pm' AS TIME);
SELECT CAST('8&&30_ _22&&44&&02 PM' AS TIME);
SELECT CAST('21:02:44 pm' AS TIME);
SELECT CAST('18:02 pm' AS TIME);
SELECT CAST('22:02:44.3 pm' AS TIME);

-- Time can also be read from datetime strings or from time strings in compact format --
SELECT CAST(' 20091012104402755553490pm' AS TIME);
SELECT CAST('20091012104402.755553490pm' AS TIME);
SELECT CAST('200910121044027.55553490pm' AS TIME);
SELECT CAST('2009101210440275.5553490pm' AS TIME);
SELECT CAST('20091012104402755.553490pm' AS TIME);
SELECT CAST('200910121044027555534.90pm' AS TIME);
SELECT CAST('20091012104402pm' AS TIME);
SELECT CAST(    '091012104402.33 PM' AS TIME);
SELECT CAST(      '91012104402.33 pm' AS TIME);
SELECT CAST(        '1012104402.33 PM' AS TIME);
SELECT CAST(          '912104402.33 pm' AS TIME);
SELECT CAST(                '104402.33 pm' AS TIME);
SELECT CAST(                  '84402.33 PM' AS TIME);
SELECT CAST(                    '4402.33 PM' AS TIME);
SELECT CAST(                      '402.33 PM' AS TIME);
SELECT CAST(                        '12.33 PM' AS TIME);
SELECT CAST(                          '2.33 PM' AS TIME);
SELECT CAST(                            '.33 PM' AS TIME);
SELECT CAST(                            '. pm' AS TIME);
SELECT CAST(                            '.' AS TIME);

SELECT CAST('10:' AS TIME);

-- Leading spaces and trailing characters or spaces are ignored--
SELECT CAST('                                             10:22:.4 PM&&&&' AS TIME);
SELECT CAST('                                             10:22:.4 PM     &&' AS TIME);
SELECT CAST('                                             10:22:.4:10:22:31' AS TIME);
SELECT CAST('                                             10:22:4:10:22:31' AS TIME);

-- If a datetime string uses no space to separate the date and the time in the input string,
-- than the year value is read as a time in compact format, and the digits will give mis and sec --
SELECT CAST('1122#10#20$18$44:58.02' AS TIME);
SELECT CAST('1122#10#20_18$44:58.' AS TIME);
SELECT CAST('1122#10#20#18$44:58' AS TIME);
SELECT CAST('1122#10#20@18$44:' AS TIME);
SELECT CAST('1122#10#20^18$44' AS TIME);
SELECT CAST('1122#10#20(18$' AS TIME);
SELECT CAST('1122#10#20*18' AS TIME);

-- datetime strings that have a two-digits (or less) year and ether just one time part, or 2 time parts but followed by space,
-- are parsed as if in compact format, with trailing characters ignored
SELECT CAST('          11-28 10' AS TIME);
SELECT CAST('          11/28 10:40' AS TIME);
SELECT CAST('    02-11-28 10' AS TIME);
SELECT CAST('    02-11-28 10:  ' AS TIME);
SELECT CAST('    02-11-28 10:48:  ' AS TIME);

-- datetime strings with fields over 999999 are parsed as if in compact format--
SELECT CAST('2009-10-12 10:48:1432784293487239487.32 pm' AS TIME);
SELECT CAST('2009-10-12 10:4847329084723948233487:14.32 pm' AS TIME);
SELECT CAST('2009-10-12 10109847329842379847:48:14.32 pm' AS TIME);
SELECT CAST('2009-10-12109847329842379847 10:48:14.32 pm' AS TIME);
SELECT CAST('2009-1000000-12 10:48:14.32 pm' AS TIME);
SELECT CAST('2009102817324842379847-10-12 10:48:14.32 pm' AS TIME);

-- leading whitespace and trailing characters or whitespace in time strings are ignored --
SELECT CAST('  2009-10-12 22:44:02asdfads' AS TIME);
SELECT CAST('        2010&&8&&30& &22&&44%%02*slkj' AS TIME);
SELECT CAST('  8&&30_ _22&&44&&02$$$$$$$' AS TIME);
SELECT CAST(' 8/30_ _22&@@@@@44^@@@@@@@@@02$' AS TIME);
SELECT CAST(' 8/20 12:10:22.90432543xxxxxxx' AS TIME);
SELECT CAST(' 2018-10-12 22:4XX' AS TIME);
SELECT CAST('         2018-10-12 22|s' AS TIME);
SELECT CAST('10:22:48.3ASDFADSF' AS TIME);
SELECT CAST('10:22:48.3 PM##' AS TIME);
SELECT CAST('10:22#48.3 PM##' AS TIME);
SELECT CAST('       10:22:48.3ASDFADSF' AS TIME);
SELECT CAST('    10:22:48.3 PM##' AS TIME);
SELECT CAST('         10:22#48.3 PM##' AS TIME);
SELECT CAST('10x22x44.23' AS TIME);


-- datetime strings with invalid fields but under 1000000 generate errors
SELECT CAST('2009-10-12 10:48:999999.32 pm' AS TIME);
SELECT CAST('2009-10-12 10:99123:14.32 pm' AS TIME);
SELECT CAST('2009-10-12 24:48:14.32 pm' AS TIME);
SELECT CAST('2009-10-32 10:48:14.32 pm' AS TIME);
SELECT CAST('2009-18-12 10:48:14.32 pm' AS TIME);
SELECT CAST('34502-10-12 10:48:14.32 pm' AS TIME);

-- time-date strings with wrong separators are read as datetime strings--

SELECT CAST('10:.22:.18 2008-10-11' AS TIME);
SELECT CAST('10-22-18 2008-10-11' AS TIME);
SELECT CAST('10:22:18 2008|10|11' AS TIME);

SELECT CAST('10:22:18 10.11' AS TIME);

-- no time value to read is also an error --
SELECT CAST('T20:21:22PM' AS TIME);
SELECT CAST('' AS TIME);


CREATE TABLE
		 StrTime
		 	(
		 		TextID INTEGER AUTO_INCREMENT PRIMARY KEY,
		 		TimeText VARCHAR(255),
		 		TimeNText NCHAR VARYING(255),
		 		TimeFText CHAR(255),
		 		TimeFNText NCHAR(255),
		 		TimeVal TIME,
		 		TimeNVal TIME,
		 		TimeFVal TIME,
		 		TimeFNVal TIME,
		 		InsertTimeVal TIME,
		 		InsertTimeNVal TIME,
		 		InsertTimeFVal TIME,
		 		InsertTimeFNVal TIME
		 	);
		 	
INSERT INTO StrTime(TimeText, TimeNText, TimeFText, TimeFNText)
VALUES
('2009-10-12 22:44:02', N'2009-10-12 22:44:02', '2009-10-12 22:44:02', N'2009-10-12 22:44:02'),
('2010&&8&&30& &22&&44%%02', N'2010&&8&&30& &22&&44%%02', '2010&&8&&30& &22&&44%%02', N'2010&&8&&30& &22&&44%%02'),
('8&&30_ _22&&44&&02', N'8&&30_ _22&&44&&02', '8&&30_ _22&&44&&02', N'8&&30_ _22&&44&&02' ),
('8/30_ _22&@@@@@44^@@@@@@@@@02', N'8/30_ _22&@@@@@44^@@@@@@@@@02', '8/30_ _22&@@@@@44^@@@@@@@@@02', N'8/30_ _22&@@@@@44^@@@@@@@@@02'),
('8/20 12:10:22.90432543', N'8/20 12:10:22.90432543', '8/20 12:10:22.90432543', N'8/20 12:10:22.90432543'),
('2018-10-12 22:4', N'2018-10-12 22:4', '2018-10-12 22:4', N'2018-10-12 22:4'),
('2018-10-12 22', N'2018-10-12 22', '2018-10-12 22', N'2018-10-12 22'),
('22 2018-10-12', N'22 2018-10-12', '22 2018-10-12', N'22 2018-10-12'),
('11pm 2012-10-12', N'11pm 2012-10-12', '11pm 2012-10-12', N'11pm 2012-10-12'),
('11:02                                   PM                         2012-10-12', N'11:02                                   PM                         2012-10-12', '11:02                                   PM                         2012-10-12', N'11:02                                   PM                         2012-10-12'),
('11:::::::::02PM 2012-10-12',  N'11:::::::::02PM 2012-10-12',  '11:::::::::02PM 2012-10-12',  N'11:::::::::02PM 2012-10-12' ),
('11:::::::::02:10.2343PM 2012-10-12', N'11:::::::::02:10.2343PM 2012-10-12', '11:::::::::02:10.2343PM 2012-10-12', N'11:::::::::02:10.2343PM 2012-10-12'),
(':22 10-12', N':22 10-12', ':22 10-12', N':22 10-12'),
(':22:10 12/10', N':22:10 12/10', ':22:10 12/10', N':22:10 12/10'),
('22:02:44.56788', N'22:02:44.56788', '22:02:44.56788', N'22:02:44.56788'),
('22:02:44', N'22:02:44', '22:02:44', N'22:02:44'),
('22:02', N'22:02', '22:02', N'22:02'),

(':02', N':02', ':02', N':02'),
(':02:44', N':02:44', ':02:44', N':02:44'),
(':02:44.3', N':02:44.3', ':02:44.3', N':02:44.3'),
(':02:.3', N':02:.3', ':02:.3', N':02:.3'),
('2009-10-12 11:44:02 PM', N'2009-10-12 11:44:02 PM', '2009-10-12 11:44:02 PM', N'2009-10-12 11:44:02 PM') ,
('2010&&8&&30& &11&&44%%02&&&pm', N'2010&&8&&30& &11&&44%%02&&&pm', '2010&&8&&30& &11&&44%%02&&&pm', N'2010&&8&&30& &11&&44%%02&&&pm') ,
('8&&30_ _12&&44&&02 am', N'8&&30_ _12&&44&&02 am', '8&&30_ _12&&44&&02 am', N'8&&30_ _12&&44&&02 am') ,
('8/30_ _10&@@@@@44^@@@@@@@@@02AM', N'8/30_ _10&@@@@@44^@@@@@@@@@02AM', '8/30_ _10&@@@@@44^@@@@@@@@@02AM', N'8/30_ _10&@@@@@44^@@@@@@@@@02AM') ,
('8/20 11:10:22.90432543 pm', N'8/20 11:10:22.90432543 pm', '8/20 11:10:22.90432543 pm', N'8/20 11:10:22.90432543 pm') ,
('2018-10-12 11:4: pm', N'2018-10-12 11:4: pm', '2018-10-12 11:4: pm', N'2018-10-12 11:4: pm') ,
('2018-10-12 11pM', N'2018-10-12 11pM', '2018-10-12 11pM', N'2018-10-12 11pM') ,
('10:02:44.56788 pm', N'10:02:44.56788 pm', '10:02:44.56788 pm', N'10:02:44.56788 pm') ,
('10:02:44.56788 pm', N'10:02:44.56788 pm', '10:02:44.56788 pm', N'10:02:44.56788 pm') ,
('11:02:44 pm', N'11:02:44 pm', '11:02:44 pm', N'11:02:44 pm') ,
('08:02 am', N'08:02 am', '08:02 am', N'08:02 am') ,
(':02: pm', N':02: pm', ':02: pm', N':02: pm') ,
(':02:44: pm', N':02:44: pm', ':02:44: pm', N':02:44: pm') ,
(':02:44:.3 pm', N':02:44:.3 pm', ':02:44:.3 pm', N':02:44:.3 pm') ,
(':02:.3 PM', N':02:.3 PM', ':02:.3 PM', N':02:.3 PM') ,
('2009-10-12 22:44:02 pm', N'2009-10-12 22:44:02 pm', '2009-10-12 22:44:02 pm', N'2009-10-12 22:44:02 pm') ,
('2010&&8&&30& &22&&44%%02pm', N'2010&&8&&30& &22&&44%%02pm', '2010&&8&&30& &22&&44%%02pm', N'2010&&8&&30& &22&&44%%02pm') ,
('8&&30_ _22&&44&&02 PM', N'8&&30_ _22&&44&&02 PM', '8&&30_ _22&&44&&02 PM', N'8&&30_ _22&&44&&02 PM') ,
('21:02:44 pm', N'21:02:44 pm', '21:02:44 pm', N'21:02:44 pm') ,
('18:02 pm', N'18:02 pm', '18:02 pm', N'18:02 pm') ,
('22:02:44.3 pm', N'22:02:44.3 pm', '22:02:44.3 pm', N'22:02:44.3 pm') ,
(' 20091012104402755553490pm', N' 20091012104402755553490pm', ' 20091012104402755553490pm', N' 20091012104402755553490pm') ,
('20091012104402.755553490pm', N'20091012104402.755553490pm', '20091012104402.755553490pm', N'20091012104402.755553490pm') ,
('200910121044027.55553490pm', N'200910121044027.55553490pm', '200910121044027.55553490pm', N'200910121044027.55553490pm') ,
('2009101210440275.5553490pm', N'2009101210440275.5553490pm', '2009101210440275.5553490pm', N'2009101210440275.5553490pm') ,
('20091012104402755.553490pm', N'20091012104402755.553490pm', '20091012104402755.553490pm', N'20091012104402755.553490pm') ,
('200910121044027555534.90pm', N'200910121044027555534.90pm', '200910121044027555534.90pm', N'200910121044027555534.90pm') ,
('20091012104402pm', N'20091012104402pm', '20091012104402pm', N'20091012104402pm') ,
(    '091012104402.33 PM',     N'091012104402.33 PM',     '091012104402.33 PM',     N'091012104402.33 PM') ,
(      '91012104402.33 pm',         N'91012104402.33 pm',         '91012104402.33 pm',         N'91012104402.33 pm'  ) ,
(        '1012104402.33 PM',         N'1012104402.33 PM',         '1012104402.33 PM',         N'1012104402.33 PM') ,
(          '912104402.33 pm',           N'912104402.33 pm',           '912104402.33 pm',           N'912104402.33 pm') ,
(                '104402.33 pm',                 N'104402.33 pm',                 '104402.33 pm',                 N'104402.33 pm') ,
(                  '84402.33 PM',                   N'84402.33 PM',                   '84402.33 PM',                   N'84402.33 PM') ,
(                    '4402.33 PM',                     N'4402.33 PM',                     '4402.33 PM',                     N'4402.33 PM') ,
(                      '402.33 PM',                       N'402.33 PM',                       '402.33 PM',                       N'402.33 PM') ,
(                        '12.33 PM',                         N'12.33 PM',                         '12.33 PM',                         N'12.33 PM') ,
(                          '2.33 PM',                           N'2.33 PM',                           '2.33 PM',                           N'2.33 PM') ,
(                            '.33 PM',                             N'.33 PM',                             '.33 PM',                             N'.33 PM') ,
(                            '. pm',                             N'. pm',                             '. pm',                             N'. pm') ,
(                            '.',                             N'.',                             '.',                             N'.') ,
('10:', N'10:', '10:', N'10:') ,
('                                             10:22:.4 PM&&&&', N'                                             10:22:.4 PM&&&&', '                                             10:22:.4 PM&&&&', N'                                             10:22:.4 PM&&&&'),
('                                             10:22:.4 PM     &&', N'                                             10:22:.4 PM     &&', '                                             10:22:.4 PM     &&', N'                                             10:22:.4 PM     &&'),
('                                             10:22:.4:10:22:31', N'                                             10:22:.4:10:22:31', '                                             10:22:.4:10:22:31', N'                                             10:22:.4:10:22:31' ),
('                                             10:22:4:10:22:31', N'                                             10:22:4:10:22:31', '                                             10:22:4:10:22:31', N'                                             10:22:4:10:22:31'),
('1122#10#20$18$44:58.02', N'1122#10#20$18$44:58.02', '1122#10#20$18$44:58.02', N'1122#10#20$18$44:58.02' ),
('1122#10#20_18$44:58.', N'1122#10#20_18$44:58.', '1122#10#20_18$44:58.', N'1122#10#20_18$44:58.' ),
('1122#10#20#18$44:58', N'1122#10#20#18$44:58', '1122#10#20#18$44:58', N'1122#10#20#18$44:58'),
('1122#10#20@18$44:', N'1122#10#20@18$44:', '1122#10#20@18$44:', N'1122#10#20@18$44:' ),
('1122#10#20^18$44', N'1122#10#20^18$44', '1122#10#20^18$44', N'1122#10#20^18$44' ),
('1122#10#20(18$', N'1122#10#20(18$', '1122#10#20(18$', N'1122#10#20(18$'),
('1122#10#20*18', N'1122#10#20*18', '1122#10#20*18', N'1122#10#20*18' ),
('          11-28 10', N'          11-28 10', '          11-28 10', N'          11-28 10'),
('          11/28 10:40', N'          11/28 10:40', '          11/28 10:40', N'          11/28 10:40'),
('    02-11-28 10', N'    02-11-28 10', '    02-11-28 10', N'    02-11-28 10'),
('    02-11-28 10:  ', N'    02-11-28 10:  ', '    02-11-28 10:  ', N'    02-11-28 10:  '),
('    02-11-28 10:48:  ', N'    02-11-28 10:48:  ', '    02-11-28 10:48:  ', N'    02-11-28 10:48:  '),
('2009-10-12 10:48:1432784293487239487.32 pm', N'2009-10-12 10:48:1432784293487239487.32 pm', '2009-10-12 10:48:1432784293487239487.32 pm', N'2009-10-12 10:48:1432784293487239487.32 pm'),
('2009-10-12 10:4847329084723948233487:14.32 pm', N'2009-10-12 10:4847329084723948233487:14.32 pm', '2009-10-12 10:4847329084723948233487:14.32 pm', N'2009-10-12 10:4847329084723948233487:14.32 pm'),
('2009-10-12 10109847329842379847:48:14.32 pm', N'2009-10-12 10109847329842379847:48:14.32 pm', '2009-10-12 10109847329842379847:48:14.32 pm', N'2009-10-12 10109847329842379847:48:14.32 pm'),
('2009-10-12109847329842379847 10:48:14.32 pm', N'2009-10-12109847329842379847 10:48:14.32 pm', '2009-10-12109847329842379847 10:48:14.32 pm', N'2009-10-12109847329842379847 10:48:14.32 pm' ),
('2009-1000000-12 10:48:14.32 pm', N'2009-1000000-12 10:48:14.32 pm', '2009-1000000-12 10:48:14.32 pm', N'2009-1000000-12 10:48:14.32 pm' ),
('2009102817324842379847-10-12 10:48:14.32 pm', N'2009102817324842379847-10-12 10:48:14.32 pm', '2009102817324842379847-10-12 10:48:14.32 pm', N'2009102817324842379847-10-12 10:48:14.32 pm'),
('  2009-10-12 22:44:02asdfads', N'  2009-10-12 22:44:02asdfads', '  2009-10-12 22:44:02asdfads', N'  2009-10-12 22:44:02asdfads'),
('        2010&&8&&30& &22&&44%%02*şlkj', N'        2010&&8&&30& &22&&44%%02*şlkj', '        2010&&8&&30& &22&&44%%02*şlkj', N'        2010&&8&&30& &22&&44%%02*şlkj'),
(' 8/30_ _22&@@@@@44^@@@@@@@@@02$', N' 8/30_ _22&@@@@@44^@@@@@@@@@02$', ' 8/30_ _22&@@@@@44^@@@@@@@@@02$', N' 8/30_ _22&@@@@@44^@@@@@@@@@02$'),
('  8&&30_ _22&&44&&02$$$$$$$', N'  8&&30_ _22&&44&&02$$$$$$$', '  8&&30_ _22&&44&&02$$$$$$$', N'  8&&30_ _22&&44&&02$$$$$$$'),
(' 8/20 12:10:22.90432543xxxxxxx', N' 8/20 12:10:22.90432543xxxxxxx', ' 8/20 12:10:22.90432543xxxxxxx', N' 8/20 12:10:22.90432543xxxxxxx'),
(' 2018-10-12 22:4XX', N' 2018-10-12 22:4XX', ' 2018-10-12 22:4XX', N' 2018-10-12 22:4XX'),
('         2018-10-12 22|s', N'         2018-10-12 22|s', '         2018-10-12 22|s', N'         2018-10-12 22|s'),
('10:22:48.3ASDFADSF', N'10:22:48.3ASDFADSF', '10:22:48.3ASDFADSF', N'10:22:48.3ASDFADSF'),
('10:22:48.3 PM##', N'10:22:48.3 PM##', '10:22:48.3 PM##', N'10:22:48.3 PM##'),
('10:22#48.3 PM##', N'10:22#48.3 PM##', '10:22#48.3 PM##', N'10:22#48.3 PM##' ),
('       10:22:48.3ASDFADSF', N'       10:22:48.3ASDFADSF', '       10:22:48.3ASDFADSF', N'       10:22:48.3ASDFADSF' ),
('    10:22:48.3 PM##', N'    10:22:48.3 PM##', '    10:22:48.3 PM##', N'    10:22:48.3 PM##'),
('         10:22#48.3 PM##', N'         10:22#48.3 PM##', '         10:22#48.3 PM##', N'         10:22#48.3 PM##'),
('10x22x44.23', N'10x22x44.23', '10x22x44.23', N'10x22x44.23');

SELECT CAST(TimeText AS TIME), CAST(TimeNText AS TIME), CAST(TimeFText AS TIME), CAST(TimeFNText AS TIME) FROM StrTime ORDER BY TextID;

UPDATE
	StrTime
SET
	TimeVal = CAST(TimeText AS TIME),
	TimeNVal = CAST(TimeNText AS TIME),
	TimeFVal = CAST(TimeFText AS TIME),
	TimeFNVal = CAST(TimeFNText AS TIME),
	InsertTimeVal = TimeText,
	InsertTimeNVal = TimeNText,
	InsertTimeFVal = TimeFText,
	InsertTimeFNVal = TimeFNText;
	
SELECT
	*
FROM
	StrTime
WHERE
	CAST(TimeText AS TIME) != TimeVal OR TimeVal != TimeNVal OR TimeVal != TimeFVal OR TimeVal != TimeFNVal
	OR TimeVal != InsertTimeVal OR TimeVal != InsertTimeNVal OR TimeVal != InsertTimeFVal OR TimeVal != InsertTimeFNVal;

DROP TABLE StrTime;
