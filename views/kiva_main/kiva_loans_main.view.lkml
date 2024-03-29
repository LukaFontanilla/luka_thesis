view: kiva_loans_main {
  sql_table_name: lukathesis.kiva_loans_main ;;
  drill_fields: [id]

####
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    link: {
      label: "Kiva Loan Page"
      url: "https://www.kiva.org/lend?queryString={{value}}"
    }
  }

  dimension: pic_img {
    type: string
    sql: 'https://dummyimage.com/600x400/000/fff' ;;
    html: <a href="https://dummyimage.com/600x400/000/fff" target="_blank"><img src="{{value}}" /></a>;;
  }

  filter: datetest {
    type: date
  }

  parameter: jgksg {
    type: date
    label: ""
  }

  dimension: datetest2 {
    type: date
    sql: {% date_start datetest %} ;;
  }

  dimension: activity {
    type: string
    sql: ${TABLE}.activity ;;
    html: {% assign val = activity %}
    {% for value in val %}
            <h1>{{value}}</h1>
          {% endfor %};;
  }

  measure: activity_list {
    type: list
    list_field: activity
  }

  parameter: date {
    type: date
  }

  dimension: datedate {
    type: string
    sql: case when current_date() < {{ date._parameter_value }} then "uh-oh" else "yuik" end ;;
  }

  measure: test {
    type: string
    sql: max("test") ;;
    html: {% assign val = activity_list._value | split: "," %}
    {% for value in val %}
            <h1>{{value}}</h1>
          {% endfor %} ;;
  }

  ### ----------------- borrower_genders is currently in a string array, unpack for analysis ###

  dimension: borrower_genders {
    type: string
    sql: ${TABLE}.borrower_genders;;
  }

  dimension: borrower_genders_bucket {
    type: string
    sql: CASE
            WHEN borrower_genders LIKE "male" AND borrower_genders NOT LIKE "%female%"
            THEN "male_only"
            WHEN borrower_genders LIKE "female" AND borrower_genders NOT LIKE "% male" OR SUBSTR(borrower_genders,0,1) LIKE "%fe"
            THEN "female_only"
         ELSE "male_female" END ;;
  }

  dimension: number_of_borrowers {
    type: number
    sql: ARRAY_LENGTH(SPLIT(kiva_loans_main.borrower_genders, ",")) ;;
  }

  #### ------------- end ####

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    link: {
      label: "Individual Country Overview"
      url: "/dashboards/3686?Country Filter={{value}}&Country 2nd Filter={{value}}"
    }
    #html: {{rendered_value}}||{{sector._rendered_value}} ;;
  }

  #### ----------- Reed's single tile viz hmtl template #####
  #### going to have the top 10 countries by mpi in a dash with each country's deets in the single tile viz #####

  dimension: lukaaaa {
    type: string
    sql: ${TABLE}.country ;;
    html: <div class="vis"><div class="vis-single-value" style="font-size:36px; background-image: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c); color:#000000"></div></div> ;;
  }

  dimension: country_test {
    type: string
    sql: ${TABLE}.country ;;
    html:
    <a href="#drillmenu" target="_self">
    <div class="vis">
    {% if country._value == "Philippines" %}
      <div class="vis-single-value" style="font-size:36px; background-image: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c); color:#000000">
    {% else %}
      <div class="vis-single-value" style="font-size:36px; background-image: linear-gradient(256deg, #ce66dc, #56dd91) 100%); color:#000000">
    {% endif %}
      <font color="#5A2FC2"; font-size:200%><center><b>{{value}}: </b>&nbsp; <img src="https://www.countryflags.io/{{country_code._value}}/shiny/64.png"></font>

      <p>Total Amount of Loans: {{ count._value  }}</p>
      <p><font color="#5A2FC2"; font-size:50%><center>Top Sectors by Loan Count</p>
      <p style="float:left; font-family: Times, serif;">
        <i class="fa fa-align-left">&nbsp;</i>First: {{ quick_window_function.sector1._value }} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <i class="fa fa-align-center">&nbsp;</i>Second: {{ quick_window_function.sector2._value }} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <i class="fa fa-align-right">&nbsp;</i>Third: {{ quick_window_function.sector3._value }}
      </p></center>
      </div>
    </div>
    </a>;;
  }

  dimension: kiva_image {
    type: string
    sql: ${country} ;;
    html: <div class="container">
            <img style='height: 50%; width: 50%; object-fit: contain' src="https://www-kiva-org.global.ssl.fastly.net/rgit6cb87e41a8dee496953ee375c971fb1b9114fd6c/img/kiva_k_cutout_new.jpg" />
          </div>;;
    }

  dimension: kiva_description {
    type: string
    sql: ${country};;
    html: <a href="#drillmenu" target="_self">
    <div class="vis">
    <div class="vis-single-value" style="font-size:36px; background-image: grey; color:#000000">
      <p><center>Kiva Data Paths</p>

      <p style="float:left; font-family: Times, serif;">
        <i class="fa fa-align-left">&nbsp;</i>Path: By Country  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <i class="fa fa-align-right">&nbsp;</i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Path: By MPI
      </p></center>
      </div>
    </div>
    </a> ;;
  }
  ##### ------------------- end #####

  ##### ------------------- Country Comparitor #####

  filter: country_select {
    type: string
    suggest_dimension: country
  }

  filter: date_Test {
    type:date
    view_label: " Common Date Range Filter"
    label: ""
    sql: {% condition %} timestamp(${date_raw}) {% endcondition %};;
  }

  dimension: country_comparitor {
    type: string
    sql: CASE
          WHEN {% condition country_select %} ${country} {% endcondition %} AND ${num.n} = 1
           THEN ${country}
          ELSE "Rest of Countries"
         END;;
  }

  ##### ------------------- End #####

  dimension: country_code {
    type: string
    sql: ${TABLE}.country_code ;;
    html: <div>
            <img src="https://www.countryflags.io/{{value}}/shiny/64.png">
            <p>{{country._rendered_value}}</p>
          </div>;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: disbursed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.disbursed_time ;;
  }

  dimension: funded_amount {
    type: number
    sql: ${TABLE}.funded_amount ;;
  }

  dimension_group: funded {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.funded_time ;;
  }

  dimension: lender_count {
    type: number
    sql: ${TABLE}.lender_count ;;
  }

  dimension: loan_amount {
    type: number
    sql: ${TABLE}.loan_amount ;;
  }

  dimension: loan_diff {
    type: number
    sql: ${loan_amount} - ${funded_amount} ;;
  }

  dimension: fully_funded {
    type: yesno
    sql: ${loan_diff} = 0;;
  }

  dimension: partner_id {
    type: number
    sql: ${TABLE}.partner_id ;;
  }

  dimension_group: posted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.posted_time ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: repayment_interval {
    type: string
    sql: ${TABLE}.repayment_interval ;;
  }

  dimension: sector {
    type: string
    sql: ${TABLE}.sector ;;
    link: {
      label: "testing"
      url: "{{link}}"
    }
    link: {
      label: "ggg"
      url: "{{link}}"
    }
  }

  dimension: tags {
    type: string
    sql: ${TABLE}.tags ;;
  }

  dimension: term_in_months {
    type: number
    sql: ${TABLE}.term_in_months ;;
  }

#   dimension: use {
#     type: string
#     sql: REGEXP_REPLACE(${TABLE}.use, "[[:punct:]]", " ") ;;
# #     html: {% assign kiva_loans_main.use = value %}
# #             {{value | downcase }}:{% for %};;
#   }

  measure: count {
    type: count
    drill_fields: [id]
    html: <a href="#drillmenu" target="_self">
    <div class="vis">
      <div class="vis-single-value" style="font-size:36px; background-image: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c); color:#000000">
      <p>{{rendered_value}}</p>
      </div>
    </div>;;
  }

  measure: count_yes {
    type: count
    filters: {
      field: fully_funded
      value: "yes"
    }
  }

  measure: percentage_fully_funded {
    type: number
    sql: ${count_yes}/${count} ;;
    value_format: "##.00%"
  }

  measure: stringggy {
    type: string
    sql: case when ${total_funded_amount} > 1000 then "jeahhh" else "nahhh" end ;;
  }

  measure: total_funded_amount {
    type: number
    sql: sum(${funded_amount})/${count_yes} ;;
  }


  ##### Measures to include
  ### start working on sums, slicing up the measures using filters (on region, state, country, sector, etc.)
  ### aggregate the type: number dimensions included median's, max's, filtered sum's, etc.
}
