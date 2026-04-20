-- =============================================
-- Hotel Management DB - Örnek Sorgular
-- Finansal ve İstatistik Sorguları (GROUP BY, HAVING)
-- =============================================

USE HotelManagementDB;
GO

-- 1. Aylık gelir özeti
SELECT 
    YEAR(GELIR_KAYIT_TARIHI) AS Yil,
    MONTH(GELIR_KAYIT_TARIHI) AS Ay,
    COUNT(*) AS IslemSayisi,
    SUM(GELIR_TUTARI) AS ToplamGelir
FROM GELIRLER
GROUP BY YEAR(GELIR_KAYIT_TARIHI), MONTH(GELIR_KAYIT_TARIHI)
ORDER BY Yil DESC, Ay DESC;


-- 2. Kar/Zarar hesabı (toplam gelir - toplam gider)
SELECT 
    (SELECT SUM(GELIR_TUTARI) FROM GELIRLER) AS ToplamGelir,
    (SELECT SUM(GIDER_TUTARI) FROM GIDERLER) AS ToplamGider,
    (SELECT SUM(GELIR_TUTARI) FROM GELIRLER) - 
    (SELECT SUM(GIDER_TUTARI) FROM GIDERLER) AS NetKar;


-- 3. Gelir kaynaklarına göre dağılım
SELECT 
    GELIR_KAYNAGI,
    COUNT(*) AS IslemSayisi,
    SUM(GELIR_TUTARI) AS ToplamGelir,
    AVG(GELIR_TUTARI) AS OrtalamaGelir
FROM GELIRLER
GROUP BY GELIR_KAYNAGI
ORDER BY ToplamGelir DESC;


-- 4. Gider tiplerine göre dağılım
SELECT 
    GIDER_TIPI,
    COUNT(*) AS IslemSayisi,
    SUM(GIDER_TUTARI) AS ToplamGider
FROM GIDERLER
GROUP BY GIDER_TIPI
ORDER BY ToplamGider DESC;


-- 5. Oda tipine göre doluluk ve ortalama fiyat
SELECT 
    ODA_TIPI,
    COUNT(*) AS ToplamOda,
    SUM(CASE WHEN DOLULUK_DURUMU = N'Dolu' THEN 1 ELSE 0 END) AS DoluOda,
    SUM(CASE WHEN DOLULUK_DURUMU = N'Boş' THEN 1 ELSE 0 END) AS BosOda,
    AVG(ODA_FIYAT_BILGISI) AS OrtalamaFiyat
FROM ODALAR
GROUP BY ODA_TIPI
ORDER BY OrtalamaFiyat DESC;


-- 6. Departmanlara göre çalışan sayısı ve ortalama maaş
SELECT 
    DEPARTMAN,
    COUNT(*) AS CalisanSayisi,
    AVG(MAASI) AS OrtalamaMaas,
    MIN(MAASI) AS EnDusukMaas,
    MAX(MAASI) AS EnYuksekMaas
FROM CALISANLAR
WHERE CALISAN_AKTIF_MI = 1
GROUP BY DEPARTMAN
ORDER BY OrtalamaMaas DESC;


-- 7. HAVING kullanımı: Birden fazla rezervasyon yapmış müşteriler
SELECT 
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS MusteriAdSoyad,
    COUNT(r.REZERVASYON_ID) AS RezervasyonSayisi,
    SUM(r.TOPLAM_FIYAT) AS ToplamHarcama
FROM MUSTERILER m
INNER JOIN REZERVASYONLAR r ON m.MUSTERI_ID = r.MUSTERI_ID
GROUP BY m.MUSTERI_ID, m.MUSTERI_ADI, m.MUSTERI_SOYADI
HAVING COUNT(r.REZERVASYON_ID) >= 2
ORDER BY ToplamHarcama DESC;


-- 8. Şikayet türlerine göre yanıtlanma oranı
SELECT 
    SIKAYET_TURU,
    COUNT(*) AS ToplamSikayet,
    SUM(CASE WHEN SIKAYET_YANITLANDI_MI = 1 THEN 1 ELSE 0 END) AS YanitlananSayi,
    CAST(
        SUM(CASE WHEN SIKAYET_YANITLANDI_MI = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
        AS DECIMAL(5,2)
    ) AS YanitlanmaOrani
FROM SIKAYETLER
GROUP BY SIKAYET_TURU
ORDER BY ToplamSikayet DESC;


-- 9. Maaş aralıklarına göre çalışan dağılımı (CASE WHEN)
SELECT 
    CASE 
        WHEN MAASI < 20000 THEN N'Düşük (< 20K)'
        WHEN MAASI BETWEEN 20000 AND 40000 THEN N'Orta (20K-40K)'
        ELSE N'Yüksek (> 40K)'
    END AS MaasKategori,
    COUNT(*) AS CalisanSayisi
FROM CALISANLAR
WHERE CALISAN_AKTIF_MI = 1
GROUP BY 
    CASE 
        WHEN MAASI < 20000 THEN N'Düşük (< 20K)'
        WHEN MAASI BETWEEN 20000 AND 40000 THEN N'Orta (20K-40K)'
        ELSE N'Yüksek (> 40K)'
    END;
