INSERT INTO 会員.会員(会員番号, 氏名, 会員種別)
VALUES
(1, '山田 太郎', '中学生以上'),
(2, '佐藤 愛子', '小学生以下'),
(3, '三宅 祐一', '中学生以上');

INSERT INTO 資料_所蔵品目.所蔵品目(所蔵品目番号, タイトル, 著者, 所蔵品目種別)
VALUES
(1, '現場で役立つシステム設計の原則', '増田亨', '図書'),
(2, 'ドメイン駆動設計', 'エリック・エヴァンス', '図書'),
(3, 'オブジェクト指向入門 第2版 原則・コンセプト', 'バートランド・メイヤー', '図書'),
(4, 'オブジェクト指向入門 第2版 方法論', 'バートランド・メイヤー', '図書'),
(5, '理論から学ぶデータベース実践入門', '奥野幹也', '図書'),
(6, 'RDRA2.0 ハンドブック: 軽く柔軟で精度の高い要件定義のモデリング手法', '神崎善司', '図書'),
(7, 'ソフトウェアシステムアーキテクチャ構築の原理 第2版', 'ニック・ロザンスキ', '図書'),
(8, '四季の行事食(別冊うかたま)', '日本調理科学会', '図書'),
(9, '365日あなたを支える!究極のお助けごはん', '角川春樹事務所', '図書'),
(10, '伝統の技キラリ!暮らしを彩る和食器具', '阿部 悦子', '図書'),
(11, '[CD] 九九のうた・県庁所在地のうた -学び応援暗記ソング集-(ザ・ベスト)', '日本コロムビア', '視聴覚資料'),
(12, '[CD] 吾輩は猫である (<声を便りに>オーディオブック)', '夏目 漱石', '視聴覚資料'),
(13, '[CD] 注文の多い料理店(新潮CD)', '宮沢 賢治/著', '視聴覚資料'),
(14, '[CD] 宮沢賢治の世界', '宮沢 賢治/原作', '視聴覚資料'),
(15, '[DVD] 落語百選DVDコレクション', 'デアゴスティーニ・ジャパン', '視聴覚資料'),
(16, '[DVD] 魚のやさしいさばき方 上(COSMIC料理DVD)', '長峰 浩一/料理指導', '視聴覚資料'),
(17, '[DVD] 魚のやさしいさばき方 下(COSMIC料理DVD)', '長峰 浩一/料理指導', '視聴覚資料'),
(18, '[DVD] 災害時に役立つ知識とサバイバルクッキング -防災を学ぶ-', 'K-essence(制作)', '視聴覚資料');

-- イベント履歴テーブルと状態テーブル

-- 所蔵品の登録イベント
INSERT INTO 資料_所蔵品.所蔵品(所蔵品番号, 所蔵品目番号)
VALUES
('1-A', 1),
('1-B', 1),
('1-C', 1),
('2-A', 2),
('2-B', 2),
('2-C', 2),
('2-D', 2),
('2-E', 2),
('2-F', 2),
('2-G', 2),
('2-H', 2),
('3-A', 3),
('4-A', 4),
('5-A', 5),
('6-A', 6),
('7-A', 7),
('8-A', 8),
('8-B', 8),
('9-A', 9),
('9-B', 9),
('10-A', 10),
('10-B', 10),
('11-A', 11),
('11-B', 11),
('12-A', 12),
('12-B', 12),
('13-A', 13),
('14-A', 14),
('15-A', 15),
('16-A', 16),
('17-A', 17),
('18-A', 18);

-- いったん、すべての所蔵品を貸出可能に追加（初期状態）
INSERT INTO 資料_所蔵品.貸出可能(所蔵品番号)
VALUES
('1-A'),
('1-B'),
('1-C'),
('2-A'),
('2-B'),
('2-C'),
('2-D'),
('2-E'),
('2-F'),
('2-G'),
('2-H'),
('3-A'),
('4-A'),
('5-A'),
('6-A'),
('7-A'),
('8-A'),
('8-B'),
('9-A'),
('9-B'),
('10-A'),
('10-B'),
('11-A'),
('11-B'),
('12-A'),
('12-B'),
('13-A'),
('14-A'),
('15-A'),
('16-A'),
('17-A'),
('18-A');

-- 貸出した
INSERT INTO 貸出.貸出履歴(貸出番号, 所蔵品番号, 貸出日)
VALUES
((SELECT NEXTVAL('貸出.貸出番号')), '1-A', CURRENT_DATE);

INSERT INTO 会員.貸出と会員(会員番号, 貸出番号)
VALUES (1, CURRVAL('貸出.貸出番号'));

-- 貸出したので貸出可能から除外
DELETE FROM 資料_所蔵品.貸出可能 WHERE 所蔵品番号 = '1-A';

-- 貸出したので、貸出中に追加
INSERT INTO 資料_所蔵品.貸出中(所蔵品番号)
VALUES ('1-A');

-- Webで予約した
INSERT INTO 予約.予約履歴(予約番号, 会員番号, 所蔵品目番号)
VALUES
((SELECT NEXTVAL('予約.予約番号')),1, 4);

-- 取り置いた
INSERT INTO 取置.取置履歴(予約番号, 所蔵品番号, 取置日)
VALUES
((SELECT CURRVAL('予約.予約番号')), '4-A', CURRENT_DATE - 8);

INSERT INTO 取置.準備完了(所蔵品番号, 予約番号, 取置日)
VALUES
('4-A', (SELECT CURRVAL('予約.予約番号')), CURRENT_DATE - 8);

DELETE FROM 資料_所蔵品.貸出可能 WHERE 所蔵品番号 = '4-A';
INSERT INTO 資料_所蔵品.取置中 (所蔵品番号) VALUES ('4-A');