-- =============================================
-- Hotel Management DB - Örnek Sorgular
-- SELECT ve JOIN Sorguları
-- =============================================

USE HotelManagementDB;
GO

-- 1. Tüm aktif rezervasyonları müşteri ve oda bilgileriyle listele
SELECT 
    r.REZERVASYON_ID,
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS MusteriAdSoyad,
    m.MUSTERI_TEL_NO,
    o.ODA_NO,
    o.ODA_TIPI,
    r.CHECK_IN,
    r.CIKIS_TARIHI,
    r.KISI_SAYISI,
    r.TOPLAM_FIYAT
FROM REZERVASYONLAR r
INNER JOIN MUSTERILER m ON r.MUSTERI_ID = m.MUSTERI_ID
INNER JOIN ODALAR o ON r.ODA_ID = o.ODA_ID
WHERE r.CIKIS_TARIHI >= GETDATE()
ORDER BY r.CHECK_IN;


-- 2. Boş odaları listele (doluluk durumuna göre)
SELECT 
    o.ODA_NO,
    o.ODA_TIPI,
    o.KAC_KISILIK,
    o.ODA_FIYAT_BILGISI,
    o.ODA_MANZARA_CESIT,
    o.INTERNET,
    o.KLIMA,
    o.MINI_BAR
FROM ODALAR o
WHERE o.DOLULUK_DURUMU = N'Boş'
ORDER BY o.ODA_FIYAT_BILGISI;


-- 3. En çok rezervasyon yapan ilk 5 müşteri
SELECT TOP 5
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS MusteriAdSoyad,
    COUNT(r.REZERVASYON_ID) AS ToplamRezervasyon,
    m.TOPLAM_HARCAMALAR
FROM MUSTERILER m
INNER JOIN REZERVASYONLAR r ON m.MUSTERI_ID = r.MUSTERI_ID
GROUP BY m.MUSTERI_ID, m.MUSTERI_ADI, m.MUSTERI_SOYADI, m.TOPLAM_HARCAMALAR
ORDER BY ToplamRezervasyon DESC;


-- 4. VIP müşterilerin listesi
SELECT 
    MUSTERI_ADI + ' ' + MUSTERI_SOYADI AS MusteriAdSoyad,
    MUSTERI_TEL_NO,
    MUSTERI_E_POSTA,
    TOPLAM_HARCAMALAR
FROM MUSTERILER
WHERE VIP_MI = 1
ORDER BY TOPLAM_HARCAMALAR DESC;


-- 5. Aktif çalışanları departmana göre listele
SELECT 
    CALISAN_AD + ' ' + CALISAN_SOYAD AS CalisanAdSoyad,
    DEPARTMAN,
    POZISYON,
    ISE_BASLAMA_TARIHI,
    MAASI
FROM CALISANLAR
WHERE CALISAN_AKTIF_MI = 1
ORDER BY DEPARTMAN, MAASI DESC;


-- 6. Şikayetleri müşteri bilgileriyle birlikte göster
SELECT 
    s.SIKAYET_ID,
    m.MUSTERI_ADI + ' ' + m.MUSTERI_SOYADI AS MusteriAdSoyad,
    s.SIKAYET_TURU,
    s.SIKAYET_ONEM_DERECESI,
    s.ILGILI_BIRIM,
    s.SIKAYET_TARIHI,
    CASE 
        WHEN s.SIKAYET_YANITLANDI_MI = 1 THEN N'Yanıtlandı'
        ELSE N'Bekliyor'
    END AS Durum
FROM SIKAYETLER s
INNER JOIN MUSTERILER m ON s.MUSTERI_ID = m.MUSTERI_ID
ORDER BY s.SIKAYET_TARIHI DESC;


-- 7. Aktif hizmetleri ve sorumlu çalışanları listele
SELECT 
    h.HIZMET_ADI,
    h.HIZMET_TURU,
    h.UCRET,
    h.MAX_KAPASITE,
    c.CALISAN_AD + ' ' + c.CALISAN_SOYAD AS SorumluCalisan
FROM HIZMETLER h
INNER JOIN CALISANLAR c ON h.CALISAN_ID = c.CALISAN_ID
WHERE h.AKTIF_MI = 1
ORDER BY h.UCRET DESC;
