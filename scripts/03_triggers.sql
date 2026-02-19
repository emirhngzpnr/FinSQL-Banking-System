/******************************************************************************************
 File: 03_triggers.sql
 Purpose:
    Contains database triggers responsible for:
        - Business rule validation
        - Data integrity protection
        - Audit logging

 Run Order:
    After 02_constraints.sql
    Before 04_seed.sql

 Notes:
    - All triggers are multi-row safe (set-based).
    - Designed for SQL Server compatibility.
******************************************************************************************/
USE [BankProjectDb]
GO

/****** Object:  Trigger [dbo].[trg_KampanyaTarihKontrol]    Script Date: 18.02.2026 20:01:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* =========================================================================================
   Trigger: trg_KampanyaTarihKontrol
   Table: Kampanyalar
   Type: AFTER INSERT, UPDATE

   Purpose:
       Ensures that campaign end date (BitisTarihi) is not earlier than
       campaign start date (BaslangicTarihi).

   Business Rule:
       BitisTarihi >= BaslangicTarihi

   Behavior:
       - If invalid data detected, transaction is rolled back.
       - Prevents inconsistent campaign definitions.
========================================================================================= */

CREATE TRIGGER [dbo].[trg_KampanyaTarihKontrol]
ON [dbo].[Kampanyalar]
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE BitisTarihi < BaslangicTarihi)
    BEGIN
        RAISERROR('Hata: Kampanya bitiş tarihi, başlangıç tarihinden önce olamaz!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

ALTER TABLE [dbo].[Kampanyalar] ENABLE TRIGGER [trg_KampanyaTarihKontrol]
GO

/* =========================================================================================
   Trigger: trg_ParaBirimiTarihGuncelle
   Table: ParaBirimleri
   Type: AFTER UPDATE

   Purpose:
       Automatically updates GuncellemeTarihi when exchange rates change.

   Business Logic:
       - If AlisKuru or SatisKuru is modified,
         GuncellemeTarihi is set to current datetime.
========================================================================================= */
CREATE TRIGGER [dbo].[trg_ParaBirimiTarihGuncelle]
ON [dbo].[ParaBirimleri]
AFTER UPDATE
AS
BEGIN
    -- Sadece Kur alanları değiştiyse tarihi güncelle
    IF UPDATE(AlisKuru) OR UPDATE(SatisKuru)
    BEGIN
        UPDATE ParaBirimleri
        SET GuncellemeTarihi = GETDATE()
        FROM ParaBirimleri P
        INNER JOIN inserted I ON P.ParaBirimiKodu = I.ParaBirimiKodu;
    END
END;
GO

ALTER TABLE [dbo].[ParaBirimleri] ENABLE TRIGGER [trg_ParaBirimiTarihGuncelle]
GO
/* =========================================================================================
   Trigger: trg_HareketDegisiklikEngelle
   Table: HesapHareketleri
   Type: INSTEAD OF UPDATE, DELETE

   Purpose:
       Prevents modification or deletion of historical account transactions.

   Security Principle:
       Financial transaction history must remain immutable.
       Corrections should be handled via reverse transactions.
========================================================================================= */
CREATE TRIGGER [dbo].[trg_HareketDegisiklikEngelle]
ON [dbo].[HesapHareketleri]
INSTEAD OF DELETE, UPDATE
AS
BEGIN
    RAISERROR('Güvenlik Uyarısı: Geçmiş hesap hareketleri silinemez veya güncellenemez! Lütfen ters işlem (iade) yapınız.', 16, 1);

END;

GO

ALTER TABLE [dbo].[HesapHareketleri] ENABLE TRIGGER [trg_HareketDegisiklikEngelle]
GO
/* =========================================================================================
   Trigger: trg_BasvuruDurumLog
   Table: MusterilikBasvurulari
   Type: AFTER UPDATE

   Purpose:
       Logs status changes of customer applications into SistemLoglari table.

   Logging Strategy:
       - Only fires when "Durum" column changes.
       - Multi-row safe (set-based logic).
       - Captures old and new status values.
========================================================================================= */
CREATE OR ALTER TRIGGER [dbo].[trg_BasvuruDurumLog]
ON [dbo].[MusterilikBasvurulari]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    IF UPDATE(Durum)
    BEGIN
        INSERT INTO dbo.SistemLoglari (TabloAdi, IslemTuru, Aciklama)
        SELECT
            'MusterilikBasvurulari' AS TabloAdi,
            'UPDATE' AS IslemTuru,
            'BasvuruID: ' + CAST(i.BasvuruID AS NVARCHAR(20)) +
            ' durumu değişti. Eski: ' + ISNULL(d.Durum, 'NULL') +
            ' -> Yeni: ' + ISNULL(i.Durum, 'NULL') AS Aciklama
        FROM inserted i
        INNER JOIN deleted d ON d.BasvuruID = i.BasvuruID
        WHERE ISNULL(d.Durum, '') <> ISNULL(i.Durum, '');
    END
END;
GO


ALTER TABLE [dbo].[MusterilikBasvurulari] ENABLE TRIGGER [trg_BasvuruDurumLog]
GO
/* =========================================================================================
   Trigger: trg_HesapSilmeKorumasi
   Table: YatirimHesaplari
   Type: INSTEAD OF DELETE

   Purpose:
       Prevents physical deletion of bank accounts.

   Business Policy:
       Accounts should not be deleted.
       Instead, they should be deactivated (AktifMi = 0).
========================================================================================= */
CREATE TRIGGER [dbo].[trg_HesapSilmeKorumasi]
ON [dbo].[YatirimHesaplari]
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Güvenlik Uyarısı: Banka hesapları fiziksel olarak silinemez. Lütfen hesabı pasife (AktifMi=0) çekiniz.', 16, 1);
END;
GO

ALTER TABLE [dbo].[YatirimHesaplari] ENABLE TRIGGER [trg_HesapSilmeKorumasi]
GO

