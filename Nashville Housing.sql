/* 
CLEANING DATA IN SQL
*/

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing

-- STANDARDIZE DATE FORMAT

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER Table Portfolio_Project.dbo.NashvilleHousing
ALTER Column SaleDate DATE

-- POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT Table1.ParcelID, Table1.PropertyAddress, Table2.ParcelID, Table2.PropertyAddress, ISNULL(Table1.PropertyAddress, Table2.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing Table1
JOIN Portfolio_Project.dbo.NashvilleHousing Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
 WHERE Table1.PropertyAddress is null


Update Table1
SET PropertyAddress = ISNULL(Table1.PropertyAddress, Table2.PropertyAddress)
FROM Portfolio_Project.dbo.NashvilleHousing Table1
JOIN Portfolio_Project.dbo.NashvilleHousing Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
WHERE Table1.PropertyAddress is null



-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)


SELECT PropertyAddress
FROM Portfolio_Project.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM Portfolio_Project.dbo.NashvilleHousing


ALTER Table Portfolio_Project.dbo.NashvilleHousing
ADD PropertyStreetAddress NvarChar(255);


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER Table Portfolio_Project.dbo.NashvilleHousing
ADD PropertyCity NvarChar(255);


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))





ALTER Table Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN PropertyCity


SELECT OwnerAddress
FROM Portfolio_Project.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
FROM Portfolio_Project.dbo.NashvilleHousing



ALTER Table Portfolio_Project.dbo.NashvilleHousing
ADD OwnerStreetAddress NvarChar(255);


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)


ALTER Table Portfolio_Project.dbo.NashvilleHousing
ADD OwnerCity NvarChar(255);


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)


ALTER Table Portfolio_Project.dbo.NashvilleHousing
ADD OwnerState NvarChar(255);


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)



-- CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio_Project.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No' 
	   ELSE SoldAsVacant
	   END
FROM Portfolio_Project.dbo.NashvilleHousing


UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No' 
	   ELSE SoldAsVacant
	   END



-- REMOVE DUPLICATES


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM Portfolio_Project.dbo.NashvilleHousing
)



SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



-- DELETE UNUSED COLUMNS


SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
