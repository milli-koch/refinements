include: "//faa/files/*.lkml"


# add joins to the explore
explore: +flights {
  join: carriers {
    foreign_key: carrier
    }
  join: aircraft {
    foreign_key: tail_num
    fields:[tail_num,year_built,count]
    }
  join: aircraft_models {
    foreign_key:aircraft.aircraft_model_code
    }
}

# set some primary keys
view: +aircraft {
  dimension: tail_num {primary_key:yes}
}
view: +aircraft_models {
  dimension: aircraft_model_code {primary_key:yes}
}
view: +carriers {
  dimension: code {primary_key:yes}
}

# Add useful fields to the flights view
view: +flights {
  measure: total_seats {
    type: sum
    sql: ${aircraft_models.seats} ;;
  }

  measure: flights.total_distance {
    type: sum
    sql: ${distance} ;;
  }

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
}
