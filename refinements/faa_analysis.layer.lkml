include: "//faa/files/*.lkml"
view: +flights {
  # final: yes
  dimension: aircraft_age {type:number  sql:${dep_year}-${aircraft.year_built};;}

  dimension: aircraft_age_tiered {
    type:tier
    sql: ${aircraft_age} ;;
    tiers: [5, 12]
  }

  dimension: timeliness {
    case: {
      when: { label: "Very Late" sql: ${arr_delay} > 60 ;;}
      when: { label: "Late" sql: ${arr_delay} > 20 ;;}
      when: { label: "Ontime" sql: ${arr_delay} <= 20 ;;}
    }
  }

  dimension: distance_tiered {
    type: tier
    sql: ${distance} ;;
    tiers: [500,1300]
  }

  measure: flights.total_distance {hidden: no}
}
