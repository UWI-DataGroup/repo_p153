

clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_003.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke & Christina Howitt
**	Date Created:	15/05/2020
**	Date Modified: 	15/05/2020
**  Algorithm Task: Graphs for MoHW


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


*Employment loss during COVID-19
#delimit ;
catplot job_loss employment,
percent(employment) 
var1opts(label(labsize(small))) 
var2opts(label(labsize(small)) relabel(`r(relabel)')) 
ytitle("Percent of Respondents by COVID job loss", size(small)) 
title("Employment lost during COVID" 
, span size(medium)) 
blabel(bar, format(%4.1f)) 
caption("Missing = 1008 responses", span size(vsmall)) 
intensity(75) 
asyvars
bar(1, color(maroon) fintensity(inten100)) 
bar(2, color(green) fintensity(inten100)) 
    ;
#delimit cr


*Parent and Guardians
label var q0020_0001 "Under 6 months old"
label var q0020_0002 "Between 6 and 12 months" 
label var q0020_0003 "More than 1 year to 5 years old" 
label var q0020_0004 "6 years to 10 years old" 
label var q0020_0005 "11 years to 15 years old"
label var q0020_0006 "16 years to 18 years old"
label var q0020_0007 "Older than 18"
label var q0020_0008 "I do not have children"

*Current Health Condition
label var diabetes "Diabetes"
label var hypertension "Hypertension"
label var heart_disease "Heart Disease"
label var resp_disease "Respiratory Disease"
label var cancer "Cancer"
label var men_disease "Mental Health Disease"
label var other_disease "Other Disease"
label var no_disease "No Health Condition"

*Method of COVID-19 Transmission
label var q0054_0001 "Talking with but not touching someone who has corona-virus but no symptoms"
label var q0054_0002 "Talking with but not touching with somone who has corona-virus"
label var q0054_0003 "Having physical contact with someone who has corona-virus but no symptoms"
label var q0054_0004 "Having physical contact with someone with corona-virus who has symptoms"
label var q0054_0005 "Being close (i.e. within 6 feet) to someone who has corona-virus, when they cough"
label var q0054_0006 "Being further away (i.e. further than 6 feet away) to someone who has corona-virus, when they cough or sneeze"
label var q0054_0007 "Touching contaminated objects (e.g. surfaces such as Shopping carts, door handles, etc.)"
label var q0054_0008 "Consumption of wild animal meat (e.g. rabbit, Iguana, monkey, yard fowl)"
label var q0054_0009 "Visiting public markets that sell fresh meat, fish or poultry"
label var q0054_0010 "Eating foods imported from China"
label var q0054_0011 "Using products imported from China"

*Protective Measures against COVID-19 transmission
label var q0055_0001 "Worn a face mask"
label var q0055_0002 "Washed hands more frequently with soap and water"
label var q0055_0003 "Used hand sanitizer more regularly"
label var q0055_0004 "Disinfected my home"
label var q0055_0005 "Covered my nose and mouth with a tissue or sleeve when sneezing and coughing"
label var q0055_0006 "Avoided being around with people who have a fever or cold like symptoms"
label var q0055_0007 "Avoided being  around people who have traveled"
label var q0055_0008 "Avoided going out in general"
label var q0055_0009 "Avoided crowded areas"
label var q0055_0010 "Avoided going to public markets that sell fresh meat, fish or poultry"
label var q0055_0011 "Avoided going to hospital and other healthcare settings"
label var q0055_0012 "Avoided taking public transport / bus"
label var q0055_0013 "Avoided going to work"
label var q0055_0014 "Avoided going to school / university"
label var q0055_0015 "Avoided letting my children go to school / university"
label var q0055_0016 "Avoided going into shops and supermarkets"
label var q0055_0017 "Avoided social events"
label var q0055_0018 "Avoided travel"
label var q0055_0019 "Avoided travel to other areas (outside Barbados) "
label var q0055_0020 "Avoided travel to other areas (inside Barbados)"
label var q0055_0021 "Moved temporarily to the countryside or a remote location"
label var q0055_0022 "Gargle with salt water"
label var q0055_0023 "Bathe in the sea"
label var q0055_0024 "Drink herbal /ginger/bush tea"

*Ability and Willingness to self-isolate
label var q0056_0001 "Ability to self-isolate"
label var q0056_0002 "Willingness to self-isolate"

*Lockdown Prepartions
label var q0057_0001 "Stocking up on food supplies"
label var q0057_0002 "Stocking up on toiletries"
label var q0057_0003 "Stocking up on prescription medicines"
label var q0057_0004 "Stocking up on over the counter medicines"
label var q0057_0005 "Stocking up on condoms, safe sex supplies"
label var q0057_0006 "Stocking up on birth control"
label var q0057_0007 "Establishing remote working capabilities"
label var q0057_0008 "Finding alternative childcare"

*Problems with lockdown
label var q0058_0001 "Mental Health"
label var q0058_0002 "Space in household" 
label var q0058_0003 "Obtaining supplies" 
label var q0058_0004 "Carer with no help" 
label var q0058_0005 "Social Life"
label var q0058_0006 "Financial"
label var q0058_0007 "Impact on education"
label var q0058_0008 "Don't know"
label var q0058_0009 "No problems"
label var q0058_0010 "Other"

*Source of COVID-19 Information
label var q0079_0001 "Newspaper(s)"
label var q0079_0002 "Magazine(s) (i.e. in print or online)" 
label var q0079_0003 "Radio" 
label var q0079_0004 "CBC / Channel 8" 
label var q0079_0005 "Cable television / Satellite"
label var q0079_0006 "Official websites"
label var q0079_0007 "Unofficial websites"
label var q0079_0008 "Social Media"
label var q0079_0009 "My doctor"
label var q0079_0010 "Other healthcare professional"
label var q0079_0011 "My family or friends" 
label var q0079_0012 "Work / school / college communications" 
label var q0079_0013 "I am not getting any information" 
label var q0079_0014 "Other" 

*Information Preference
label var q0080_0001 "Research"
label var q0080_0002 "Common Sign and symptoms of infection"
label var q0080_0003 "Less Common Sign and symptoms of infection"
label var q0080_0004 "How to know if infected"
label var q0080_0005 "Information on transmission"
label var q0080_0006 "Information on prevention"
label var q0080_0007 "High risk groups"
label var q0080_0008 "Number of cases (Barbados)"
label var q0080_0009 "Distribution of cases (Barbados)"
label var q0080_0010 "Infection risk (Barbados)"
label var q0080_0011 "NPIs (Barbados)"
label var q0080_0012 "NPIs (Other Countries)"
label var q0080_0013 "NPIs (International organizations)"
label var q0080_0014 "I do want to receive any information"
label var q0080_0015 "Other"


//Chronic Health Conditions
#delimit ;
			mrgraph hbar no_disease hypertension resp_disease diabetes  heart_disease  cancer men_disease other_disease , 
			includemissing 
			width(15) 
			by(sex) 
			stat(column) 
			title(Chronic Health Condition, c(black) size(5)) 
			ylabel(0(10)100,angle(0) nogrid labs(3)) yscale(fill range(0(10)100)) 
			
			ytitle(Percent (%))
			
			legend(bmargin(t+1) cols(6) size(2))  
			
			oversubopts(label(labsize(small)))
			
			blabel(bar, size(vsmall) format(%4.1f))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
			bar(1, color(red) fintensity(inten100)) 
			bar(2, color(blue) fintensity(inten100)) 

    ;
#delimit cr

*-------------------------------------------------------------------------------

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




