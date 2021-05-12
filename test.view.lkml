# include: "/pdts/v1/outbound_sms_report_part_1_pdt_nube_1.view.lkml"
# include: "/pdts/v1/outbound_sms_report_part_1_pdt_nube_2.view.lkml"
# include: "/pdts/v1/outbound_sms_report_part_1_pdt_nube_3.view.lkml"
# include: "/pdts/v1/outbound_sms_report_part_1_pdt_nube_4.view.lkml"
# include: "/pdts/v1/outbound_sms_report_part_1_pdt_nube_5.view.lkml"

# view: outbound_sms_report_part_2_pdt {
#   parameter: schema {
#     type: unquoted
#     hidden: no
#     allowed_value: {
#       label: "Nube 1"
#       value: "nube1"
#     }
#     allowed_value: {
#       label: "Nube 2"
#       value: "nube2"
#     }
#     allowed_value: {
#       label: "Nube 3"
#       value: "nube3"
#     }
#     allowed_value: {
#       label: "Nube 4"
#       value: "nube4"
#     }
#     allowed_value: {
#       label: "Nube 5"
#       value: "nube5"
#     }
#     default_value: "nube1"
#   }


#   derived_table: {
#     sql:
#     select
#     primary_id, Campaign_Name, Parent_Campaign_Id, Campaign_Timestamp, Sub_campaign_Name,
#     Subcampaign_Id, Started_Date, Group_Name, Client, Member_id, Cs_Member,
#     First_Name, Last_Name, Ethnicity, Cohort,Race, Status, status_desc,
#     response_code, twilio_error_code, Outbound_SMS, Phone_type,
#     CAST(SMS_Timestamp as timestamp) as sms_timestamp,
#     Demographics_DOB, Demographics_Gender, Demographics_Language,
#     CASE
#     WHEN (length(Demographics_Zip_code) = 4) THEN concat('0', Demographics_Zip_code)
#     ELSE Demographics_Zip_code
#     END as demographics_zip_code,
#     phone_number, mobile_phone,
#     Demographics_Mobile_phone_type, Appointment_Location, sms_response_code
#     from
#     {% if outbound_sms_report_part_2_pdt.schema._parameter_value == 'nube1' %}
#     ${outbound_sms_report_part_1_pdt_nube_1.SQL_TABLE_NAME} as osr
#     {% elsif outbound_sms_report_part_2_pdt.schema._parameter_value == 'nube2' %}
#     ${outbound_sms_report_part_1_pdt_nube_2.SQL_TABLE_NAME} as osr
#     {% elsif outbound_sms_report_part_2_pdt.schema._parameter_value == 'nube3' %}
#     ${outbound_sms_report_part_1_pdt_nube_3.SQL_TABLE_NAME} as osr
#     {% elsif outbound_sms_report_part_2_pdt.schema._parameter_value == 'nube4' %}
#     ${outbound_sms_report_part_1_pdt_nube_4.SQL_TABLE_NAME} as osr
#     {% elsif outbound_sms_report_part_2_pdt.schema._parameter_value == 'nube5' %}
#     ${outbound_sms_report_part_1_pdt_nube_5.SQL_TABLE_NAME} as osr
#     {% endif %}

#     order by
#     osr.sms_timestamp
#     ;;
#   }


#   dimension: id {
#     type: number
#     primary_key: yes
#     sql: ${TABLE}.primary_id;;
#   }
#   dimension: Campaign_Name {
#     case_sensitive: no
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Campaign_Name ;;
#   }
#   dimension: Parent_Campaign_Id {
#     type: number
#     primary_key: no
#     sql: ${TABLE}.Parent_Campaign_Id ;;
#   }
#   dimension_group: campaign_T {
#     type: time
#     timeframes: [raw,time, hour_of_day,date,week,quarter,month,year]
#     sql: ${TABLE}.campaign_timestamp at time zone 'UTC' at time zone {% parameter timezone %} ;;
#     convert_tz: no

#   }
#   dimension: campaign_T_12hr {
#     label: "campaign_12hr_timestamp"
#     type: string
#     sql: to_char(${campaign_T_raw}, 'MM/DD/YYYY HH12:MI:SS AM') ;;
#     group_label: "Campaign T Date"
#   }

#   dimension: Sub_campaign_Name {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Sub_campaign_Name ;;
#   }
#   dimension: Subcampaign_Id {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Subcampaign_Id ;;
#   }
#   dimension_group: started{
#     type: time
#     timeframes: [raw,time,date,week,quarter,month,year]
#     sql: ${TABLE}.started_date at time zone 'UTC' at time zone {% parameter timezone %} ;;
#     convert_tz: no

#   }
#   dimension: started_T_12_hr {
#     label: "started_date"
#     type: string
#     sql: to_char(${started_raw}, 'MM/DD/YYYY HH12:MI:SS AM') ;;
#     group_label: "Started Date"
#   }
#   dimension: Group_Name {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Group_Name ;;
#   }
#   dimension: Client {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Client ;;
#   }
#   dimension: Member_id {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Member_id ;;
#   }
#   dimension: Cs_Member {
#     type: number
#     primary_key: no
#     sql: ${TABLE}.Cs_member ;;
#     value_format_name: id
#   }
#   dimension: First_Name {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.First_Name ;;
#   }
#   dimension: Last_Name {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Last_Name ;;
#   }
#   dimension: Ethnicity {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Ethnicity ;;
#   }
#   dimension: Cohort {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Cohort ;;
#   }
#   dimension: Race {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Race ;;
#   }
#   dimension: Status {
#     type: number
#     primary_key: no
#     sql: ${TABLE}.Status ;;
#   }
#   dimension: status_desc {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.status_desc ;;
#   }
#   dimension: response_code {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.response_code ;;
#   }
#   dimension: twilio_error_code {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.twilio_error_code ;;
#   }
#   dimension: Outbound_SMS {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Outbound_SMS ;;
#   }
#   dimension: Phone_type {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Phone_type ;;
#   }
#   dimension_group: sms_T {
#     type: time
#     timeframes: [raw,time,date,week,quarter,month,year]
#     sql: ${TABLE}.sms_timestamp at time zone 'UTC' at time zone {% parameter timezone %} ;;
#     convert_tz: no

#   }
#   dimension: sms_timestamp_12hr {
#     label: "sms_Timestamp"
#     type: string
#     sql: to_char(${sms_T_raw}, 'MM/DD/YYYY HH12:MI:SS AM') ;;
#     group_label: "Sms T Date"

#   }
#   dimension: Demographics_DOB {
#     type: date
#     primary_key: no
#     sql: ${TABLE}.Demographics_DOB ;;
#     convert_tz: no
#   }
#   dimension: Demographics_Gender {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Demographics_Gender ;;
#   }
#   dimension: Demographics_Language {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Demographics_Language ;;
#   }
#   dimension: demographics_zip_code {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.demographics_zip_code ;;
#   }
#   dimension: phone_number {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.phone_number ;;
#   }
#   dimension: mobile_phone {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.mobile_phone ;;
#   }
#   dimension: Demographics_Mobile_phone_type {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Demographics_Mobile_phone_type ;;
#   }
#   dimension: Appointment_Location {
#     type: string
#     primary_key: no
#     sql: ${TABLE}.Appointment_Location ;;
#   }
#   dimension: sms_response_code {
#     type: number
#     sql: ${TABLE}.sms_response_code ;;
#     value_format_name: id
#   }
#   dimension: sms_response_code_description {
#     type: string
#     sql: ${TABLE}.sms_response_code_description ;;
#   }
#   dimension: connected_call {
#     label: "Connected Call"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (22002, 22020, 22021, 22022, 22023,
#       22026, 22027, 22029, 22040, 22041, 22043, 22044, 22045, 22046, 22047, 22048,
#       22049, 22052, 22053, 22054, 22096, 22097, 22098, 22099);;
#   }
#   dimension: appointment_made {
#     label: "Appointment Made/Success"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11026, 11046, 11048, 22026, 22045, 22046, 22048);;
#   }
#   dimension: do_not_text {
#     label: "Do Not Text"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11097, 22097);;
#   }
#   dimension: do_not_call {
#     label: "Do Not Call"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11098, 22098);;
#   }
#   dimension: do_not_contact {
#     label: "Do Not Contact"
#     type: yesno
#     primary_key: no
#     sql:${do_not_text} is True and ${do_not_call} is True;;
#   }
#   dimension: wrong_designation{
#     label: "Wrong Designation"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11002, 22002);;
#   }
#   dimension: declined {
#     label: "Declined"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11096, 22096);;
#   }
#   dimension: wrong_number{
#     label: "Wrong Number/ No Number"
#     type: yesno
#     primary_key: no
#     sql:${sms_response_code} in (11020, 22020, 22027);;
#   }
#   parameter: timezone {
#     type: string
#     default_value: "UTC"
#     allowed_value: {
#       value: "UTC"
#     }
#     allowed_value: {
#       value: "America/Chicago"
#     }
#     allowed_value: {
#       value: "America/Los_Angeles"
#     }
#   }
#   measure: number_of_rows {
#     type: count
#   }
#   measure: count_of_campaign{
#     type: count_distinct
#     sql: ${Campaign_Name} ;;
#   }
# }
