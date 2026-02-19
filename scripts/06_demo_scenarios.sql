/******************************************************************************************
 File: 06_demo_scenarios.sql
 Purpose:
    Demonstrates how to use stored procedures in BankProjectDb with realistic scenarios.
    Includes both SUCCESS and FAILURE cases to validate business rules and error handling.

 Run Order:
    After 05_seed.sql

 Notes:
    - If IDs differ in your environment, use the "Pre-Check" SELECTs to find valid IDs.
    - Each scenario prints result queries at the end for quick verification.
******************************************************************************************/

USE [BankProjectDb];
GO

SET NOCOUNT ON;
GO

/* =============================================================================
   0) PRE-CHECK (ID'leri hızlı görmek için)
   ============================================================================= */

PRINT '--- PRE-CHECK: Sample IDs ---';

SELECT TOP 10 HesapID, MusteriID, ParaBirimiKodu, HesapNo, AktifMi
FROM dbo.YatirimHesaplari
ORDER BY HesapID;

SELECT TOP 10 TransferID, GonderenHesapID, AliciHesapID, Tutar, ParaBirimiKodu, IslemTarihi
FROM dbo.Transferler
ORDER BY TransferID DESC;

SELECT TOP 10 ParaBirimiKodu, Ad, AlisKuru, SatisKuru, GuncellemeTarihi
FROM dbo.ParaBirimleri
ORDER BY ParaBirimiKodu;

SELECT TOP 10 KartID, MusteriID, AnaHesapID, KartNo, KartTuru
FROM dbo.BankaKartlari
ORDER BY KartID;

PRINT '--- PRE-CHECK DONE ---';
GO


/* =============================================================================
   1) SENARYO: Başarılı Para Transferi (TRY -> TRY)
   sp_ParaTransferi
   ============================================================================= */

PRINT '--- SCENARIO 1: Successful Transfer (TRY -> TRY) ---';

BEGIN TRY
    EXEC dbo.sp_ParaTransferi
        @GonderenHesapID = 1,
        @AliciHesapID    = 3,
        @Tutar           = 250,
        @Aciklama        = N'Demo Transfer - Success';
END TRY
BEGIN CATCH
    PRINT 'SCENARIO 1 FAILED: ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama
SELECT TOP 10 *
FROM dbo.Transferler
ORDER BY TransferID DESC;

SELECT TOP 20 *
FROM dbo.HesapHareketleri
WHERE Referans LIKE N'%Demo Transfer%'
ORDER BY IslemTarihi DESC, HareketID DESC;

PRINT '--- SCENARIO 1 DONE ---';
GO


/* =============================================================================
   2) SENARYO: Hatalı Transfer (Yetersiz Bakiye)
   sp_ParaTransferi
   ============================================================================= */

PRINT '--- SCENARIO 2: Failed Transfer - Insufficient Balance ---';

BEGIN TRY
    EXEC dbo.sp_ParaTransferi
        @GonderenHesapID = 1,
        @AliciHesapID    = 3,
        @Tutar           = 99999999,
        @Aciklama        = N'Demo Transfer - Insufficient Balance';
END TRY
BEGIN CATCH
    PRINT 'EXPECTED ERROR (SCENARIO 2): ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama: Bu referansla hareket oluşmamalı
SELECT TOP 20 *
FROM dbo.HesapHareketleri
WHERE Referans LIKE N'%Insufficient Balance%'
ORDER BY IslemTarihi DESC, HareketID DESC;

PRINT '--- SCENARIO 2 DONE ---';
GO


/* =============================================================================
   3) SENARYO: Hatalı Transfer (Para birimi uyuşmazlığı)
   sp_ParaTransferi
   (Örnek: TRY hesabından USD hesabına direkt transfer engellenmeli)
   ============================================================================= */

PRINT '--- SCENARIO 3: Failed Transfer - Currency Mismatch ---';

BEGIN TRY
    EXEC dbo.sp_ParaTransferi
        @GonderenHesapID = 1,   -- TRY
        @AliciHesapID    = 2,   -- USD (seed’ine göre)
        @Tutar           = 50,
        @Aciklama        = N'Demo Transfer - Currency Mismatch';
END TRY
BEGIN CATCH
    PRINT 'EXPECTED ERROR (SCENARIO 3): ' + ERROR_MESSAGE();
END CATCH;

PRINT '--- SCENARIO 3 DONE ---';
GO


/* =============================================================================
   4) SENARYO: Döviz Alış İşlemi (TL -> USD)
   sp_DovizIslemi
   ============================================================================= */

PRINT '--- SCENARIO 4: FX Buy (TRY -> USD) ---';

BEGIN TRY
    EXEC dbo.sp_DovizIslemi
        @MusteriID      = 1,
        @KaynakHesapID  = 1,       -- TRY hesabı
        @HedefHesapID   = 2,       -- USD hesabı
        @KaynakTutar    = 3200,    -- TL bozdur
        @IslemTuru      = N'Alis'; -- döviz alış
END TRY
BEGIN CATCH
    PRINT 'SCENARIO 4 FAILED: ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama: Son hareketler
SELECT TOP 10 *
FROM dbo.HesapHareketleri
WHERE Referans = N'Döviz İşlemi'
ORDER BY IslemTarihi DESC, HareketID DESC;

PRINT '--- SCENARIO 4 DONE ---';
GO


/* =============================================================================
   5) SENARYO: Yatırım Alımı (Hisse alımı)
   sp_YatirimAlimi
   ============================================================================= */

PRINT '--- SCENARIO 5: Investment Buy (Stock) ---';

BEGIN TRY
    EXEC dbo.sp_YatirimAlimi
        @HesapID        = 1,
        @EnstrumanKodu  = N'THYAO',
        @Adet           = 10,
        @BirimFiyat     = 250;
END TRY
BEGIN CATCH
    PRINT 'SCENARIO 5 FAILED: ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama
SELECT TOP 10 *
FROM dbo.HesapVarliklari
ORDER BY VarlikID DESC;

SELECT TOP 20 *
FROM dbo.HesapHareketleri
WHERE Referans LIKE N'Yatırım:%'
ORDER BY IslemTarihi DESC, HareketID DESC;

PRINT '--- SCENARIO 5 DONE ---';
GO


/* =============================================================================
   6) SENARYO: Kart Borcu Ödeme
   sp_KartBorcOdeme
   ============================================================================= */

PRINT '--- SCENARIO 6: Card Debt Payment ---';

BEGIN TRY
    EXEC dbo.sp_KartBorcOdeme
        @HesapID = 1,
        @KartID  = 1,
        @Tutar   = 100;
END TRY
BEGIN CATCH
    PRINT 'SCENARIO 6 FAILED: ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama
SELECT TOP 20 *
FROM dbo.HesapHareketleri
WHERE Referans = N'KK Borç Ödeme'
ORDER BY IslemTarihi DESC, HareketID DESC;

PRINT '--- SCENARIO 6 DONE ---';
GO


/* =============================================================================
   7) SENARYO: Trigger Test - Kampanya Tarih Kontrolü
   trg_KampanyaTarihKontrol (Bitis < Baslangic => hata)
   ============================================================================= */

PRINT '--- SCENARIO 7: Trigger Test - Invalid Campaign Date ---';

BEGIN TRY
    INSERT INTO dbo.Kampanyalar (Baslik, Aciklama, BaslangicTarihi, BitisTarihi, AktifMi)
    VALUES (N'Trigger Test Campaign', N'Invalid dates should fail',
            '2026-02-10', '2026-02-01', 1);
END TRY
BEGIN CATCH
    PRINT 'EXPECTED ERROR (SCENARIO 7): ' + ERROR_MESSAGE();
END CATCH;

-- Doğrulama: eklenmemiş olmalı
SELECT TOP 10 *
FROM dbo.Kampanyalar
WHERE Baslik = N'Trigger Test Campaign'
ORDER BY KampanyaID DESC;

PRINT '--- SCENARIO 7 DONE ---';
GO


/* =============================================================================
   8) SENARYO: INSTEAD OF Trigger Test - Hesap Hareketi Silme/Update Engeli
   trg_HareketDegisiklikEngelle
   ============================================================================= */

PRINT '--- SCENARIO 8: Trigger Test - Prevent Update/Delete on HesapHareketleri ---';

DECLARE @AnyHareketId INT;
SELECT TOP 1 @AnyHareketId = HareketID FROM dbo.HesapHareketleri ORDER BY HareketID DESC;

BEGIN TRY
    UPDATE dbo.HesapHareketleri
    SET Referans = N'Attempted Update'
    WHERE HareketID = @AnyHareketId;
END TRY
BEGIN CATCH
    PRINT 'EXPECTED ERROR (SCENARIO 8 - UPDATE): ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    DELETE FROM dbo.HesapHareketleri
    WHERE HareketID = @AnyHareketId;
END TRY
BEGIN CATCH
    PRINT 'EXPECTED ERROR (SCENARIO 8 - DELETE): ' + ERROR_MESSAGE();
END CATCH;

PRINT '--- SCENARIO 8 DONE ---';
GO


PRINT 'ALL DEMO SCENARIOS COMPLETED.';
GO
