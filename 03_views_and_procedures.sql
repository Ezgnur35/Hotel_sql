-- =============================================
-- Hotel Management DB - Gelişmiş Sorgular
-- VIEW ve Stored Procedure Örnekleri
-- =============================================

USE HotelManagementDB;
GO

-- =============================================
-- 1. VIEW: Aktif Rezervasyonlar Görünümü
-- Sık kullanılan rezervasyon bilgilerini tek sorguda toplar
-- =============================================
CREATE OR ALTER VIEW vw_AktifRezervasyonlar AS
SELECT 
    r.REZERVASYON_ID,
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS MusteriAdSoyad,
    m.MUSTERI_TEL_NO,
    o.ODA_NO,
    o.ODA_TIPI,
    o.ODA_FIYAT_BILGISI,
    r.CHECK_IN,
    r.CIKIS_TARIHI,
    DATEDIFF(DAY, r.CHECK_IN, r.CIKIS_TARIHI) AS KonaklamaGunu,
    r.KISI_SAYISI,
    r.TOPLAM_FIYAT,
    r.REZERVASYON_DURUMU
FROM REZERVASYONLAR r
INNER JOIN MUSTERILER m ON r.MUSTERI_ID = m.MUSTERI_ID
INNER JOIN ODALAR o ON r.ODA_ID = o.ODA_ID
WHERE r.CIKIS_TARIHI >= GETDATE();
GO

-- Kullanım:
-- SELECT * FROM vw_AktifRezervasyonlar;


-- =============================================
-- 2. VIEW: Müşteri Özet Bilgileri
-- =============================================
CREATE OR ALTER VIEW vw_MusteriOzet AS
SELECT 
    m.MUSTERI_ID,
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS TamAd,
    m.MUSTERI_TEL_NO,
    m.MUSTERI_E_POSTA,
    m.VIP_MI,
    m.TOPLAM_HARCAMALAR,
    COUNT(DISTINCT r.REZERVASYON_ID) AS ToplamRezervasyon,
    COUNT(DISTINCT s.SIKAYET_ID) AS SikayetSayisi
FROM MUSTERILER m
LEFT JOIN REZERVASYONLAR r ON m.MUSTERI_ID = r.MUSTERI_ID
LEFT JOIN SIKAYETLER s ON m.MUSTERI_ID = s.MUSTERI_ID
GROUP BY 
    m.MUSTERI_ID, 
    m.MUSTERI_ADI, 
    m.MUSTERI_SOYADI,
    m.MUSTERI_TEL_NO,
    m.MUSTERI_E_POSTA,
    m.VIP_MI,
    m.TOPLAM_HARCAMALAR;
GO


-- =============================================
-- 3. VIEW: Finansal Özet
-- =============================================
CREATE OR ALTER VIEW vw_FinansalOzet AS
SELECT 
    YEAR(GELIR_KAYIT_TARIHI) AS Yil,
    MONTH(GELIR_KAYIT_TARIHI) AS Ay,
    SUM(GELIR_TUTARI) AS AylikGelir,
    (SELECT SUM(GIDER_TUTARI) 
     FROM GIDERLER 
     WHERE YEAR(GIDER_KAYIT_TARIHI) = YEAR(g.GELIR_KAYIT_TARIHI) 
     AND MONTH(GIDER_KAYIT_TARIHI) = MONTH(g.GELIR_KAYIT_TARIHI)
    ) AS AylikGider
FROM GELIRLER g
GROUP BY YEAR(GELIR_KAYIT_TARIHI), MONTH(GELIR_KAYIT_TARIHI);
GO


-- =============================================
-- 4. STORED PROCEDURE: Yeni Rezervasyon Ekle
-- =============================================
CREATE OR ALTER PROCEDURE sp_YeniRezervasyon
    @RezervasyonID INT,
    @MusteriID INT,
    @OdaID INT,
    @CheckIn DATETIME,
    @CikisTarihi DATETIME,
    @KisiSayisi SMALLINT,
    @ToplamFiyat DECIMAL(6,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Oda dolu mu kontrol et
    IF EXISTS (
        SELECT 1 FROM REZERVASYONLAR 
        WHERE ODA_ID = @OdaID 
        AND (
            (@CheckIn BETWEEN CHECK_IN AND CIKIS_TARIHI) OR
            (@CikisTarihi BETWEEN CHECK_IN AND CIKIS_TARIHI)
        )
    )
    BEGIN
        RAISERROR(N'Bu oda seçilen tarihlerde dolu!', 16, 1);
        RETURN;
    END
    
    -- Rezervasyon ekle
    INSERT INTO REZERVASYONLAR (
        REZERVASYON_ID, ODA_ID, MUSTERI_ID, REZERVASYON_DURUMU,
        CHECK_IN, CIKIS_TARIHI, KISI_SAYISI, TOPLAM_FIYAT, OLUSTURULMA_TARIHI
    )
    VALUES (
        @RezervasyonID, @OdaID, @MusteriID, N'Aktif',
        @CheckIn, @CikisTarihi, @KisiSayisi, @ToplamFiyat, GETDATE()
    );
    
    PRINT N'Rezervasyon başarıyla oluşturuldu.';
END
GO


-- =============================================
-- 5. STORED PROCEDURE: Aylık Gelir Raporu
-- =============================================
CREATE OR ALTER PROCEDURE sp_AylikGelirRaporu
    @Yil INT,
    @Ay INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS IslemSayisi,
        SUM(GELIR_TUTARI) AS ToplamGelir,
        AVG(GELIR_TUTARI) AS OrtalamaGelir,
        MAX(GELIR_TUTARI) AS EnYuksekGelir,
        MIN(GELIR_TUTARI) AS EnDusukGelir
    FROM GELIRLER
    WHERE YEAR(GELIR_KAYIT_TARIHI) = @Yil 
      AND MONTH(GELIR_KAYIT_TARIHI) = @Ay;
END
GO

-- Kullanım:
-- EXEC sp_AylikGelirRaporu @Yil=2024, @Ay=12;


-- =============================================
-- 6. STORED PROCEDURE: Müşteri VIP Durumu Güncelle
-- Toplam harcaması belirli bir miktarın üzerindeki müşterileri VIP yap
-- =============================================
CREATE OR ALTER PROCEDURE sp_VipDurumuGuncelle
    @VipLimit DECIMAL(10,2) = 50000
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE MUSTERILER
    SET VIP_MI = 1
    WHERE TOPLAM_HARCAMALAR >= @VipLimit
      AND VIP_MI = 0;
    
    PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + N' müşteri VIP statüsüne alındı.';
END
GO

-- Kullanım:
-- EXEC sp_VipDurumuGuncelle @VipLimit=100000;
