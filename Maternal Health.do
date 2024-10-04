// Group 6: Soha Moorad, Hassan Juzar, Sameen Agha Durrani, Hina Ahmed
// Data Anlytics Final Project Cleaning Do File


/// First, we start with merging:
/// I will be using the household member file as my master file since it has data for each individual member of the household. Each memebr can be individually identified by the line number, household number, and cluster number. 

************************** MASTER DATASET *************************************
///I will create a unique identifier that combines cluster number, household number, and line number.
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen unique=cluster+"-"+hh+"-"+ind
///save the file
************************* BIRTHS DATASET **************************************

///I am first going to merge the household the household member file with the births data.
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKBQ7ADT\PKBQ7AFL.DTA"

///for my own understanding, I am renaming the line number variable to match the same variable name as the line number variable in master file
rename qh26 qh01

///I will now create a unique identifier that concatenates the cluster number, household number, and member ID. 
///However, there are some children in this dataset that do not have a unique member ID because they do not exist in the master file (because they dont live in the household). These are indicated by line number "." or "0".
///In order to include them as well, I have given each of them a separate unique ID (denoted by code lines 33-36)
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen other_id=.
replace other_id=_n
replace other_id=other_id+1000 ///adding one thousand
tostring other_id, gen (otherID)
gen unique=cluster+"-"+hh+"-"+ind
gen unique_notliving=cluster+"-"+hh+"-"+otherID
replace unique=unique_notliving if qh01==.|qh01==0
duplicates drop unique, force

///Now I can do a 1:1 merge on the unique ID this will match all the unique member IDs and add additional rows below for the children that do not match because they were not in the original master file.

///Save the file and then open the master file 
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
///Conduct a many-to-one-marge 
merge 1:1 unique using "C:\Users\hassa\Downloads\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKBQ7ADT\PKBQ7AFL.DTA"
drop _merge
///save the file


*************************CHILDREN DATASET ************************************

///After saving the file, I will now repeat the same steps to merge the master file with the children datasets
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKCH7ADT\PKCH7AFL.DTA"
rename q219 qh01
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen other_id=.
replace other_id=_n
replace other_id=other_id+10000 ///adding ten thousand
tostring other_id, gen (otherID)
gen unique=cluster+"-"+hh+"-"+ind
gen unique_notliving=cluster+"-"+hh+"-"+otherID
replace unique=unique_notliving if qh01==.|qh01==0
///As with the previous file, there are children who are not in the master file because they do not live in the household, identified by line number "." or "0". To account for their non-unique IDs, I have given each of them a separate unique ID as well

///Save the file and open master dataset and merge 1:1 on unique ID
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
merge 1:1 unique using "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKCH7ADT\PKCH7AFL.DTA"
drop _merge
///save the file

************************HOUSEHOLD DATASET**************************************

///After saving the file, I will now merge the household dataset with the
///master file. Since this is at the household level, i will only use the 
///cluster number and household number to identify my datapoints. I will then 
///do a many-to-one merge since the household dataset had a unique entry for
///each household and the master file had multiple entries for each household
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKHH7ADT\PKHH7AFL.DTA"
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
gen unique=cluster+"-"+hh

///save the datafile and open the master dataset
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
merge m:1 qhclust qhnumber using "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKHH7ADT\PKHH7AFL.DTA"
drop _merge

*some were in the household dataset but not in the master dataset, so they have 
///been added
///Save the file


****************************WOMENS DATASET*************************************

///Now open the womens dataset and merge it 1:1 to the master dataset on the 
///unique ID created from cluster number, househhold number, and member ID
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKIQ7ADT\PKIQ7AFL.DTA"
rename qline qh01
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen unique=cluster+"-"+hh+"-"+ind

///save the file and open the master dataset
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
merge 1:1 unique using "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKIQ7ADT\PKIQ7AFL.DTA"
drop _merge

///Save the file


******************************VERBAL AUTOPSY DATASET***************************

///Now open the verbal autopsy dataset and merge it 1:1 to the master dataset on the 
///unique ID created from cluster number, househhold number, and member ID
///However, since the member IDs in the VA file are not present in the master 
///member file (since these are deceased), I will create a separate unique member
///ID for them denoted by code line 133
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKVA7ADT\PKVA7AFL.DTA"
rename qline qh01
replace qh01=qh01+100000 ///adding one hundred thousand
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen unique=cluster+"-"+hh+"-"+ind

///save the file and open the master dataset
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
merge 1:1 unique using "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKVA7ADT\PKVA7AFL.DTA"
drop _merge
///Since these individuals were deceased, they did not match to the master data 
///hence, they were added in addition to the master dataset

///Save the file

********************************OTHER DATA DATASET*****************************

///Now open the other data dataset and merge it 1:1 to the master dataset on the 
///unique ID created from cluster number, househhold number, and member ID
///However, the members mentioned in this dataset are not the same as those
///in the master file. Hence, I will first have to create new member IDs for them that 
///that are unique and distinct from those IDs in the master file, as denoted
///by code line 158
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKOD7ADT\PKOD7AFL.DTA"
rename qh29 qh01
replace qh01=qh01+1000000 ///adding a million
tostring qhclust, gen (cluster)
tostring qhnumber, gen (hh)
tostring qh01, gen (ind)
gen unique=cluster+"-"+hh+"-"+ind



///save the file and open the master dataset
use "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKPQ7ADT\PKPQ7AFL.DTA"
merge 1:1 unique using "C:\Users\hassa\OneDrive\Desktop\PK 2019 unzipped\PK_2019_SPECIAL_03282024_421_209560\PKOD7ADT\PKOD7AFL.DTA"
///Since the member IDs were different from those in the master file, the datasets did not match. New rows were instead added to the bottom of the master file.


// Now that the files are merged, we move onto cleaning the master file:


// Firstly, we will drop all the repeated variables which have the same function but have been repeated when the files were merged. 

// The duplicates command did not work, thus we switched to drop. Essentially their functions are the same, but drop was used because duplicate was not working and this is efficient.

// There is already a qhcluter variabledrop. therefore we drop the extra variable 

drop cluster

// There is already a qhnumber variable. therefore we drop the extra variable 

drop hh

// There is already a qh01 variable. therefore we drop the extra variable 

drop ind

// Renaming all the variables that are relevant to the Research Paper for our group

// Research Question: How did the mother's health contribute to the pregnancy experience overall? 

rename qhclust clust
rename qhnumber hhnumber
rename qh01 lnmember
rename qhdist district
rename qhregion region
rename qhtype residence_type
rename qhshort questionnare_hh_short
rename qhintd interview_day
rename qhintm interview_month
rename qhinty interview_year
rename qhintnum interview_num
rename qhresult interview_result
rename qhvisits hh_visit
rename qhmember hh_member
rename qhwomen hh_women
rename qhdwomen hh_dead_women
rename qhresp hh_ln_number_respondant
rename qhlangq lang_questionnare
rename qhlangi lang_interview
rename qhlangr lang_respondant
rename qhtrans translator
rename qhsuperv	supervisor_num
rename qhfedit field_ent_num
rename qhkeyer data_ent_clerk
rename qhintc hh_interview_date_cmc
rename qhintcd hh_interview_data_cdc
rename qh100h hh_interview_hr_start
rename qh100m hh_interview_mins_start
rename qhweight hh_weight
rename qhwomweight hh_weight_women
rename qhstrata sample_error
rename qhwlthf wealth_index_fector
rename qhwlthi wealth_index_quintile
rename qhwltfur wealth_index_factor_urban
rename qhwltiur wealth_index_quintile_urband
rename qhvacomp vaccinated
rename qh18 birth_after_2016
rename qh19 birth_num_after_2016
rename qh27 death_after_2016
rename qh28 death_num_after_2016
rename qh38 women_death_after_2016
rename qh146h hh_interview_hr_end
rename qh146m hh_interview_mins_end
rename qh101 source_water_drink
rename qh102 source_water_misc
rename qh103 source_water_loc
rename qh104 water_time_mins
rename qh106 water_unavailable_1_day
rename qh107 water_safety_measure_anything
rename qh108 water_safety_measure
rename qh109 toilet_type
rename qh110 toilet_shared_hh
rename qh111 toilet_shared_hh_num
rename qh112 toilet_location
rename qh113 cooking_fuel_type
rename qh114 cooking_loc
rename qh115 hh_separate_room
rename qh116 num_rooms_sleeping
rename qh117 agriculture_owned
rename qh118a cattle
rename qh118b other_cattle
rename qh118c horses_donkey_mule
rename qh118d goats
rename qh118e sheep
rename qh118f camel
rename qh118g poultry
rename qh121a electricity
rename qh121b radio
rename qh121c television
rename qh121d landline
rename qh121e refrigerator
rename qh121f closet
rename qh121g chair
rename qh121h room_cooler
rename qh121i airconditioner
rename qh121j washer
rename qh121k water_pump
rename qh121l bed
rename qh121m clock
rename qh121n sofa
rename qh121o camera
rename qh121p sewing_machine
rename qh121q computer
rename qh121r internet
rename qh122a watch
rename qh122b cell_phone
rename qh122c bicycle
rename qh122d motorcycle
rename qh122e animal_cart
rename qh122f motorvehicle
rename qh122g tractor
rename qh122h motorboat
rename qh122i boat
rename qh122j rickshaw
rename qh142 floor_material
rename qh143 roof_material
rename qh144 wall_material
rename qh03 head_relation
rename qh04 hh_member_sex
rename qh05 resident_usual
rename qh06 slept_last_night
rename qh07 hh_member_age
rename qh08 martial_status
rename qh09 female_interview_eligibility
rename qh16 any_school
rename qh17 most_school
rename ml07i individual_age_corrected
rename ml07f flag_age_corrected
rename mlpreg pregnancy_status_individual
rename qh20 ln_number_child
rename qh22 sex_child
rename qh23m birth_month
rename qh23y year_birth
rename qh24 live_birth
rename qh25 alive_child
rename qh23c dob_cmc
rename qh23f dob_flag
rename qline dead_ln_number_indi_questionnare
rename q212 dead_ln_number_child
rename q212a dead_number_pregnancy
rename q212b dead_child_dead_or_alive_birth
rename q212c dead_baby_movement
rename q213 dead_baby_sex
rename q215d dead_baby_dob
rename q215m dead_baby_mob
rename q215y dead_baby_yob
rename q216 dead_child_still_alive
rename q217 dead_child_age
rename q218 dead_child_hh_residence
rename q220u death_child_death_age
rename q220abd pregnancy_lost_day
rename q220abm pregnancy_lost_month
rename q220aby pregnancy_lost_year
rename q220ac pregnancy_duration
rename q220ad abortion
rename q221 other_pregnancy
rename qlast3 alive_dead_after_2016
rename q215cd dob_pregnancy_cdc
rename q215c dob_pregnancy_cmc
rename q215di dob_pregnancy_imputed
rename q215f flag_dob_pregnancy_cmc
rename q220c age_death_months_imputed
rename q220f flag_age_death_months_imputed
rename qregion region_residence_dead
rename qdist district_dead
rename qqtype dead_baby_questionnare
rename qintd dead_baby_day_interview
rename qintm dead_baby_month_interview
rename qinty dead_baby_year_interview
rename qintnum dead_baby_interviewer_number
rename qresult dead_baby_interview_result
rename qvisits dead_baby_total_visit
rename qlangq dead_baby_quesionnare_lang
rename qlangi dead_baby_interview_lang
rename qlangr dead_baby_respondanr_lang
rename qtrans dead_baby_translator
rename qsuperv dead_baby_supervisor_number
rename qfedit dead_baby_field_editor_num
rename qkeyer dead_baby_data_entry_clery
rename qintc dead_baby_date_interview_cmc
rename qintcd dead_baby_date_interview_cdc

// Women Variables Renamed:

rename qwftotal total_women
rename qwftype urban_rural_women
rename qwfreg region_women
rename qwfeduc education_women
rename qwfwlth wealth_index_women
rename qwfeduc1 educ_report_women
rename qwfregur region_urban_rural_women
rename q201 birth
rename q202 children_residing
rename q203a sons_residing
rename q203b daughters_residing
rename q204 children_away
rename q205a sons_away
rename q205b daughters_away
rename q206 children_dead
rename q207a son_died
rename q207b daughter_died
rename q207aa lost_pregnancy
rename q207bb lost_pregnancy_number
rename q208 total_children_alive_dead
rename q208a total_children_born
rename q222 pregnancy_between_interview
rename q224 births_since_2016_healthcare
rename q225 currently_pregnant
rename q226 duration
rename q227 wanted_pregnancy_at_time
rename q228 wanted_pregnancy
rename q226c date_conception_cmc
rename q226f flag_date_conception_cmc
rename q301 contraceptive_knowledge
rename q302 contraceptive_use
rename q303 ever_used
rename q304 side_effect_family_planning
rename q305 side_effect_awareness
rename q306a advice_fp_help
rename q306b advice_fp_explain
rename q307 source_info_fp
rename q308 visited_lhw_12_month
rename q309a lhw_fp
rename q309b lhw_info_antenatal_care
rename q309c lhw_info_deliver_care
rename q309d lhw_info_postnatal_care
rename q309e lhw_info_complications_pregnancy
rename q310a lhw_advice_treatment_malaria
rename q310b lhw_advice_treatment_diarrhea
rename q310c lhw_advice_treatment_fever
rename q310d lhw_advice_referral_fp
rename q310e lhw_advice_referral_antenatal
rename q310f lhw_advice_referral_delivery
rename q310x lhw_advice_other
rename q310x_code lhw_advice_other_code
rename q311 visit_healthfacility_12_months
rename q312 healthfacility_fp
rename q303n contraceptive_use_major
rename child3 child_birth_last3years

rename q403 ln_number_2
rename q406 antenatal_care_recieved
rename q407 antenatal_care_provider
rename q408 service_satisfaction
rename q409 antenatal_care_loc
rename q410 months_preg_first_antenatal
rename q411 antenatal_visits_during_preg
rename q412a antenatal_bp
rename q412b antenatal_urine_sample
rename q412c antenatal_blood_sample
rename q413a advice_on_early_breastfeeding
rename q413b advice_onearly_breastfeeding
rename q413c advice_on_balanced_diet 
r
rename q415 number_of_tetanus_injectionsrename 
rename q418 iron_tablets_during_pregnancy
rename q414 tetanus_during_pregnancy
rename q417 tetanus_before_pregnancy
rename q417a years_since_tetanus
rename q419 days_tookIron_tablets
rename q420 drugs_intestinal_parasites
rename q423 assistance_at_delivery
rename q424 place_of_delivery
rename q425 delivery_type
rename q426 timing_decision_caesarian
rename q426 time_decision_csection
rename q427 baby_head_first
rename q428 delivery_time
rename q429 induced_abortion
rename q430 loc_healthcare_abortion
rename q431 postnatal_check_facility
rename q438u time_respondant_postnatal_facility
rename q438n time_respondant_postnatal_homebirth
rename q438 person_checkup_respondant_discharged
rename q438b loc_checkup_respondant_discharged
rename q439 period
rename q440 months_no_period
rename q442 beginning_intercourse
rename q443 abstinence
rename q440f flag_amenorrhea
rename q443f flag_abstinence

rename q501a preg_problem_fever
rename q501b preg_problem_seizure
rename q501c preg_problem_vaginalbleed
rename q501d preg_problem_jaundice
rename q501e preg_problem_labdomin_pain
rename q501f preg_problem_vomitting
rename q501g preg_problem_gabdominpain
rename q501h preg_problem_blurry_vision
rename q501i preg_problem_headache
rename q501j preg_problem_ext_weakness
rename q501k preg_problem_sbreath_exercise
rename q501l preg_problem_sbreat_rest
rename q501m preg_problem_coma
rename q501n preg_problem_chestpain
rename q501o preg_problem_breath_diff
rename q501p preg_problem_cough
rename q501q preg_problem_highbp
rename q501r preg_problem_high_sugar
rename q501s preg_problem_weightloss
rename q501t preg_problem_unusual_weightgain
rename q501u preg_problem_micturiton
rename q501v preg_problem_bloodyuring
rename q501w preg_problem_bodyache
rename q501x preg_problem_anemia
rename q501y preg_problem_swollen_feet
rename q501z preg_problem_swollen_face

rename q502b duration_laborpain
rename q503a prob_ldel_prolpain
rename q503b prob_ldel_bleedbefore
rename q503c prob_ldel_bleedafterb
rename q503d prob_ldel_bleedafterp
rename q503e prob_ldel_retainp
rename q503f prob_ldel_umbcord_wrap
rename q503g prob_ldel_baby_nobreath
rename q503h prob_ldel_premie
rename q503i prob_ldel_vaginallac
rename q503j prob_ldel_babypres_breech
rename q503k prob_ldel_babypres_hand

rename q505a postpart_problem_fever
rename q505b postpart_problem_seizure
rename q505c postpart_problem_bleed
rename q505d postpart_problem_jaundice
rename q505e postpart_problem_vagdischarge
rename q505f postpart_problem_mictrution
rename q505g postpart_problem_incurince
rename q505h postpart_problem_weakness
rename q505i postpart_problem_pallor
rename q505j postpart_problem_sbreath
rename q505k postpart_problem_cough
rename q505l postpart_problem_btender
rename q505m postpart_problem_bswelling
rename q505n postpart_problem_binfection
rename q505o postpart_problem_btear_bulcer
rename q505p postpart_problem_swollenleg
rename q505q postpart_problem_fever_wound

rename q508a informed_pneumonia
rename q508b informed_jaundice
rename q508c informed_embolism
rename q508d informed_postpartum_infection
rename q508e informed_highbp
rename q508f informed_diabetes
rename q508g informed_any_infection
rename q508h informed_slow_fetus_growth
rename q508i informed_placenta_problem
rename q508j informed_position_problem
rename q508k informed_uterine
rename q508l informed_preeclampsia
rename q508x informed_other

rename q509a during_preg_treat_highbp
rename q509b during_preg_treat_diabetes
rename q509c during_preg_treat_nausea
rename q509d during_preg_treat_chestinfection
rename q509e during_preg_treat_anemia
rename q509f during_preg_treat_otherinfection
rename q509g during_preg_treat_preeclampsia
rename q509h during_preg_treat_premie_fetus
rename q509i during_preg_treat_preterml
rename q509j during_preg_treat_uti
rename q509k during_preg_treat_jaundice
rename q509l during_preg_treat_protien_urine
rename q509x during_preg_treat_other

rename q510 hospital_24_hrs_lastpreg
rename q510aa times_hospitalized_duringpreg
rename q510ab times_hospitalized_duringab
rename q510ac times_hospitalized_duringpp
rename q510ad times_hospitalized_afterpp

rename q511a before_preg_suffered_highbp
rename q511b before_preg_suffered_diabetes
rename q511c before_preg_suffered_obseity
rename q511d before_preg_suffered_cinfection
rename q511e before_preg_suffered_tb
rename q511f before_preg_suffered_hep
rename q511g before_preg_suffered_vvein
rename q511h before_preg_suffered_anemia
rename q511i before_preg_suffered_kidneyprob
rename q511j before_preg_suffered_epilepsy
rename q511k before_preg_suffered_stds
rename q511l before_preg_suffered_hiv_aids
rename q511x before_preg_suffered_other

rename q512 before_preg_surgery
rename q513 before_preg_cigarette
rename q514 avg_cig_daily
rename q515 after_preg_reduce_smoking
rename q516 before_preg_smoked_tob
rename q517 type_tob
rename q518 after_preg_reduce_tob
rename q519 before_preg_meds_use


