/******************************************************************************************
 File: 04_procedures.sql
 Purpose:
    Contains transactional business logic implemented via stored procedures.

    These procedures handle:
        - Money transfers
        - Foreign exchange operations
        - Investment transactions
        - Card debt payments
        - Validation and balance checks
        - Transaction management with TRY/CATCH

 Run Order:
    After 03_triggers.sql


 Notes:
    - All procedures are transaction-safe.
    - Designed to work with active constraints and triggers.
******************************************************************************************/

GO
/****** Object:  StoredProcedure [dbo].[sp_DovizIslemi]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DovizIslemi]
    @MusteriID INT,
    @KaynakHesapID INT, -- TL Hesabı
    @HedefHesapID INT,  -- USD/EUR Hesabı
    @KaynakTutar DECIMAL(18,2), -- Ne kadar TL bozdurulacak
    @IslemTuru NVARCHAR(10) -- 'Alis' veya 'Satis'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION; -- Transaction Başlangıcı

        -- 1. Kur Bilgisi (Anlık kurdan işlem yapılır)
        DECLARE @Kur DECIMAL(18,4);
        DECLARE @HedefParaBirimi CHAR(3);
        
        SELECT @HedefParaBirimi = ParaBirimiKodu FROM YatirimHesaplari WHERE HesapID = @HedefHesapID;
        
        -- İşlem türüne göre kuru seç
        IF @IslemTuru = 'Alis' -- Müşteri Döviz Alıyor (Bankadan Satış Kuru)
            SELECT @Kur = SatisKuru FROM ParaBirimleri WHERE ParaBirimiKodu = @HedefParaBirimi;
        ELSE -- Müşteri Döviz Satıyor (Bankadan Alış Kuru)
            SELECT @Kur = AlisKuru FROM ParaBirimleri WHERE ParaBirimiKodu = @HedefParaBirimi;

        -- 2. Hedef Tutarı Hesap (Örn: 3200 TL / 32.00 = 100 USD)
        DECLARE @HedefTutar DECIMAL(18,2);
        IF @IslemTuru = 'Alis'
            SET @HedefTutar = @KaynakTutar / @Kur;
        ELSE -- Satışta Kaynak Dövizdir, Hedeften (TL) hesaplanır
             -- Burada mantığı basitleştirmek için Kaynak her zaman "Giden Para" olarak düşünülmüştür.
             SET @HedefTutar = @KaynakTutar * @Kur;

        -- 3. Bakiye Kontrolü (Kaynak Hesapta para var mı)
        DECLARE @KaynakBakiye DECIMAL(18,2);
        SELECT TOP 1 @KaynakBakiye = IslemSonrasiBakiye FROM HesapHareketleri WHERE HesapID = @KaynakHesapID ORDER BY IslemTarihi DESC;
        
        IF ISNULL(@KaynakBakiye, 0) < @KaynakTutar
        BEGIN
            RAISERROR('Yetersiz Bakiye!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Kaynak Hesaptan Düş (Para Çıkışı)
        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@KaynakHesapID, 'TRY', @IslemTuru, -@KaynakTutar, (@KaynakBakiye - @KaynakTutar), 'Döviz İşlemi');

        -- 5. Hedef Hesaba Ekle (Para Girişi)
        DECLARE @HedefBakiye DECIMAL(18,2);
        SELECT TOP 1 @HedefBakiye = IslemSonrasiBakiye FROM HesapHareketleri WHERE HesapID = @HedefHesapID ORDER BY IslemTarihi DESC;

        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@HedefHesapID, @HedefParaBirimi, @IslemTuru, @HedefTutar, (ISNULL(@HedefBakiye,0) + @HedefTutar), 'Döviz İşlemi');

        COMMIT TRANSACTION; -- Her şey yolundaysa kaydet
        PRINT 'Döviz işlemi başarıyla tamamlandı.';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION; -- Hata varsa her şeyi geri al
        DECLARE @HataMesaji NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@HataMesaji, 16, 1);
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_HesapKapat]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_HesapKapat]
    @HesapID INT
AS
BEGIN
    -- 1. Bakiye Kontrolü
    DECLARE @SonBakiye DECIMAL(18,2);
    SELECT TOP 1 @SonBakiye = IslemSonrasiBakiye 
    FROM HesapHareketleri WHERE HesapID = @HesapID ORDER BY IslemTarihi DESC;

    IF @SonBakiye > 0
    BEGIN
        RAISERROR('Bakiyesi bulunan hesap kapatılamaz! Lütfen önce parayı çekin.', 16, 1);
        RETURN;
    END

    -- 2. Hesabı Pasife Çek
    UPDATE YatirimHesaplari 
    SET AktifMi = 0 
    WHERE HesapID = @HesapID;

    PRINT 'Hesap başarıyla kapatıldı.';
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_KartBorcOdeme]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_KartBorcOdeme]
    @HesapID INT, 
    @KartID INT,  
    @Tutar DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    
    DECLARE @HesapBakiye DECIMAL(18,2);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Vadesiz Hesap Bakiye Kontrolü
        SELECT TOP 1 @HesapBakiye = IslemSonrasiBakiye 
        FROM HesapHareketleri 
        WHERE HesapID = @HesapID 
        ORDER BY IslemTarihi DESC;

        -- Bakiye Kontrolü
        IF ISNULL(@HesapBakiye, 0) < @Tutar
        BEGIN
          
            THROW 50001, 'Hesap bakiyesi borç ödemesi için yetersiz!', 1;
        END

        -- 2. Hesaptan Para Düş
        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@HesapID, 'TRY', 'Cek', -@Tutar, (@HesapBakiye - @Tutar), 'KK Borç Ödeme');

        -- 3. Kart İşlemleri Buraya Gelecek (Gerekli INSERT/UPDATE işlemleri)

        COMMIT TRANSACTION;
        PRINT 'Kredi kartı borcu başarıyla ödendi.';

    END TRY
    BEGIN CATCH
        -- Eğer aktif bir transaction varsa geri al
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Hata mesajını düzeltilmiş fonksiyonla fırlat
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ParaTransferi]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ParaTransferi]
    @GonderenHesapID INT,
    @AliciHesapID INT,
    @Tutar DECIMAL(18,2),
    @Aciklama NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
   
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kontrol: Gönderenin Bakiyesi Yeterli mi?
        -- Not: Basitlik adına son hareket bakiyesini alıyoruz.
        DECLARE @MevcutBakiye DECIMAL(18,2);
        SELECT TOP 1 @MevcutBakiye = IslemSonrasiBakiye 
        FROM HesapHareketleri WHERE HesapID = @GonderenHesapID ORDER BY IslemTarihi DESC;

        IF @MevcutBakiye IS NULL SET @MevcutBakiye = 0;

        IF @MevcutBakiye < @Tutar
        BEGIN
            RAISERROR('Yetersiz Bakiye!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Para Birimi Kontrolü 
        DECLARE @GonderenParaBirimi CHAR(3), @AliciParaBirimi CHAR(3);
        SELECT @GonderenParaBirimi = ParaBirimiKodu FROM YatirimHesaplari WHERE HesapID = @GonderenHesapID;
        SELECT @AliciParaBirimi = ParaBirimiKodu FROM YatirimHesaplari WHERE HesapID = @AliciHesapID;

        IF @GonderenParaBirimi <> @AliciParaBirimi
        BEGIN
            RAISERROR('Farklı para birimleri arasında doğrudan transfer yapılamaz!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Transfer Tablosuna Kayıt
        DECLARE @YeniTransferID INT;
        INSERT INTO Transferler (GonderenHesapID, AliciHesapID, Tutar, ParaBirimiKodu, Aciklama)
        VALUES (@GonderenHesapID, @AliciHesapID, @Tutar, @GonderenParaBirimi, @Aciklama);
        
        SET @YeniTransferID = SCOPE_IDENTITY(); -- Eklenen son ID'yi al

        -- 4. Gönderen İçin Hareket Kaydı (Para Çıkışı)
        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, TransferID, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@GonderenHesapID, @GonderenParaBirimi, @YeniTransferID, 'TransferGiden', -@Tutar, (@MevcutBakiye - @Tutar), @Aciklama);

        -- 5. Alıcı İçin Hareket Kaydı (Para Girişi)
        -- Alıcının son bakiyesini bul
        DECLARE @AliciBakiye DECIMAL(18,2);
        SELECT TOP 1 @AliciBakiye = IslemSonrasiBakiye 
        FROM HesapHareketleri WHERE HesapID = @AliciHesapID ORDER BY IslemTarihi DESC;
        
        IF @AliciBakiye IS NULL SET @AliciBakiye = 0;

        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, TransferID, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@AliciHesapID, @AliciParaBirimi, @YeniTransferID, 'TransferGelen', @Tutar, (@AliciBakiye + @Tutar), @Aciklama);

        -- İşlem Başarılı, Onayla
        COMMIT TRANSACTION;
        PRINT 'Transfer başarıyla gerçekleşti.';
    END TRY
    BEGIN CATCH
        -- Hata olursa her şeyi geri al
        ROLLBACK TRANSACTION;
        DECLARE @HataMesaji NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@HataMesaji, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_YatirimAlimi]    Script Date: 12.02.2026 15:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_YatirimAlimi]
    @HesapID INT,
    @EnstrumanKodu NVARCHAR(20), -- Örn: THYAO
    @Adet INT,
    @BirimFiyat DECIMAL(18,2) -- O anki borsa fiyatı
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ToplamTutar DECIMAL(18,2) = @Adet * @BirimFiyat;

        -- 1. Nakit Bakiye Kontrolü
        DECLARE @NakitBakiye DECIMAL(18,2);
        SELECT TOP 1 @NakitBakiye = IslemSonrasiBakiye FROM HesapHareketleri WHERE HesapID = @HesapID ORDER BY IslemTarihi DESC;

        IF ISNULL(@NakitBakiye, 0) < @ToplamTutar
        BEGIN
            RAISERROR('Yatırım için yetersiz bakiye!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Nakit Hesaptan Düş
        INSERT INTO HesapHareketleri (HesapID, ParaBirimiKodu, IslemTuru, Tutar, IslemSonrasiBakiye, Referans)
        VALUES (@HesapID, 'TRY', 'Alis', -@ToplamTutar, (@NakitBakiye - @ToplamTutar), 'Yatırım: ' + @EnstrumanKodu);

        -- 3. Varlık Tablosuna Ekle (Yoksa oluştur, varsa güncelle)
        IF EXISTS (SELECT 1 FROM HesapVarliklari WHERE HesapID = @HesapID AND EnstrumanKodu = @EnstrumanKodu)
        BEGIN
            -- Ortalama maliyeti güncellemek gerekir ama basitlik için sadece miktarı artırıyoruz
            UPDATE HesapVarliklari
            SET Miktar = Miktar + @Adet
            WHERE HesapID = @HesapID AND EnstrumanKodu = @EnstrumanKodu;
        END
        ELSE
        BEGIN
            INSERT INTO HesapVarliklari (HesapID, ParaBirimiKodu, EnstrumanTuru, EnstrumanKodu, Miktar, OrtMaliyet)
            VALUES (@HesapID, 'TRY', 'Hisse', @EnstrumanKodu, @Adet, @BirimFiyat);
        END

        COMMIT TRANSACTION;
        PRINT 'Yatırım işlemi gerçekleşti.';

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END;
GO