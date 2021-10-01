
-- スキーマとオブジェクトをリセット
DROP SCHEMA IF EXISTS 資料_所蔵品目 CASCADE;
CREATE SCHEMA 資料_所蔵品目;

DROP SCHEMA IF EXISTS 資料_所蔵品 CASCADE;
CREATE SCHEMA 資料_所蔵品;

DROP SCHEMA IF EXISTS 会員 CASCADE;
CREATE SCHEMA 会員;

DROP SCHEMA IF EXISTS 貸出 CASCADE;
CREATE SCHEMA 貸出;

DROP SCHEMA IF EXISTS 予約 CASCADE;
CREATE SCHEMA 予約;

DROP SCHEMA IF EXISTS 取置 CASCADE;
CREATE SCHEMA 取置;

-- 会員スキーマ
CREATE TABLE 会員.会員
(
  会員番号 INTEGER PRIMARY KEY,
  氏名   VARCHAR(40) NOT NULL,
  会員種別 VARCHAR(5)  NOT NULL,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 資料_所蔵品目スキーマ
CREATE TABLE 資料_所蔵品目.所蔵品目
(
  所蔵品目番号  INTEGER PRIMARY KEY,
  タイトル VARCHAR(40) NOT NULL,
  著者   VARCHAR(40) NOT NULL,
  所蔵品目種別 VARCHAR(5) NOT NULL,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 資料_所蔵品スキーマ
CREATE TABLE 資料_所蔵品.所蔵品
(
  所蔵品番号 VARCHAR(40) PRIMARY KEY,
  所蔵品目番号  INTEGER   NOT NULL REFERENCES 資料_所蔵品目.所蔵品目,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 資料_所蔵品.貸出可能
(
  所蔵品番号 VARCHAR(40) PRIMARY KEY REFERENCES 資料_所蔵品.所蔵品,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 資料_所蔵品.貸出中
(
  所蔵品番号 VARCHAR(40) NOT NULL REFERENCES 資料_所蔵品.所蔵品,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 資料_所蔵品.取置中
(
  所蔵品番号 VARCHAR(40) PRIMARY KEY REFERENCES 資料_所蔵品.所蔵品,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 貸出スキーマ
CREATE SEQUENCE 貸出.貸出番号;

CREATE TABLE 貸出.貸出履歴
(
  貸出番号 INTEGER PRIMARY KEY,
  所蔵品番号 VARCHAR(40) NOT NULL REFERENCES 資料_所蔵品.所蔵品,
  貸出日  DATE        NOT NULL,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 貸出.返却履歴
(
  貸出番号 INTEGER PRIMARY KEY REFERENCES 貸出.貸出履歴,
  返却日  DATE      NOT NULL,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 予約スキーマ
CREATE SEQUENCE 予約.予約番号;

CREATE TABLE 予約.予約履歴
(
  予約番号 INTEGER PRIMARY KEY,
  所蔵品目番号  INTEGER   NOT NULL REFERENCES 資料_所蔵品目.所蔵品目,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE 予約.予約取消履歴
(
  予約番号 INTEGER PRIMARY KEY REFERENCES 予約.予約履歴,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 取置スキーマ
CREATE TABLE 取置.取置履歴
(
  予約番号 INTEGER PRIMARY KEY REFERENCES 予約.予約履歴,
  所蔵品番号 VARCHAR(40) NOT NULL REFERENCES 資料_所蔵品.所蔵品,
  取置日  DATE        NOT NULL,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 準備完了 所蔵品でユニーク（同じ所蔵品を同時に取置はできない）
CREATE TABLE 取置.準備完了
(
  所蔵品番号 VARCHAR(40) PRIMARY KEY,
  予約番号 INTEGER   NOT NULL,
  FOREIGN KEY (予約番号, 所蔵品番号) REFERENCES 取置.取置履歴 (予約番号, 所蔵品番号),
  取置日  DATE      NOT NULL,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 取置を貸し出した記録
CREATE TABLE 取置.取置解放履歴
(
  予約番号 INTEGER PRIMARY KEY,
  所蔵品番号 VARCHAR(40) NOT NULL,
  登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (予約番号, 所蔵品番号) REFERENCES 取置.取置履歴 (予約番号, 所蔵品番号)
);
-- 取置の期限切れ
CREATE TABLE 取置.取置期限切れ履歴
(
  予約番号 INTEGER PRIMARY KEY REFERENCES 取置.取置解放履歴,
  登録日時 TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 貸出と会員の関連テーブル
CREATE TABLE 会員.貸出と会員
(
    貸出番号 INTEGER     PRIMARY KEY REFERENCES 貸出.貸出履歴,
    会員番号 INTEGER     NOT NULL REFERENCES 会員.会員,
    登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 予約と会員の関連テーブル
CREATE TABLE 会員.予約と会員
(
    予約番号 INTEGER     PRIMARY KEY REFERENCES 予約.予約履歴,
    会員番号 INTEGER     NOT NULL REFERENCES 会員.会員,
    登録日時 TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);
