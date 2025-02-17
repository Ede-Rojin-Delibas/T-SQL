--STRING FUNCTIONS:ASCII 
SELECT ASCII('E')
SELECT CHAR(69)
SELECT CONCAT('EDE ', 'ROJIN ','DELIBA�')
SELECT 'EDE '+'ROJIN '+'DELIBA�'--It's doing the same function like concat;but sometimes plus is creating bad situations
SELECT RIGHT('EDE ROJIN DELIBA�',5)
SELECT LEFT('EDE ROJIN DELIBA�',5)
SELECT RTRIM('EDE ROJIN DELIBA�','A�')
--2022 sonras� parametreler
--06.02.2025
--Lower,Upper,Reverse,Replicate fonksiyonlar�,Replace 
SELECT REPLACE('T-SQL ile herhangi bir programlama dili ile yap�labilecek hemen hemen her �eyi yapabilirsiniz.',
'T-SQL','Transact SQL')
--SUBSTRING FONKS�YONU
SELECT SUBSTRING('SQL Server 2022 ile yeni gelen �zelliklerden biri de iyile�tirilen TRIM fonksiyonudur.',1,15)
--CHARINDEX FONKS�YONU
SELECT CHARINDEX('2022','SQL SERVER 2022')
SELECT * FROM string_split('Turkcell gelece�i yazanlar',' ',1)
--STRING FONKS�YONLARI, ALI�TIRMALAR
--1)Elimizde m��terilerimizin NAME ve SURNAME alanlar�n�n oldu�u bir veri taban� var. Ve bu veri taban� �zerinde
-- NAME ve SURNAME alanlar�n� hem '+' operat�r�yle hem de concat fonksiyonuyla birle�tirerek NAMESURNAME alan�n� update ediniz.
SELECT ID, NAME_,SURNAME,NAME_+' '+SURNAME,
CONCAT(NAME_,' ',SURNAME) FROM LAB01
UPDATE LAB01 SET NAMESURNAME =CONCAT(NAME_,' ',SURNAME)
SELECT * FROM LAB01
--2)Elimizdeki ayn� vt �zerinden NAME ve SURNAME alanlar�n� SURNAME ifadesi tamamen b�y�k olacak �ekilde birle�tiriniz.
SELECT * FROM LAB02 
UPDATE LAB02 SET NAMESURNAME=NAME_+' '+UPPER(SURNAME)
--3)Elimizde m��terilerimizin telefon numaralar�n� tuttu�umuz bir vt var.Burada TELNR1 alan�n�n operat�r 
--numaras�na g�re hangi numaradan ka� telefon oldu�u bilgisini getiren sql sorgusunu yaz�n�z.
SELECT SUBSTRING(TELNR1,2,3) OPERATORNO,COUNT(*) TELEFONSAYISI FROM LAB03 
GROUP BY SUBSTRING(TELNR1,2,3)
--4)Elimizde foto�raf dosyalar�n�n exif bilgisini tutan bir vt var.Bu veri taban�nda her bilgi ## ile ay�rt edilmi� durumda
--Buradaki bilgileri enter karakteriyle alt alta yazd�rmak i�in gereken kodu yaz�n�z.
SELECT ID,FILENAME, 
REPLACE(INFO,'##',CHAR(13)) EXIFINFO
FROM LAB04
--ENTER KARAKTER�N�N ASCI KAR�ILI�I 13 VE ## BU KARAKTER ENTER'IN KAR�ILI�I �LE DE���T�RECE��M.
--5)Elimizde StackOverflow db si var. Bu database i�inde yorumlar�n bulundu�u ve her bir sat�r�n da
--'SQL' kelimesinin ge�ti�i bir tablomuz var. Bu tabloda her bir sat�rdaki TEXT alan�nda ka� tane SQL kelimesi
-- ge�ti�ini getirecek sorguyu yaz�n�z.
SELECT TEXT,
(	
	SELECT COUNT(*) FROM string_split(TEXT,' ') where value like '%SQL%'
) WordCount
FROM LAB05
ORDER BY Id
--6) Elimizde sipari�lerin tutuldu�u bir tablo var. Bu tabloda otomatik �ekilde olu�acak ak�ll� bir sipari� 
--numaras� olu�turmak istiyoruz. Bunun i�in sipari� no format�n� �u �ekilde yapaca��m:Tarih+0'lar+sipari�Id si (0 say�s� toplamda 8 karaktere tamamlayacak �ekilde olmal�d�r.)
SELECT FORMAT(DATE_,'yyyyMMdd')+'-'+REPLICATE('0',8-LEN(ID))+ID,*
FROM LAB06
--ORDERNO ALANININ G�NCELLENMES�
UPDATE LAB06 SET ORDERNO=FORMAT(DATE_,'yyyyMMdd')+'-'+REPLICATE('0',8-LEN(ID))+ID
SELECT * FROM LAB06
--7)M��terilerimize bir kampanya yapmak istiyoruz ve isme �zel bir hediye olu�turmak istiyoruz. Bu ama�la isminin ba� harfini ve 
-- her ba� harften ka� m��teri oldu�unu getiren sorguyu yaz�n�z.	
SELECT 
substring(NAME_ ,1,1) basHarf,
COUNT(substring(NAME_ ,1,1)) basHarfSayisi
FROM LAB07
GROUP BY substring(NAME_ ,1,1)
--�SM�N�N VE SOY�SM�N�N BA�HARFLER�NE G�RE B�R HED�YE OLU�TURMAK ���N
SELECT LEFT(NAME_,1)+LEFT(SURNAME,1) BASHARF , COUNT(*) BASHARFSAY�S� FROM LAB07
GROUP BY LEFT(NAME_,1), LEFT(SURNAME,1)
ORDER BY 1
--8)Elimizde NAMESURNAME alanlar�n�n oldu�u bir vt var.Bu vt �zerinden Name ve Surname alanlar�n� par�alayarak getiriniz.
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
--9)Elimizde m��terilerimizin oldu�u bir vt var. Burada iki isimli kullan�c�lar�n isimleri yaz�l�rken 
-- d�zensiz bir �ekilde birden fazla bo�luk kullan�lm��. Ayr�ca ikinci isimler tamamen k���k harfle yaz�lm��.
--Burada isimler aras�ndaki bo�lu�u 1'e indiriniz ve ikinci isimleri de ilk harf b�y�k olacak �ekilde update ediniz.
SELECT ID,NAME_,SURNAME,NAMESURNAME FROM LAB09 WHERE NAME_ LIKE '% %' --iki isimlileri yakalamak i�in
UPDATE LAB09 SET NAME_= REPLACE(NAME_,'   ', ' ')
UPDATE LAB09 SET NAME_= REPLACE(NAME_,'  ', ' ')
--�kinci isimleri k���k yapmak i�in isim b�l�m�nde ay�rma i�lemi yapmal�y�z.
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
-- FARKLI B�R Y�NTEM
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
--Datetime Fonksiyonlar�:
--Anl�k tarih saat bilgisini getiren fonksiyonlar
SELECT 
GETDATE() "GETDATE",
SYSDATETIME() "SYSDATETIME",
SYSDATETIMEOFFSET() "SYSDATETIMEOFFSET",
SYSUTCDATETIME() "SYSUTCDATETIME",
CURRENT_TIMESTAMP "CURRENT_TIMESTAMP",
GETUTCDATE() "GETUTCDATE" 

-- Do�um tarihinizi i�eren bir tablo olu�turma
CREATE TABLE Persons (
    ID int PRIMARY KEY,
    Name varchar(255),
    BirthDate date
);

-- �rnek veri ekleme
INSERT INTO Persons (ID, Name, BirthDate) VALUES (1, 'Ede Rojin Delibas', '2003-08-08');

-- Ya� hesaplama
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

