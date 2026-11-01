BEGIN TRANSACTION;
CREATE TABLE gmp_observations (
	id INTEGER NOT NULL, 
	ipo_id INTEGER NOT NULL, 
	source VARCHAR(64) NOT NULL, 
	observed_at DATETIME NOT NULL, 
	premium NUMERIC(12, 2) NOT NULL, 
	source_url VARCHAR(500), 
	collected_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_gmp_observation UNIQUE (ipo_id, source, observed_at), 
	FOREIGN KEY(ipo_id) REFERENCES ipos (id)
);
INSERT INTO "gmp_observations" VALUES(1,2,'iporise','2026-08-10 08:56:00.000000',0,'https://www.iporise.com/ipo/lalithaa-jewellery-mart-ipo/gmp','2026-08-10 17:43:57.650354');
INSERT INTO "gmp_observations" VALUES(2,3,'iporise','2026-08-10 09:56:00.000000',0,'https://www.iporise.com/ipo/credent-connect-n-care-ipo/gmp','2026-08-10 17:43:57.651441');
INSERT INTO "gmp_observations" VALUES(3,4,'iporise','2026-08-10 07:24:00.000000',15,'https://www.iporise.com/ipo/qt-foods-ipo/gmp','2026-08-10 17:43:57.652287');
INSERT INTO "gmp_observations" VALUES(4,4,'iporise','2026-08-10 06:54:00.000000',6,'https://www.iporise.com/ipo/qt-foods-ipo/gmp','2026-08-10 17:43:57.652560');
INSERT INTO "gmp_observations" VALUES(5,4,'iporise','2026-08-10 06:24:00.000000',15,'https://www.iporise.com/ipo/qt-foods-ipo/gmp','2026-08-10 17:43:57.652843');
INSERT INTO "gmp_observations" VALUES(6,4,'iporise','2026-08-09 18:32:00.000000',6,'https://www.iporise.com/ipo/qt-foods-ipo/gmp','2026-08-10 17:43:57.653125');
INSERT INTO "gmp_observations" VALUES(7,4,'iporise','2026-08-09 09:35:00.000000',6,'https://www.iporise.com/ipo/qt-foods-ipo/gmp','2026-08-10 17:43:57.653356');
INSERT INTO "gmp_observations" VALUES(8,5,'iporise','2026-08-10 09:26:00.000000',53,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.654159');
INSERT INTO "gmp_observations" VALUES(9,5,'iporise','2026-08-10 07:24:00.000000',43,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.654412');
INSERT INTO "gmp_observations" VALUES(10,5,'iporise','2026-08-10 03:58:00.000000',25,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.654661');
INSERT INTO "gmp_observations" VALUES(11,5,'iporise','2026-08-09 09:36:00.000000',25,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.654911');
INSERT INTO "gmp_observations" VALUES(12,5,'iporise','2026-08-08 06:19:00.000000',30,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.655159');
INSERT INTO "gmp_observations" VALUES(13,5,'iporise','2026-08-07 12:10:00.000000',25,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.655407');
INSERT INTO "gmp_observations" VALUES(14,5,'iporise','2026-08-07 10:39:00.000000',30,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.655656');
INSERT INTO "gmp_observations" VALUES(15,5,'iporise','2026-08-07 09:08:00.000000',25,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.655901');
INSERT INTO "gmp_observations" VALUES(16,5,'iporise','2026-08-07 08:37:00.000000',0,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.656148');
INSERT INTO "gmp_observations" VALUES(17,5,'iporise','2026-08-07 07:37:00.000000',15,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.656404');
INSERT INTO "gmp_observations" VALUES(18,5,'iporise','2026-08-07 05:57:00.000000',10,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.656659');
INSERT INTO "gmp_observations" VALUES(19,5,'iporise','2026-08-07 03:23:00.000000',0,'https://www.iporise.com/ipo/behari-lal-engineering-ipo/gmp','2026-08-10 17:43:57.656884');
INSERT INTO "gmp_observations" VALUES(20,6,'iporise','2026-08-10 12:01:00.000000',26,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.657546');
INSERT INTO "gmp_observations" VALUES(21,6,'iporise','2026-08-10 09:26:00.000000',26.5,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.657799');
INSERT INTO "gmp_observations" VALUES(22,6,'iporise','2026-08-10 07:24:00.000000',26,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.658045');
INSERT INTO "gmp_observations" VALUES(23,6,'iporise','2026-08-10 06:54:00.000000',22,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.658290');
INSERT INTO "gmp_observations" VALUES(24,6,'iporise','2026-08-10 06:23:00.000000',23.5,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.658532');
INSERT INTO "gmp_observations" VALUES(25,6,'iporise','2026-08-10 03:58:00.000000',22,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.658772');
INSERT INTO "gmp_observations" VALUES(26,6,'iporise','2026-08-09 14:09:00.000000',21,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.659026');
INSERT INTO "gmp_observations" VALUES(27,6,'iporise','2026-08-09 09:36:00.000000',20,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.659275');
INSERT INTO "gmp_observations" VALUES(28,6,'iporise','2026-08-08 06:19:00.000000',14,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.659522');
INSERT INTO "gmp_observations" VALUES(29,6,'iporise','2026-08-07 09:08:00.000000',15,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.659768');
INSERT INTO "gmp_observations" VALUES(30,6,'iporise','2026-08-07 08:37:00.000000',16,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.660012');
INSERT INTO "gmp_observations" VALUES(31,6,'iporise','2026-08-07 07:37:00.000000',15,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.660254');
INSERT INTO "gmp_observations" VALUES(32,6,'iporise','2026-08-07 05:57:00.000000',20,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.660498');
INSERT INTO "gmp_observations" VALUES(33,6,'iporise','2026-08-07 03:23:00.000000',16,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.660748');
INSERT INTO "gmp_observations" VALUES(34,6,'iporise','2026-08-06 04:09:00.000000',0,'https://www.iporise.com/ipo/shiprocket-ipo/gmp','2026-08-10 17:43:57.661015');
INSERT INTO "gmp_observations" VALUES(35,7,'iporise','2026-08-09 18:32:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.661809');
INSERT INTO "gmp_observations" VALUES(36,7,'iporise','2026-08-09 09:36:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.662056');
INSERT INTO "gmp_observations" VALUES(37,7,'iporise','2026-08-08 06:20:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.662306');
INSERT INTO "gmp_observations" VALUES(38,7,'iporise','2026-08-07 03:27:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.662555');
INSERT INTO "gmp_observations" VALUES(39,7,'iporise','2026-08-06 04:10:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.662798');
INSERT INTO "gmp_observations" VALUES(40,7,'iporise','2026-08-05 05:57:00.000000',0,'https://www.iporise.com/ipo/pramodini-medicare-ipo/gmp','2026-08-10 17:43:57.663030');
INSERT INTO "gmp_observations" VALUES(41,8,'iporise','2026-08-09 18:32:00.000000',0,'https://www.iporise.com/ipo/fascinate-textiles-ipo/gmp','2026-08-10 17:43:57.663812');
INSERT INTO "gmp_observations" VALUES(42,8,'iporise','2026-08-09 09:37:00.000000',0,'https://www.iporise.com/ipo/fascinate-textiles-ipo/gmp','2026-08-10 17:43:57.664065');
INSERT INTO "gmp_observations" VALUES(43,8,'iporise','2026-08-08 06:20:00.000000',0,'https://www.iporise.com/ipo/fascinate-textiles-ipo/gmp','2026-08-10 17:43:57.664312');
INSERT INTO "gmp_observations" VALUES(44,8,'iporise','2026-08-07 03:27:00.000000',0,'https://www.iporise.com/ipo/fascinate-textiles-ipo/gmp','2026-08-10 17:43:57.664529');
INSERT INTO "gmp_observations" VALUES(45,9,'iporise','2026-08-10 09:26:00.000000',25,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.665306');
INSERT INTO "gmp_observations" VALUES(46,9,'iporise','2026-08-10 07:24:00.000000',26.5,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.665553');
INSERT INTO "gmp_observations" VALUES(47,9,'iporise','2026-08-10 06:54:00.000000',26,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.665800');
INSERT INTO "gmp_observations" VALUES(48,9,'iporise','2026-08-10 06:23:00.000000',26.5,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.666046');
INSERT INTO "gmp_observations" VALUES(49,9,'iporise','2026-08-10 03:58:00.000000',26,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.666291');
INSERT INTO "gmp_observations" VALUES(50,9,'iporise','2026-08-09 14:09:00.000000',25,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.666530');
INSERT INTO "gmp_observations" VALUES(51,9,'iporise','2026-08-09 09:37:00.000000',27,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.666772');
INSERT INTO "gmp_observations" VALUES(52,9,'iporise','2026-08-08 09:44:00.000000',23,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.667014');
INSERT INTO "gmp_observations" VALUES(53,9,'iporise','2026-08-08 06:19:00.000000',24,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.667255');
INSERT INTO "gmp_observations" VALUES(54,9,'iporise','2026-08-07 12:10:00.000000',23,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.667499');
INSERT INTO "gmp_observations" VALUES(55,9,'iporise','2026-08-07 10:39:00.000000',24,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.667743');
INSERT INTO "gmp_observations" VALUES(56,9,'iporise','2026-08-07 09:08:00.000000',23,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.667985');
INSERT INTO "gmp_observations" VALUES(57,9,'iporise','2026-08-07 08:37:00.000000',25,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.668226');
INSERT INTO "gmp_observations" VALUES(58,9,'iporise','2026-08-07 07:37:00.000000',20,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.668469');
INSERT INTO "gmp_observations" VALUES(59,9,'iporise','2026-08-07 07:06:00.000000',21,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.668710');
INSERT INTO "gmp_observations" VALUES(60,9,'iporise','2026-08-07 05:57:00.000000',27,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.668953');
INSERT INTO "gmp_observations" VALUES(61,9,'iporise','2026-08-07 03:23:00.000000',25,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.669194');
INSERT INTO "gmp_observations" VALUES(62,9,'iporise','2026-08-06 13:03:00.000000',35,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.669447');
INSERT INTO "gmp_observations" VALUES(63,9,'iporise','2026-08-06 12:33:00.000000',36,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.669689');
INSERT INTO "gmp_observations" VALUES(64,9,'iporise','2026-08-06 12:03:00.000000',26,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.669934');
INSERT INTO "gmp_observations" VALUES(65,9,'iporise','2026-08-06 04:09:00.000000',0,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.670179');
INSERT INTO "gmp_observations" VALUES(66,9,'iporise','2026-08-05 05:57:00.000000',0,'https://www.iporise.com/ipo/milky-mist-dairy-food-ipo/gmp','2026-08-10 17:43:57.670402');
INSERT INTO "gmp_observations" VALUES(67,10,'iporise','2026-08-09 18:32:00.000000',0,'https://www.iporise.com/ipo/sham-foam-ipo/gmp','2026-08-10 17:43:57.671287');
INSERT INTO "gmp_observations" VALUES(68,10,'iporise','2026-08-09 09:37:00.000000',0,'https://www.iporise.com/ipo/sham-foam-ipo/gmp','2026-08-10 17:43:57.671531');
INSERT INTO "gmp_observations" VALUES(69,10,'iporise','2026-08-08 06:20:00.000000',0,'https://www.iporise.com/ipo/sham-foam-ipo/gmp','2026-08-10 17:43:57.671777');
INSERT INTO "gmp_observations" VALUES(70,10,'iporise','2026-08-07 06:36:00.000000',0,'https://www.iporise.com/ipo/sham-foam-ipo/gmp','2026-08-10 17:43:57.672012');
INSERT INTO "gmp_observations" VALUES(71,11,'iporise','2026-08-10 10:27:00.000000',138,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.672806');
INSERT INTO "gmp_observations" VALUES(72,11,'iporise','2026-08-10 09:26:00.000000',125,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.673048');
INSERT INTO "gmp_observations" VALUES(73,11,'iporise','2026-08-10 07:24:00.000000',120,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.673293');
INSERT INTO "gmp_observations" VALUES(74,11,'iporise','2026-08-10 06:54:00.000000',132,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.673548');
INSERT INTO "gmp_observations" VALUES(75,11,'iporise','2026-08-10 06:23:00.000000',120,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.673797');
INSERT INTO "gmp_observations" VALUES(76,11,'iporise','2026-08-10 03:58:00.000000',132,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.674047');
INSERT INTO "gmp_observations" VALUES(77,11,'iporise','2026-08-09 14:10:00.000000',122,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.674292');
INSERT INTO "gmp_observations" VALUES(78,11,'iporise','2026-08-09 09:38:00.000000',130,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.674539');
INSERT INTO "gmp_observations" VALUES(79,11,'iporise','2026-08-08 06:19:00.000000',130,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.674788');
INSERT INTO "gmp_observations" VALUES(80,11,'iporise','2026-08-07 12:10:00.000000',175,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.675033');
INSERT INTO "gmp_observations" VALUES(81,11,'iporise','2026-08-07 11:09:00.000000',180,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.675281');
INSERT INTO "gmp_observations" VALUES(82,11,'iporise','2026-08-07 10:08:00.000000',125,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.675526');
INSERT INTO "gmp_observations" VALUES(83,11,'iporise','2026-08-07 09:08:00.000000',175,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.675772');
INSERT INTO "gmp_observations" VALUES(84,11,'iporise','2026-08-07 03:23:00.000000',205,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.676020');
INSERT INTO "gmp_observations" VALUES(85,11,'iporise','2026-08-06 12:33:00.000000',220,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.676265');
INSERT INTO "gmp_observations" VALUES(86,11,'iporise','2026-08-06 10:01:00.000000',210,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.676507');
INSERT INTO "gmp_observations" VALUES(87,11,'iporise','2026-08-06 06:59:00.000000',200,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.676750');
INSERT INTO "gmp_observations" VALUES(88,11,'iporise','2026-08-06 06:29:00.000000',195,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.677002');
INSERT INTO "gmp_observations" VALUES(89,11,'iporise','2026-08-06 04:09:00.000000',170,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.677246');
INSERT INTO "gmp_observations" VALUES(90,11,'iporise','2026-08-05 14:04:00.000000',80,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.677489');
INSERT INTO "gmp_observations" VALUES(91,11,'iporise','2026-08-05 03:42:00.000000',0,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.677730');
INSERT INTO "gmp_observations" VALUES(92,11,'iporise','2026-08-04 06:50:00.000000',0,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/gmp','2026-08-10 17:43:57.677951');
INSERT INTO "gmp_observations" VALUES(93,12,'iporise','2026-08-10 12:34:00.000000',267,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.679228');
INSERT INTO "gmp_observations" VALUES(94,12,'iporise','2026-08-10 09:26:00.000000',270,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.679563');
INSERT INTO "gmp_observations" VALUES(95,12,'iporise','2026-08-10 08:25:00.000000',264,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.679842');
INSERT INTO "gmp_observations" VALUES(96,12,'iporise','2026-08-10 07:55:00.000000',261,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.680107');
INSERT INTO "gmp_observations" VALUES(97,12,'iporise','2026-08-10 06:54:00.000000',259,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.680389');
INSERT INTO "gmp_observations" VALUES(98,12,'iporise','2026-08-10 06:23:00.000000',257,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.680653');
INSERT INTO "gmp_observations" VALUES(99,12,'iporise','2026-08-10 03:58:00.000000',259,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.680906');
INSERT INTO "gmp_observations" VALUES(100,12,'iporise','2026-08-09 09:38:00.000000',259,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.681155');
INSERT INTO "gmp_observations" VALUES(101,12,'iporise','2026-08-08 09:44:00.000000',250,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.681410');
INSERT INTO "gmp_observations" VALUES(102,12,'iporise','2026-08-08 06:19:00.000000',247,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.681657');
INSERT INTO "gmp_observations" VALUES(103,12,'iporise','2026-08-07 09:08:00.000000',250,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.681905');
INSERT INTO "gmp_observations" VALUES(104,12,'iporise','2026-08-07 08:37:00.000000',255,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.682152');
INSERT INTO "gmp_observations" VALUES(105,12,'iporise','2026-08-07 06:36:00.000000',250,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.682393');
INSERT INTO "gmp_observations" VALUES(106,12,'iporise','2026-08-07 05:57:00.000000',254,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.682635');
INSERT INTO "gmp_observations" VALUES(107,12,'iporise','2026-08-07 03:23:00.000000',255,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.682881');
INSERT INTO "gmp_observations" VALUES(108,12,'iporise','2026-08-06 12:03:00.000000',255,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.683124');
INSERT INTO "gmp_observations" VALUES(109,12,'iporise','2026-08-06 08:30:00.000000',258,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.683374');
INSERT INTO "gmp_observations" VALUES(110,12,'iporise','2026-08-06 07:29:00.000000',254,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.683619');
INSERT INTO "gmp_observations" VALUES(111,12,'iporise','2026-08-06 06:59:00.000000',248,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.683860');
INSERT INTO "gmp_observations" VALUES(112,12,'iporise','2026-08-06 06:29:00.000000',240,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.684101');
INSERT INTO "gmp_observations" VALUES(113,12,'iporise','2026-08-06 04:09:00.000000',253,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.684340');
INSERT INTO "gmp_observations" VALUES(114,12,'iporise','2026-08-05 07:59:00.000000',255,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.684595');
INSERT INTO "gmp_observations" VALUES(115,12,'iporise','2026-08-05 03:42:00.000000',253,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.684844');
INSERT INTO "gmp_observations" VALUES(116,12,'iporise','2026-08-04 14:53:00.000000',247,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.685094');
INSERT INTO "gmp_observations" VALUES(117,12,'iporise','2026-08-04 11:29:00.000000',246,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.685346');
INSERT INTO "gmp_observations" VALUES(118,12,'iporise','2026-08-04 10:54:00.000000',238,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.685600');
INSERT INTO "gmp_observations" VALUES(119,12,'iporise','2026-08-04 09:21:00.000000',243,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.685853');
INSERT INTO "gmp_observations" VALUES(120,12,'iporise','2026-08-04 08:21:00.000000',236,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.686107');
INSERT INTO "gmp_observations" VALUES(121,12,'iporise','2026-08-04 07:50:00.000000',250,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.686361');
INSERT INTO "gmp_observations" VALUES(122,12,'iporise','2026-08-04 07:20:00.000000',240,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.686616');
INSERT INTO "gmp_observations" VALUES(123,12,'iporise','2026-08-04 06:50:00.000000',220,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.686869');
INSERT INTO "gmp_observations" VALUES(124,12,'iporise','2026-08-04 06:18:00.000000',200,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.687115');
INSERT INTO "gmp_observations" VALUES(125,12,'iporise','2026-08-04 05:24:00.000000',168,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.687377');
INSERT INTO "gmp_observations" VALUES(126,12,'iporise','2026-08-04 04:54:00.000000',196,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.687628');
INSERT INTO "gmp_observations" VALUES(127,12,'iporise','2026-08-04 04:23:00.000000',168,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.687870');
INSERT INTO "gmp_observations" VALUES(128,12,'iporise','2026-08-04 03:44:00.000000',150,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.688111');
INSERT INTO "gmp_observations" VALUES(129,12,'iporise','2026-08-03 11:46:00.000000',0,'https://www.iporise.com/ipo/dhoot-transmission-ipo/gmp','2026-08-10 17:43:57.688349');
INSERT INTO "gmp_observations" VALUES(130,13,'iporise','2026-08-10 10:27:00.000000',12,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.689740');
INSERT INTO "gmp_observations" VALUES(131,13,'iporise','2026-08-10 09:56:00.000000',13,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.690032');
INSERT INTO "gmp_observations" VALUES(132,13,'iporise','2026-08-10 09:26:00.000000',11.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.690320');
INSERT INTO "gmp_observations" VALUES(133,13,'iporise','2026-08-10 08:56:00.000000',11,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.690579');
INSERT INTO "gmp_observations" VALUES(134,13,'iporise','2026-08-10 08:25:00.000000',10.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.690832');
INSERT INTO "gmp_observations" VALUES(135,13,'iporise','2026-08-10 07:55:00.000000',12.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.691097');
INSERT INTO "gmp_observations" VALUES(136,13,'iporise','2026-08-10 07:24:00.000000',14,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.691348');
INSERT INTO "gmp_observations" VALUES(137,13,'iporise','2026-08-10 06:54:00.000000',16,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.691596');
INSERT INTO "gmp_observations" VALUES(138,13,'iporise','2026-08-10 06:23:00.000000',15.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.691844');
INSERT INTO "gmp_observations" VALUES(139,13,'iporise','2026-08-10 03:58:00.000000',16,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.692091');
INSERT INTO "gmp_observations" VALUES(140,13,'iporise','2026-08-09 09:38:00.000000',16,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.692332');
INSERT INTO "gmp_observations" VALUES(141,13,'iporise','2026-08-08 06:19:00.000000',15,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.692575');
INSERT INTO "gmp_observations" VALUES(142,13,'iporise','2026-08-07 12:10:00.000000',13,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.692821');
INSERT INTO "gmp_observations" VALUES(143,13,'iporise','2026-08-07 10:08:00.000000',14.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.693064');
INSERT INTO "gmp_observations" VALUES(144,13,'iporise','2026-08-07 09:38:00.000000',13,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.693309');
INSERT INTO "gmp_observations" VALUES(145,13,'iporise','2026-08-07 09:08:00.000000',14,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.693561');
INSERT INTO "gmp_observations" VALUES(146,13,'iporise','2026-08-07 08:37:00.000000',19.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.693809');
INSERT INTO "gmp_observations" VALUES(147,13,'iporise','2026-08-07 08:07:00.000000',12.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.694057');
INSERT INTO "gmp_observations" VALUES(148,13,'iporise','2026-08-07 07:37:00.000000',11,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.694304');
INSERT INTO "gmp_observations" VALUES(149,13,'iporise','2026-08-07 07:06:00.000000',13.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.694547');
INSERT INTO "gmp_observations" VALUES(150,13,'iporise','2026-08-07 06:36:00.000000',16,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.694793');
INSERT INTO "gmp_observations" VALUES(151,13,'iporise','2026-08-07 05:57:00.000000',17,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.695038');
INSERT INTO "gmp_observations" VALUES(152,13,'iporise','2026-08-07 03:23:00.000000',19.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.695285');
INSERT INTO "gmp_observations" VALUES(153,13,'iporise','2026-08-06 12:03:00.000000',12,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.695528');
INSERT INTO "gmp_observations" VALUES(154,13,'iporise','2026-08-06 11:32:00.000000',11,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.695780');
INSERT INTO "gmp_observations" VALUES(155,13,'iporise','2026-08-06 10:01:00.000000',10,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.696024');
INSERT INTO "gmp_observations" VALUES(156,13,'iporise','2026-08-06 09:01:00.000000',9,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.696270');
INSERT INTO "gmp_observations" VALUES(157,13,'iporise','2026-08-06 08:30:00.000000',7.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.696518');
INSERT INTO "gmp_observations" VALUES(158,13,'iporise','2026-08-06 08:00:00.000000',6.5,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.696836');
INSERT INTO "gmp_observations" VALUES(159,13,'iporise','2026-08-06 07:29:00.000000',6,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.697101');
INSERT INTO "gmp_observations" VALUES(160,13,'iporise','2026-08-06 04:11:00.000000',3,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.697358');
INSERT INTO "gmp_observations" VALUES(161,13,'iporise','2026-08-05 03:42:00.000000',3,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.697606');
INSERT INTO "gmp_observations" VALUES(162,13,'iporise','2026-08-04 09:21:00.000000',3,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.697851');
INSERT INTO "gmp_observations" VALUES(163,13,'iporise','2026-08-04 03:44:00.000000',4,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.698101');
INSERT INTO "gmp_observations" VALUES(164,13,'iporise','2026-08-03 11:16:00.000000',4,'https://www.iporise.com/ipo/leap-india-ipo/gmp','2026-08-10 17:43:57.698333');
INSERT INTO "gmp_observations" VALUES(165,14,'iporise','2026-08-09 18:32:00.000000',5,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.699278');
INSERT INTO "gmp_observations" VALUES(166,14,'iporise','2026-08-09 09:39:00.000000',5,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.699532');
INSERT INTO "gmp_observations" VALUES(167,14,'iporise','2026-08-08 09:44:00.000000',5,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.699780');
INSERT INTO "gmp_observations" VALUES(168,14,'iporise','2026-08-08 06:20:00.000000',0,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.700029');
INSERT INTO "gmp_observations" VALUES(169,14,'iporise','2026-08-07 03:27:00.000000',5,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.700279');
INSERT INTO "gmp_observations" VALUES(170,14,'iporise','2026-08-06 08:30:00.000000',5,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.700526');
INSERT INTO "gmp_observations" VALUES(171,14,'iporise','2026-08-06 04:10:00.000000',0,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.700767');
INSERT INTO "gmp_observations" VALUES(172,14,'iporise','2026-08-05 03:42:00.000000',0,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.701027');
INSERT INTO "gmp_observations" VALUES(173,14,'iporise','2026-08-04 03:45:00.000000',0,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.701321');
INSERT INTO "gmp_observations" VALUES(174,14,'iporise','2026-08-03 11:16:00.000000',0,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/gmp','2026-08-10 17:43:57.701580');
INSERT INTO "gmp_observations" VALUES(175,15,'iporise','2026-08-10 09:56:00.000000',27.5,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.702494');
INSERT INTO "gmp_observations" VALUES(176,15,'iporise','2026-08-10 08:25:00.000000',26,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.702741');
INSERT INTO "gmp_observations" VALUES(177,15,'iporise','2026-08-10 07:24:00.000000',25,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.702987');
INSERT INTO "gmp_observations" VALUES(178,15,'iporise','2026-08-10 06:54:00.000000',23,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.703233');
INSERT INTO "gmp_observations" VALUES(179,15,'iporise','2026-08-10 06:23:00.000000',24,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.703479');
INSERT INTO "gmp_observations" VALUES(180,15,'iporise','2026-08-10 03:58:00.000000',23,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.703734');
INSERT INTO "gmp_observations" VALUES(181,15,'iporise','2026-08-09 14:10:00.000000',22,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.703980');
INSERT INTO "gmp_observations" VALUES(182,15,'iporise','2026-08-09 09:38:00.000000',21.5,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.704226');
INSERT INTO "gmp_observations" VALUES(183,15,'iporise','2026-08-08 09:44:00.000000',19,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.704469');
INSERT INTO "gmp_observations" VALUES(184,15,'iporise','2026-08-08 06:19:00.000000',15,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.704707');
INSERT INTO "gmp_observations" VALUES(185,15,'iporise','2026-08-07 12:10:00.000000',17,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.704952');
INSERT INTO "gmp_observations" VALUES(186,15,'iporise','2026-08-07 10:39:00.000000',18,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.705196');
INSERT INTO "gmp_observations" VALUES(187,15,'iporise','2026-08-07 09:08:00.000000',17,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.705442');
INSERT INTO "gmp_observations" VALUES(188,15,'iporise','2026-08-07 08:37:00.000000',15,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.705686');
INSERT INTO "gmp_observations" VALUES(189,15,'iporise','2026-08-07 03:23:00.000000',16,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.705929');
INSERT INTO "gmp_observations" VALUES(190,15,'iporise','2026-08-06 12:33:00.000000',17,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.706172');
INSERT INTO "gmp_observations" VALUES(191,15,'iporise','2026-08-06 10:01:00.000000',15,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.706424');
INSERT INTO "gmp_observations" VALUES(192,15,'iporise','2026-08-06 09:01:00.000000',14,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.706674');
INSERT INTO "gmp_observations" VALUES(193,15,'iporise','2026-08-06 04:11:00.000000',13,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.706920');
INSERT INTO "gmp_observations" VALUES(194,15,'iporise','2026-08-05 11:02:00.000000',12,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.707169');
INSERT INTO "gmp_observations" VALUES(195,15,'iporise','2026-08-05 03:42:00.000000',10,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.707426');
INSERT INTO "gmp_observations" VALUES(196,15,'iporise','2026-08-04 03:44:00.000000',10,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.707668');
INSERT INTO "gmp_observations" VALUES(197,15,'iporise','2026-08-03 15:07:00.000000',13,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.707911');
INSERT INTO "gmp_observations" VALUES(198,15,'iporise','2026-08-03 13:55:00.000000',10,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.708151');
INSERT INTO "gmp_observations" VALUES(199,15,'iporise','2026-08-03 11:16:00.000000',16,'https://www.iporise.com/ipo/technocraft-ventures-ipo/gmp','2026-08-10 17:43:57.708378');
INSERT INTO "gmp_observations" VALUES(200,16,'iporise','2026-08-10 07:25:00.000000',39,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.709229');
INSERT INTO "gmp_observations" VALUES(201,16,'iporise','2026-08-09 18:32:00.000000',37,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.709477');
INSERT INTO "gmp_observations" VALUES(202,16,'iporise','2026-08-09 09:39:00.000000',35,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.709733');
INSERT INTO "gmp_observations" VALUES(203,16,'iporise','2026-08-08 06:20:00.000000',35,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.709973');
INSERT INTO "gmp_observations" VALUES(204,16,'iporise','2026-08-07 03:27:00.000000',32,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.710218');
INSERT INTO "gmp_observations" VALUES(205,16,'iporise','2026-08-06 04:10:00.000000',30,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.710462');
INSERT INTO "gmp_observations" VALUES(206,16,'iporise','2026-08-05 07:59:00.000000',26,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.710705');
INSERT INTO "gmp_observations" VALUES(207,16,'iporise','2026-08-05 03:42:00.000000',27,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.710953');
INSERT INTO "gmp_observations" VALUES(208,16,'iporise','2026-08-04 03:45:00.000000',27,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.711203');
INSERT INTO "gmp_observations" VALUES(209,16,'iporise','2026-08-03 15:08:00.000000',27,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.711450');
INSERT INTO "gmp_observations" VALUES(210,16,'iporise','2026-08-03 13:55:00.000000',32,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.711697');
INSERT INTO "gmp_observations" VALUES(211,16,'iporise','2026-08-03 11:16:00.000000',25,'https://www.iporise.com/ipo/lapl-automotive-ipo/gmp','2026-08-10 17:43:57.711924');
INSERT INTO "gmp_observations" VALUES(212,17,'iporise','2026-08-10 10:27:00.000000',15,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.712785');
INSERT INTO "gmp_observations" VALUES(213,17,'iporise','2026-08-10 07:24:00.000000',15.5,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.713033');
INSERT INTO "gmp_observations" VALUES(214,17,'iporise','2026-08-10 06:54:00.000000',16,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.713283');
INSERT INTO "gmp_observations" VALUES(215,17,'iporise','2026-08-10 06:23:00.000000',15.5,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.713536');
INSERT INTO "gmp_observations" VALUES(216,17,'iporise','2026-08-10 03:58:00.000000',16,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.713776');
INSERT INTO "gmp_observations" VALUES(217,17,'iporise','2026-08-09 09:39:00.000000',16,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.714021');
INSERT INTO "gmp_observations" VALUES(218,17,'iporise','2026-08-08 06:19:00.000000',15,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.714268');
INSERT INTO "gmp_observations" VALUES(219,17,'iporise','2026-08-07 12:10:00.000000',13,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.714512');
INSERT INTO "gmp_observations" VALUES(220,17,'iporise','2026-08-07 11:09:00.000000',15,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.714757');
INSERT INTO "gmp_observations" VALUES(221,17,'iporise','2026-08-07 09:38:00.000000',13,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.714999');
INSERT INTO "gmp_observations" VALUES(222,17,'iporise','2026-08-07 08:37:00.000000',14,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.715238');
INSERT INTO "gmp_observations" VALUES(223,17,'iporise','2026-08-07 08:07:00.000000',10,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.715481');
INSERT INTO "gmp_observations" VALUES(224,17,'iporise','2026-08-07 06:36:00.000000',9,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.715722');
INSERT INTO "gmp_observations" VALUES(225,17,'iporise','2026-08-07 05:57:00.000000',12,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.715963');
INSERT INTO "gmp_observations" VALUES(226,17,'iporise','2026-08-07 03:23:00.000000',14,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.716205');
INSERT INTO "gmp_observations" VALUES(227,17,'iporise','2026-08-06 11:32:00.000000',15.5,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.716449');
INSERT INTO "gmp_observations" VALUES(228,17,'iporise','2026-08-06 10:01:00.000000',15,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.716689');
INSERT INTO "gmp_observations" VALUES(229,17,'iporise','2026-08-06 06:29:00.000000',14,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.716934');
INSERT INTO "gmp_observations" VALUES(230,17,'iporise','2026-08-06 04:11:00.000000',15.25,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.717182');
INSERT INTO "gmp_observations" VALUES(231,17,'iporise','2026-08-05 11:32:00.000000',14,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.717433');
INSERT INTO "gmp_observations" VALUES(232,17,'iporise','2026-08-05 08:30:00.000000',15,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.717680');
INSERT INTO "gmp_observations" VALUES(233,17,'iporise','2026-08-05 07:59:00.000000',14,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.717919');
INSERT INTO "gmp_observations" VALUES(234,17,'iporise','2026-08-05 07:29:00.000000',12.2,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.718161');
INSERT INTO "gmp_observations" VALUES(235,17,'iporise','2026-08-05 06:28:00.000000',9,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.718404');
INSERT INTO "gmp_observations" VALUES(236,17,'iporise','2026-08-05 03:42:00.000000',8,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.718643');
INSERT INTO "gmp_observations" VALUES(237,17,'iporise','2026-08-04 14:53:00.000000',8,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.718887');
INSERT INTO "gmp_observations" VALUES(238,17,'iporise','2026-08-04 03:44:00.000000',7.5,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.719137');
INSERT INTO "gmp_observations" VALUES(239,17,'iporise','2026-08-03 11:16:00.000000',6.75,'https://www.iporise.com/ipo/ardee-industries-ipo/gmp','2026-08-10 17:43:57.719356');
INSERT INTO "gmp_observations" VALUES(240,18,'iporise','2026-08-09 18:32:00.000000',12,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.720206');
INSERT INTO "gmp_observations" VALUES(241,18,'iporise','2026-08-09 14:10:00.000000',12,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.720479');
INSERT INTO "gmp_observations" VALUES(242,18,'iporise','2026-08-08 06:20:00.000000',12,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.720723');
INSERT INTO "gmp_observations" VALUES(243,18,'iporise','2026-08-07 03:27:00.000000',12,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.720980');
INSERT INTO "gmp_observations" VALUES(244,18,'iporise','2026-08-06 10:32:00.000000',12,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.721242');
INSERT INTO "gmp_observations" VALUES(245,18,'iporise','2026-08-06 04:10:00.000000',0,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.721487');
INSERT INTO "gmp_observations" VALUES(246,18,'iporise','2026-08-05 03:42:00.000000',0,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.721752');
INSERT INTO "gmp_observations" VALUES(247,18,'iporise','2026-08-04 03:45:00.000000',0,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.721995');
INSERT INTO "gmp_observations" VALUES(248,18,'iporise','2026-08-03 10:45:00.000000',0,'https://www.iporise.com/ipo/aegeus-technologies-ipo/gmp','2026-08-10 17:43:57.722222');
INSERT INTO "gmp_observations" VALUES(249,19,'iporise','2026-08-09 18:33:00.000000',58,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.723066');
INSERT INTO "gmp_observations" VALUES(250,19,'iporise','2026-08-09 14:10:00.000000',55,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.723327');
INSERT INTO "gmp_observations" VALUES(251,19,'iporise','2026-08-08 06:20:00.000000',64,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.723572');
INSERT INTO "gmp_observations" VALUES(252,19,'iporise','2026-08-07 12:10:00.000000',60,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.723823');
INSERT INTO "gmp_observations" VALUES(253,19,'iporise','2026-08-07 10:08:00.000000',64,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.724079');
INSERT INTO "gmp_observations" VALUES(254,19,'iporise','2026-08-07 09:08:00.000000',60,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.724325');
INSERT INTO "gmp_observations" VALUES(255,19,'iporise','2026-08-07 08:37:00.000000',70,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.724568');
INSERT INTO "gmp_observations" VALUES(256,19,'iporise','2026-08-07 05:57:00.000000',67,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.724809');
INSERT INTO "gmp_observations" VALUES(257,19,'iporise','2026-08-07 03:27:00.000000',66,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.725054');
INSERT INTO "gmp_observations" VALUES(258,19,'iporise','2026-08-06 04:10:00.000000',78,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.725302');
INSERT INTO "gmp_observations" VALUES(259,19,'iporise','2026-08-05 03:42:00.000000',80,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.725542');
INSERT INTO "gmp_observations" VALUES(260,19,'iporise','2026-08-04 03:45:00.000000',80,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.725781');
INSERT INTO "gmp_observations" VALUES(261,19,'iporise','2026-08-03 06:10:00.000000',80,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.726026');
INSERT INTO "gmp_observations" VALUES(262,19,'iporise','2026-08-03 05:08:00.000000',90,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.726271');
INSERT INTO "gmp_observations" VALUES(263,19,'iporise','2026-08-01 19:03:00.000000',90,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/gmp','2026-08-10 17:43:57.726491');
INSERT INTO "gmp_observations" VALUES(264,20,'iporise','2026-08-06 04:10:00.000000',0,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.727337');
INSERT INTO "gmp_observations" VALUES(265,20,'iporise','2026-08-05 03:42:00.000000',0,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.727586');
INSERT INTO "gmp_observations" VALUES(266,20,'iporise','2026-08-04 03:45:00.000000',0,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.727830');
INSERT INTO "gmp_observations" VALUES(267,20,'iporise','2026-08-03 05:09:00.000000',0,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.728071');
INSERT INTO "gmp_observations" VALUES(268,20,'iporise','2026-08-01 19:03:00.000000',4,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.728313');
INSERT INTO "gmp_observations" VALUES(269,20,'iporise','2026-08-01 06:26:00.000000',4,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.728560');
INSERT INTO "gmp_observations" VALUES(270,20,'iporise','2026-07-31 07:56:00.000000',7,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.728801');
INSERT INTO "gmp_observations" VALUES(271,20,'iporise','2026-07-31 04:22:00.000000',9,'https://www.iporise.com/ipo/fusion-klassroom-edutech-ipo/gmp','2026-08-10 17:43:57.729031');
INSERT INTO "gmp_observations" VALUES(272,11,'ipogram','2026-08-10 03:06:00.000000',132,'https://ipogram.in/ipo-gmp/molbio-diagnostics/','2026-08-10 17:43:57.729761');
INSERT INTO "gmp_observations" VALUES(273,12,'ipogram','2026-08-09 18:03:00.000000',259,'https://ipogram.in/ipo-gmp/dhoot-transmission/','2026-08-10 17:43:57.730259');
INSERT INTO "gmp_observations" VALUES(274,13,'ipogram','2026-08-10 17:11:00.000000',38,'https://ipogram.in/ipo-gmp/leap-india/','2026-08-10 17:43:57.730742');
INSERT INTO "gmp_observations" VALUES(275,14,'ipogram','2026-08-10 12:39:00.000000',5,'https://ipogram.in/ipo-gmp/optimystix-entertainment/','2026-08-10 17:43:57.731575');
INSERT INTO "gmp_observations" VALUES(276,15,'ipogram','2026-08-10 02:41:00.000000',23,'https://ipogram.in/ipo-gmp/technocraft-ventures/','2026-08-10 17:43:57.732072');
INSERT INTO "gmp_observations" VALUES(277,16,'ipogram','2026-08-10 01:35:00.000000',17,'https://ipogram.in/lapl-automotive-ipo-gmp-grey-market-premium/','2026-08-10 17:43:57.732679');
INSERT INTO "gmp_observations" VALUES(278,17,'ipogram','2026-08-09 17:55:00.000000',16,'https://ipogram.in/ipo-gmp/ardee-industries/','2026-08-10 17:43:57.733164');
INSERT INTO "gmp_observations" VALUES(279,18,'ipogram','2026-08-09 17:56:00.000000',12,'https://ipogram.in/ipo-gmp/aegeus-technologies/','2026-08-10 17:43:57.733650');
INSERT INTO "gmp_observations" VALUES(280,21,'ipogram','2026-08-10 12:31:00.000000',26,'https://ipogram.in/ipo-gmp/g-v-electricals/','2026-08-10 17:43:57.734489');
INSERT INTO "gmp_observations" VALUES(281,15,'ipocracker','2026-08-10 16:24:00.000000',27,'https://ipocracker.com/ipo-gmp/technocraft-ventures','2026-08-10 17:43:57.745911');
INSERT INTO "gmp_observations" VALUES(282,14,'ipocracker','2026-08-06 08:23:00.000000',5,'https://ipocracker.com/ipo-gmp/optimystix-entertainment','2026-08-10 17:43:57.746660');
INSERT INTO "gmp_observations" VALUES(283,13,'ipocracker','2026-08-10 14:56:00.000000',13,'https://ipocracker.com/ipo-gmp/leap-india','2026-08-10 17:43:57.747288');
INSERT INTO "gmp_observations" VALUES(284,11,'ipocracker','2026-08-10 16:24:00.000000',135,'https://ipocracker.com/ipo-gmp/molbio-diagnostics','2026-08-10 17:43:57.747785');
INSERT INTO "gmp_observations" VALUES(285,12,'ipocracker','2026-08-10 16:24:00.000000',255,'https://ipocracker.com/ipo-gmp/dhoot-transmission','2026-08-10 17:43:57.748278');
INSERT INTO "gmp_observations" VALUES(286,9,'ipocracker','2026-08-10 15:54:00.000000',20,'https://ipocracker.com/ipo-gmp/milky-mist','2026-08-10 17:43:57.749471');
INSERT INTO "gmp_observations" VALUES(287,5,'ipocracker','2026-08-10 09:29:00.000000',53,'https://ipocracker.com/ipo-gmp/behari-lal-engineering','2026-08-10 17:43:57.749949');
INSERT INTO "gmp_observations" VALUES(288,4,'ipocracker','2026-08-10 05:28:00.000000',15,'https://ipocracker.com/ipo-gmp/qt-foods','2026-08-10 17:43:57.750431');
INSERT INTO "gmp_observations" VALUES(289,6,'ipocracker','2026-08-10 13:56:00.000000',27,'https://ipocracker.com/ipo-gmp/shiprocket','2026-08-10 17:43:57.751149');
INSERT INTO "gmp_observations" VALUES(290,31,'ipocracker','2026-06-19 11:08:00.000000',0,'https://ipocracker.com/ipo-gmp/dhanwel-hybrid-seeds','2026-08-10 17:43:57.752334');
INSERT INTO "gmp_observations" VALUES(291,16,'ipocracker','2026-08-10 07:28:00.000000',39,'https://ipocracker.com/ipo-gmp/lapl-automotive','2026-08-10 17:43:57.752957');
INSERT INTO "gmp_observations" VALUES(292,17,'ipocracker','2026-08-10 10:35:00.000000',15,'https://ipocracker.com/ipo-gmp/ardee-industries','2026-08-10 17:43:57.753483');
INSERT INTO "gmp_observations" VALUES(293,21,'ipocracker','2026-08-10 16:24:00.000000',25,'https://ipocracker.com/ipo-gmp/gv-electricals','2026-08-10 17:43:57.753991');
INSERT INTO "gmp_observations" VALUES(294,18,'ipocracker','2026-08-06 10:34:00.000000',12,'https://ipocracker.com/ipo-gmp/aegeus-technologies','2026-08-10 17:43:57.754522');
CREATE TABLE ipos (
	id INTEGER NOT NULL, 
	slug VARCHAR(180) NOT NULL, 
	name VARCHAR(240) NOT NULL, 
	segment VARCHAR(32) NOT NULL, 
	status VARCHAR(32) NOT NULL, 
	price_lower NUMERIC(12, 2), 
	price_upper NUMERIC(12, 2), 
	lot_size INTEGER, 
	open_date DATE, 
	close_date DATE, 
	listing_date DATE, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL, 
	PRIMARY KEY (id)
);
INSERT INTO "ipos" VALUES(1,'shankesh-jewellers','Shankesh Jewellers','mainboard','upcoming',NULL,NULL,NULL,'2026-08-18','2026-08-20','2026-08-25','2026-08-10 17:43:57.647427','2026-08-10 18:04:02.669377');
INSERT INTO "ipos" VALUES(2,'lalithaa-jewellery-mart','Lalithaa Jewellery Mart','mainboard','upcoming',NULL,NULL,NULL,'2026-08-17','2026-08-19','2026-08-24','2026-08-10 17:43:57.649096','2026-08-10 18:04:02.671067');
INSERT INTO "ipos" VALUES(3,'credent-connect-n-care','Credent Connect N Care','sme','upcoming',179,189,NULL,'2026-08-13','2026-08-17','2026-08-20','2026-08-10 17:43:57.650903','2026-08-10 18:04:02.734087');
INSERT INTO "ipos" VALUES(4,'q-and-t-foods','Q&T Foods','sme','upcoming',115,115,NULL,'2026-08-12','2026-08-14','2026-08-19','2026-08-10 17:43:57.651794','2026-08-10 18:04:02.733172');
INSERT INTO "ipos" VALUES(5,'behari-lal-engineering','Behari Lal Engineering','mainboard','upcoming',271,285,NULL,'2026-08-12','2026-08-14','2026-08-19','2026-08-10 17:43:57.653685','2026-08-10 18:04:02.732816');
INSERT INTO "ipos" VALUES(6,'shiprocket','Shiprocket','mainboard','upcoming',92,97,NULL,'2026-08-12','2026-08-14','2026-08-19','2026-08-10 17:43:57.657100','2026-08-10 18:04:02.733744');
INSERT INTO "ipos" VALUES(7,'pramodini-medicare','Pramodini Medicare','sme','upcoming',110,118,NULL,'2026-08-12','2026-08-14','2026-08-19','2026-08-10 17:43:57.661350','2026-08-10 18:04:02.733517');
INSERT INTO "ipos" VALUES(8,'fascinate-textiles','Fascinate Textiles','sme','upcoming',148,156,NULL,'2026-08-11','2026-08-13','2026-08-18','2026-08-10 17:43:57.663371','2026-08-10 18:04:02.731716');
INSERT INTO "ipos" VALUES(9,'milky-mist-dairy-food','Milky Mist','mainboard','upcoming',133,140,NULL,'2026-08-11','2026-08-13','2026-08-18','2026-08-10 17:43:57.664867','2026-08-10 18:04:02.732451');
INSERT INTO "ipos" VALUES(10,'sham-foam','Sham Foam','sme','upcoming',130,130,NULL,'2026-08-11','2026-08-13','2026-08-18','2026-08-10 17:43:57.670831','2026-08-10 18:04:02.731956');
INSERT INTO "ipos" VALUES(11,'molbio-diagnostics','Molbio Diagnostics','mainboard','open',768,807,NULL,'2026-08-10','2026-08-12','2026-08-17','2026-08-10 17:43:57.672361','2026-08-10 18:04:02.731010');
INSERT INTO "ipos" VALUES(12,'dhoot-transmission','Dhoot Transmission','mainboard','open',829,871,NULL,'2026-08-10','2026-08-12','2026-08-17','2026-08-10 17:43:57.678329','2026-08-10 18:04:02.731367');
INSERT INTO "ipos" VALUES(13,'leap-india','LEAP India','mainboard','open',151,159,NULL,'2026-08-07','2026-08-11','2026-08-14','2026-08-10 17:43:57.689079','2026-08-10 18:04:02.730650');
INSERT INTO "ipos" VALUES(14,'optimystix-entertainment-india','Optimystix Entertainment','sme','open',166,175,NULL,'2026-08-07','2026-08-11','2026-08-14','2026-08-10 17:43:57.698783','2026-08-10 18:04:02.730283');
INSERT INTO "ipos" VALUES(15,'technocraft-ventures','Technocraft Ventures','mainboard','open',200,212,NULL,'2026-08-07','2026-08-11','2026-08-14','2026-08-10 17:43:57.702002','2026-08-10 18:04:02.729630');
INSERT INTO "ipos" VALUES(16,'lapl-automotive','LAPL Automotive','sme','closed',88,94,NULL,'2026-08-06','2026-08-10','2026-08-13','2026-08-10 17:43:57.708772','2026-08-10 18:04:02.734664');
INSERT INTO "ipos" VALUES(17,'ardee-industries','Ardee Industries','mainboard','closed',50,53,NULL,'2026-08-05','2026-08-07','2026-08-12','2026-08-10 17:43:57.712337','2026-08-10 18:04:02.735207');
INSERT INTO "ipos" VALUES(18,'aegeus-technologies','Aegeus Technologies','sme','closed',100,105,NULL,'2026-08-04','2026-08-06','2026-08-11','2026-08-10 17:43:57.719751','2026-08-10 18:04:02.735903');
INSERT INTO "ipos" VALUES(19,'anawil-wire-and-engineering','Anawil Wire & Engineering','sme','listed',270,270,NULL,'2026-08-03','2026-08-05','2026-08-10','2026-08-10 17:43:57.722622','2026-08-10 18:04:02.705119');
INSERT INTO "ipos" VALUES(20,'fusion-klassroom-edutech','Fusion Klassroom Edutech','sme','listed',159,159,NULL,'2026-07-31','2026-08-04','2026-08-07','2026-08-10 17:43:57.726894','2026-08-10 17:43:57.726962');
INSERT INTO "ipos" VALUES(21,'g-v-electricals','G.V. Electricals','sme','closed',123,130,NULL,'2026-07-31','2026-08-07','2026-08-12','2026-08-10 17:43:57.734061','2026-08-10 18:04:02.735558');
INSERT INTO "ipos" VALUES(22,'oneindig-technologies','Oneindig Technologies','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.739131','2026-08-10 17:43:57.739132');
INSERT INTO "ipos" VALUES(23,'dhaval-packaging','Dhaval Packaging','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.739889','2026-08-10 17:43:57.739889');
INSERT INTO "ipos" VALUES(24,'juniper-green-energy','Juniper Green Energy','mainboard','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.740607','2026-08-10 17:43:57.740607');
INSERT INTO "ipos" VALUES(25,'mv-electrosystems','MV Electrosystems','mainboard','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.741326','2026-08-10 17:43:57.741327');
INSERT INTO "ipos" VALUES(26,'h-r-hygiene-products','H.R. Hygiene Products','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.742039','2026-08-10 17:43:57.742040');
INSERT INTO "ipos" VALUES(27,'manipal-health','Manipal Health','mainboard','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.742763','2026-08-10 17:43:57.742764');
INSERT INTO "ipos" VALUES(28,'poojaa-precision','Poojaa Precision','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.743491','2026-08-10 17:43:57.743492');
INSERT INTO "ipos" VALUES(29,'propshop-events','Propshop Events','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.744232','2026-08-10 17:43:57.744232');
INSERT INTO "ipos" VALUES(30,'advance-technoforge','Advance Technoforge','sme','listed',NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.744977','2026-08-10 17:43:57.744978');
INSERT INTO "ipos" VALUES(31,'dhanwel-hybrid-seeds','Dhanwel Hybrid Seeds','sme','upcoming',95,99,NULL,NULL,NULL,NULL,'2026-08-10 17:43:57.751906','2026-08-10 18:04:02.734316');
INSERT INTO "ipos" VALUES(32,'skytech-infinite-platform','Skytech Infinite Platform','sme','upcoming',NULL,NULL,NULL,'2026-08-14','2026-08-18','2026-08-21','2026-08-10 18:04:02.673296','2026-08-10 18:04:02.673543');
CREATE TABLE market_observations (
	id INTEGER NOT NULL, 
	index_name VARCHAR(32) NOT NULL, 
	source VARCHAR(64) NOT NULL, 
	observed_at DATETIME NOT NULL, 
	value NUMERIC(14, 2) NOT NULL, 
	percent_change NUMERIC(8, 3), 
	source_url VARCHAR(500), 
	collected_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_market_observation UNIQUE (index_name, source, observed_at)
);
INSERT INTO "market_observations" VALUES(1,'NIFTY 50','yahoo-finance','2026-07-28 03:45:00.000000',23985.35,NULL,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.755323');
INSERT INTO "market_observations" VALUES(2,'NIFTY 50','yahoo-finance','2026-07-29 03:45:00.000000',24250.2,1.1042156983325238,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.755716');
INSERT INTO "market_observations" VALUES(3,'NIFTY 50','yahoo-finance','2026-07-30 03:45:00.000000',24317.15,0.27608019727672351,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.755958');
INSERT INTO "market_observations" VALUES(4,'NIFTY 50','yahoo-finance','2026-07-31 03:45:00.000000',24383.6,0.27326393101165225,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.756193');
INSERT INTO "market_observations" VALUES(5,'NIFTY 50','yahoo-finance','2026-08-03 03:45:00.000000',24774.3,1.6023064682819601,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.756424');
INSERT INTO "market_observations" VALUES(6,'NIFTY 50','yahoo-finance','2026-08-04 03:45:00.000000',24614.9,-0.6434086936866027,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.756664');
INSERT INTO "market_observations" VALUES(7,'NIFTY 50','yahoo-finance','2026-08-05 03:45:00.000000',24624.65,0.039610154824923118,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.756890');
INSERT INTO "market_observations" VALUES(8,'NIFTY 50','yahoo-finance','2026-08-06 03:45:00.000000',24636,0.046092025673461351,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.757122');
INSERT INTO "market_observations" VALUES(9,'NIFTY 50','yahoo-finance','2026-08-07 03:45:00.000000',24570.65,-0.26526221789251503,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.757348');
INSERT INTO "market_observations" VALUES(10,'NIFTY 50','yahoo-finance','2026-08-10 03:45:00.000000',24583.8,0.053519137670350603,'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=10d&interval=1d','2026-08-10 17:43:57.757579');
INSERT INTO "market_observations" VALUES(11,'SENSEX','yahoo-finance','2026-07-28 03:45:00.000000',76765.92,NULL,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.757805');
INSERT INTO "market_observations" VALUES(12,'SENSEX','yahoo-finance','2026-07-29 03:45:00.000000',77654.6,1.1576491234652044,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.758030');
INSERT INTO "market_observations" VALUES(13,'SENSEX','yahoo-finance','2026-07-30 03:45:00.000000',77928.15,0.35226503001753923,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.758255');
INSERT INTO "market_observations" VALUES(14,'SENSEX','yahoo-finance','2026-07-31 03:45:00.000000',78094.64,0.21364551833965004,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.758479');
INSERT INTO "market_observations" VALUES(15,'SENSEX','yahoo-finance','2026-08-03 03:45:00.000000',78639.03,0.69709009478755524,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.758706');
INSERT INTO "market_observations" VALUES(16,'SENSEX','yahoo-finance','2026-08-04 03:45:00.000000',78428.95,-0.26714469901269128,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.758933');
INSERT INTO "market_observations" VALUES(17,'SENSEX','yahoo-finance','2026-08-05 03:45:00.000000',78581,0.19386973815153716,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.759165');
INSERT INTO "market_observations" VALUES(18,'SENSEX','yahoo-finance','2026-08-06 03:45:00.000000',78954.76,0.47563660426820731,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.759392');
INSERT INTO "market_observations" VALUES(19,'SENSEX','yahoo-finance','2026-08-07 03:45:00.000000',78499.17,-0.5770266415856371,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.759616');
INSERT INTO "market_observations" VALUES(20,'SENSEX','yahoo-finance','2026-08-10 03:45:00.000000',78542.44,0.055121601922670009,'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN?range=10d&interval=1d','2026-08-10 17:43:57.759805');
CREATE TABLE subscription_observations (
	id INTEGER NOT NULL, 
	ipo_id INTEGER NOT NULL, 
	source VARCHAR(64) NOT NULL, 
	observed_at DATETIME NOT NULL, 
	qib NUMERIC(12, 2), 
	nii NUMERIC(12, 2), 
	retail NUMERIC(12, 2), 
	total NUMERIC(12, 2), 
	source_url VARCHAR(500), 
	collected_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_subscription_observation UNIQUE (ipo_id, source, observed_at), 
	FOREIGN KEY(ipo_id) REFERENCES ipos (id)
);
INSERT INTO "subscription_observations" VALUES(1,13,'ipogram','2026-08-10 17:43:57.145597',200.23,433.26,387.78,344.31,'https://ipogram.in/ipo-subscription/leap-india/','2026-08-10 17:43:57.735687');
INSERT INTO "subscription_observations" VALUES(2,14,'ipogram','2026-08-10 17:43:57.145597',1.02,0.21,0.88,0.77,'https://ipogram.in/ipo-subscription/optimystix-entertainment/','2026-08-10 17:43:57.736565');
INSERT INTO "subscription_observations" VALUES(3,15,'ipogram','2026-08-10 17:43:57.145597',4.47,3.8,1.01,2.59,'https://ipogram.in/ipo-subscription/technocraft-ventures/','2026-08-10 17:43:57.737030');
INSERT INTO "subscription_observations" VALUES(4,19,'ipogram','2026-08-10 17:43:57.145597',7.09,2.81,4.34,4.8,'https://ipogram.in/ipo-subscription/anawil-wire/','2026-08-10 17:43:57.737675');
INSERT INTO "subscription_observations" VALUES(5,21,'ipogram','2026-08-10 17:43:57.145597',3.52,29.99,29.33,31.21,'https://ipogram.in/ipo-subscription/g-v-electricals/','2026-08-10 17:43:57.738124');
INSERT INTO "subscription_observations" VALUES(6,20,'ipogram','2026-08-10 17:43:57.145597',0.68,0.55,0.32,0.97,'https://ipogram.in/ipo-subscription/fusion-klassroom-edutech/','2026-08-10 17:43:57.738569');
INSERT INTO "subscription_observations" VALUES(7,22,'ipogram','2026-08-10 17:43:57.145597',1.05,2.4,1.84,1.73,'https://ipogram.in/ipo-subscription/oneindig-technologies/','2026-08-10 17:43:57.739446');
INSERT INTO "subscription_observations" VALUES(8,23,'ipogram','2026-08-10 17:43:57.145597',56.38,75.35,40.36,49.99,'https://ipogram.in/ipo-subscription/dhaval-packaging/','2026-08-10 17:43:57.740182');
INSERT INTO "subscription_observations" VALUES(9,24,'ipogram','2026-08-10 17:43:57.145597',26.22,1.92,0.98,8.38,'https://ipogram.in/ipo-subscription/juniper-green-energy/','2026-08-10 17:43:57.740887');
INSERT INTO "subscription_observations" VALUES(10,25,'ipogram','2026-08-10 17:43:57.145597',96.13,397.99,218.25,200.66,'https://ipogram.in/ipo-subscription/mv-electrosystems/','2026-08-10 17:43:57.741608');
INSERT INTO "subscription_observations" VALUES(11,26,'ipogram','2026-08-10 17:43:57.145597',2.81,11.83,6.74,6.65,'https://ipogram.in/ipo-subscription/h-r-hygiene-products/','2026-08-10 17:43:57.742319');
INSERT INTO "subscription_observations" VALUES(12,27,'ipogram','2026-08-10 17:43:57.145597',8.54,1.06,0.98,5.12,'https://ipogram.in/manipal-health-ipo-subscription-status/','2026-08-10 17:43:57.743048');
INSERT INTO "subscription_observations" VALUES(13,28,'ipogram','2026-08-10 17:43:57.145597',206.46,463.43,247.58,278.83,'https://ipogram.in/poojaa-precision-ipo-subscription-status/','2026-08-10 17:43:57.743784');
INSERT INTO "subscription_observations" VALUES(14,29,'ipogram','2026-08-10 17:43:57.145597',1.37,1.38,1.77,1.53,'https://ipogram.in/propshop-events-ipo-subscription-status/','2026-08-10 17:43:57.744526');
INSERT INTO "subscription_observations" VALUES(15,30,'ipogram','2026-08-10 17:43:57.145597',0,0.43,2.68,1.55,'https://ipogram.in/advance-technoforge-ipo-subscription-status/','2026-08-10 17:43:57.745273');
INSERT INTO "subscription_observations" VALUES(16,11,'iporise','2026-08-10 12:30:00.000000',1,0.73,0.77,0.83,'https://www.iporise.com/ipo/molbio-diagnostics-ipo/subscription','2026-08-10 18:04:02.708304');
INSERT INTO "subscription_observations" VALUES(17,12,'iporise','2026-08-10 12:30:00.000000',0.06,1.02,0.76,0.62,'https://www.iporise.com/ipo/dhoot-transmission-ipo/subscription','2026-08-10 18:04:02.709236');
INSERT INTO "subscription_observations" VALUES(18,13,'iporise','2026-08-07 12:30:00.000000',0.64,0.12,0.14,0.28,'https://www.iporise.com/ipo/leap-india-ipo/subscription','2026-08-10 18:04:02.709782');
INSERT INTO "subscription_observations" VALUES(19,13,'iporise','2026-08-10 12:30:00.000000',0.64,0.53,0.43,0.52,'https://www.iporise.com/ipo/leap-india-ipo/subscription','2026-08-10 18:04:02.710266');
INSERT INTO "subscription_observations" VALUES(20,14,'iporise','2026-08-07 12:30:00.000000',1.02,0.77,0.55,0.67,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/subscription','2026-08-10 18:04:02.710734');
INSERT INTO "subscription_observations" VALUES(21,14,'iporise','2026-08-10 12:30:00.000000',1.02,0.21,0.87,0.77,'https://www.iporise.com/ipo/optimystix-entertainment-india-ipo/subscription','2026-08-10 18:04:02.711375');
INSERT INTO "subscription_observations" VALUES(22,15,'iporise','2026-08-07 12:30:00.000000',4.47,3.8,1.01,2.59,'https://www.iporise.com/ipo/technocraft-ventures-ipo/subscription','2026-08-10 18:04:02.712088');
INSERT INTO "subscription_observations" VALUES(23,15,'iporise','2026-08-10 12:30:00.000000',4.5,6.48,4.13,4.74,'https://www.iporise.com/ipo/technocraft-ventures-ipo/subscription','2026-08-10 18:04:02.712633');
INSERT INTO "subscription_observations" VALUES(24,17,'iporise','2026-08-05 12:30:00.000000',1.13,5.57,3.39,3.21,'https://www.iporise.com/ipo/ardee-industries-ipo/subscription','2026-08-10 18:04:02.713122');
INSERT INTO "subscription_observations" VALUES(25,17,'iporise','2026-08-06 12:30:00.000000',1.33,31.93,14.99,14.72,'https://www.iporise.com/ipo/ardee-industries-ipo/subscription','2026-08-10 18:04:02.713595');
INSERT INTO "subscription_observations" VALUES(26,17,'iporise','2026-08-07 12:30:00.000000',202.26,266.75,47.77,138.83,'https://www.iporise.com/ipo/ardee-industries-ipo/subscription','2026-08-10 18:04:02.714100');
INSERT INTO "subscription_observations" VALUES(27,19,'iporise','2026-08-03 12:30:00.000000',7.09,2.81,4.34,4.64,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/subscription','2026-08-10 18:04:02.714568');
INSERT INTO "subscription_observations" VALUES(28,19,'iporise','2026-08-04 12:30:00.000000',8.91,9.52,13.25,11.89,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/subscription','2026-08-10 18:04:02.715025');
INSERT INTO "subscription_observations" VALUES(29,19,'iporise','2026-08-05 12:30:00.000000',164.56,233.36,104.22,134.16,'https://www.iporise.com/ipo/anawil-wire-engineering-ipo/subscription','2026-08-10 18:04:02.715475');
INSERT INTO "subscription_observations" VALUES(30,16,'iporise','2026-08-06 12:30:00.000000',NULL,4.21,7.12,4.46,'https://www.iporise.com/ipo/lapl-automotive-ipo/subscription','2026-08-10 18:04:02.715933');
INSERT INTO "subscription_observations" VALUES(31,16,'iporise','2026-08-07 12:30:00.000000',3.56,30.78,47.53,31.41,'https://www.iporise.com/ipo/lapl-automotive-ipo/subscription','2026-08-10 18:04:02.716372');
INSERT INTO "subscription_observations" VALUES(32,16,'iporise','2026-08-10 12:30:00.000000',200.23,433.26,387.78,344.31,'https://www.iporise.com/ipo/lapl-automotive-ipo/subscription','2026-08-10 18:04:02.716826');
INSERT INTO "subscription_observations" VALUES(33,18,'iporise','2026-08-04 12:30:00.000000',NULL,0.27,0.65,0.47,'https://www.iporise.com/ipo/aegeus-technologies-ipo/subscription','2026-08-10 18:04:02.717283');
INSERT INTO "subscription_observations" VALUES(34,18,'iporise','2026-08-05 12:30:00.000000',0.74,2.37,2.35,2.05,'https://www.iporise.com/ipo/aegeus-technologies-ipo/subscription','2026-08-10 18:04:02.717737');
INSERT INTO "subscription_observations" VALUES(35,18,'iporise','2026-08-06 12:30:00.000000',23.88,48.05,25.59,28.47,'https://www.iporise.com/ipo/aegeus-technologies-ipo/subscription','2026-08-10 18:04:02.718198');
INSERT INTO "subscription_observations" VALUES(36,13,'ipogram','2026-08-10 18:04:00.110622',200.23,433.26,387.78,344.31,'https://ipogram.in/ipo-subscription/leap-india/','2026-08-10 18:04:02.722581');
INSERT INTO "subscription_observations" VALUES(37,14,'ipogram','2026-08-10 18:04:00.110622',1.02,0.21,0.88,0.77,'https://ipogram.in/ipo-subscription/optimystix-entertainment/','2026-08-10 18:04:02.723316');
INSERT INTO "subscription_observations" VALUES(38,15,'ipogram','2026-08-10 18:04:00.110622',4.47,3.8,1.01,2.59,'https://ipogram.in/ipo-subscription/technocraft-ventures/','2026-08-10 18:04:02.723766');
INSERT INTO "subscription_observations" VALUES(39,19,'ipogram','2026-08-10 18:04:00.110622',7.09,2.81,4.34,4.8,'https://ipogram.in/ipo-subscription/anawil-wire/','2026-08-10 18:04:02.724475');
INSERT INTO "subscription_observations" VALUES(40,21,'ipogram','2026-08-10 18:04:00.110622',3.52,29.99,29.33,31.21,'https://ipogram.in/ipo-subscription/g-v-electricals/','2026-08-10 18:04:02.724926');
INSERT INTO "subscription_observations" VALUES(41,20,'ipogram','2026-08-10 18:04:00.110622',0.68,0.55,0.32,0.97,'https://ipogram.in/ipo-subscription/fusion-klassroom-edutech/','2026-08-10 18:04:02.725385');
INSERT INTO "subscription_observations" VALUES(42,22,'ipogram','2026-08-10 18:04:00.110622',1.05,2.4,1.84,1.73,'https://ipogram.in/ipo-subscription/oneindig-technologies/','2026-08-10 18:04:02.725828');
INSERT INTO "subscription_observations" VALUES(43,23,'ipogram','2026-08-10 18:04:00.110622',56.38,75.35,40.36,49.99,'https://ipogram.in/ipo-subscription/dhaval-packaging/','2026-08-10 18:04:02.726274');
INSERT INTO "subscription_observations" VALUES(44,24,'ipogram','2026-08-10 18:04:00.110622',26.22,1.92,0.98,8.38,'https://ipogram.in/ipo-subscription/juniper-green-energy/','2026-08-10 18:04:02.726714');
INSERT INTO "subscription_observations" VALUES(45,25,'ipogram','2026-08-10 18:04:00.110622',96.13,397.99,218.25,200.66,'https://ipogram.in/ipo-subscription/mv-electrosystems/','2026-08-10 18:04:02.727155');
INSERT INTO "subscription_observations" VALUES(46,26,'ipogram','2026-08-10 18:04:00.110622',2.81,11.83,6.74,6.65,'https://ipogram.in/ipo-subscription/h-r-hygiene-products/','2026-08-10 18:04:02.727602');
INSERT INTO "subscription_observations" VALUES(47,27,'ipogram','2026-08-10 18:04:00.110622',8.54,1.06,0.98,5.12,'https://ipogram.in/manipal-health-ipo-subscription-status/','2026-08-10 18:04:02.728042');
INSERT INTO "subscription_observations" VALUES(48,28,'ipogram','2026-08-10 18:04:00.110622',206.46,463.43,247.58,278.83,'https://ipogram.in/poojaa-precision-ipo-subscription-status/','2026-08-10 18:04:02.728557');
INSERT INTO "subscription_observations" VALUES(49,29,'ipogram','2026-08-10 18:04:00.110622',1.37,1.38,1.77,1.53,'https://ipogram.in/propshop-events-ipo-subscription-status/','2026-08-10 18:04:02.729022');
INSERT INTO "subscription_observations" VALUES(50,30,'ipogram','2026-08-10 18:04:00.110622',0,0.43,2.68,1.55,'https://ipogram.in/advance-technoforge-ipo-subscription-status/','2026-08-10 18:04:02.729483');
CREATE INDEX ix_ipos_status ON ipos (status);
CREATE UNIQUE INDEX ix_ipos_slug ON ipos (slug);
CREATE INDEX ix_market_observations_index_name ON market_observations (index_name);
CREATE INDEX ix_market_observations_observed_at ON market_observations (observed_at);
CREATE INDEX ix_gmp_observations_source ON gmp_observations (source);
CREATE INDEX ix_gmp_observations_observed_at ON gmp_observations (observed_at);
CREATE INDEX ix_gmp_observations_ipo_id ON gmp_observations (ipo_id);
CREATE INDEX ix_subscription_observations_source ON subscription_observations (source);
CREATE INDEX ix_subscription_observations_observed_at ON subscription_observations (observed_at);
CREATE INDEX ix_subscription_observations_ipo_id ON subscription_observations (ipo_id);
COMMIT;
