/******************************************************************************************
 File: 02_constraints.sql
 Purpose: Adds indexes, defaults, foreign keys and check constraints
 Run Order: After schema (see README for recommended order)
******************************************************************************************/
USE [BankProjectDb];
GO
/****** Object:  Index [UQ__BankaKar__88CDCC53514B525D]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[BankaKartlari] ADD UNIQUE NONCLUSTERED 
(
	[KartNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Kampanya__B3DB6BFDC3334C11]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[KampanyaBasvurulari] ADD UNIQUE NONCLUSTERED 
(
	[MusteriID] ASC,
	[KampanyaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Kullanic__03ABA391C1ADE66E]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[Kullanicilar] ADD UNIQUE NONCLUSTERED 
(
	[Eposta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Kullanic__E011D8E5BD3B4F58]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[Kullanicilar] ADD UNIQUE NONCLUSTERED 
(
	[KullaniciNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Musteril__72627C23D4A4CD5B]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[Musteriler] ADD UNIQUE NONCLUSTERED 
(
	[MusteriNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Musteril__E011F09A4B6BBD54]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[Musteriler] ADD UNIQUE NONCLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Personel__E011F09A37FC9FE2]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[Personel] ADD UNIQUE NONCLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__YatirimH__96C8E3813F614F8B]    Script Date: 12.02.2026 15:54:04 ******/
ALTER TABLE [dbo].[YatirimHesaplari] ADD UNIQUE NONCLUSTERED 
(
	[MusteriID] ASC,
	[HesapNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HesapHareketleri] ADD  DEFAULT (getdate()) FOR [IslemTarihi]
GO
ALTER TABLE [dbo].[HesapVarliklari] ADD  DEFAULT ((0)) FOR [Miktar]
GO
ALTER TABLE [dbo].[HesapVarliklari] ADD  DEFAULT ((0)) FOR [OrtMaliyet]
GO
ALTER TABLE [dbo].[HesapYukumlulukleri] ADD  DEFAULT ((0)) FOR [Anapara]
GO
ALTER TABLE [dbo].[HesapYukumlulukleri] ADD  DEFAULT ((0)) FOR [FaizOrani]
GO
ALTER TABLE [dbo].[KampanyaBasvurulari] ADD  DEFAULT ('Beklemede') FOR [Durum]
GO
ALTER TABLE [dbo].[KampanyaBasvurulari] ADD  DEFAULT (getdate()) FOR [BasvuruTarihi]
GO
ALTER TABLE [dbo].[Kampanyalar] ADD  DEFAULT ((1)) FOR [AktifMi]
GO
ALTER TABLE [dbo].[Kullanicilar] ADD  DEFAULT (getdate()) FOR [KayitTarihi]
GO
ALTER TABLE [dbo].[Musteriler] ADD  DEFAULT (getdate()) FOR [OlusturmaTarihi]
GO
ALTER TABLE [dbo].[MusterilikBasvurulari] ADD  DEFAULT ('Beklemede') FOR [Durum]
GO
ALTER TABLE [dbo].[MusterilikBasvurulari] ADD  DEFAULT (getdate()) FOR [BasvuruTarihi]
GO
ALTER TABLE [dbo].[SistemLoglari] ADD  DEFAULT (getdate()) FOR [IslemTarihi]
GO
ALTER TABLE [dbo].[SistemLoglari] ADD  DEFAULT (suser_sname()) FOR [Kullanici]
GO
ALTER TABLE [dbo].[Subeler] ADD  DEFAULT ((1)) FOR [AktifMi]
GO
ALTER TABLE [dbo].[TeknikDestek] ADD  DEFAULT ('Acik') FOR [Durum]
GO
ALTER TABLE [dbo].[TeknikDestek] ADD  DEFAULT (getdate()) FOR [AcilisTarihi]
GO
ALTER TABLE [dbo].[Transferler] ADD  DEFAULT (getdate()) FOR [IslemTarihi]
GO
ALTER TABLE [dbo].[YatirimHesaplari] ADD  DEFAULT (getdate()) FOR [AcilisTarihi]
GO
ALTER TABLE [dbo].[YatirimHesaplari] ADD  DEFAULT ((1)) FOR [AktifMi]
GO
ALTER TABLE [dbo].[BankaKartlari]  WITH CHECK ADD FOREIGN KEY([AnaHesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[BankaKartlari]  WITH CHECK ADD FOREIGN KEY([MusteriID])
REFERENCES [dbo].[Musteriler] ([MusteriID])
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD FOREIGN KEY([HesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD FOREIGN KEY([KartID])
REFERENCES [dbo].[BankaKartlari] ([KartID])
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD FOREIGN KEY([ParaBirimiKodu])
REFERENCES [dbo].[ParaBirimleri] ([ParaBirimiKodu])
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD FOREIGN KEY([TransferID])
REFERENCES [dbo].[Transferler] ([TransferID])
GO
ALTER TABLE [dbo].[HesapVarliklari]  WITH CHECK ADD FOREIGN KEY([HesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[HesapVarliklari]  WITH CHECK ADD FOREIGN KEY([ParaBirimiKodu])
REFERENCES [dbo].[ParaBirimleri] ([ParaBirimiKodu])
GO
ALTER TABLE [dbo].[HesapYukumlulukleri]  WITH CHECK ADD FOREIGN KEY([HesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[KampanyaBasvurulari]  WITH CHECK ADD FOREIGN KEY([KampanyaID])
REFERENCES [dbo].[Kampanyalar] ([KampanyaID])
GO
ALTER TABLE [dbo].[KampanyaBasvurulari]  WITH CHECK ADD FOREIGN KEY([MusteriID])
REFERENCES [dbo].[Musteriler] ([MusteriID])
GO
ALTER TABLE [dbo].[KampanyaBasvurulari]  WITH CHECK ADD FOREIGN KEY([OnaylayanPersonelID])
REFERENCES [dbo].[Personel] ([PersonelID])
GO
ALTER TABLE [dbo].[Musteriler]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[Musteriler]  WITH CHECK ADD FOREIGN KEY([SubeID])
REFERENCES [dbo].[Subeler] ([SubeID])
GO
ALTER TABLE [dbo].[MusterilikBasvurulari]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[MusterilikBasvurulari]  WITH CHECK ADD FOREIGN KEY([OnaylayanPersonelID])
REFERENCES [dbo].[Personel] ([PersonelID])
GO
ALTER TABLE [dbo].[Personel]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO
ALTER TABLE [dbo].[Personel]  WITH CHECK ADD FOREIGN KEY([SubeID])
REFERENCES [dbo].[Subeler] ([SubeID])
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD FOREIGN KEY([IlgiliHesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD FOREIGN KEY([IlgiliKartID])
REFERENCES [dbo].[BankaKartlari] ([KartID])
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD FOREIGN KEY([IlgiliKampanyaID])
REFERENCES [dbo].[Kampanyalar] ([KampanyaID])
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD FOREIGN KEY([MusteriID])
REFERENCES [dbo].[Musteriler] ([MusteriID])
GO
ALTER TABLE [dbo].[Transferler]  WITH CHECK ADD FOREIGN KEY([AliciHesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[Transferler]  WITH CHECK ADD FOREIGN KEY([GonderenHesapID])
REFERENCES [dbo].[YatirimHesaplari] ([HesapID])
GO
ALTER TABLE [dbo].[YatirimHesaplari]  WITH CHECK ADD FOREIGN KEY([MusteriID])
REFERENCES [dbo].[Musteriler] ([MusteriID])
GO
ALTER TABLE [dbo].[YatirimHesaplari]  WITH CHECK ADD FOREIGN KEY([ParaBirimiKodu])
REFERENCES [dbo].[ParaBirimleri] ([ParaBirimiKodu])
GO
ALTER TABLE [dbo].[YatirimHesaplari]  WITH CHECK ADD FOREIGN KEY([SubeID])
REFERENCES [dbo].[Subeler] ([SubeID])
GO
ALTER TABLE [dbo].[BankaKartlari]  WITH CHECK ADD CHECK  (([KartTuru]='Credit' OR [KartTuru]='Debit'))
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD CHECK  (([IslemTuru]='TransferGelen' OR [IslemTuru]='TransferGiden' OR [IslemTuru]='Faiz' OR [IslemTuru]='Ucret' OR [IslemTuru]='Satis' OR [IslemTuru]='Alis' OR [IslemTuru]='Cek' OR [IslemTuru]='Yatir'))
GO
ALTER TABLE [dbo].[HesapHareketleri]  WITH CHECK ADD CHECK  (([Tutar]<>(0)))
GO
ALTER TABLE [dbo].[HesapVarliklari]  WITH CHECK ADD CHECK  (([EnstrumanTuru]='Doviz' OR [EnstrumanTuru]='Tahvil' OR [EnstrumanTuru]='Fon' OR [EnstrumanTuru]='Hisse'))
GO
ALTER TABLE [dbo].[HesapYukumlulukleri]  WITH CHECK ADD CHECK  (([Tur]='Marjin' OR [Tur]='Kredi'))
GO
ALTER TABLE [dbo].[Kullanicilar]  WITH CHECK ADD CHECK  (([Rol]='Admin' OR [Rol]='Personel' OR [Rol]='Musteri' OR [Rol]='Aday'))
GO
ALTER TABLE [dbo].[MusterilikBasvurulari]  WITH CHECK ADD CHECK  (([Durum]='Reddedildi' OR [Durum]='Onaylandi' OR [Durum]='Beklemede'))
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD CHECK  (([Durum]='Kapali' OR [Durum]='Cozumde' OR [Durum]='Acik'))
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD CHECK  (([Kanal]='Uygulama' OR [Kanal]='E-Posta' OR [Kanal]='Telefon'))
GO
ALTER TABLE [dbo].[TeknikDestek]  WITH CHECK ADD CHECK  (([Oncelik]='Yuksek' OR [Oncelik]='Orta' OR [Oncelik]='Dusuk'))
GO
ALTER TABLE [dbo].[Transferler]  WITH CHECK ADD CHECK  (([Tutar]>(0)))
GO