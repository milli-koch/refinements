include: "//faa/files/*.lkml"

view: airports2 {
  extends: [airports]
  measure: count_in_california {
    type: count
    filters: {field:state  value:"CA"}
  }
}

explore: flights2 {
  extends: [flights]
  view_name: flights
  from: flights
  join: carriers {foreign_key: carrier}
  join: aircraft {foreign_key: tail_num}
}

explore: airports2 {
  extends: [airports]
  from: airports2
  view_name: airports
}
