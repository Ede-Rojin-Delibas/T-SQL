--STRING FUNCTIONS:ASCII 
SELECT ASCII('E')
SELECT CHAR(69)
SELECT CONCAT('EDE ', 'ROJIN ','DELIBAÞ')
SELECT 'EDE '+'ROJIN '+'DELIBAÞ'--It's doing the same function like concat;but sometimes plus is creating bad situations
SELECT RIGHT('EDE ROJIN DELIBAÞ',5)
SELECT LEFT('EDE ROJIN DELIBAÞ',5)
SELECT RTRIM('EDE ROJIN DELIBAÞ','AÞ')
--2022 sonrasý parametreler
--06.02.2025
--Lower,Upper,Reverse,Replicate fonksiyonlarý,Replace 
SELECT REPLACE('T-SQL ile herhangi bir programlama dili ile yapýlabilecek hemen hemen her þeyi yapabilirsiniz.',
'T-SQL','Transact SQL')
--SUBSTRING FONKSÝYONU
SELECT SUBSTRING('SQL Server 2022 ile yeni gelen özelliklerden biri de iyileþtirilen TRIM fonksiyonudur.',1,15)
--CHARINDEX FONKSÝYONU
SELECT CHARINDEX('2022','SQL SERVER 2022')
SELECT * FROM string_split('Turkcell geleceði yazanlar',' ',1)
--STRING FONKSÝYONLARI, ALIÞTIRMALAR
--1)Elimizde müþterilerimizin NAME ve SURNAME alanlarýnýn olduðu bir veri tabaný var. Ve bu veri tabaný üzerinde
-- NAME ve SURNAME alanlarýný hem '+' operatörüyle hem de concat fonksiyonuyla birleþtirerek NAMESURNAME alanýný update ediniz.
SELECT ID, NAME_,SURNAME,NAME_+' '+SURNAME,
CONCAT(NAME_,' ',SURNAME) FROM LAB01
UPDATE LAB01 SET NAMESURNAME =CONCAT(NAME_,' ',SURNAME)
SELECT * FROM LAB01
--2)Elimizdeki ayný vt üzerinden NAME ve SURNAME alanlarýný SURNAME ifadesi tamamen büyük olacak þekilde birleþtiriniz.
SELECT * FROM LAB02 
UPDATE LAB02 SET NAMESURNAME=NAME_+' '+UPPER(SURNAME)
--3)Elimizde müþterilerimizin telefon numaralarýný tuttuðumuz bir vt var.Burada TELNR1 alanýnýn operatör 
--numarasýna göre hangi numaradan kaç telefon olduðu bilgisini getiren sql sorgusunu yazýnýz.
SELECT SUBSTRING(TELNR1,2,3) OPERATORNO,COUNT(*) TELEFONSAYISI FROM LAB03 
GROUP BY SUBSTRING(TELNR1,2,3)
--4)Elimizde fotoðraf dosyalarýnýn exif bilgisini tutan bir vt var.Bu veri tabanýnda her bilgi ## ile ayýrt edilmiþ durumda
--Buradaki bilgileri enter karakteriyle alt alta yazdýrmak için gereken kodu yazýnýz.
SELECT ID,FILENAME, 
REPLACE(INFO,'##',CHAR(13)) EXIFINFO
FROM LAB04
--ENTER KARAKTERÝNÝN ASCI KARÞILIÐI 13 VE ## BU KARAKTER ENTER'IN KARÞILIÐI ÝLE DEÐÝÞTÝRECEÐÝM.
--5)Elimizde StackOverflow db si var. Bu database içinde yorumlarýn bulunduðu ve her bir satýrýn da
--'SQL' kelimesinin geçtiði bir tablomuz var. Bu tabloda her bir satýrdaki TEXT alanýnda kaç tane SQL kelimesi
-- geçtiðini getirecek sorguyu yazýnýz.
SELECT TEXT,
(	
	SELECT COUNT(*) FROM string_split(TEXT,' ') where value like '%SQL%'
) WordCount
FROM LAB05
ORDER BY Id
--6) Elimizde sipariþlerin tutulduðu bir tablo var. Bu tabloda otomatik þekilde oluþacak akýllý bir sipariþ 
--numarasý oluþturmak istiyoruz. Bunun için sipariþ no formatýný þu þekilde yapacaðým:Tarih+0'lar+sipariþId si (0 sayýsý toplamda 8 karaktere tamamlayacak þekilde olmalýdýr.)
SELECT FORMAT(DATE_,'yyyyMMdd')+'-'+REPLICATE('0',8-LEN(ID))+ID,*
FROM LAB06
--ORDERNO ALANININ GÜNCELLENMESÝ
UPDATE LAB06 SET ORDERNO=FORMAT(DATE_,'yyyyMMdd')+'-'+REPLICATE('0',8-LEN(ID))+ID
SELECT * FROM LAB06
--7)Müþterilerimize bir kampanya yapmak istiyoruz ve isme özel bir hediye oluþturmak istiyoruz. Bu amaçla isminin baþ harfini ve 
-- her baþ harften kaç müþteri olduðunu getiren sorguyu yazýnýz.	
SELECT 
substring(NAME_ ,1,1) basHarf,
COUNT(substring(NAME_ ,1,1)) basHarfSayisi
FROM LAB07
GROUP BY substring(NAME_ ,1,1)
--ÝSMÝNÝN VE SOYÝSMÝNÝN BAÞHARFLERÝNE GÖRE BÝR HEDÝYE OLUÞTURMAK ÝÇÝN
SELECT LEFT(NAME_,1)+LEFT(SURNAME,1) BASHARF , COUNT(*) BASHARFSAYÝSÝ FROM LAB07
GROUP BY LEFT(NAME_,1), LEFT(SURNAME,1)
ORDER BY 1
--8)Elimizde NAMESURNAME alanlarýnýn olduðu bir vt var.Bu vt üzerinden Name ve Surname alanlarýný parçalayarak getiriniz.
SELECT ID, REPLACE(NAMESURNAME,' '+SURNAME,'') NAME_,
SURNAME,NAMESURNAME FROM
(
SELECT ID,NAMESURNAME,
(SELECT TOP 1 VALUE FROM string_split(NAMESURNAME,' ',1) ORDER BY ordinal desc) SURNAME
FROM LAB08
) T
UPDATE LAB08 SET SURNAME=(SELECT TOP 1 VALUE FROM string_split(NAMESURNAME,' ',1) ORDER BY ordinal desc)
UPDATE LAB08 SET NAME_=REPLACE(NAMESURNAME,' '+SURNAME,'')
SELECT * FROM LAB08
--9)Elimizde müþterilerimizin olduðu bir vt var. Burada iki isimli kullanýcýlarýn isimleri yazýlýrken 
-- düzensiz bir þekilde birden fazla boþluk kullanýlmýþ. Ayrýca ikinci isimler tamamen küçük harfle yazýlmýþ.
--Burada isimler arasýndaki boþluðu 1'e indiriniz ve ikinci isimleri de ilk harf büyük olacak þekilde update ediniz.
SELECT ID,NAME_,SURNAME,NAMESURNAME FROM LAB09 WHERE NAME_ LIKE '% %' --iki isimlileri yakalamak için
UPDATE LAB09 SET NAME_= REPLACE(NAME_,'   ', ' ')
UPDATE LAB09 SET NAME_= REPLACE(NAME_,'  ', ' ')
--Ýkinci isimleri küçük yapmak için isim bölümünde ayýrma iþlemi yapmalýyýz.
SELECT ID, NAME_,SURNAME,NAME_1,
UPPER(LEFT(NAME_2,1))+
SUBSTRING(NAME_2,2,LEN(NAME_2) - 1)
FROM 
(
SELECT ID,NAME_,SURNAME,NAMESURNAME,
(SELECT VALUE FROM string_split(NAME_,' ', 1) WHERE ordinal=1) NAME_1,
(SELECT VALUE FROM string_split(NAME_,' ', 1) WHERE ordinal=2) NAME_2	
FROM LAB09 WHERE NAME_ LIKE '% %'
) T

UPDATE LAB09 SET NAME_ =(SELECT VALUE FROM string_split(NAME_,' ', 1) WHERE ordinal=1)+' '+
UPPER(LEFT(
(SELECT VALUE FROM string_split(NAME_,' ', 1) WHERE ordinal=2)
,1))+ 
+UPPER(SUBSTRING(
(SELECT VALUE FROM string_split(NAME_,' ', 1) WHERE ordinal=2)
,2,100))
WHERE NAME_ LIKE '% %'

SELECT * FROM LAB09
WHERE NAME_ LIKE '% %'
-- FARKLI BÝR YÖNTEM
WITH NameParts AS (
    SELECT 
        ID, 
        NAME_, 
        SURNAME, 
        NAMESURNAME,
        LEFT(NAME_, CHARINDEX(' ', NAME_ + ' ') - 1) AS NAME_1,
        SUBSTRING(NAME_, CHARINDEX(' ', NAME_ + ' ') + 1, LEN(NAME_)) AS NAME_2
    FROM LAB09 
    WHERE NAME_ LIKE '% %'
)
UPDATE LAB09
SET NAME_ = NAME_1 + ' ' + UPPER(LEFT(NAME_2, 1)) + LOWER(SUBSTRING(NAME_2, 2, LEN(NAME_2)))
FROM NameParts
WHERE LAB09.ID = NameParts.ID;
SELECT * FROM LAB09
WHERE NAME_ LIKE '% %' 
--Datetime Fonksiyonlarý:
--Anlýk tarih saat bilgisini getiren fonksiyonlar
SELECT 
GETDATE() "GETDATE",
SYSDATETIME() "SYSDATETIME",
SYSDATETIMEOFFSET() "SYSDATETIMEOFFSET",
SYSUTCDATETIME() "SYSUTCDATETIME",
CURRENT_TIMESTAMP "CURRENT_TIMESTAMP",
GETUTCDATE() "GETUTCDATE" 

-- Doðum tarihinizi içeren bir tablo oluþturma
CREATE TABLE Persons (
    ID int PRIMARY KEY,
    Name varchar(255),
    BirthDate date
);

-- Örnek veri ekleme
INSERT INTO Persons (ID, Name, BirthDate) VALUES (1, 'Ede Rojin Delibas', '2003-08-08');

-- Yaþ hesaplama
SELECT 
    Name,
    BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) - 
    CASE 
        WHEN MONTH(BirthDate) > MONTH(GETDATE()) OR (MONTH(BirthDate) = MONTH(GETDATE()) AND DAY(BirthDate) > DAY(GETDATE())) 
        THEN 1 
        ELSE 0 
    END AS Age
FROM Persons;

