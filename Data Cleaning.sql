--Creating table in PostgreSQL
CREATE TABLE NashvilleHousing (
UniqueID NUMERIC,
ParcelID VARCHAR(100),
LandUse VARCHAR(100),
PropertyAddress VARCHAR(300),
SaleDate TIMESTAMP,
SalePrice NUMERIC,
LegalReference VARCHAR(100),
SoldAsVacant VARCHAR(5),
OwnerName VARCHAR(300),
OwnerAddress VARCHAR(300),
Acreage NUMERIC,
TaxDistrict VARCHAR(300),
LandValue NUMERIC,
BuildingValue NUMERIC,
TotalValue NUMERIC,
YearBuilt NUMERIC,
Bedrooms NUMERIC,
FullBath NUMERIC,
HalfBath NUMERIC)

--Converting the dates to remove the timestamps 
SELECT SaleDate
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE 

Update NashvilleHousing
SET SaleDateConverted = DATE(Saledate)

--Populating Property Address Null Data by matching ParcelID
SELECT a.parcelID, a.PropertyAddress, b.parcelID, b.propertyaddress, COALESCE(a.Propertyaddress, b.PropertyAddress, 'Null')
FROM NashvilleHousing as A
JOIN NashvilleHousing as B on a.parcelID = b.parcelID AND a.uniqueID != b.uniqueID
WHERE a.propertyAddress is Null

Update NashvilleHousing
SET PropertyAddress = a.PropertyAddress
FROM
(SELECT DISTINCT ON (ParcelID) ParcelID, PropertyAddress
 FROM NashvilleHousing
 WHERE PropertyAddress IS NOT NULL 
 ORDER BY ParcelID, PropertyAddress) AS a
WHERE a.ParcelID = NashvilleHousing.ParcelID
AND NashvilleHousing.PropertyAddress IS NULL

--Breaking Address column into individual columns (Address, City) from Property Address Field
SELECT 
	SUBSTRING (PropertyAddress, 1, STRPOS(PropertyAddress, ',')-1) AS Address,
	SUBSTRING (PropertyAddress, STRPOS(PropertyAddress, ',')+1, LENGTH(PropertyAddress)) AS City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress VARCHAR(250),
ADD	PropertySplitCity VARCHAR(150)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, STRPOS(PropertyAddress, ',')-1),
    PropertySplitCity =  SUBSTRING (PropertyAddress, STRPOS(PropertyAddress, ',')+1, LENGTH(PropertyAddress))

--Changing 'Y' and 'N' to Yes and No in Sold as Vacant Field
SELECT DISTINCT(SoldAsVacant), COUNT(SOldasVacant)
FROM NashvilleHousing
GROUP BY SoldasVacant

UPDATE nashvillehousing
SET SoldAsVacant = 
	CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END

--Delete unused Columns

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate, 
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict