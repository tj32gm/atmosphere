
*************** Quantile Rgressions ******************

* divide data set into smaller ones *

cd "/media/tack/Climate-5/`ex'_GFDL_CM3/stata_files"

local dt = "GFDL_CM3"

*local j = 1

forvalues j = 1/6 {
 use  `dt'_stata_latg`j'_all.dta, clear
 egen group = cut(loc2), group(6)
 replace group = group + 1
 save `dt'_stata_latg`j'_all.dta, replace
}


forvalues j = 1/6 {
 forvalues i=1/6 {
  use  `dt'_stata_latg`j'_all.dta, clear
  keep if group == `i'
  local k = `i' + 6*(`j'-1)
  dis " --------------------   k = `k' -----------------  "
  egen loc3 = group(lat lon)
  sum loc3
  save "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_finalstata/`dt'_stata_latg_group`k'.dta", replace
 }
}


local dt = "GFDL_CM3"

cd "/media/tack/Climate-5/`ex'_`dt'/RCP45_finalstata"

forvalues k= 1/36 {

di " --------------- group `k' ------------- "

use `dt'_stata_latg_group`k'.dta, clear

sort lat lon year month day
bysort lat lon: gen hfls1 = hfls[_n-1]
bysort lat lon: gen hfls2 = hfls[_n-2]
bysort lat lon: gen hfls3 = hfls[_n-3]

bysort lat lon: gen hfls4 = hfls[_n-4]
bysort lat lon: gen hfls5 = hfls[_n-5]
bysort lat lon: gen hfls6 = hfls[_n-6]
order lat lon year month day pr circul thermal viha hfls circul1-viha3 hfls1-hfls3
save `dt'_stata_latg_group`k'.dta, replace

}




cd "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_finalstata"

forvalues k= 1/36 {

di " --------------- group `k' ------------- "

use `dt'_stata_latg_group`k'.dta, clear

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

bysort lat lon: gen circul4 = circul[_n-4]
bysort lat lon: gen circul5 = circul[_n-5]
bysort lat lon: gen circul6 = circul[_n-6]
bysort lat lon: gen thermal4 = thermal[_n-4]
bysort lat lon: gen thermal5 = thermal[_n-5]
bysort lat lon: gen thermal6 = thermal[_n-6]
bysort lat lon: gen viha4 = viha[_n-4]
bysort lat lon: gen viha5 = viha[_n-5]
bysort lat lon: gen viha6 = viha[_n-6]

save `dt'_stata_latg_group`k'.dta, replace

}



**** Match with std grid  ******

local dt = "GFDL_CM3"
local ex = "RCP45"

cd "/media/tack/Climate-5/`ex'_`dt'/RCP45_finalstata/"


forvalues k = 1/36 {
 forvalues y = 1/2 {
 
 di " --------- `k'/ 36 & 30yr = `y' -------------- "
 
 use  `dt'_`ex'_latg_group`k'_30yr`y'.dta, clear
 
 gen lat_int = int(lat*100)/100
 gen lon_int = int(lon*100)/100
 
 sort lat_int lon_int
 
 merge n:1  lat_int lon_int using `dt'_`ex'_stdgrid.dta
 
 keep if _merge == 3
 drop  _merge
 
 save `dt'_`ex'_latg_group`k'_30yr`y'_matched.dta, replace
 }
}




*** 20 yr sample ***

local dt = "GFDL_CM3"
local ex = "RCP45"

cd "/media/tack/Climate-5/`ex'_`dt'/RCP45_finalstata/"


forvalues k = 1/ 36 {
 di " ------------- `k' / 36  -------------- "
 use   `dt'_`ex'_latg_group`k'_30yr1_matched.dta, clear
 keep if year <= 2025
 save `dt'_`ex'_latg_group`k'_20yr1_matched.dta, replace
 
 use   `dt'_`ex'_latg_group`k'_30yr2_matched.dta, clear
 keep if year >= 2081
 save `dt'_`ex'_latg_group`k'_20yr2_matched.dta, replace
}





**** SVAR Regression : regsave  +  SVAR *****

local dt = "GFDL_CM3"
local ex = "RCP45"

cd "/media/tack/Climate-5/`ex'_`dt'/dump_VAR/"

local nloc = 360

foreach j in  35 36 {

* y =1 if first 30yr and 2 otherwise
forvalues y = 1/2 {

qui{
clear
gen irf = .
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/results_`ex'_irf_`dt'_group`j'_30yr`y'_order1.dta", replace
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/results_`ex'_irf_`dt'_group`j'_30yr`y'_order2.dta", replace
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/results_`ex'_irf_`dt'_group`j'_30yr`y'_order3.dta", replace

clear
gen var = ""
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/regsave_`ex'_irf_`dt'_group`j'_30yr`y'.dta", replace
}


forvalues xx = 1/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & loc = `xx'  / `nloc' --- "

qui {
use  "/media/tack/Climate-5/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_30yr`y'.dta", clear
keep if loc3 == `xx'
local lat1 =  lat[1]
local lon1 =  lon[1]
local loc3v =  loc3[1]

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
regsave using regsave_tmp_group`j'_30yr`y'.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_30yr`y'_loc`xx'_order1)  order(viha hfls thermal circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_30yr`y'_loc`xx'_order2)  order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_30yr`y'_loc`xx'_order3)  order(viha thermal circul hfls pr) replace

forvalues k = 1/3 {
 use pe`j'_30yr`y'_loc`xx'_order`k'.irf, clear
 gen lat  = `lat1'
 gen lon  = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/results_`ex'_irf_`dt'_group`j'_30yr`y'_order`k'.dta"
 save              "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/results_`ex'_irf_`dt'_group`j'_30yr`y'_order`k'.dta", replace
}

use regsave_tmp_group`j'_30yr`y'.dta, clear
gen lat  = `lat1'
gen lon  = `lon1'
gen loc3 = `loc3v'
append using  "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/regsave_`ex'_irf_`dt'_group`j'_30yr`y'.dta"
save               "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults/regsave_`ex'_irf_`dt'_group`j'_30yr`y'.dta", replace

}
}
}
}



***  summary statistics of raw values of components ***
* compute mean and std of variables *

local dt = "GFDL_CM3"
local ex = "RCP45"
local y = 2

cd  "/media/tack/Climate-5/`ex'_`dt'/`ex'_finalstata/"

clear
gen lat =.
save  mean_`dt'_`ex'_30yr`y'.dta, replace

forvalues j = 1/36 {

di " ----- `j' / 36  ------ "

use "`dt'_`ex'_latg_group`j'_30yr`y'.dta", clear

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

append using mean_`dt'_`ex'_30yr`y'.dta
save         mean_`dt'_`ex'_30yr`y'.dta, replace

}



**** SVAR Regression : regsave  +  SVAR --  20yr sample *****


local dt = "GFDL_CM3"
local ex = "RCP45"
* cs = # of order cases
local cs = 9
*local j = 11
local y = 1

forvalues j = 23/24 {

cd     "/media/tack/Climate-5/`ex'_`dt'/dump_VAR/"

clear
gen irf = .
forvalues z = 1/`cs' {
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`z'.dta", replace
}

clear
gen var = ""
save "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'.dta", replace




clear
local st = 1

* find # of locations
use  "/media/tack/Climate-5/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
sort  loc3
local nloc = loc3[_N]


forvalues xx = 1/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & 20yr = `y' & loc = `xx'  / `nloc' --- "

qui {
use  "/media/tack/Climate-5/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
keep if loc3 == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v =  loc3[1]

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
regsave using regsave_tmp_group`j'_20yr`y'.dta, tstat ci detail(all)  replace

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
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'.dta"
 save                "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'.dta", replace
}

use regsave_tmp_group`j'_20yr`y'.dta, clear
gen lat_std  = `lat1'
gen lon_std  = `lon1'
gen loc3 = `loc3v'
append using  "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'.dta"
save                 "/media/tack/Climate-5/`ex'_`dt'/RCP45_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'.dta", replace

}
}
}



* compute mean and std of variables *

local dt = "GFDL_CM3"
local ex = "RCP45"
local dr = "Climate-5"

cd "D:/`ex'_`dt'/`ex'_finalstata"

forvalues y = 1/2 {

clear
gen lat_std =.
save  mean_`dt'_`ex'_20yr`y'.dta, replace

forvalues j = 1/36 {

di " ----- `j' / 36  ------ "

use "`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear

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

append using mean_`dt'_`ex'_20yr`y'.dta
save              mean_`dt'_`ex'_20yr`y'.dta, replace

}

use  mean_`dt'_`ex'_20yr`y'.dta, clear

gen model = "`dt'"
gen exp   = "`ex'"
gen yr  = `y'
sort lat_std lon_std

save mean_`dt'_`ex'_20yr`y'.dta, replace

}




* Run Quantile Rgressions *

cd "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_finalstata/"

local dt = "GFDL_CM3"

* group id : 1 ~ 36*
* # of location: i = 360 for all group


forvalues k = 21/36 {

di " --------------- group `k' ------------- "

forvalues i= 1/360 {

foreach qq in 0.05 0.1 0.25 0.5 0.75 0.9 0.95 {

use `dt'_stata_latg_group`k'.dta, clear

keep if loc3 == `i'

local lat1=  lat[1]
local lon1=  lon[1]

qreg pe circul thermal viha circul1-viha3 if loc3 == `i', q(`qq') vce(robust)

regsave using "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_qresults/RCP45_qresults_GFDL_CM3_group`k'_loc`i'_qtile`qq'.dta", tstat pval ci replace

use                "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_qresults/RCP45_qresults_GFDL_CM3_group`k'_loc`i'_qtile`qq'.dta", clear

* add information to regression results *
gen group = `k'
gen loc3   = `i'
gen lat =  `lat1'
gen lon = `lon1'
gen qtile = `qq'

save              "/media/tack/Climate-5/`ex'_GFDL_CM3/RCP45_qresults/RCP45_qresults_GFDL_CM3_group`k'_loc`i'_qtile`qq'.dta", replace
}
}
}






*** mean for GFDL_CM3 ***

local dt = "GFDL_CM3"

cd "/media/tack/Climate-5/`ex'_`dt'/RCP45_finalstata"


forvalues j = 25/36 {

di " --------------------   location = `j' /  36 ------------------------- "

use `dt'_stata_latg_group`j'.dta, clear

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


save "/media/tack/Climate-5/`ex'_`dt'/RCP45_mean/mean_`dt'_RCP45_latg_group`j'.dta", replace
}





local dt = "GFDL_CM3"

cd  "/media/tack/Climate-5/`ex'_`dt'/RCP45_mean"

use mean_`dt'_RCP45_latg_group1.dta, clear

forvalues j = 2/36 {
 append using mean_`dt'_RCP45_latg_group`j'.dta
}

save mean_`dt'_RCP45_latg_all.dta, replace




* match with stamdard grid *

local dt = "GFDL_CM3"

cd  "/media/tack/Climate-5/`ex'_`dt'/RCP45_mean"

forvalues j =1/12960 {

di  "-------------------------- `j' / 12960 ------------------------ "

use "/media/tack/Climate-5/location_master2.dta", clear
 
qui {
 * lat1, lon1 are the base
local lat1 = lat[`j']
local lon1 = lon[`j']
local location1 = location[`j']

use  mean_`dt'_RCP45_latg_all.dta, clear

gen lat_std = `lat1'
gen lon_std = `lon1'
gen location = `location1'

gen dist = sqrt((lat-`lat1')*(lat-`lat1') + (lon-`lon1')*(lon-`lon1'))

sort dist
gen xx = (dist != dist[_n-1] | _n == 1)
gen yy =  sum(xx)
keep if yy == 1

save "/media/tack/Climate-5/`ex'_`dt'/dump/xclostest_mean_location`j'.dta", replace
}

}



cd "/media/tack/Climate-5/`ex'_`dt'/dump/"

clear
gen  lat_std = .
save  mean_`dt'_RCP45_latg_all_matched.dta, replace

forvalues j =1/12960 {
 di  "-------------------------- `j' / 12960 ------------------------ "
 append using xclostest_mean_location`j'.dta
}

sort lat_std lon_std

save  "/media/tack/Climate-5/`ex'_`dt'/RCP45_mean/mean_`dt'_RCP45_latg_all_matched.dta", replace





**** RCP45 SVAR Regression : regsave  +  SVAR --  20yr sample + 24 orders *****


local dt = "GFDL_CM3"
local ex = "RCP45"
*local dr = "Climate-5"
local y = 2

* cs = # of order cases
local cs = 30

forvalues j = 29/29 {
cd   "D:/`ex'_`dt'/dump_VAR/"

clear
gen irf = .

forvalues z = 1/4 {
save "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`z'_v2.dta", replace
}

forvalues z = 11/`cs' {
save "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`z'_v2.dta", replace
}

clear
gen var = ""
save "D:/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'_v2.dta", replace


clear
local st = 1

* find # of locations
use  "D:/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
sort  loc3
local nloc = loc3[_N]

forvalues xx = `st'/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & 20yr =`y' & loc = `xx'  / `nloc' --- "

qui {
use  "D:/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
keep if loc3 == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v =  loc3[1]

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
regsave using regsave_tmp_group`j'_20yr`y'.dta, tstat ci detail(all)  replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order1) order(viha thermal circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order2) order(circul viha thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order3) order(thermal circul viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order4) order(hfls thermal circul viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order11) order(viha thermal hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order12) order(viha circul thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order13) order(viha circul hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order14) order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order15) order(viha hfls thermal circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order16) order(circul viha hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order17) order(circul thermal viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order18) order(circul thermal hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order19) order(circul hfls viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order20) order(circul hfls thermal viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order21) order(thermal circul hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order22) order(thermal viha circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order23) order(thermal viha hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order24) order(thermal hfls circul viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order25) order(thermal hfls viha circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order26) order(hfls thermal viha circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order27) order(hfls circul viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order28) order(hfls circul thermal viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order29) order(hfls viha circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order30) order(hfls viha thermal circul pr) replace


forvalues k = 1/4 {
 use pe`j'_20yr`y'_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta"
 save         "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta", replace
}


forvalues k = 11/`cs' {
 use pe`j'_20yr`y'_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta"
 save         "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta", replace
}

use regsave_tmp_group`j'_20yr`y'.dta, clear
gen lat_std  = `lat1'
gen lon_std = `lon1'
gen loc3 = `loc3v'
append using  "D:/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'_v2.dta"
save          "D:/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'_v2.dta", replace

}
}
}





**** RCP45 SVAR Regression : regsave  +  SVAR --  20yr sample + 24 orders *****
* after a break *


local dt = "GFDL_CM3"
local ex = "RCP45"
*local dr = "Climate-5"

cd   "D:/`ex'_`dt'/dump_VAR/"

* cs = # of order cases
local cs = 30
local y = 1
local j = 35
local st = 37

* find # of locations
use  "D:/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
sort  loc3
local nloc = loc3[_N]

forvalues xx = `st'/`nloc' {

di " --- model = `dt' & ex = `ex' & group = `j' & 20yr =`y' & loc = `xx'  / `nloc' --- "

qui {
use  "D:/`ex'_`dt'/`ex'_finalstata/`dt'_`ex'_latg_group`j'_20yr`y'_matched.dta", clear
keep if loc3 == `xx'
local lat1 =  lat_std[1]
local lon1 =  lon_std[1]
local loc3v =  loc3[1]

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
regsave using regsave_tmp_group`j'_20yr`y'.dta, tstat ci detail(all)  replace

*irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order1) order(viha thermal circul hfls pr) replace
*irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order2) order(circul viha thermal hfls pr) replace
*irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order3) order(thermal circul viha hfls pr) replace
*irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order4) order(hfls thermal circul viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order11) order(viha thermal hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order12) order(viha circul thermal hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order13) order(viha circul hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order14) order(viha hfls circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order15) order(viha hfls thermal circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order16) order(circul viha hfls thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order17) order(circul thermal viha hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order18) order(circul thermal hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order19) order(circul hfls viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order20) order(circul hfls thermal viha pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order21) order(thermal circul hfls viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order22) order(thermal viha circul hfls pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order23) order(thermal viha hfls circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order24) order(thermal hfls circul viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order25) order(thermal hfls viha circul pr) replace

irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order26) order(hfls thermal viha circul pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order27) order(hfls circul viha thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order28) order(hfls circul thermal viha pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order29) order(hfls viha circul thermal pr) replace
irf create var`xx', step(`optlag') set(pe`j'_20yr`y'_loc`xx'_order30) order(hfls viha thermal circul pr) replace


*forvalues k = 1/4 {
* use pe`j'_20yr`y'_loc`xx'_order`k'.irf, clear
* gen lat_std  = `lat1'
* gen lon_std = `lon1'
* gen loc3 = `loc3v'
 
* append using "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta"
* save         "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta", replace
*}


forvalues k = 11/`cs' {
 use pe`j'_20yr`y'_loc`xx'_order`k'.irf, clear
 gen lat_std  = `lat1'
 gen lon_std = `lon1'
 gen loc3 = `loc3v'
 
 append using "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta"
 save         "D:/`ex'_`dt'/`ex'_varresults_20yr/results_`ex'_irf_`dt'_group`j'_20yr`y'_order`k'_v2.dta", replace
}

use regsave_tmp_group`j'_20yr`y'.dta, clear
gen lat_std  = `lat1'
gen lon_std = `lon1'
gen loc3 = `loc3v'
append using  "D:/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'_v2.dta"
save          "D:/`ex'_`dt'/`ex'_varresults_20yr/regsave_`ex'_irf_`dt'_group`j'_20yr`y'_v2.dta", replace

}
}


