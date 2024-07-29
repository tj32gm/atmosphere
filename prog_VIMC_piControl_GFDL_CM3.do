cd "/media/tack/Climate4c/piControl_GFDL_CM3/"

local dt   = "GFDL_CM3"

local var = "circul"
local var = "thermal"
local var = "localq"
local var = "vimc"
local var = "viha"

local var = "pr"
local var = "hfls"


* year month day are generated in CDO, and so no needed here

forvalues i= 1(5)96 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_piControl_`var'_y`i'.txt, clear

drop if _n == 1
split v1, parse("") gen(x)
split x1, parse("-") gen(y)
drop x1 v1

ren x2 lat
ren x3 lon
ren x4 `var'
ren y1 year
ren y2 month
ren y3 day

destring _all, replace

*  make 12960 grids

* create lat lon year month day

gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80

egen loc = group(lat lon)

keep latg lat lon loc year month day `var'
sort loc year month day

save "/media/tack/Climate4c/piControl_GFDL_CM3/stata_files/`dt'_piControl_`var'_y`i'.dta", replace

}




* need to generate year month day *

forvalues i= 560(1)640 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_piControl_`var'_y`i'.txt, clear

drop if _n == 1
split v1, parse("") gen(x)
split x1, parse("-") gen(y)
drop x1 v1

ren x2 lat
ren x3 lon
ren x4 `var'
ren y1 year
ren y2 month
ren y3 day

destring _all, replace



*  make 12960 grids


* create lat lon year month day

gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80


egen loc = group(lat lon)

gen y = 0
gen year = 0
sort lat lon time

bysort lat lon (time): gen t = _n
bysort lat lon (time): replace y = 1             if mod(t[_n-1],365) == 0 | _n == 1
bysort lat lon (time): replace year = sum(y)     if y == 1
bysort lat lon (time): replace year = year[_n-1] if y == 0

gen month = 1
sort lat lon year time
bysort lat lon year (time): replace month = 2  if _n >=  32 & _n <=  59
bysort lat lon year (time): replace month = 3  if _n >=  60 & _n <=  90
bysort lat lon year (time): replace month = 4  if _n >=  91 & _n <= 120
bysort lat lon year (time): replace month = 5  if _n >= 121 & _n <= 151
bysort lat lon year (time): replace month = 6  if _n >= 152 & _n <= 181
bysort lat lon year (time): replace month = 7  if _n >= 182 & _n <= 212
bysort lat lon year (time): replace month = 8  if _n >= 213 & _n <= 243
bysort lat lon year (time): replace month = 9  if _n >= 244 & _n <= 273
bysort lat lon year (time): replace month = 10 if _n >= 274 & _n <= 304
bysort lat lon year (time): replace month = 11 if _n >= 305 & _n <= 334
bysort lat lon year (time): replace month = 12 if _n >= 335 & _n <= 365

sort lat lon year month time
bysort lat lon year month (time): gen day = _n

replace year = year + `i' - 1

keep latg lat lon loc year month day `var'
sort loc year month day

save `dt1'_stata_`var'_y`i'.dta, replace

}


cd "/media/tack/Climate-7/MIROC5/stata_files/"

local var = "pr"
local var = "hfls"


forvalues i= 560(1)640 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_`var'_y`i'.txt, clear



gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80

egen loc = group(lat lon)

gen y = 0
gen year = 0
sort lat lon time

bysort lat lon (time): gen t = _n
bysort lat lon (time): replace y = 1             if mod(t[_n-1],365) == 0 | _n == 1
bysort lat lon (time): replace year = sum(y)     if y == 1
bysort lat lon (time): replace year = year[_n-1] if y == 0

gen month = 1
sort lat lon year time
bysort lat lon year (time): replace month = 2  if _n >=  32 & _n <=  59
bysort lat lon year (time): replace month = 3  if _n >=  60 & _n <=  90
bysort lat lon year (time): replace month = 4  if _n >=  91 & _n <= 120
bysort lat lon year (time): replace month = 5  if _n >= 121 & _n <= 151
bysort lat lon year (time): replace month = 6  if _n >= 152 & _n <= 181
bysort lat lon year (time): replace month = 7  if _n >= 182 & _n <= 212
bysort lat lon year (time): replace month = 8  if _n >= 213 & _n <= 243
bysort lat lon year (time): replace month = 9  if _n >= 244 & _n <= 273
bysort lat lon year (time): replace month = 10 if _n >= 274 & _n <= 304
bysort lat lon year (time): replace month = 11 if _n >= 305 & _n <= 334
bysort lat lon year (time): replace month = 12 if _n >= 335 & _n <= 365

sort lat lon year month time
bysort lat lon year month (time): gen day = _n

replace year = year + `i' - 1

ren `var'_reorder `var'

keep latg lat lon loc year month day `var'
sort loc year month day

save `dt1'_stata_`var'_y`i'.dta, replace

}




************** Create regional files **********************

cd "/media/tack/Climate4c/piControl_GFDL_CM3/stata_files/" 

local dt = "GFDL_CM3"


forvalues j= 1(1)18 {

 di  " ----------------  latitude group =  `j'  / 18 --------------- "

 clear
 gen lat =.
 save `dt'_piControl_latg`j'.dta, replace

 forvalues i= 1(5)96 {

 use  `dt'_piControl_vimc_y`i'.dta, clear
 keep if latg ==`j'
 save tmp1.dta, replace

 use  `dt'_piControl_viha_y`i'.dta, clear
 keep if latg ==`j'
 save tmp2.dta, replace

 use  `dt'_piControl_circul_y`i'.dta, clear
 keep if latg ==`j'
 save tmp3.dta, replace

 use  `dt'_piControl_thermal_y`i'.dta, clear
 keep if latg ==`j'
 save tmp4.dta, replace

 use  `dt'_piControl_localq_y`i'.dta, clear
 keep if latg ==`j'
 save tmp5.dta, replace

 use  `dt'_piControl_pr_y`i'.dta, clear
 keep if latg ==`j'
 save tmp6.dta, replace

 use  `dt'_piControl_hfls_y`i'.dta, clear
 keep if latg ==`j'
 save tmp7.dta, replace


 use tmp1.dta, clear
 merge 1:1 loc year month day using tmp2.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp3.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp4.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp5.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 merge 1:1 loc year month day using tmp6.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 merge 1:1 loc year month day using tmp7.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 use   `dt'_piControl_latg`j'.dta, clear
 append using tmp_all.dta
 save `dt'_piControl_latg`j'.dta, replace

 }
}




forvalues j = 2/18 {
 use  `dt'_piControl_latg`j'.dta, clear
 egen loc2 = group(lat lon)
 duplicates tag loc2 month day year, gen(xx)
 tab xx
 keep if xx  == 0
 drop xx
 gen pe =  pr -  hfls
 replace year = year  + 1849
 gen time  = mdy(month, day, year)
 sum loc2
 
 xtset loc2 time
 save `dt'_piControl_latgg`j'.dta, replace
 
 * sample of 30 years *
 
 keep if year <= 1879

 save `dt'_piControl_latgg`j'_30yr.dta, replace
}


********* check outliers **********

cd "/media/tack/Climate4c/piControl_GFDL_CM3/stata_files/" 

local dt = "GFDL_CM3"

forvalues j = 1/18 {

di " -------------- region  = `j' ------------------- "

use `dt'_piControl_latgg`j'_30yr.dta, clear

tabstat  circul thermal viha vimc pr hfls, s(min mean max)

}


cd "/media/tack/Climate4c/piControl_GFDL_CM3/stata_files/" 

local dt = "GFDL_CM3"

local j =1 

 use  `dt'_piControl_latg`j'.dta, clear
 egen loc2 = group(lat lon)
 duplicates tag loc2 month day year, gen(xx)
 tab xx



cd "/media/tack/Climate4c/piControl_GFDL_CM3/stata_files/" 

local dt = "GFDL_CM3"

* all regions =  720

local j = 18

clear
gen irf = .
save results_irf_piControl_`dt'_pe`j'_order1.dta, replace
save results_irf_piControl_`dt'_pe`j'_order2.dta, replace


forvalues xx = 1/720 {

di " -------------- pe = `j' & loc = `xx' ------------------- "
use `dt'_piControl_latgg`j'_30yr.dta, clear
keep if loc2 == `xx'
local lat1 =  lat[1]
local lon1 =  lon[1]
*local lat2 =  lat_std[1]
*local lon2 =  lon_std[1]

tsset time
varsoc pe circul thermal viha, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time
*orif 1
*var pe circul thermal viha localq, lags(1/`optlag') dfk small
*oirf 2
*var viha localq circul thermal pe, lags(1/`optlag') dfk small

*oirf 3 (w/o localq)
var viha thermal circul pe, lags(1/`optlag') dfk small

* tw scatter pred_pe pe, msize(vtiny)

irf create var`xx', step(`optlag') set(pe`j'_piControl_loc`xx'_order1)  order(viha thermal circul pe) replace
irf create var`xx', step(`optlag') set(pe`j'_piControl_loc`xx'_order2)  order(viha circul thermal pe) replace



forvalues k = 1/2 {
 use pe`j'_piControl_loc`xx'_order`k'.irf, clear
 
 * copy lat lon information from original file.
 gen lat = `lat1'
 gen lon = `lon1'
 *gen lat_std = `lat2'
 *gen lon_std = `lon2'
 save tmp`j'_piControl_loc`xx'_order`k'.dta, replace

 
 use   results_irf_piControl_`dt'_pe`j'_order`k'.dta, clear
 append using tmp`j'_piControl_loc`xx'_order`k'.dta
 save results_irf_piControl_`dt'_pe`j'_order`k'.dta, replace
}

}





***** matching to the standard grid map *********

** step 1. combine  all results ***



cd "/media/tack/Climate4c/piControl_GFDL_CM3/results/" 

local dt = "GFDL_CM3"

local or = 2

use results_irf_piControl_`dt'_pe1_order`or'.dta, clear

forvalue i =2/18 {
 append using results_irf_piControl_`dt'_pe`i'_order`or'.dta
}
save results_irf_piControl_`dt'_pe_all_order`or'.dta, replace



*** step 2. For each  standard location, find one with the closest from results ***


forvalues j =1/12960 {

di  "-------------------------- `j' / 12960 ------------------------ "

use location_master2.dta, clear
 
 * lat1, lon1 are the base
local lat1 = lat[`j']
local lon1 = lon[`j']
local location1 = location[`j']

use results_irf_piControl_`dt'_pe_all_order`or'.dta, clear

gen lat_std = `lat1'
gen lon_std = `lon1'
gen location = `location1'

gen dist = sqrt((lat-`lat1')*(lat-`lat1') + (lon-`lon1')*(lon-`lon1'))

sort dist
gen xx = (dist != dist[_n-1] | _n == 1)
gen yy =  sum(xx)
keep if yy == 1

save xclostest_order`or'_location`j'.dta, replace
}


clear
gen irf = .
save  results_irf_piControl_`dt'_pe_all_order`or'_matched.dta, replace

forvalues j =1/12960 {
 di  "-------------------------- `j' / 12960 ------------------------ "
 append using xclostest_order`or'_location`j'.dta
}

save  results_irf_piControl_`dt'_pe_all_order`or'_matched.dta, replace




******  compute the anomly from the mean ************

local dt = "CanCM3"

cd "/home/tack/CanCM3/stata_files"


forvalues j = 2/6 {

di " --------------------   location = `j' /  6 ------------------------- "

use `dt'_stata_latg`j'_simple.dta, clear

*gen month=month(time)
*gen year=year(time)
*gen day=day(time)

gen normal = 1 if year > 2030 & year <= 2060

sort loc2 normal
bysort loc2 normal: egen m1 = mean(pe)
bysort loc2 normal: egen m2 = mean(pr)
bysort loc2 normal: egen m3 = mean(hfls)
bysort loc2 normal: egen m4 = mean(viha)
bysort loc2 normal: egen m5 = mean(circul)
bysort loc2 normal: egen m6 = mean(thermal)
bysort loc2 normal: egen m7 = mean(localq)

bysort loc2 (normal): gen n1 = m1[1]
bysort loc2 (normal): gen n2 = m2[1]
bysort loc2 (normal): gen n3 = m3[1]
bysort loc2 (normal): gen n4 = m4[1]
bysort loc2 (normal): gen n5 = m5[1]
bysort loc2 (normal): gen n6 = m6[1]
bysort loc2 (normal): gen n7 = m7[1]


gen ano_pe        = pe - n1
gen ano_pr         = pr - n2
gen ano_hfls       = hfls - n3
gen ano_viha      = viha - n4
gen ano_circul     = circul - n5
gen ano_thermal = thermal - n6
gen ano_localq    = localq - n7  

drop m1-m7 n1-n7

save anomaly_`dt'_stata_latg`j'_all.dta, replace

sort loc2
bysort loc2: egen m_ano_pe = mean(ano_pe)
bysort loc2: egen m_ano_pr = mean(ano_pr)
bysort loc2: egen m_ano_hfls = mean(ano_hfls)
bysort loc2: egen m_ano_viha = mean(ano_viha)
bysort loc2: egen m_ano_circul = mean(ano_circul)
bysort loc2: egen m_ano_thermal = mean(ano_thermal)
bysort loc2: egen m_ano_localq = mean(ano_localq)
bysort loc2: keep if _n == 1

keep lat lon loc loc2 m_ano_*
sort lat lon

save meananomaly_`dt'_stata_latg`j'_all.dta, replace

}


use meananomaly_`dt'_stata_latg1_all.dta, clear

forvalues j = 2/6 {
 append using meananomaly_`dt'_stata_latg`j'_all.dta
}

save "/home/tack/CanESM2M/results/final_meananomaly_`dt'.dta", replace



cd "/home/tack/CanESM2M/results/"

use final_meananomaly_`dt'.dta, clear

local s = 4

sort lat lon

merge n:1 lat lon using `dt'_latlon_matched_part`s'.dta

keep if _merge == 3
cd "/media/tack/Climate4c/piControl_IPSL_CM5B_LR/cleaned/"

local dt   = "IPSL_CM5B_LR"
*local dt1 = "MIROC5"

local var = "circul"
local var = "thermal"
local var = "localq"
local var = "vimc"
local var = "viha"

local var = "pr"
local var = "hfls"




* year month day are generated in CDO, and so no needed here

forvalues i= 1850(5)1945 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_piControl_`var'_y`i'.txt, clear

drop if _n == 1
split v1, parse("") gen(x)
split x1, parse("-") gen(y)
drop x1 v1

ren x2 lat
ren x3 lon
ren x4 `var'
ren y1 year
ren y2 month
ren y3 day

destring _all, replace



*  make 12960 grids


* create lat lon year month day

gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80

egen loc = group(lat lon)

keep latg lat lon loc year month day `var'
sort loc year month day

save "/media/tack/Climate4c/piControl_IPSL_CM5B_LR/stata_files/`dt'_piControl_`var'_y`i'.dta", replace

}


cd "/media/tack/Climate4c/piControl_IPSL_CM5B_LR/cleaned/"

local var = "pr"
local var = "hfls"



forvalues i= 1850(5)1945 {

di  "   ----------------  year = `i' ------------------  "

insheet using `var'_`dt'_piControl_y`i'.txt, clear


drop if _n == 1
split v1, parse("") gen(x)
split x1, parse("-") gen(y)
drop x1 v1

ren x2 lat
ren x3 lon
ren x4 `var'
ren y1 year
ren y2 month
ren y3 day

destring _all, replace


gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80

egen loc = group(lat lon)

keep latg lat lon loc year month day `var'
sort loc year month day

save "/media/tack/Climate4c/piControl_IPSL_CM5B_LR/stata_files/`dt'_piControl_`var'_y`i'.dta", replace

}



* need to generate year month day *

forvalues i= 560(1)640 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_piControl_`var'_y`i'.txt, clear

drop if _n == 1
split v1, parse("") gen(x)
split x1, parse("-") gen(y)
drop x1 v1

ren x2 lat
ren x3 lon
ren x4 `var'
ren y1 year
ren y2 month
ren y3 day

destring _all, replace



*  make 12960 grids


* create lat lon year month day

gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80





egen loc = group(lat lon)

gen y = 0
gen year = 0
sort lat lon time

bysort lat lon (time): gen t = _n
bysort lat lon (time): replace y = 1             if mod(t[_n-1],365) == 0 | _n == 1
bysort lat lon (time): replace year = sum(y)     if y == 1
bysort lat lon (time): replace year = year[_n-1] if y == 0

gen month = 1
sort lat lon year time
bysort lat lon year (time): replace month = 2  if _n >=  32 & _n <=  59
bysort lat lon year (time): replace month = 3  if _n >=  60 & _n <=  90
bysort lat lon year (time): replace month = 4  if _n >=  91 & _n <= 120
bysort lat lon year (time): replace month = 5  if _n >= 121 & _n <= 151
bysort lat lon year (time): replace month = 6  if _n >= 152 & _n <= 181
bysort lat lon year (time): replace month = 7  if _n >= 182 & _n <= 212
bysort lat lon year (time): replace month = 8  if _n >= 213 & _n <= 243
bysort lat lon year (time): replace month = 9  if _n >= 244 & _n <= 273
bysort lat lon year (time): replace month = 10 if _n >= 274 & _n <= 304
bysort lat lon year (time): replace month = 11 if _n >= 305 & _n <= 334
bysort lat lon year (time): replace month = 12 if _n >= 335 & _n <= 365

sort lat lon year month time
bysort lat lon year month (time): gen day = _n

replace year = year + `i' - 1

keep latg lat lon loc year month day `var'
sort loc year month day

save `dt1'_stata_`var'_y`i'.dta, replace

}


cd "/media/tack/Climate-7/MIROC5/stata_files/"

local var = "pr"
local var = "hfls"


forvalues i= 560(1)640 {

di  "   ----------------  year = `i' ------------------  "

insheet using `dt'_`var'_y`i'.txt, clear



gen latg = 1
replace latg = 2   if lat > 70  & lat <= 80
replace latg = 3   if lat > 60  & lat <= 70
replace latg = 4   if lat > 50  & lat <= 60
replace latg = 5   if lat > 40  & lat <= 50
replace latg = 6   if lat > 30  & lat <= 40
replace latg = 7   if lat > 20  & lat <= 30
replace latg = 8   if lat > 10  & lat <= 20
replace latg = 9   if lat > 0    & lat <= 10
replace latg = 10 if lat > -10 & lat <=  0
replace latg = 11 if lat > -20 & lat <= -10
replace latg = 12 if lat > -30 & lat <= -20
replace latg = 13 if lat > -40 & lat <= -30
replace latg = 14 if lat > -50 & lat <= -40
replace latg = 15 if lat > -60 & lat <= -50
replace latg = 16 if lat > -70 & lat <= -60
replace latg = 17 if lat > -80 & lat <= -70
replace latg = 18 if lat <= -80

egen loc = group(lat lon)

gen y = 0
gen year = 0
sort lat lon time

bysort lat lon (time): gen t = _n
bysort lat lon (time): replace y = 1             if mod(t[_n-1],365) == 0 | _n == 1
bysort lat lon (time): replace year = sum(y)     if y == 1
bysort lat lon (time): replace year = year[_n-1] if y == 0

gen month = 1
sort lat lon year time
bysort lat lon year (time): replace month = 2  if _n >=  32 & _n <=  59
bysort lat lon year (time): replace month = 3  if _n >=  60 & _n <=  90
bysort lat lon year (time): replace month = 4  if _n >=  91 & _n <= 120
bysort lat lon year (time): replace month = 5  if _n >= 121 & _n <= 151
bysort lat lon year (time): replace month = 6  if _n >= 152 & _n <= 181
bysort lat lon year (time): replace month = 7  if _n >= 182 & _n <= 212
bysort lat lon year (time): replace month = 8  if _n >= 213 & _n <= 243
bysort lat lon year (time): replace month = 9  if _n >= 244 & _n <= 273
bysort lat lon year (time): replace month = 10 if _n >= 274 & _n <= 304
bysort lat lon year (time): replace month = 11 if _n >= 305 & _n <= 334
bysort lat lon year (time): replace month = 12 if _n >= 335 & _n <= 365

sort lat lon year month time
bysort lat lon year month (time): gen day = _n

replace year = year + `i' - 1

ren `var'_reorder `var'

keep latg lat lon loc year month day `var'
sort loc year month day

save `dt1'_stata_`var'_y`i'.dta, replace

}






cd "/media/tack/Climate4c/piControl_FGOALS_g2/cleaned/"

local dt = "FGOALS_g2"


forvalues j= 1(1)18 {

 di  " ----------------  latitude group =  `j'  / 18 --------------- "

 clear
 gen lat =.
 save `dt'_piControl_latg`j'.dta, replace

 forvalues i= 560(1)640 {


 use  `dt'_piControl_vimc_y`i'.dta, clear
 keep if latg ==`j'
 save tmp1.dta, replace

 use  `dt'_piControl_viha_y`i'.dta, clear
 keep if latg ==`j'
 save tmp2.dta, replace

 use  `dt'_piControl_circul_y`i'.dta, clear
 keep if latg ==`j'
 save tmp3.dta, replace

 use  `dt'_piControl_thermal_y`i'.dta, clear
 keep if latg ==`j'
 save tmp4.dta, replace

 use  `dt'_piControl_localq_y`i'.dta, clear
 keep if latg ==`j'
 save tmp5.dta, replace

 use  `dt'_piControl_pr_y`i'.dta, clear
 keep if latg ==`j'
 save tmp6.dta, replace

 use  `dt'_piControl_hfls_y`i'.dta, clear
 keep if latg ==`j'
 save tmp7.dta, replace


 use tmp1.dta, clear
 merge 1:1 loc year month day using tmp2.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp3.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp4.dta
 keep if _merge == 3
 drop _merge

 merge 1:1 loc year month day using tmp5.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 merge 1:1 loc year month day using tmp6.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 merge 1:1 loc year month day using tmp7.dta
 keep if _merge == 3
 drop _merge
 save tmp_all.dta, replace

 use   `dt'_piControl_latg`j'.dta, clear
 append using tmp_all.dta
 save `dt'_piControl_latg`j'.dta, replace

 }
}




forvalues j = 2/18 {
 use  `dt'_piControl_latg`j'.dta, clear
 egen loc2 = group(lat lon)
 duplicates tag loc2 month day year, gen(xx)
 tab xx
 keep if xx  == 0
 drop xx
 gen pe =  pr -  hfls
 gen time  = mdy(month, day, year)
 sum loc2
 
 xtset loc2 time
 save `dt'_piControl_latgg`j'.dta, replace
}


* sample of 30 years *

cd "/media/tack/Climate4c/piControl_FGOALS_g2/stata_files/"

local dt = "FGOALS_g2"


forvalues j = 2/18 {
 use   `dt'_piControl_latgg`j'.dta, clear
 
 keep if year <= 589

 save `dt'_piControl_latgg`j'_30yr.dta, replace
}




* j = 1,3,4, 6 : 5376
* j = 2, 5       : 5632




cd "/media/tack/Climate4c/piControl_FGOALS_g2/stata_files/"

local dt = "FGOALS_g2"

local j = 1

clear
gen irf = .
save results_irf_`dt'_pe`j'_order1.dta, replace
save results_irf_`dt'_pe`j'_order2.dta, replace


forvalues xx = 5097/5376 {

di " -------------- pe = `j' & loc = `xx' ------------------- "
use `dt'_stata_latgg`j'.dta, clear
keep if loc2 == `xx'
local lat1 =  lat[1]
local lon1 =  lon[1]
*local lat2 =  lat_std[1]
*local lon2 =  lon_std[1]

tsset time
varsoc pe circul thermal viha, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time
*orif 1
*var pe circul thermal viha localq, lags(1/`optlag') dfk small
*oirf 2
*var viha localq circul thermal pe, lags(1/`optlag') dfk small

*oirf 3 (w/o localq)
var viha thermal circul pe, lags(1/`optlag') dfk small

* tw scatter pred_pe pe, msize(vtiny)

irf create var`xx', step(`optlag') set(pe`j'_loc`xx'_order1)  order(viha thermal circul pe) replace
irf create var`xx', step(`optlag') set(pe`j'_loc`xx'_order2)  order(viha circul thermal pe) replace



forvalues k = 1/2 {
 use pe`j'_loc`xx'_order`k'.irf, clear
 
 gen lat = `lat1'
 gen lon = `lon1'
 *gen lat_std = `lat2'
 *gen lon_std = `lon2'
 save tmp`j'_loc`xx'_order`k'.dta, replace

 
 use  results_irf_`dt'_pe`j'_order`k'.dta, clear
 
 append using tmp`j'_loc`xx'_order`k'.dta
 
 save results_irf_`dt'_pe`j'_order`k'.dta, replace
}

}




***** matching to the standard grid map *********


local dt = "FGOALS_g2"

cd "/media/tack/Climate4c/piControl_`dt'/stata_files"

insheet using  `dt'_piControl_circul_y560.txt, clear

sort lat lon
bysort lat lon: keep if _n == 1

keep lat lon

save `dt'_piControl_latlon.dta, replace

expand 12960

sort lat lon
bysort lat lon: gen location = _n
*egen location = group(lat lon)

sort location
ren lat lat1
ren lon lon1

save `dt'_piControl_latlon_duplicates.dta, replace


*merge*

merge n:1 location using "/media/tack/Climate4b/location_master2.dta"
drop _merge


*  to convert degrees to radians
*gen lat_pi =  lat*(_pi/180)
*gen lon_pi = lon*(_pi/180)

*gen lat1_pi =  lat1*(_pi/180)
*gen lon1_pi = lon1*(_pi/180)
*gen dif_lat = lat1_pi -  lat_pi
*gen dif_lon = lon1_pi -  lon_pi

*gen a  =  (sin((dif_lat/2)))^2  + cos(lat1)*cos(lat)*(sin((dif_lon/2)))^2
*gen dist = 6371*2*atan2(sqrt(a),sqrt(1-a))


gen dist = sqrt((lat-lat1)*(lat-lat1) + (lon-lon1)*(lon-lon1))

sort location dist
bysort location (dist): keep if _n == 1

ren lat lat_std
ren lon lon_std
ren lat1 lat
ren lon1 lon


sort lat lon
bysort lat lon: gen zz = _n
save tmp.dta, replace


save  "`dt'_latlon_matched.dta", replace




*merge with results *

cd "/media/tack/Climate-7/`dt'/results"

local or = 2

use results_irf_`dt'_pe1_order`or'.dta, clear
forvalue i =2/6 {
 append using results_irf_`dt'_pe`i'_order`or'.dta
}
save results_irf_`dt'_pe_all_order`or'.dta, replace



use  results_irf_`dt'_pe_all_order`or'.dta, clear


sort lat lon

merge n:1 lat lon using `dt'_latlon_matched.dta

count if (lat != lat[_n-1] | lon != lon[_n-1]) & _merge == 3

keep if _merge == 3
drop _merge

sort  lat_std lon_std response impulse step

duplicates report lat_std lon_std response impulse step


* final file of IRF results *
save final_irf_`dt'_pe_all_order`or'.dta, replace






******  NEW: compute mean  ************

local dt   = "GFDL_CM3"

cd "/media/tack/Climate4c/piControl_`dt'/piControl_finalstata"


forvalues j = 1/18 {

di " --------------------   location = `j' /  18 ------------------------- "

use `dt'_piControl_latgg`j'_30yr.dta, clear

*gen month=month(time)
*gen year=year(time)
*gen day=day(time)

sort lat lon
bysort lat lon: egen m_pr = mean(pr)
bysort lat lon: egen m_pe = mean(pe)
bysort lat lon: egen m_circul = mean(circul)
bysort lat lon: egen m_thermal = mean(thermal)
bysort lat lon: egen m_viha = mean(viha)
bysort lat lon: egen m_localq = mean(localq)
bysort lat lon: egen m_hfls = mean(hfls)

bysort lat lon: egen sd_pr = sd(pr)
bysort lat lon: egen sd_pe = sd(pe)
bysort lat lon: egen sd_circul = sd(circul)
bysort lat lon: egen sd_thermal = sd(thermal)
bysort lat lon: egen sd_viha = sd(viha)
bysort lat lon: egen sd_localq = sd(localq)
bysort lat lon: egen sd_hfls = sd(hfls)

bysort lat lon: keep if _n == 1

keep lat lon loc loc2 m_pr-sd_hfls
sort lat lon

save  "/media/tack/Climate4c/piControl_`dt'/piControl_mean/mean_`dt'_piControl_latg_group`j'.dta", replace
}


cd "/media/tack/Climate4c/piControl_`dt'/piControl_mean/"

use mean_`dt'_piControl_latg_group1.dta, clear

forvalues j = 2/18 {
 append using mean_`dt'_piControl_latg_group`j'.dta
}

save mean_`dt'_piControl_latg_all.dta, replace




* match with standard grid *

cd "/media/tack/Climate4c/piControl_`dt'/piControl_mean/"

forvalues j =1/12960 {

di  "-------------------------- `j' / 12960 ------------------------ "

use "/media/tack/Climate4b/location_master2.dta", clear
 
qui {
 * lat1, lon1 are the base
 
local lat1 = lat[`j']
local lon1 = lon[`j']
local location1 = location[`j']

use  mean_`dt'_piControl_latg_all.dta, clear

gen lat_std = `lat1'
gen lon_std = `lon1'
gen location = `location1'

gen dist = sqrt((lat-`lat1')*(lat-`lat1') + (lon-`lon1')*(lon-`lon1'))

sort dist
gen xx = (dist != dist[_n-1] | _n == 1)
gen yy =  sum(xx)
keep if yy == 1

save "/media/tack/Climate4c/piControl_`dt'/dump/xclostest_mean_location`j'.dta", replace
}
}



cd  "/media/tack/Climate4c/piControl_`dt'/dump/"

clear
gen  lat_std = .
save  mean_`dt'_piControl_latg_all_matched.dta, replace

forvalues j =1/12960 {
 di  "-------------------------- `j' / 12960 ------------------------ "
 append using xclostest_mean_location`j'.dta
}

sort lat_std lon_std

save  "/media/tack/Climate4c/piControl_`dt'/piControl_mean/mean_`dt'_piControl_latg_all_matched.dta", replace







local dt = "GFDL_CM3"
local ex = "piControl"

cd "/media/tack/Climate4c/`ex'_`dt'/`ex'_finalstata/"


forvalues k= 2/18 {

di " --------------- group `k' ------------- "

use `dt'_`ex'_latgg`k'_30yr.dta, clear

sort lat lon year month day
bysort lat lon: gen circul1 = circul[_n-1]
bysort lat lon: gen circul2 = circul[_n-2]
bysort lat lon: gen circul3 = circul[_n-3]
bysort lat lon: gen thermal1 = thermal[_n-1]
bysort lat lon: gen thermal2 = thermal[_n-2]
bysort lat lon: gen thermal3 = thermal[_n-3]
bysort lat lon: gen viha1 = viha[_n-1]
bysort lat lon: gen viha2 = viha[_n-2]
bysort lat lon: gen viha3 = viha[_n-3]
bysort lat lon: gen hfls1 = hfls[_n-1]
bysort lat lon: gen hfls2 = hfls[_n-2]
bysort lat lon: gen hfls3 = hfls[_n-3]

bysort lat lon: gen circul4 = circul[_n-4]
bysort lat lon: gen circul5 = circul[_n-5]
bysort lat lon: gen circul6 = circul[_n-6]
bysort lat lon: gen thermal4 = thermal[_n-4]
bysort lat lon: gen thermal5 = thermal[_n-5]
bysort lat lon: gen thermal6 = thermal[_n-6]
bysort lat lon: gen viha4 = viha[_n-4]
bysort lat lon: gen viha5 = viha[_n-5]
bysort lat lon: gen viha6 = viha[_n-6]
bysort lat lon: gen hfls4 = hfls[_n-4]
bysort lat lon: gen hfls5 = hfls[_n-5]
bysort lat lon: gen hfls6 = hfls[_n-6]

bysort lat lon: gen pr1 = pr[_n-1]
bysort lat lon: gen pr2 = pr[_n-2]
bysort lat lon: gen pr3 = pr[_n-3]
bysort lat lon: gen pe1 = pe[_n-1]
bysort lat lon: gen pe2 = pe[_n-2]
bysort lat lon: gen pe3 = pe[_n-3]

order lat lon year month day pr circul thermal viha hfls circul1-viha3 hfls1-hfls3
save `dt'_`ex'_latg_group`k'.dta, replace

}



*** Obtain std grid from mean ***

local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

cd "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/"

* RCP45
* use mean_`dt'_`ex'_30yr1_std.dta, clear

* piControl
use mean_`dt'_`ex'_30yr_std.dta, clear


duplicates report lat lon
duplicates report lat_std lon_std

keep lat_std lon_std lat lon

gen lat_int = int(lat*100)/100
gen lon_int = int(lon*100)/100

sort lat_int lon_int

save `dt'_`ex'_stdgrid.dta, replace





**** Match with std grid  ******


local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

cd "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/"

forvalues j = 1/ 18 {

 di " --------- `j'/ 18 -------------- "
 
 use `dt'_`ex'_latgg`j'_30yr.dta, clear
 
 gen lat_int = int(lat*100)/100
 gen lon_int = int(lon*100)/100
 
 sort lat_int lon_int
 
 merge n:1  lat_int lon_int using `dt'_`ex'_stdgrid.dta
 
 keep if _merge == 3
 drop  _merge
 
 save `dt'_`ex'_latgg`j'_30yr_matched.dta, replace
}




** 20yr data creation **
 
forvalues j = 1/18 {
 di " ------------ `j'/ 18 ----------------- "
 use  `dt'_`ex'_latgg`j'_30yr_matched.dta, clear
 sum year
 keep if year <= 1869
 sort lat_std lon_std
 egen loc3_pi = group(lat_std lon_std)
 save `dt'_`ex'_latgg`j'_20yr_matched.dta, replace
}





**** SVAR Regression : regsave  +  SVAR --  20yr sample *****

local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

* cs = # of order cases
local cs = 9
*local j = 5

forvalues j = 6/6 {
cd   "/media/tack/`dr'/`ex'_`dt'/dump_VAR/"

clear
gen irf = .
forvalues z = 1/`cs' {
save "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`z'.dta", replace
}

clear
gen var = ""
save "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr.dta", replace




clear
local st = 1

* find # of locations
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
sort  loc3_pi
local nloc = loc3_pi[_N]


forvalues xx = 1/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & loc = `xx'  / `nloc' --- "

qui {
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
keep if loc3_pi == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v =  loc3_pi[1]

set seed 12345
tsset time
varsoc pr circul thermal viha hfls, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time

var viha thermal circul hfls pr, lags(1/`optlag') dfk small
regsave using regsave_tmp_group`j'_20yr.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order1) order(viha thermal circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order2) order(circul viha thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order3) order(thermal circul viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order4) order(hfls thermal circul viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order5) order(viha hfls pr thermal circul) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order6) order(thermal circul hfls pr viha) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order7) order(pr thermal circul viha hfls) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order8) order(pr viha thermal circul hfls) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order9) order(hfls pr circul viha thermal) replace


forvalues k = 1/`cs' {
 use pe`j'_20yr`y'_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std  = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'.dta"
 save         "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'.dta", replace
}

use regsave_tmp_group`j'_20yr.dta, clear
gen lat_std  = `lat1'
gen lon_std  = `lon1'
gen loc3 = `loc3v'
append using  "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr.dta"
save          "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr.dta", replace

}
}
}


***  summary statistics of raw values of components ***

* compute mean and std of variables *

local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

cd "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/"

clear
gen lat_std =.
save  mean_`dt'_`ex'_20yr.dta, replace

forvalues j = 1/18 {

di " ----- `j' / 18  ------ "

use "`dt'_`ex'_latgg`j'_20yr_matched.dta", clear

sort lat_std lon_std
bysort lat_std lon_std: egen m_pr = mean(pr)
bysort lat_std lon_std: egen m_hfls = mean(hfls)
bysort lat_std lon_std: egen m_circul = mean(circul)
bysort lat_std lon_std: egen m_thermal = mean(thermal)
bysort lat_std lon_std: egen m_viha = mean(viha)
bysort lat_std lon_std: egen m_localq = mean(localq)
bysort lat_std lon_std: egen m_vimc = mean(vimc)

bysort lat_std lon_std: egen sd_pr = sd(pr)
bysort lat_std lon_std: egen sd_hfls = sd(hfls)
bysort lat_std lon_std: egen sd_circul = sd(circul)
bysort lat_std lon_std: egen sd_thermal = sd(thermal)
bysort lat_std lon_std: egen sd_viha = sd(viha)
bysort lat_std lon_std: egen sd_localq = sd(localq)
bysort lat_std lon_std: egen sd_vimc = sd(vimc)

bysort lat_std lon_std: keep if _n == 1

keep lat_std lon_std m_* sd_*

append using mean_`dt'_`ex'_20yr.dta
save              mean_`dt'_`ex'_20yr.dta, replace

}

use  mean_`dt'_`ex'_20yr.dta, clear

gen model = "`dt'"
gen exp   = "`ex'"
gen yr  = 0
sort lat_std lon_std

save mean_`dt'_`ex'_20yr.dta, replace







**** SVAR Regression : SVAR + regsave  *****

local dt = "GFDL_CM3"
local ex = "piControl"

cd "/media/tack/Climate4c/`ex'_`dt'/dump_VAR/"

local nloc = 720

forvalues  j = 18/18 {

qui{
clear
gen irf = .
save "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/results_`ex'_irf_`dt'_group`j'_order1.dta", replace
save "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/results_`ex'_irf_`dt'_group`j'_order2.dta", replace
save "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/results_`ex'_irf_`dt'_group`j'_order3.dta", replace

clear
gen var = ""
save "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/regsave_`ex'_irf_`dt'_group`j'.dta", replace
}

forvalues xx =1/`nloc' {

di " ---- model = `dt' & exp = `ex' & group = `j' & loc = `xx'  / `nloc' ---- "

qui {
use  "/media/tack/Climate4c/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'.dta", clear
keep if loc2 == `xx'
local lat1   =  lat[1]
local lon1  =  lon[1]
local loc2v =  loc2[1]

tsset time
varsoc pr circul thermal viha hfls, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time
*oirf 3 (w/o localq)
var viha thermal circul hfls pr, lags(1/`optlag') dfk small

regsave using regsave_tmp_group`j'.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_loc`xx'_order1)  order(viha hfls thermal circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_loc`xx'_order2)  order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_loc`xx'_order3)  order(viha thermal circul hfls pr) replace

forvalues k = 1/3 {
 use pe`j'_loc`xx'_order`k'.irf, clear
 gen lat    = `lat1'
 gen lon   = `lon1'
 gen loc2 = `loc2v'
 
 append using     "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/results_`ex'_irf_`dt'_group`j'_order`k'.dta"
 save                  "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/results_`ex'_irf_`dt'_group`j'_order`k'.dta", replace
}

use regsave_tmp_group`j'.dta, clear
gen lat  = `lat1'
gen lon = `lon1'
gen loc2 = `loc2v'

append using  "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/regsave_`ex'_irf_`dt'_group`j'.dta"
save               "/media/tack/Climate4c/`ex'_`dt'/`ex'_varresults/regsave_`ex'_irf_`dt'_group`j'.dta", replace
 
}
}
}



**** piControl SVAR Regression : regsave  +  SVAR --  20yr sample + 24 orders *****
* after a break

local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

* cs = # of order cases
local cs = 30
local j  = 15
local st = 74

* find # of locations
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
sort  loc3_pi
local nloc = loc3_pi[_N]

forvalues xx = `st'/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & loc = `xx'  / `nloc' --- "

qui {
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
keep if loc3_pi == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v = loc3_pi[1]

set seed 12345
tsset time
varsoc pr circul thermal viha hfls, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time

var viha thermal circul hfls pr, lags(1/`optlag') dfk small
regsave using regsave_tmp_group`j'_20yr.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order1) order(viha thermal circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order2) order(circul viha thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order3) order(thermal circul viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order4) order(hfls thermal circul viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order11) order(viha thermal hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order12) order(viha circul thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order13) order(viha circul hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order14) order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order15) order(viha hfls thermal circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order16) order(circul viha hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order17) order(circul thermal viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order18) order(circul thermal hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order19) order(circul hfls viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order20) order(circul hfls thermal viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order21) order(thermal circul hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order22) order(thermal viha circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order23) order(thermal viha hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order24) order(thermal hfls circul viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order25) order(thermal hfls viha circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order26) order(hfls thermal viha circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order27) order(hfls circul viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order28) order(hfls circul thermal viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order29) order(hfls viha circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order30) order(hfls viha thermal circul pr) replace


forvalues k = 1/4 {
 use pe`j'_20yr_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta"
 save         "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta", replace
}

forvalues k = 11/`cs' {
 use pe`j'_20yr_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta"
 save         "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta", replace
}

use regsave_tmp_group`j'_20yr.dta, clear
gen lat_std  = `lat1'
gen lon_std = `lon1'
gen loc3 = `loc3v'
append using  "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr_v2.dta"
save          "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr_v2.dta", replace

}
}




**** piControl SVAR Regression : regsave  +  SVAR --  20yr sample + 24 orders *****


local dt = "GFDL_CM3"
local ex = "piControl"
local dr = "D7040"

* cs = # of order cases
local cs = 30

forvalues j = 12/12 {
cd     "/media/tack/`dr'/`ex'_`dt'/dump_VAR/"

clear

gen irf = .

forvalues z = 1/4 {
 save "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`z'_v2.dta", replace
}

forvalues z = 11/`cs' {
save "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`z'_v2.dta", replace
}

clear
gen var = ""
save "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr_v2.dta", replace



clear
local st = 1

* find # of locations
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
sort  loc3_pi
local nloc = loc3_pi[_N]

forvalues xx = 1/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & loc = `xx'  / `nloc' --- "

qui {
use  "/media/tack/`dr'/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latgg`j'_20yr_matched.dta", clear
keep if loc3_pi == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v = loc3_pi[1]

set seed 12345
tsset time
varsoc pr circul thermal viha hfls, maxlag(14)
matrix Z = r(stats)
svmat Z, name(col)
egen minh = min(AIC)
gen optimal_lag = lag if minh == AIC
sort optimal_lag
local optlag = optimal_lag[1]
sort time

var viha thermal circul hfls pr, lags(1/`optlag') dfk small
regsave using regsave_tmp_group`j'_20yr.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order1) order(viha thermal circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order2) order(circul viha thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order3) order(thermal circul viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order4) order(hfls thermal circul viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order11) order(viha thermal hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order12) order(viha circul thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order13) order(viha circul hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order14) order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order15) order(viha hfls thermal circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order16) order(circul viha hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order17) order(circul thermal viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order18) order(circul thermal hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order19) order(circul hfls viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order20) order(circul hfls thermal viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order21) order(thermal circul hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order22) order(thermal viha circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order23) order(thermal viha hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order24) order(thermal hfls circul viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order25) order(thermal hfls viha circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order26) order(hfls thermal viha circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order27) order(hfls circul viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order28) order(hfls circul thermal viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order29) order(hfls viha circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr_loc`xx'_order30) order(hfls viha thermal circul pr) replace


forvalues k = 1/4 {
 use pe`j'_20yr_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta"
 save         "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta", replace
}

forvalues k = 11/`cs' {
 use pe`j'_20yr_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta"
 save         "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr_order`k'_v2.dta", replace
}

use regsave_tmp_group`j'_20yr.dta, clear
gen lat_std  = `lat1'
gen lon_std = `lon1'
gen loc3 = `loc3v'
append using  "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr_v2.dta"
save          "/media/tack/`dr'/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr_v2.dta", replace

}
}
}










***  summary statistics of raw values of components ***
* compute mean and std of variables *

local dt = "GFDL_CM3"
local ex = "piControl"

cd "/media/tack/Climate4c/`ex'_`dt'/`ex'_finalstata/"

clear
gen lat =.
save  mean_`dt'_`ex'_30yr.dta, replace

forvalues j = 1/18 {

di " ----- `j' / 18 ------ "

use "`dt'_`ex'_latgg`j'_30yr.dta", clear

sort lat lon
bysort lat lon: egen m_pr = mean(pr)
bysort lat lon: egen m_hfls = mean(hfls)
bysort lat lon: egen m_circul = mean(circul)
bysort lat lon: egen m_thermal = mean(thermal)
bysort lat lon: egen m_viha = mean(viha)
bysort lat lon: egen m_localq = mean(localq)
bysort lat lon: egen m_vimc = mean(vimc)

bysort lat lon: egen sd_pr = sd(pr)
bysort lat lon: egen sd_hfls = sd(hfls)
bysort lat lon: egen sd_circul = sd(circul)
bysort lat lon: egen sd_thermal = sd(thermal)
bysort lat lon: egen sd_viha = sd(viha)
bysort lat lon: egen sd_localq = sd(localq)
bysort lat lon: egen sd_vimc = sd(vimc)

bysort lat lon: keep if _n == 1

keep lat lon m_* sd_*

append using mean_`dt'_`ex'_30yr.dta
save              mean_`dt'_`ex'_30yr.dta, replace

}


