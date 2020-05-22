

clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_003.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke & Christina Howitt
**	Date Created:	15/05/2020
**	Date Modified: 	22/05/2020
**  Algorithm Task: Tables and Graphs for MoHW Report


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*
NOTE:
The working directories here are set to both Windows and MAC OS

Thus before running this algorithm please ensure the appropriate *
are place under either MAC OS or Windows OS

For example if you are using Windows
Remove the * from all the code below WINDOW OS but leave the * under
MAC OS

*/


*Setting working directories

*WINDOWS OS
**Datasets to encrypted folder
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p153"
**Graph outputs to encrypted folder
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p153/version01/3-output"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p153"

*MAC OS
**Datasets to encrypted folder
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
**Logfiles to unencrypted folder
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The University of the West Indies/Github Repositories/repo_p153"
**Graph outputs to encrypted folder
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - PROJECT_p153/05_Outputs"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153/version01/3-output"



** Close any open log files and open new log file
capture log close
*log using "`logpath'/COVID_BIM_KABP_Descriptives", replace


*Install mrtab for dealing with multiple response questions
ssc install mrtab, replace

*Load in data from encrypted location
use "`datapath'/version01/2-working/BarbadosCovid19_KABP_v2.dta", clear


*DEMOGRAPHICS

*Stacked bar chart with age groups by sex

#delimit ;
			graph hbar,
			over(sex) 
			over(agegrp, relabel(7 "Missing")) 
			missing 
			stack asyvars 
			percentages 
			
			ylabel(0(10)100,angle(0) nogrid labs(3))
			ytitle("Percent (%)")
			
			blabel(bar,  position(center) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(red) fintensity(inten60)) 
			bar(2, color(blue) fintensity(inten60)) 
			bar(3, color(green) fintensity(inten60)) 
			
			title(Age Groups by Sex, c(black) size(5)) 
			
			legend(size(3) position(1.5) ring(2) colf cols(3) lc(gs16)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2) lc(gs16)) 
			sub("", size(1.75)) order(1 2 3)
			lab(3 "Missing")
						
    )
	name(age_sex_stack, replace) 
    ;
#delimit cr


graph export "`outputpath'/agegrp_sex.png", replace 


*-------------------------------------------------------------------------------
*Bar chart of age group distribution
#delimit ;
			graph bar,
			over(agegrp, relabel(7 "Missing")) 
			missing
			
			ylabel(0(10)100,angle(0) nogrid labs(3))
			ytitle("Percent (%)")
			
			blabel(bar,  position(top) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(gs7) fintensity(inten60)) 

			
			title(Age Groups Distribution , c(black) size(5)) 
			
	name(agegrps_overall, replace)
    ;
#delimit cr

graph export "`outputpath'/agegrp_overall.png", replace 
*-------------------------------------------------------------------------------

*Education
tab education sex, miss col

*Dependant Parent/Guardian
mrtab a0_5 a6_10 a11_18 a18_over ano_child, nonames


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*ECONOMIC ASPECTS

*Bar chart of employment distribution

label define employment 1 "Working full-time" ///
						2 "Working part-time" ///
						3 "Student" ///
						4 "Retired" ///
						5 "Self-employed" ///
						6 "Unemployed (Not seeking work)" ///
						7 "Unemployed (Seeking work)" ///
						8 "Other" , modify

label value employment employment
						
						
#delimit ;
			graph hbar,
			over(employment, relabel(9 "Missing")) 
			missing
			
			ylabel(0(10)100,angle(0) nogrid labs(3))
			ytitle("Percent (%)")
			
			blabel(bar,  position(top) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(gs7) fintensity(inten60)) 

			
			title(Employment Categories Distribution , c(black) size(5)) 
			
	name(employment_overall, replace)
    ;
#delimit cr

graph export "`outputpath'/employment_overall.png", replace 


*Stacked bar chart with employment by sex

#delimit ;
			graph hbar,
			over(sex) 
			over(employment, relabel(9 "Missing") lab(labs(2))) 
			missing 
			stack asyvars 
			percentages 
			
			ylabel(0(10)100,angle(0) nogrid labs(3))
			ytitle("Percent (%)")
			
			blabel(bar,  position(center) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(red) fintensity(inten60)) 
			bar(2, color(blue) fintensity(inten60)) 
			bar(3, color(green) fintensity(inten60)) 
			
			title(Employment by Sex, c(black) size(5)) 
			
			legend(size(2) position(1) ring(2) colf cols(3) lc(gs16)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2) lc(gs16)) 
			sub("", size(1.75)) order(1 2 3)
			lab(3 "Missing")
						
    )
	name(employment_sex_stack, replace) 
    ;
#delimit cr

graph export "`outputpath'/employment_sex.png", replace 


gen savings = save_bills
recode savings (2/5=2) (6=3) (7=4) (8=5)
label var savings "Based on your current savings how long can you pay your bills?"
label define savings 1 "Less than 1 month" ///
					 2 "1 to 6 months" ///
					 3 "More than 6 months" ///
					 4 "Not applicable" ///
					 5 "Other"
label value savings savings

tab savings, miss
tab savings sex, miss col
tab savings agegrp, miss col
					 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*CURRENT HEALTH CONDITIONS
 
 //Chronic Health Conditions
#delimit ;
			mrgraph hbar no_disease hypertension resp_disease diabetes  heart_disease  cancer men_disease other_disease , 
			includemissing 
			width(15) 
			by(sex) 
			stat(column) 
			title(Chronic Health Condition, c(black) size(5)) 
			ylabel(0(5)40,angle(0) nogrid labs(3)) yscale(fill range(0(5)40)) 
			
			ytitle(Percent (%))
			
			legend(bmargin(t+1) cols(6) size(2))  
			
			oversubopts(label(labsize(small)))
			
			blabel(bar, size(vsmall) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(red) fintensity(inten100)) 
			bar(2, color(blue) fintensity(inten100)) 
			
	name(current_health)

    ;
#delimit cr

graph export "`outputpath'/current_health_sex.png", replace 

					 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
					 
*ATTITUDES to COVID-19			

*Bar chart of Worried about getting COVID-19 distribution
#delimit ;
			graph hbar,
			over(worried, relabel(6 "Missing")) 
			missing
			
			ylabel(0(10)100,angle(0) nogrid labs(3))
			ytitle("Percent (%)")
			
			blabel(bar,  position(top) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(gs7) fintensity(inten60)) 

			
			title(Worried about COVID-19 outbreak in Barbados , c(black) size(5)) 
			
	name(worried_overall, replace)
    ;
#delimit cr
		 
graph export "`outputpath'/worried_Covid_Overall.png", replace 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*PRACTICES AND EXPERIENCES

*Lockdown Preparation
#delimit ;
			mrgraph hbar q0057_0001 - q0057_0008 , 
			includemissing 
			response(1)
			width(15) 
			stat(column) 
			title(Lockdown Preparation, c(black) size(4)) 
			ylabel(0(10)60,angle(0) nogrid labs(3)) yscale(fill range(0(10)60)) 
			
			ytitle(Percent (%))
			 
			
			oversubopts(label(labsize(vsmall)))
			
			blabel(bar, size(vsmall) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(purple) fintensity(inten60)) 
			
	name(lockdown_prep, replace)
	saving(lockdown_prep, replace)
    ;
#delimit cr

graph export "`outputpath'/lockdown_prep.png", replace 


*Lockdown Problems
#delimit ;
			mrgraph hbar q0058_0001 - q0058_0010 , 
			includemissing 
			response(1)
			width(15) 
			stat(column) 
			title(Problems with the Lockdown/Curfew, c(black) size(4)) 
			ylabel(0(5)30,angle(0) nogrid labs(3)) yscale(fill range(0(5)30)) 
			
			ytitle(Percent (%))
			 
			
			oversubopts(
			
			label(labsize(vsmall))
		
			)
			
			blabel(bar, size(vsmall) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(orange) fintensity(inten60)) 
			
	name(lockdown_prob, replace)
	saving(lockdown_prob, replace)

    ;
#delimit cr

graph export "`outputpath'/lockdown_prob.png", replace 



*Combine Graphs

#delimit ;
			gr combine lockdown_prep.gph lockdown_prob.gph, 
			ycommon

			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
	name(lockdown_combine, replace)
    ;
#delimit cr

graph export "`outputpath'/lockdown_combine.png", replace 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Protective measures against COVID-19 Transmission

//Note: remove q0055_0022 q0055_0023 q0055_0024 (These are myths to protect against infection)

#delimit ;
			mrgraph hbar  q0055_0001 q0055_0002 q0055_0003 
						  q0055_0005 q0055_0006 q0055_0007 
						  q0055_0008 q0055_0009 q0055_0011 
						  q0055_0012 q0055_0016  
						  , 
			 
			includemissing 
			response(1)
			width(15) 
			stat(column) 
			title(Protective Measures Against Transmission, c(black) size(4)) 
			ylabel(0(10)70,angle(0) nogrid labs(3)) yscale(fill range(0(10)70)) 
			
			ytitle(Percent (%))
			 
			
			oversubopts(
			
			label(labsize(tiny))
		
			)
			
			blabel(bar, size(vsmall) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(dknavy) fintensity(inten70)) 
			
	name(protection_overall, replace)
	saving(protection_overall, replace)


    ;
#delimit cr
