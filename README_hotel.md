# 🏨 Hotel Management Database

SQL Server ile tasarlanmış otel yönetim sistemi veritabanı. Otel operasyonlarının dijital takibi için 11 ilişkili tablodan oluşan kapsamlı bir şema içerir.

## 📊 Veritabanı Şeması

<!-- ER Diyagramını buraya ekleyeceksin -->
<!-- ![ER Diagram](docs/er_diagram.png) -->

Proje aşağıdaki tabloları içerir:

| Tablo | Açıklama |
|-------|----------|
| **MUSTERILER** | Müşteri bilgileri ve iletişim detayları |
| **ODALAR** | Oda numaraları, tipleri ve durumları |
| **REZERVASYONLAR** | Müşteri rezervasyon kayıtları |
| **CALISANLAR** | Otel personeli bilgileri |
| **HIZMETLER** | Sunulan hizmetler (spa, restoran, vb.) |
| **ETKINLIKLER** | Otelde düzenlenen etkinlikler |
| **GELIRLER** | Gelir kayıtları |
| **GIDERLER** | Gider kayıtları |
| **SIKAYETLER** | Müşteri şikayet ve geri bildirimleri |
| **RAPORLAR** | Yönetim raporları |
| **OTEL_BILGI** | Otele ait genel bilgiler |

## 🛠️ Kullanılan Teknolojiler

- **Microsoft SQL Server** (SSMS - SQL Server Management Studio)
- **T-SQL** (Transact-SQL)

## 📁 Proje Yapısı

```
hotel-management-db/
├── README.md
├── hotel_management.sql              # Ana veritabanı şeması
└── queries/
    ├── 01_select_queries.sql         # SELECT ve JOIN örnekleri
    ├── 02_aggregate_queries.sql      # GROUP BY, HAVING, finansal sorgular
    └── 03_views_and_procedures.sql   # VIEW ve Stored Procedure örnekleri
```

## 🚀 Kurulum

1. SQL Server Management Studio'yu (SSMS) aç
2. Yeni bir sorgu penceresi oluştur
3. `hotel_management.sql` dosyasını aç ve çalıştır (F5)
4. Veritabanı `HotelManagementDB` adıyla otomatik oluşacaktır
5. Örnek sorguları denemek için `queries/` klasöründeki dosyaları çalıştır

## 📝 İçerik

### Veritabanı Özellikleri
- ✅ İlişkisel veritabanı tasarımı (Foreign Key ilişkileri)
- ✅ Veri bütünlüğü kuralları (Primary Key, NOT NULL constraint'ler)
- ✅ Otel yönetimi için kapsamlı şema

### Örnek Sorgular
- 🔍 **SELECT ve JOIN**: Aktif rezervasyonlar, boş odalar, en çok rezervasyon yapan müşteriler
- 📊 **Aggregate sorgular**: Aylık gelir raporu, kar/zarar hesabı, doluluk oranı
- 🎯 **VIEW'ler**: Sık kullanılan sorgular için hazır görünümler
- ⚡ **Stored Procedure**: Yeni rezervasyon ekleme, aylık gelir raporu

## 📚 Ders Bilgisi

Bu proje, Veritabanı Yönetim Sistemleri dersi kapsamında geliştirilmiştir.

## 👤 Geliştirici

**Ezginur Ünver**  
[GitHub](https://github.com/Ezgnur35) | [LinkedIn](https://linkedin.com/in/ezginur-ünver-603980403/)
