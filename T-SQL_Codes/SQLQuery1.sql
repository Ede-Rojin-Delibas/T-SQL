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
--9)