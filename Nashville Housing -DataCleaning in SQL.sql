
SELECT * FROM DataCleaning..NashvilleHousing;

-----------------------------------------------------------------------------------------------------------------------------------

--STANDARDIZE DATE FORMAT

SELECT SaleDateConverted FROM DataCleaning..NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)


-------------------------------------------------------------------------------------------------------------------------------------

--POPULATE PROPERTY ADDRESS DATA

SELECT PropertyAddress FROM DataCleaning..NashvilleHousing;
 
 UPDATE A
 SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
 FROM DataCleaning..NashvilleHousing A 
 JOIN   DataCleaning..NashvilleHousing B
	  ON A.ParcelId = B.ParcelId
      AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------------------
--BREAKING THE ADDRESS INTO INDIVIDUAL COLUMNS


ALTER TABLE DataCleaning..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE DataCleaning..NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2)
 


 ALTER TABLE DataCleaning..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE DataCleaning..NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'),1)

 
 ALTER TABLE DataCleaning..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE DataCleaning..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
 

  
 ALTER TABLE DataCleaning..NashvilleHousing
ADD OwnerSplitState NVARCHAR(25);

UPDATE DataCleaning..NashvilleHousing
SET OwnerSplitStatE = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 

  
 ALTER TABLE DataCleaning..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE DataCleaning..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
 
 -------------------------------------------------------------------------------------------------------------------------------

 --CHANGE Y & N TO YES/NO IN SOLDASVACANT

 UPDATE DataCleaning..NashvilleHousing
 SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END
					
--SELECT DISTINCT(SoldAsVacant) FROM DataCleaning..NashvilleHousing


---------------------------------------------------------------------------------------------------------------------------------------

--REMOVE DUPLICATES

WITH RowNumCTE AS (
SELECT * , ROW_NUMBER() 
		OVER(PARTITION BY ParcelID,
		              PropertyAddress,
					  SaleDate,
					  SalePrice,
					  LegalReference
					  ORDER BY UniqueID) AS duplicate
FROM DataCleaning..NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE duplicate > 1;

----------------------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

ALTER TABLE DataCleaning..NashvilleHousing
DROP COLUMN PropertyAddress,OwnerAddress,SaleDate,TaxDistrict