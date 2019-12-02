--this case was added for cubridsus-1502

CREATE CLASS that03;
CREATE CLASS that07;
CREATE CLASS that08;
ALTER CLASS that03 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       uewdh_test character(4) NOT NULL,
       bwk_that character(1) NOT NULL,
       qz_that character(1) NOT NULL,
       uewdh character varying(2) NOT NULL,
       aq_that integer NOT NULL,
       fv_that character varying(17) NOT NULL,
       aolq_that character(4) NOT NULL,
       e_u_that integer NOT NULL,
       e_v_that character(1) NOT NULL,
       e_a_that character(1) NOT NULL,
       e_o_that character(1) NOT NULL,
       iao_fswu_that character(1),
       sy_a_that numeric(5,2),
       vwuwv_that character(1) NOT NULL,
       opdwth_that character varying(20) NOT NULL,
       uzs_that character(1),
       uq_that character(2),
       aqk_v_that character(1),
       i_n_that character(1) DEFAULT 'N',
       njmfiev_that integer NOT NULL,
       a_wthat numeric(4,1),
       a_dthat numeric(4,1),
       a_wthat_m numeric(4,1),
       a_dthat_m numeric(4,1),
       a_wthat_w numeric(4,1),
       a_dthat_w numeric(4,1),
       tw_that character varying(2),
       opdwth_dt timestamp NOT NULL;

ALTER CLASS that03 ADD ATTRIBUTE
       CONSTRAINT "that03_pk" UNIQUE(uewdh_test, bwk_that, qz_that, uewdh, aq_that, fv_that, aolq_that, e_u_that, njmfiev_that);

ALTER CLASS that07 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       uewdh_test character(4) NOT NULL,
       bwk_that character(1) NOT NULL,
       qz_that character(1) NOT NULL,
       uzs_that character(2) NOT NULL,
       uewdh character varying(2) NOT NULL,
       aq_that integer NOT NULL,
       fv_that character varying(17) NOT NULL,
       aolq_that character(4) NOT NULL,
       i_n_that character(1) NOT NULL,
       aqk_fswu_that character(1) NOT NULL,
       aqk_v_that character(1),
       vwuwv_that character(1),
       opdwth_that character varying(20) NOT NULL,
       e_v_that character(1),
       e_a_that character(1),
       iao_fswu_that character(1),
       sy_a_that numeric(5,2),
       uq_that character(2),
       njmfiev_that integer NOT NULL,
       a_wthat numeric(4,1),
       a_dthat numeric(4,1),
       a_wthat_m numeric(4,1),
       a_dthat_m numeric(4,1),
       a_wthat_w numeric(4,1),
       a_dthat_w numeric(4,1),
       bkw_that character(4) NOT NULL,
       opdwth_dt timestamp NOT NULL;

ALTER CLASS that07 ADD ATTRIBUTE
       CONSTRAINT "that07_pk" UNIQUE(uewdh_test, bwk_that, qz_that, uzs_that, uewdh, bkw_that, aq_that, fv_that, aolq_that, njmfiev_that);

ALTER CLASS that08 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       uewdh_test character(4) NOT NULL,
       bwk_that character(1) NOT NULL,
       qz_that character(1) NOT NULL,
       uzs_that character(2) NOT NULL,
       uewdh character varying(2) NOT NULL,
       aq_that integer NOT NULL,
       fv_that character varying(17) NOT NULL,
       aolq_that character(4) NOT NULL,
       i_n_that character(1) NOT NULL,
       aqk_fswu_that character(1) NOT NULL,
       aqk_v_that character(1),
       vwuwv_that character(1),
       opdwth_that character varying(20) NOT NULL,
       e_v_that character(1),
       e_a_that character(1),
       iao_fswu_that character(1),
       sy_a_that numeric(5,2),
       uq_that character(2),
       njmfiev_that integer NOT NULL,
       a_wthat numeric(4,1),
       a_dthat numeric(4,1),
       a_wthat_m numeric(4,1),
       a_dthat_m numeric(4,1),
       a_wthat_w numeric(4,1),
       a_dthat_w numeric(4,1),
       opdwth_dt timestamp NOT NULL;

ALTER CLASS that08 ADD ATTRIBUTE
       CONSTRAINT "that08_pk" UNIQUE(uewdh_test, bwk_that, qz_that, uzs_that, uewdh, aq_that, fv_that, aolq_that, njmfiev_that);
       
SELECT *
FROM (
	SELECT uzs_that, bkw_that
	FROM that07
	WHERE 1 = (
			SELECT CASE 
					WHEN e_o_that = '3' THEN 1
					ELSE 0
				END
			FROM that03
			WHERE uewdh_test = '2009'
				AND bwk_that = '1'
				AND qz_that = '1'
				AND uewdh = '1'
				AND aq_that = 3
				AND fv_that = '007010101'
				AND aolq_that = '0008'
		)
		AND (uewdh_test, bwk_that, qz_that, uewdh, aq_that, fv_that, aolq_that, njmfiev_that) IN (
			SELECT uewdh_test, bwk_that, qz_that, uewdh, aq_that
				, fv_that, aolq_that, njmfiev_that
			FROM that03
			WHERE uewdh_test = '2009'
				AND bwk_that = '1'
				AND qz_that = '1'
				AND uewdh = '1'
				AND aq_that = 3
				AND fv_that = '007010101'
				AND aolq_that = '0008'
				AND njmfiev_that = 2
		)
		AND vwuwv_that = 'N'
	UNION ALL
	SELECT uzs_that, bkw_that
	FROM that07
	WHERE (uewdh_test, bwk_that, qz_that, uzs_that, uewdh, aq_that, fv_that, aolq_that, njmfiev_that) IN (
		SELECT uewdh_test, bwk_that, qz_that, uzs_that, uewdh
			, aq_that, fv_that, aolq_that, njmfiev_that
		FROM that08
		WHERE 1 = (
				SELECT CASE 
						WHEN e_o_that = '2' THEN 1
						ELSE 0
					END
				FROM that03
				WHERE uewdh_test = '2009'
					AND bwk_that = '1'
					AND qz_that = '1'
					AND uewdh = '1'
					AND aq_that = 3
					AND fv_that = '007010101'
					AND aolq_that = '0008'
			)
			AND (uewdh_test, bwk_that, qz_that, uewdh, aq_that, fv_that, aolq_that, njmfiev_that) IN (
				SELECT uewdh_test, bwk_that, qz_that, uewdh, aq_that
					, fv_that, aolq_that, njmfiev_that
				FROM that03
				WHERE uewdh_test = '2009'
					AND bwk_that = '1'
					AND qz_that = '1'
					AND uewdh = '1'
					AND aq_that = 3
					AND fv_that = '007010101'
					AND aolq_that = '0008'
					AND njmfiev_that = 2
			)
			AND vwuwv_that = 'N'
			AND uzs_that = '06'
	)
) a
WHERE bkw_that <> '0685'
	AND uzs_that = '06';

SELECT uzs_that
FROM that07
WHERE (uewdh_test, bwk_that, uzs_that) IN (
		SELECT uewdh_test, bwk_that, uzs_that
		FROM that08
	)
	AND uzs_that = '06';

SELECT x.uzs_that
FROM that07 x, (
		SELECT DISTINCT uewdh_test, bwk_that, uzs_that
		FROM that08
	) y
WHERE (x.uewdh_test, x.bwk_that, x.uzs_that) = (y.uewdh_test, y.bwk_that, y.uzs_that)
	AND x.uzs_that = '06';

SELECT *
FROM (
	SELECT uzs_that, bkw_that
	FROM that07
	WHERE 1 = (
			SELECT CASE 
					WHEN e_o_that = '3' THEN 1
					ELSE 0
				END
			FROM that03
			WHERE uewdh_test = '2009'
				AND bwk_that = '1'
				AND qz_that = '1'
				AND uewdh = '1'
				AND aq_that = 3
				AND fv_that = '007010101'
				AND aolq_that = '0008'
		)
		AND uewdh_test IN (
			SELECT uewdh_test
			FROM that03
			WHERE uewdh_test = '2009'
				AND bwk_that = '1'
				AND qz_that = '1'
				AND uewdh = '1'
				AND aq_that = 3
				AND fv_that = '007010101'
				AND aolq_that = '0008'
				AND njmfiev_that = 2
		)
		AND vwuwv_that = 'N'
	UNION ALL
	SELECT uzs_that, bkw_that
	FROM that07
	WHERE uewdh_test IN (
		SELECT uewdh_test
		FROM that08
		WHERE 1 = (
				SELECT CASE 
						WHEN e_o_that = '2' THEN 1
						ELSE 0
					END
				FROM that03
				WHERE uewdh_test = '2009'
					AND bwk_that = '1'
					AND qz_that = '1'
					AND uewdh = '1'
					AND aq_that = 3
					AND fv_that = '007010101'
					AND aolq_that = '0008'
			)
			AND uewdh_test IN (
				SELECT uewdh_test
				FROM that03
				WHERE uewdh_test = '2009'
					AND bwk_that = '1'
					AND qz_that = '1'
					AND uewdh = '1'
					AND aq_that = 3
					AND fv_that = '007010101'
					AND aolq_that = '0008'
					AND njmfiev_that = 2
			)
			AND vwuwv_that = 'N'
			AND uzs_that = '06'
	)
) a
WHERE bkw_that <> '0685'
	AND uzs_that = '06';

SELECT uzs_that
FROM that07
WHERE uewdh_test IN (
		SELECT uewdh_test
		FROM that08
	)
	AND uzs_that = '06';
                 
SELECT x.uzs_that
FROM that07 x, (
		SELECT DISTINCT uewdh_test, bwk_that, uzs_that
		FROM that08
	) y
WHERE (x.uewdh_test, x.bwk_that, x.uzs_that) = (y.uewdh_test, y.bwk_that, y.uzs_that)
	AND x.uzs_that = '06';

drop CLASS that03;
drop CLASS that07;
drop CLASS that08;
                                                              
