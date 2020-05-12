clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_002.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke
**	Date Created:	12/05/2020
**	Date Modified: 	12/05/2020
**  Algorithm Task: Inital Descriptives for MoHW


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


*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p153"
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p153/version01/3-output"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p153"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153/version01/3-output"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"

*Load in data from encrypted location
use "`datapath'/version01/1-input/BarbadosCovid19_KABP.dta", clear

/*
This algorithm provides basic descriptives for key variables for reporting of 
results of the COVID-19 KABP Barbados study. 
*/


*-------------------------------------------------------------------------------

*Descriptives

*Age
rename q0001 age
destring age, replace

*Age categories (10-year bands)
gen agegrp = age
recode agegrp (18/29=1) (30/39=2) (40/49=3) (50/59=4) (60/69=5) (70/max=6)
label var agegrp "Age Category (10-year bands)"
label define agegrp 1	"18-29" ///
					2	"30-39" ///
					3	"40-49" ///
					4	"50-59" ///
					5	"60-69" ///
					6	"70 & over"
label value agegrp agegrp


//Keep male and female
rename q0004 gender
gen sex = .
replace sex =1 if gender == 1 // Female
replace sex =2 if gender == 2 // Male
label var sex "Sex"
label define sex 1"Female" 2"Male"
label value sex sex
*Note others (transgender women; gender fluid)

*Education
gen education = .
replace education = 1 if q0012 == 1 //no primary school
replace education = 1 if q0012 == 2 //primary school
replace education = 2 if q0012 == 3 //some secondary school
replace education = 2 if q0012 == 4 //completed secondary school
replace education = 3 if q0012 == 5 //polytechnic/ BCC
replace education = 4 if q0012 == 6 //University
label var education "Education"
label define education 1"Primary/less" 2"Secondary" 3"Polytechnic/BCC" 4"University"
label value education education
*How should we deal with q0012_other [other education]

*Ethnicity
gen ethnic = . 
replace ethnic = 1 if q0013 == 1 // Black or African-decent
replace ethnic = 2 if q0013 == 5 // Indo-decent
replace ethnic = 3 if q0013 == 7 // Multiracial
replace ethnic = 4 if q0013 == 4 // White
replace ethnic = 5 if q0013 == 0 // Other
replace ethnic = 5 if q0013 == 2 // Other
replace ethnic = 5 if q0013 == 3 // Other
replace ethnic = 5 if q0013 == 8 // Other
label var ethnic "Ethnic Groups"
label define ethnic 1"Black or African" ///
					2"Indo-decent" ///
					3"Multiracial" ///
					4"White" ///
					5"Other"
label value ethnic ethnic

*Religion
gen religion = .
replace religion = 1 if q0014 == 1 // Anglican
replace religion = 2 if q0014 == 2 // Catholic
replace religion = 3 if q0014 == 3 // Baptist
replace religion = 4 if q0014 == 4 // Seventh Day Adventist
replace religion = 5 if q0014 == 5 // Muslim
replace religion = 6 if q0014 == 6 // Rastafarian
replace religion = 7 if q0014 == 7 // Hindu
replace religion = 8 if q0014 == 0 // Other
label var religion "Religion"
label define religion 1"Anglican" ///
					  2"Roman Catholic" ///
					  3"Baptist" ///
					  4"Seventh Day Adventist" ///
					  5"Muslim" /// 
					  6"Rastafarian" ///
					  7"Hindu" ///
					  8"Other"
label value religion religion


*Employment
rename q0015 employment
replace employment = 8 if employment == 0
label define q0015 8"Other", modify
label value employment q0015

*Parent guardian of children
gen parent_child = . 
replace parent_child = 1 if q0020_0001 == 1 // Under 6 months old
replace parent_child = 2 if q0020_0002 == 1 // Between 6 and 12 months
replace parent_child = 3 if q0020_0003 == 1 // More than 1 year to 5 years old
replace parent_child = 4 if q0020_0004 == 1 // 6 years to 10 years old
replace parent_child = 5 if q0020_0005 == 1 // 11 years to 15 years old
replace parent_child = 6 if q0020_0006 == 1 // 16 years to 18 years old
replace parent_child = 7 if q0020_0007 == 1 // Older than 18
replace parent_child = 8 if q0020_0008 == 1 // I do not have children
label var parent_child "Are you the parent/ guardian of children of any of the following ages?"
label define parent_child 1 "Under 6 months old" ///
						  2 "Between 6 and 12 months" ///
						  3 "More than 1 year to 5 years old" ///
						  4 "6 years to 10 years old" ///
						  5 "11 years to 15 years old" ///
						  6 "16 years to 18 years old" ///
						  7 "Older than 18" ///
						  8 "I do not have children"
label value parent_child parent_child
*Note: This question is multiple response and may need to be treated differently


*Job lost due to COVID-19
rename q0022 job_loss

*Savings to pay bills
rename q0023 save_bills
replace save_bills = 8 if save_bills == 0
label define q0023 8"Other", modify
label value save_bills q0023

*Work from home due to COVID
rename q0024 work_home
replace work_home = 5 if work_home == 0
label define q0024 5"Other", modify
label value work_home q0024

*Study from home due to COVID
rename q0025 study_home

//Essential workers
*Health workers
rename q0028 health_worker
*Essential worker
rename q0029 essential_worker

*Chronic Health conditions
gen health_condition = .
replace health_condition = 6 if q0031_0002 == 1 // Eye condititon
replace health_condition = 6 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace health_condition = 5 if q0031_0004 == 1 // Cancer
replace health_condition = 6 if q0031_0005 == 1 // Epilepsy/Seizue
replace health_condition = 3 if q0031_0006 == 1 // Stroke
replace health_condition = 2 if q0031_0007 == 1 // Hypertension
replace health_condition = 3 if q0031_0008 == 1 // Heart disease
replace health_condition = 4 if q0031_0009 == 1 // Asthma
replace health_condition = 4 if q0031_0010 == 1 // Empysema, bronchitis
replace health_condition = 4 if q0031_0011 == 1 // Tuberculosis
replace health_condition = 6 if q0031_0012 == 1 // Thyroid glands
replace health_condition = 1 if q0031_0013 == 1 // Diabetes
replace health_condition = 6 if q0031_0014 == 1 // Hyperlipidemia
replace health_condition = 6 if q0031_0015 == 1 // Kidney condition
replace health_condition = 6 if q0031_0016 == 1 // Liver condition
replace health_condition = 6 if q0031_0017 == 1 // Bowel condition
replace health_condition = 6 if q0031_0018 == 1 // Anaemia
replace health_condition = 6 if q0031_0019 == 1 // Genetic blood disorder
replace health_condition = 6 if q0031_0020 == 1 // Skelettomuscular disorder
replace health_condition = 6 if q0031_0021 == 1 // Autoimmune disorder
replace health_condition = 6 if q0031_0022 == 1 // Skin coniditon
replace health_condition = 7 if q0031_0023 == 1 // Depression
replace health_condition = 7 if q0031_0024 == 1 // Anxiety
replace health_condition = 7 if q0031_0025 == 1 // Schizophrenia
replace health_condition = 6 if q0031_0028 == 1 // Other
label var health_condition "Health coniditions"
label define health_condition 1 "Diabetes" ///
							  2 "Hypertension" ///
							  3 "Heart Disease" ///
							  4 "Respiratory Disease" ///
							  5 "Cancer" ///
							  6 "Other" ///
							  7 "Mental Disease"
label value health_condition health_condition

//Heart Disease
gen heart_disease = .
replace heart_disease = 1 if q0031_0006 == 1 // Stroke
replace heart_disease = 1 if q0031_0008 == 1 // Heart disease
label var heart_disease "Heart Disease"
label define heart_disease 1 "Heart Disease"
label value heart_disease heart_disease

//Diabetes
gen diabetes = .
replace diabetes = 1 if q0031_0013 == 1 // Diabetes
label var diabetes "Diabetes"
label define diabetes 1 "Diabetes"
label value diabetes diabetes

//Hypertension
gen hypertension = .
replace hypertension = 1 if q0031_0007 == 1 // Hypertension
label var hypertension "Hypertension"
label define hypertension 1 "Hypertension"
label value hypertension hypertension

//Respiratory Disease
gen resp_disease = .
replace resp_disease = 1 if q0031_0010 == 1 // Empysema, bronchitis
replace resp_disease = 1 if q0031_0011 == 1 // Tuberculosis
replace resp_disease = 1 if q0031_0009 == 1 // Asthma
label var resp_disease "Respiratory Disease"
label define resp_disease 1 "Respiratory Disease"
label value resp_disease resp_disease

//Cancer
gen cancer = .
replace cancer = 1 if q0031_0004 == 1 // Cancer
label var cancer "Cancer"
label define cancer 1"Cancer"
label value cancer cancer

// Mental Health Disease
gen men_disease = .
replace men_disease = 1 if q0031_0023 == 1 // Depression
replace men_disease = 1 if q0031_0024 == 1 // Anxiety
replace men_disease = 1 if q0031_0025 == 1 // Schizophrenia
label var men_disease "Mental Health Disease"
label define men_disease 1" Mental Health Disease"
label value men_disease men_disease

//Other Disease
gen other_disease = .
replace other_disease = 1 if q0031_0002 == 1 // Eye condititon
replace other_disease = 1 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace other_disease = 1 if q0031_0005 == 1 // Epilepsy/Seizue
replace other_disease = 1 if q0031_0012 == 1 // Thyroid glands
replace other_disease = 1 if q0031_0014 == 1 // Hyperlipidemia
replace other_disease = 1 if q0031_0015 == 1 // Kidney condition
replace other_disease = 1 if q0031_0016 == 1 // Liver condition
replace other_disease = 1 if q0031_0017 == 1 // Bowel condition
replace other_disease = 1 if q0031_0018 == 1 // Anaemia
replace other_disease = 1 if q0031_0019 == 1 // Genetic blood disorder
replace other_disease = 1 if q0031_0020 == 1 // Skelettomuscular disorder
replace other_disease = 1 if q0031_0021 == 1 // Autoimmune disorder
replace other_disease = 1 if q0031_0022 == 1 // Skin coniditon
replace other_disease = 1 if q0031_0028 == 1 // Other
label var other_disease "Other health condition"
label define other_disease 1 "Other"
label value other_disease other_disease

*Note: Should q0033 be analyzed?

*Worried about COVID-19
rename q0048 worried_covid

*Would like to be tested
rename q0050 test_interest

*Likely to be infected 
rename q0052 likely_infected

*Infection expectation
rename q0053 expect_infected

*Method of virus transmission (q0054)

*clear screen for focus on result only
cls			  
*Overall Descriptives
tabstat age, stat(mean median min max) col(stat)
tab agegrp
tab sex
tab education
tab ethnic
tab religion
tab employment
tab parent_child
tab1 q0020_0001 q0020_0002 q0020_0003 q0020_0004 q0020_0005 q0020_0006 ///
	 q0020_0007 q0020_0008
tab job_loss
tab save_bills
tab work_home
tab study_home
tab health_worker
tab essential_worker
tab health_condition
tab1 diabetes hypertension heart_disease resp_disease cancer ///
	 men_disease other_disease
tab worried_covid
tab test_interest
tab likely_infected
tab expect_infected
