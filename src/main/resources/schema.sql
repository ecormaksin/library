DROP TABLE IF EXISTS 会員,本,蔵書,貸出,返却,予約;
DROP SEQUENCE IF EXISTS 貸出ID;
DROP SEQUENCE IF EXISTS 予約ID;

CREATE TABLE 会員 (
    会員番号 INTEGER NOT NULL PRIMARY KEY,
    氏名 VARCHAR(40) NOT NULL,
    会員種別 VARCHAR(2) NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 本 (
    本ID INTEGER NOT NULL PRIMARY KEY,
    タイトル VARCHAR(40) NOT NULL,
    著者 VARCHAR(40) NOT NULL,
    本種別 VARCHAR(8) NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 蔵書 (
    蔵書コード VARCHAR(40) NOT NULL PRIMARY KEY,
    本ID INTEGER NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (本ID) REFERENCES 本(本ID)
);

CREATE TABLE 貸出 (
    貸出ID INTEGER NOT NULL PRIMARY KEY,
    会員番号 INTEGER NOT NULL,
    蔵書コード VARCHAR(40) NOT NULL,
    貸出日 DATE NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (会員番号) REFERENCES 会員(会員番号)
    ,FOREIGN KEY (蔵書コード) REFERENCES 蔵書(蔵書コード)
);
CREATE SEQUENCE 貸出ID;

CREATE TABLE 返却 (
    貸出ID INTEGER NOT NULL PRIMARY KEY,
    返却日 DATE NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (貸出ID) REFERENCES 貸出(貸出ID)
);

CREATE TABLE 予約 (
    予約ID INTEGER NOT NULL PRIMARY KEY,
    会員番号 INTEGER NOT NULL,
    本ID INTEGER NOT NULL,
    登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,FOREIGN KEY (会員番号) REFERENCES 会員(会員番号)
    ,FOREIGN KEY (本ID) REFERENCES 本(本ID)
);
CREATE SEQUENCE 予約ID;