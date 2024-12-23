USE [master]
GO
/****** Object:  Database [MOBILE2]    Script Date: 28.11.2024 г. 15:35:16 ******/
CREATE DATABASE [MOBILE2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MOBILE2', FILENAME = N'D:\Downloads\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MOBILE2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MOBILE2_log', FILENAME = N'D:\Downloads\SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MOBILE2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MOBILE2] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MOBILE2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MOBILE2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MOBILE2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MOBILE2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MOBILE2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MOBILE2] SET ARITHABORT OFF 
GO
ALTER DATABASE [MOBILE2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MOBILE2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MOBILE2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MOBILE2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MOBILE2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MOBILE2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MOBILE2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MOBILE2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MOBILE2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MOBILE2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MOBILE2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MOBILE2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MOBILE2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MOBILE2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MOBILE2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MOBILE2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MOBILE2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MOBILE2] SET RECOVERY FULL 
GO
ALTER DATABASE [MOBILE2] SET  MULTI_USER 
GO
ALTER DATABASE [MOBILE2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MOBILE2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MOBILE2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MOBILE2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MOBILE2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MOBILE2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MOBILE2', N'ON'
GO
ALTER DATABASE [MOBILE2] SET QUERY_STORE = ON
GO
ALTER DATABASE [MOBILE2] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MOBILE2]
GO
/****** Object:  UserDefinedFunction [dbo].[CountListingsWithCriteria]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CountListingsWithCriteria](
    @category_id INT = NULL,
    @brand_id INT = NULL,
    @model_id INT = NULL,
    @region_id INT = NULL,
    @price_min DECIMAL(18, 2) = NULL,
    @price_max DECIMAL(18, 2) = NULL
)
RETURNS INT
AS
BEGIN
    DECLARE @listingCount INT;

    SELECT @listingCount = COUNT(*)
    FROM LISTING l
    LEFT JOIN VEHICLE v ON l.vehicle_id = v.vehicle_id
    LEFT JOIN CARPART cp ON l.part_id = cp.part_id
    WHERE 
        (@category_id IS NULL OR l.category_id = @category_id)
        AND (@brand_id IS NULL OR (v.brand_id = @brand_id OR cp.brand_id = @brand_id))
        AND (@model_id IS NULL OR v.model_id = @model_id)
        AND (@region_id IS NULL OR l.region_id = @region_id)
        AND (@price_min IS NULL OR l.price >= @price_min)
        AND (@price_max IS NULL OR l.price <= @price_max)

    RETURN @listingCount;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CountUserListings]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CountUserListings](@users_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @listingCount INT;
    
    SELECT @listingCount = COUNT(*)
    FROM LISTING
    WHERE users_id = @users_id;
    
    RETURN @listingCount;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[FormatPrice]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FormatPrice](@price DECIMAL(18, 2), @currencySymbol NVARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN CONCAT(@currencySymbol, FORMAT(@price, 'N2'));
END;
GO
/****** Object:  Table [dbo].[REGION]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REGION](
	[region_id] [int] NOT NULL,
	[regionName] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[region_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRANSMISSION]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRANSMISSION](
	[transmission_id] [int] NOT NULL,
	[transmissionType] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[transmission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ENGINE]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ENGINE](
	[typeofengine_id] [int] NOT NULL,
	[engineType] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[typeofengine_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BRAND]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BRAND](
	[brand_id] [int] NOT NULL,
	[brandName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[brand_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MODEL]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MODEL](
	[model_id] [int] NOT NULL,
	[brand_id] [int] NULL,
	[modelName] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[model_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CARPART]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CARPART](
	[part_id] [int] NOT NULL,
	[category_id] [int] NULL,
	[brand_id] [int] NULL,
	[model_id] [int] NULL,
	[partType] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[part_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VEHICLE]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VEHICLE](
	[vehicle_id] [int] NOT NULL,
	[category_id] [int] NULL,
	[transmission_id] [int] NULL,
	[typeofengine_id] [int] NULL,
	[power] [int] NULL,
	[brand_id] [int] NULL,
	[model_id] [int] NULL,
	[color] [varchar](50) NULL,
	[mileage] [int] NULL,
	[VIN] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LISTING]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LISTING](
	[listing_id] [int] NOT NULL,
	[users_id] [int] NULL,
	[category_id] [int] NOT NULL,
	[vehicle_id] [int] NULL,
	[part_id] [int] NULL,
	[region_id] [int] NULL,
	[title] [varchar](255) NOT NULL,
	[description] [varchar](255) NULL,
	[photos] [varchar](255) NULL,
	[dateTime] [datetime] NULL,
	[price] [decimal](10, 2) NOT NULL,
	[isUsed] [bit] NULL,
	[yearOfProduction] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[listing_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ListingsDetails]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ListingsDetails] AS
SELECT 
    L.listing_id,
    L.title,
    L.description,
    L.category_id,
    L.price,
    L.isUsed,
    L.yearOfProduction,
    L.dateTime,
    L.region_id,
    R.regionName,
    -- Unified brand_id and model_id for vehicles and car parts
    COALESCE(V.brand_id, CP.brand_id) AS brand_id,
    COALESCE(V.model_id, CP.model_id) AS model_id,
    B.brandName,
    M.modelName,
    -- Vehicle-specific details
    V.transmission_id,
    T.transmissionType,
    V.typeOfEngine_id,
    E.engineType,
    V.power,
    V.color,
    V.mileage,
    V.VIN,
    -- Car part-specific details
    CP.partType
FROM LISTING L
-- Join with VEHICLE
LEFT JOIN VEHICLE V ON L.vehicle_id = V.vehicle_id
-- Join with CARPART
LEFT JOIN CARPART CP ON L.part_id = CP.part_id
-- Join with REGION
LEFT JOIN REGION R ON L.region_id = R.region_id
-- Join with BRAND and MODEL
LEFT JOIN BRAND B ON COALESCE(V.brand_id, CP.brand_id) = B.brand_id
LEFT JOIN MODEL M ON COALESCE(V.model_id, CP.model_id) = M.model_id
-- Join with TRANSMISSION (for vehicles)
LEFT JOIN TRANSMISSION T ON V.transmission_id = T.transmission_id
-- Join with ENGINE (for vehicles)
LEFT JOIN ENGINE E ON V.typeOfEngine_id = E.typeOfEngine_id;
GO
/****** Object:  Table [dbo].[ASK]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASK](
	[users_id] [int] NOT NULL,
	[listing_id] [int] NOT NULL,
	[message] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CATEGORY]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATEGORY](
	[category_id] [int] NOT NULL,
	[categoryName] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FAVLISTING]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAVLISTING](
	[favlisting_id] [int] IDENTITY(1,1) NOT NULL,
	[users_id] [int] NULL,
	[listing_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[favlisting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERS](
	[users_id] [int] NOT NULL,
	[name] [varchar](255) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[phoneNumber] [varchar](20) NULL,
	[listingsCounter] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[users_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LISTING] ADD  DEFAULT (getdate()) FOR [dateTime]
GO
ALTER TABLE [dbo].[USERS] ADD  DEFAULT ((0)) FOR [listingsCounter]
GO
ALTER TABLE [dbo].[ASK]  WITH CHECK ADD FOREIGN KEY([listing_id])
REFERENCES [dbo].[LISTING] ([listing_id])
GO
ALTER TABLE [dbo].[ASK]  WITH CHECK ADD FOREIGN KEY([users_id])
REFERENCES [dbo].[USERS] ([users_id])
GO
ALTER TABLE [dbo].[CARPART]  WITH CHECK ADD FOREIGN KEY([brand_id])
REFERENCES [dbo].[BRAND] ([brand_id])
GO
ALTER TABLE [dbo].[CARPART]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[CATEGORY] ([category_id])
GO
ALTER TABLE [dbo].[CARPART]  WITH CHECK ADD FOREIGN KEY([model_id])
REFERENCES [dbo].[MODEL] ([model_id])
GO
ALTER TABLE [dbo].[FAVLISTING]  WITH CHECK ADD  CONSTRAINT [FK_FAVLISTING_LISTING] FOREIGN KEY([listing_id])
REFERENCES [dbo].[LISTING] ([listing_id])
GO
ALTER TABLE [dbo].[FAVLISTING] CHECK CONSTRAINT [FK_FAVLISTING_LISTING]
GO
ALTER TABLE [dbo].[FAVLISTING]  WITH CHECK ADD  CONSTRAINT [FK_FAVLISTING_USERS] FOREIGN KEY([users_id])
REFERENCES [dbo].[USERS] ([users_id])
GO
ALTER TABLE [dbo].[FAVLISTING] CHECK CONSTRAINT [FK_FAVLISTING_USERS]
GO
ALTER TABLE [dbo].[LISTING]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[CATEGORY] ([category_id])
GO
ALTER TABLE [dbo].[LISTING]  WITH CHECK ADD FOREIGN KEY([part_id])
REFERENCES [dbo].[CARPART] ([part_id])
GO
ALTER TABLE [dbo].[LISTING]  WITH CHECK ADD FOREIGN KEY([region_id])
REFERENCES [dbo].[REGION] ([region_id])
GO
ALTER TABLE [dbo].[LISTING]  WITH CHECK ADD FOREIGN KEY([users_id])
REFERENCES [dbo].[USERS] ([users_id])
GO
ALTER TABLE [dbo].[LISTING]  WITH CHECK ADD FOREIGN KEY([vehicle_id])
REFERENCES [dbo].[VEHICLE] ([vehicle_id])
GO
ALTER TABLE [dbo].[MODEL]  WITH CHECK ADD FOREIGN KEY([brand_id])
REFERENCES [dbo].[BRAND] ([brand_id])
GO
ALTER TABLE [dbo].[VEHICLE]  WITH CHECK ADD FOREIGN KEY([brand_id])
REFERENCES [dbo].[BRAND] ([brand_id])
GO
ALTER TABLE [dbo].[VEHICLE]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[CATEGORY] ([category_id])
GO
ALTER TABLE [dbo].[VEHICLE]  WITH CHECK ADD FOREIGN KEY([model_id])
REFERENCES [dbo].[MODEL] ([model_id])
GO
ALTER TABLE [dbo].[VEHICLE]  WITH CHECK ADD FOREIGN KEY([transmission_id])
REFERENCES [dbo].[TRANSMISSION] ([transmission_id])
GO
ALTER TABLE [dbo].[VEHICLE]  WITH CHECK ADD FOREIGN KEY([typeofengine_id])
REFERENCES [dbo].[ENGINE] ([typeofengine_id])
GO
/****** Object:  StoredProcedure [dbo].[CreateListingWithDetails]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateListingWithDetails]
    @user_id INT,
    @category_id INT,
    @region_id INT,
    @title NVARCHAR(255),
    @description TEXT,
    @photos NVARCHAR(MAX),
    @price DECIMAL(18, 2),
    @yearOfProduction INT,
    
    -- Vehicle details (optional, only used if category is for vehicles)
    @transmission_id INT = NULL,
    @typeOfEngine_id INT = NULL,
    @power INT = NULL,
    @brand_id INT = NULL,
    @model_id INT = NULL,
    @color NVARCHAR(50) = NULL,
    @mileage INT = NULL,
    @VIN NVARCHAR(50) = NULL,
    
    -- Car part details (optional, only used if category is for car parts)
    @partBrand_id INT = NULL,
    @partModel_id INT = NULL,
    @partType NVARCHAR(100) = NULL
AS
BEGIN
    DECLARE @listing_id INT;
    DECLARE @vehicle_id INT = NULL;
    DECLARE @part_id INT = NULL;

    -- Check if category is for vehicles
    IF @category_id = 1
    BEGIN
        -- Insert a new record into the VEHICLE table
        INSERT INTO VEHICLE (category_id, transmission_id, typeOfEngine_id, power, brand_id, model_id, color, mileage, VIN)
        VALUES (@category_id, @transmission_id, @typeOfEngine_id, @power, @brand_id, @model_id, @color, @mileage, @VIN);
        
        -- Get the new vehicle_id
        SET @vehicle_id = SCOPE_IDENTITY();
    END
    -- Check if category is for car parts
    ELSE IF @category_id = 2
    BEGIN
        -- Insert a new record into the CARPART table
        INSERT INTO CARPART (category_id, brand_id, model_id, partType)
        VALUES (@category_id, @partBrand_id, @partModel_id, @partType);
        
        -- Get the new part_id
        SET @part_id = SCOPE_IDENTITY();
    END

    -- Insert the listing with the appropriate vehicle_id or part_id
    INSERT INTO LISTING (users_id, category_id, vehicle_id, part_id, region_id, title, description, photos, price, yearOfProduction, dateTime)
    VALUES (@user_id, @category_id, @vehicle_id, @part_id, @region_id, @title, @description, @photos, @price, @yearOfProduction, GETDATE());

    SET @listing_id = SCOPE_IDENTITY();

    -- Return the new listing_id as confirmation
    SELECT @listing_id AS NewListingID;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetListingsByUser]    Script Date: 28.11.2024 г. 15:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetListingsByUser]
    @users_id INT
AS
BEGIN
    SELECT listing_id, title, price, dateTime
    FROM LISTING
    WHERE users_id = @users_id
    ORDER BY dateTime DESC;
END;
GO
USE [master]
GO
ALTER DATABASE [MOBILE2] SET  READ_WRITE 
GO
