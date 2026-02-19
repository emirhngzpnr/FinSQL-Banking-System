/******************************************************************************************
 File: 01_schema.sql
 Purpose: Creates all tables and views for BankProjectDb
 Run Order: After 00_database.sql
******************************************************************************************/

CREATE TABLE [dbo].[Kampanyalar](
	[KampanyaID] [int] IDENTITY(1,1) NOT NULL,
	[Baslik] [nvarchar](100) NOT NULL,
	[Aciklama] [nvarchar](max) NULL,
	[BaslangicTarihi] [datetime] NOT NULL,
	[BitisTarihi] [datetime] NULL,
	[AktifMi] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[KampanyaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_AktifKampanyalar]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_AktifKampanyalar] AS
SELECT 
    KampanyaID, 
    Baslik, 
    BaslangicTarihi, 
    BitisTarihi,
    DATEDIFF(day, GETDATE(), BitisTarihi) AS KalanGun
FROM 
    Kampanyalar
WHERE 
    AktifMi = 1 
    AND GETDATE() BETWEEN BaslangicTarihi AND BitisTarihi;

GO
/****** Object:  Table [dbo].[BankaAyarlari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankaAyarlari](
	[AyarAdi] [nvarchar](50) NOT NULL,
	[AyarDegeri] [nvarchar](255) NOT NULL,
	[Aciklama] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AyarAdi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BankaKartlari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankaKartlari](
	[KartID] [int] IDENTITY(1,1) NOT NULL,
	[MusteriID] [int] NOT NULL,
	[AnaHesapID] [int] NULL,
	[KartNo] [char](16) NOT NULL,
	[SonKullanma] [char](5) NOT NULL,
	[CvvHash] [nvarchar](256) NOT NULL,
	[PinHash] [nvarchar](256) NOT NULL,
	[KartTuru] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[KartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HesapHareketleri]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HesapHareketleri](
	[HareketID] [int] IDENTITY(1,1) NOT NULL,
	[HesapID] [int] NOT NULL,
	[ParaBirimiKodu] [char](3) NOT NULL,
	[KartID] [int] NULL,
	[TransferID] [int] NULL,
	[IslemTarihi] [datetime] NULL,
	[IslemTuru] [nvarchar](20) NULL,
	[Tutar] [decimal](18, 2) NOT NULL,
	[Referans] [nvarchar](50) NULL,
	[IslemSonrasiBakiye] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[HareketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HesapVarliklari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HesapVarliklari](
	[VarlikID] [int] IDENTITY(1,1) NOT NULL,
	[HesapID] [int] NOT NULL,
	[ParaBirimiKodu] [char](3) NOT NULL,
	[EnstrumanTuru] [nvarchar](20) NULL,
	[EnstrumanKodu] [nvarchar](20) NOT NULL,
	[Miktar] [decimal](18, 4) NULL,
	[OrtMaliyet] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[VarlikID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HesapYukumlulukleri]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HesapYukumlulukleri](
	[YukumlulukID] [int] IDENTITY(1,1) NOT NULL,
	[HesapID] [int] NOT NULL,
	[ParaBirimiKodu] [char](3) NOT NULL,
	[Tur] [nvarchar](20) NULL,
	[Anapara] [decimal](18, 2) NULL,
	[FaizOrani] [decimal](5, 2) NULL,
	[VadeTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[YukumlulukID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KampanyaBasvurulari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KampanyaBasvurulari](
	[KampanyaBasvuruID] [int] IDENTITY(1,1) NOT NULL,
	[MusteriID] [int] NOT NULL,
	[KampanyaID] [int] NOT NULL,
	[Durum] [nvarchar](20) NULL,
	[BasvuruTarihi] [datetime] NULL,
	[KararTarihi] [datetime] NULL,
	[OnaylayanPersonelID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[KampanyaBasvuruID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kullanicilar]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanicilar](
	[KullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciNo] [char](11) NOT NULL,
	[Ad] [nvarchar](50) NOT NULL,
	[Soyad] [nvarchar](50) NOT NULL,
	[Eposta] [nvarchar](100) NOT NULL,
	[Telefon] [nvarchar](15) NULL,
	[SifreHash] [nvarchar](256) NOT NULL,
	[Tuz] [nvarchar](50) NOT NULL,
	[Rol] [nvarchar](20) NOT NULL,
	[KayitTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Musteriler]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Musteriler](
	[MusteriID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[MusteriNo] [char](10) NOT NULL,
	[SubeID] [int] NULL,
	[Adres] [nvarchar](250) NULL,
	[Ilce] [nvarchar](50) NULL,
	[Sehir] [nvarchar](50) NULL,
	[OlusturmaTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MusteriID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MusterilikBasvurulari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MusterilikBasvurulari](
	[BasvuruID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[Durum] [nvarchar](20) NULL,
	[BasvuruTarihi] [datetime] NULL,
	[KararTarihi] [datetime] NULL,
	[OnaylayanPersonelID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[BasvuruID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ParaBirimleri]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParaBirimleri](
	[ParaBirimiKodu] [char](3) NOT NULL,
	[Ad] [nvarchar](50) NOT NULL,
	[AlisKuru] [decimal](18, 4) NULL,
	[SatisKuru] [decimal](18, 4) NULL,
	[GuncellemeTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ParaBirimiKodu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personel]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personel](
	[PersonelID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[SubeID] [int] NULL,
	[Unvan] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SistemLoglari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SistemLoglari](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[TabloAdi] [nvarchar](50) NULL,
	[IslemTuru] [nvarchar](20) NULL,
	[IslemTarihi] [datetime] NULL,
	[Aciklama] [nvarchar](max) NULL,
	[Kullanici] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subeler]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subeler](
	[SubeID] [int] IDENTITY(1,1) NOT NULL,
	[SubeAdi] [nvarchar](100) NOT NULL,
	[Sehir] [nvarchar](50) NOT NULL,
	[AktifMi] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SubeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeknikDestek]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeknikDestek](
	[TalepID] [int] IDENTITY(1,1) NOT NULL,
	[MusteriID] [int] NOT NULL,
	[IlgiliHesapID] [int] NULL,
	[IlgiliKartID] [int] NULL,
	[IlgiliKampanyaID] [int] NULL,
	[Kanal] [nvarchar](20) NULL,
	[Konu] [nvarchar](100) NOT NULL,
	[Aciklama] [nvarchar](max) NOT NULL,
	[Oncelik] [nvarchar](10) NULL,
	[Durum] [nvarchar](20) NULL,
	[AcilisTarihi] [datetime] NULL,
	[KapanisTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TalepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transferler]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transferler](
	[TransferID] [int] IDENTITY(1,1) NOT NULL,
	[GonderenHesapID] [int] NOT NULL,
	[AliciHesapID] [int] NOT NULL,
	[Tutar] [decimal](18, 2) NOT NULL,
	[ParaBirimiKodu] [char](3) NOT NULL,
	[IslemTarihi] [datetime] NULL,
	[Aciklama] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[YatirimHesaplari]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YatirimHesaplari](
	[HesapID] [int] IDENTITY(1,1) NOT NULL,
	[MusteriID] [int] NOT NULL,
	[ParaBirimiKodu] [char](3) NOT NULL,
	[SubeID] [int] NULL,
	[HesapNo] [nvarchar](20) NOT NULL,
	[AcilisTarihi] [datetime] NULL,
	[AktifMi] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[HesapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO