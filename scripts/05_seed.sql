/******************************************************************************************
 File: 05_seed.sql
 Purpose:
    Inserts demo/test data for development and testing purposes.

    Seed data:
        - Complies with all foreign keys
        - Respects check constraints
        - Works with defined triggers
        - Is compatible with stored procedures

 Run Order:
    After 04_procedures.sql
   

 Notes:
    - This file assumes full schema, constraints, triggers, and procedures are active.
    - If errors occur, verify data consistency with business rules.
******************************************************************************************/


GO
INSERT [dbo].[BankaAyarlari] ([AyarAdi], [AyarDegeri], [Aciklama]) VALUES (N'BankaKodu', N'04', N'Bankamızın resmi kodu')
INSERT [dbo].[BankaAyarlari] ([AyarAdi], [AyarDegeri], [Aciklama]) VALUES (N'MusteriNoSayaci', N'1000', N'Sıradaki müşteri numarası sonu')
GO
SET IDENTITY_INSERT [dbo].[BankaKartlari] ON 

INSERT [dbo].[BankaKartlari] ([KartID], [MusteriID], [AnaHesapID], [KartNo], [SonKullanma], [CvvHash], [PinHash], [KartTuru]) VALUES (1, 1, 1, N'1111222233334444', N'12/28', N'hashedCVV', N'hashedPIN', N'Debit')
SET IDENTITY_INSERT [dbo].[BankaKartlari] OFF
GO
SET IDENTITY_INSERT [dbo].[HesapHareketleri] ON 

INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (1, 1, N'TRY', NULL, NULL, CAST(N'2024-05-01T10:00:00.000' AS DateTime), N'Yatir', CAST(50000.00 AS Decimal(18, 2)), N'ATM Yatırım', CAST(50000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (2, 1, N'TRY', NULL, NULL, CAST(N'2024-05-02T14:00:00.000' AS DateTime), N'Satis', CAST(-32850.00 AS Decimal(18, 2)), N'Döviz Alış 1000 USD', CAST(17150.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (3, 2, N'USD', NULL, NULL, CAST(N'2024-05-02T14:00:00.000' AS DateTime), N'Alis', CAST(1000.00 AS Decimal(18, 2)), N'Döviz Alış', CAST(1000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (4, 1, N'TRY', NULL, NULL, CAST(N'2024-05-02T14:00:00.000' AS DateTime), N'Satis', CAST(-32850.00 AS Decimal(18, 2)), N'Döviz Alış 1000 USD', CAST(17150.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (5, 2, N'USD', NULL, NULL, CAST(N'2024-05-02T14:00:00.000' AS DateTime), N'Alis', CAST(1000.00 AS Decimal(18, 2)), N'Döviz Alış', CAST(1000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (6, 1, N'TRY', NULL, 1, CAST(N'2024-05-03T09:30:00.000' AS DateTime), N'TransferGiden', CAST(-5000.00 AS Decimal(18, 2)), N'Ayşe Yılmaz Transfer', CAST(12150.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (7, 3, N'TRY', NULL, 1, CAST(N'2024-05-03T09:30:00.000' AS DateTime), N'TransferGelen', CAST(5000.00 AS Decimal(18, 2)), N'Emirhan Gözpınar Transfer', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (8, 1, N'TRY', NULL, 2, CAST(N'2025-12-06T13:33:18.343' AS DateTime), N'TransferGiden', CAST(-500.00 AS Decimal(18, 2)), N'Kira Odemesi', CAST(11650.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (9, 3, N'TRY', NULL, 2, CAST(N'2025-12-06T13:33:18.343' AS DateTime), N'TransferGelen', CAST(500.00 AS Decimal(18, 2)), N'Kira Odemesi', CAST(5500.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (10, 1, N'TRY', NULL, 3, CAST(N'2025-12-06T13:44:39.843' AS DateTime), N'TransferGiden', CAST(-100.00 AS Decimal(18, 2)), N'Illegal Transfer Denemesi', CAST(11550.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (11, 3, N'TRY', NULL, 3, CAST(N'2025-12-06T13:44:39.843' AS DateTime), N'TransferGelen', CAST(100.00 AS Decimal(18, 2)), N'Illegal Transfer Denemesi', CAST(5600.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (12, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:11.600' AS DateTime), N'Yatir', CAST(49000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(49000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (13, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:11.620' AS DateTime), N'Alis', CAST(-32850.00 AS Decimal(18, 2)), N'Döviz İşlemi', CAST(16150.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (14, 2, N'USD', NULL, NULL, CAST(N'2025-12-30T11:54:11.620' AS DateTime), N'Alis', CAST(1000.00 AS Decimal(18, 2)), N'Döviz İşlemi', CAST(2000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (15, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.007' AS DateTime), N'Yatir', CAST(5.00 AS Decimal(18, 2)), N'Test Hazırlık - Fakir Hesap', CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (16, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.030' AS DateTime), N'Yatir', CAST(5000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (17, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.040' AS DateTime), N'Cek', CAST(-1200.00 AS Decimal(18, 2)), N'KK Borç Ödeme', CAST(3800.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (18, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.220' AS DateTime), N'Yatir', CAST(500.00 AS Decimal(18, 2)), N'Test Hazırlık - Az Bakiye', CAST(500.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (19, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.247' AS DateTime), N'Yatir', CAST(50000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(50000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (20, 1, N'TRY', NULL, 4, CAST(N'2025-12-30T11:54:12.263' AS DateTime), N'TransferGiden', CAST(-1000.00 AS Decimal(18, 2)), N'Borç Ödeme', CAST(49000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (21, 3, N'TRY', NULL, 4, CAST(N'2025-12-30T11:54:12.263' AS DateTime), N'TransferGelen', CAST(1000.00 AS Decimal(18, 2)), N'Borç Ödeme', CAST(6600.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (22, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.320' AS DateTime), N'Yatir', CAST(49000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(49000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (23, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.347' AS DateTime), N'Yatir', CAST(10000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(10000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (24, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.363' AS DateTime), N'Alis', CAST(-5000.00 AS Decimal(18, 2)), N'Yatırım: ASELS', CAST(5000.00 AS Decimal(18, 2)))
INSERT [dbo].[HesapHareketleri] ([HareketID], [HesapID], [ParaBirimiKodu], [KartID], [TransferID], [IslemTarihi], [IslemTuru], [Tutar], [Referans], [IslemSonrasiBakiye]) VALUES (25, 1, N'TRY', NULL, NULL, CAST(N'2025-12-30T11:54:12.587' AS DateTime), N'Yatir', CAST(5000.00 AS Decimal(18, 2)), N'Test Hazırlık', CAST(5000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[HesapHareketleri] OFF
GO
SET IDENTITY_INSERT [dbo].[HesapVarliklari] ON 

INSERT [dbo].[HesapVarliklari] ([VarlikID], [HesapID], [ParaBirimiKodu], [EnstrumanTuru], [EnstrumanKodu], [Miktar], [OrtMaliyet]) VALUES (3, 1, N'TRY', N'Hisse', N'ASELS', CAST(100.0000 AS Decimal(18, 4)), CAST(50.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[HesapVarliklari] OFF
GO
SET IDENTITY_INSERT [dbo].[HesapYukumlulukleri] ON 

INSERT [dbo].[HesapYukumlulukleri] ([YukumlulukID], [HesapID], [ParaBirimiKodu], [Tur], [Anapara], [FaizOrani], [VadeTarihi]) VALUES (3, 1, N'TRY', N'Kredi', CAST(50000.00 AS Decimal(18, 2)), CAST(2.49 AS Decimal(5, 2)), CAST(N'2026-12-06T13:35:10.420' AS DateTime))
INSERT [dbo].[HesapYukumlulukleri] ([YukumlulukID], [HesapID], [ParaBirimiKodu], [Tur], [Anapara], [FaizOrani], [VadeTarihi]) VALUES (4, 3, N'TRY', N'Marjin', CAST(10000.00 AS Decimal(18, 2)), CAST(0.50 AS Decimal(5, 2)), CAST(N'2026-01-06T13:35:10.450' AS DateTime))
SET IDENTITY_INSERT [dbo].[HesapYukumlulukleri] OFF
GO
SET IDENTITY_INSERT [dbo].[KampanyaBasvurulari] ON 

INSERT [dbo].[KampanyaBasvurulari] ([KampanyaBasvuruID], [MusteriID], [KampanyaID], [Durum], [BasvuruTarihi], [KararTarihi], [OnaylayanPersonelID]) VALUES (1, 1, 1, N'Beklemede', CAST(N'2025-12-06T13:19:43.550' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[KampanyaBasvurulari] OFF
GO
SET IDENTITY_INSERT [dbo].[Kampanyalar] ON 

INSERT [dbo].[Kampanyalar] ([KampanyaID], [Baslik], [Aciklama], [BaslangicTarihi], [BitisTarihi], [AktifMi]) VALUES (1, N'Yeni Müşteri Kredisi', N'Faizsiz 10.000 TL', CAST(N'2024-01-01T00:00:00.000' AS DateTime), CAST(N'2024-12-31T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Kampanyalar] OFF
GO
SET IDENTITY_INSERT [dbo].[Kullanicilar] ON 

INSERT [dbo].[Kullanicilar] ([KullaniciID], [KullaniciNo], [Ad], [Soyad], [Eposta], [Telefon], [SifreHash], [Tuz], [Rol], [KayitTarihi]) VALUES (1, N'10000000001', N'Mustafa', N'Yıldız', N'mustafa@banka.com', N'5551112233', N'hash123', N'salt1', N'Admin', CAST(N'2025-12-06T13:13:40.643' AS DateTime))
INSERT [dbo].[Kullanicilar] ([KullaniciID], [KullaniciNo], [Ad], [Soyad], [Eposta], [Telefon], [SifreHash], [Tuz], [Rol], [KayitTarihi]) VALUES (2, N'10000000002', N'Şeyhmus', N'Elik', N'seyhmus@banka.com', N'5552223344', N'hash456', N'salt2', N'Personel', CAST(N'2025-12-06T13:13:40.673' AS DateTime))
INSERT [dbo].[Kullanicilar] ([KullaniciID], [KullaniciNo], [Ad], [Soyad], [Eposta], [Telefon], [SifreHash], [Tuz], [Rol], [KayitTarihi]) VALUES (3, N'10000000003', N'Emirhan', N'Gözpınar', N'emirhan@gmail.com', N'5553334455', N'hash789', N'salt3', N'Musteri', CAST(N'2025-12-06T13:13:40.673' AS DateTime))
INSERT [dbo].[Kullanicilar] ([KullaniciID], [KullaniciNo], [Ad], [Soyad], [Eposta], [Telefon], [SifreHash], [Tuz], [Rol], [KayitTarihi]) VALUES (4, N'10000000004', N'Ayşe', N'Yılmaz', N'ayse@gmail.com', N'5554445566', N'hashabc', N'salt4', N'Musteri', CAST(N'2025-12-06T13:13:40.673' AS DateTime))
INSERT [dbo].[Kullanicilar] ([KullaniciID], [KullaniciNo], [Ad], [Soyad], [Eposta], [Telefon], [SifreHash], [Tuz], [Rol], [KayitTarihi]) VALUES (5, N'10000000005', N'Mehmet', N'Demir', N'mehmet@gmail.com', N'5556667788', N'hashxyz', N'salt5', N'Aday', CAST(N'2025-12-06T13:13:40.673' AS DateTime))
SET IDENTITY_INSERT [dbo].[Kullanicilar] OFF
GO
SET IDENTITY_INSERT [dbo].[Musteriler] ON 

INSERT [dbo].[Musteriler] ([MusteriID], [KullaniciID], [MusteriNo], [SubeID], [Adres], [Ilce], [Sehir], [OlusturmaTarihi]) VALUES (1, 3, N'0400001001', 2, N'Üniversite Mah. No:5', N'Merkez', N'Elazığ', CAST(N'2025-12-06T13:13:57.337' AS DateTime))
INSERT [dbo].[Musteriler] ([MusteriID], [KullaniciID], [MusteriNo], [SubeID], [Adres], [Ilce], [Sehir], [OlusturmaTarihi]) VALUES (2, 4, N'0400001002', 3, N'Çarşı Mah. No:12', N'Merkez', N'Elazığ', CAST(N'2025-12-06T13:13:57.337' AS DateTime))
SET IDENTITY_INSERT [dbo].[Musteriler] OFF
GO
SET IDENTITY_INSERT [dbo].[MusterilikBasvurulari] ON 

INSERT [dbo].[MusterilikBasvurulari] ([BasvuruID], [KullaniciID], [Durum], [BasvuruTarihi], [KararTarihi], [OnaylayanPersonelID]) VALUES (1, 5, N'Onaylandi', CAST(N'2023-12-01T00:00:00.000' AS DateTime), CAST(N'2023-12-02T00:00:00.000' AS DateTime), 2)
INSERT [dbo].[MusterilikBasvurulari] ([BasvuruID], [KullaniciID], [Durum], [BasvuruTarihi], [KararTarihi], [OnaylayanPersonelID]) VALUES (2, 5, N'Onaylandi', CAST(N'2023-12-01T00:00:00.000' AS DateTime), CAST(N'2023-12-02T00:00:00.000' AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[MusterilikBasvurulari] OFF
GO
INSERT [dbo].[ParaBirimleri] ([ParaBirimiKodu], [Ad], [AlisKuru], [SatisKuru], [GuncellemeTarihi]) VALUES (N'EUR', N'Euro', CAST(35.1000 AS Decimal(18, 4)), CAST(35.6000 AS Decimal(18, 4)), CAST(N'2025-12-06T13:12:58.310' AS DateTime))
INSERT [dbo].[ParaBirimleri] ([ParaBirimiKodu], [Ad], [AlisKuru], [SatisKuru], [GuncellemeTarihi]) VALUES (N'TRY', N'Türk Lirası', CAST(1.0000 AS Decimal(18, 4)), CAST(1.0000 AS Decimal(18, 4)), CAST(N'2025-12-06T13:12:58.310' AS DateTime))
INSERT [dbo].[ParaBirimleri] ([ParaBirimiKodu], [Ad], [AlisKuru], [SatisKuru], [GuncellemeTarihi]) VALUES (N'USD', N'Amerikan Doları', CAST(32.5000 AS Decimal(18, 4)), CAST(32.8500 AS Decimal(18, 4)), CAST(N'2025-12-06T13:12:58.310' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Personel] ON 

INSERT [dbo].[Personel] ([PersonelID], [KullaniciID], [SubeID], [Unvan]) VALUES (1, 1, 1, N'Sistem Yöneticisi')
INSERT [dbo].[Personel] ([PersonelID], [KullaniciID], [SubeID], [Unvan]) VALUES (2, 2, 2, N'Müşteri Temsilcisi')
SET IDENTITY_INSERT [dbo].[Personel] OFF
GO
SET IDENTITY_INSERT [dbo].[Subeler] ON 

INSERT [dbo].[Subeler] ([SubeID], [SubeAdi], [Sehir], [AktifMi]) VALUES (1, N'Merkez Şube', N'İstanbul', 1)
INSERT [dbo].[Subeler] ([SubeID], [SubeAdi], [Sehir], [AktifMi]) VALUES (2, N'Kampüs Şube', N'Elazığ', 1)
INSERT [dbo].[Subeler] ([SubeID], [SubeAdi], [Sehir], [AktifMi]) VALUES (3, N'Çarşı Şube', N'Elazığ', 1)
SET IDENTITY_INSERT [dbo].[Subeler] OFF
GO
SET IDENTITY_INSERT [dbo].[Transferler] ON 

INSERT [dbo].[Transferler] ([TransferID], [GonderenHesapID], [AliciHesapID], [Tutar], [ParaBirimiKodu], [IslemTarihi], [Aciklama]) VALUES (1, 1, 3, CAST(5000.00 AS Decimal(18, 2)), N'TRY', CAST(N'2024-05-03T09:30:00.000' AS DateTime), N'Borç ödemesi')
INSERT [dbo].[Transferler] ([TransferID], [GonderenHesapID], [AliciHesapID], [Tutar], [ParaBirimiKodu], [IslemTarihi], [Aciklama]) VALUES (2, 1, 3, CAST(500.00 AS Decimal(18, 2)), N'TRY', CAST(N'2025-12-06T13:33:18.343' AS DateTime), N'Kira Odemesi')
INSERT [dbo].[Transferler] ([TransferID], [GonderenHesapID], [AliciHesapID], [Tutar], [ParaBirimiKodu], [IslemTarihi], [Aciklama]) VALUES (3, 1, 3, CAST(100.00 AS Decimal(18, 2)), N'TRY', CAST(N'2025-12-06T13:44:39.843' AS DateTime), N'Illegal Transfer Denemesi')
INSERT [dbo].[Transferler] ([TransferID], [GonderenHesapID], [AliciHesapID], [Tutar], [ParaBirimiKodu], [IslemTarihi], [Aciklama]) VALUES (4, 1, 3, CAST(1000.00 AS Decimal(18, 2)), N'TRY', CAST(N'2025-12-30T11:54:12.260' AS DateTime), N'Borç Ödeme')
SET IDENTITY_INSERT [dbo].[Transferler] OFF
GO
SET IDENTITY_INSERT [dbo].[YatirimHesaplari] ON 

INSERT [dbo].[YatirimHesaplari] ([HesapID], [MusteriID], [ParaBirimiKodu], [SubeID], [HesapNo], [AcilisTarihi], [AktifMi]) VALUES (1, 1, N'TRY', 2, N'TR-1001-TRY', CAST(N'2024-01-01T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[YatirimHesaplari] ([HesapID], [MusteriID], [ParaBirimiKodu], [SubeID], [HesapNo], [AcilisTarihi], [AktifMi]) VALUES (2, 1, N'USD', 2, N'TR-1001-USD', CAST(N'2024-01-05T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[YatirimHesaplari] ([HesapID], [MusteriID], [ParaBirimiKodu], [SubeID], [HesapNo], [AcilisTarihi], [AktifMi]) VALUES (3, 2, N'TRY', 3, N'TR-1002-TRY', CAST(N'2024-01-10T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[YatirimHesaplari] ([HesapID], [MusteriID], [ParaBirimiKodu], [SubeID], [HesapNo], [AcilisTarihi], [AktifMi]) VALUES (5, 1, N'TRY', NULL, N'ILLEGAL-HESAP', CAST(N'2025-12-06T13:42:14.163' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[YatirimHesaplari] OFF
GO
SET ANSI_PADDING ON
GO