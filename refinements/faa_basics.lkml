include: "//faa/files/*.lkml"


# Add joins to the flights Explore
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

# Create a simplified aircraft Explore
explore: +aircraft {
  label: "Aircraft Simplified"
  fields: [aircraft.aircraft_serial, aircraft.name, aircraft.count]
}

# Set some primary keys
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
    hidden: yes
    type: sum
    sql: ${distance} ;;
  }
}
