/*
 cleaning Data in SQL Queries

 */

select *
from PortfolioProject..NashvilleHousing


-- Standardize Date format

select SaleDateConverted, convert(date, saledate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,saledate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)


-- Populate property address date

select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- breaking out address into individual columns( address, city, state)

select PropertyAddress
from PortfolioProject..NashvilleHousing

select
substring(PropertyAddress, 1,charindex(',', PropertyAddress) - 1) as Address, 
substring(PropertyAddress,charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1,charindex(',', PropertyAddress) - 1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, 1,charindex(',', PropertyAddress) + 1)

select *
from PortfolioProject..NashvilleHousing





select OwnerAddress
from PortfolioProject..NashvilleHousing

select
parsename(replace(OwnerAddress, ',', '.') ,3),
parsename(replace(OwnerAddress, ',', '.') ,2),
parsename(replace(OwnerAddress, ',', '.') ,1)
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.') ,3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.') ,2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.') ,1)

select *
from PortfolioProject..NashvilleHousing


-- change Y and N to Yes AND No in "Sold as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


-- remove duplicates


WITH RowNumCTE AS(
select *, 
	row_number() over ( partition by ParcelID, 
						PropertyAddress, 
						SalePrice, 
						SaleDate, 
						LegalReference
						ORDER BY UniqueID) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress



-- delete unused columns


select *
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

alter table PortfolioProject..NashvilleHousing
drop column  SaleDate


