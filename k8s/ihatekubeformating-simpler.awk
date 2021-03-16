function split_unit(used, output) {
  if ( match(used, /([0-9]+)Ki/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "Ki"
    return 1
  } else if ( match(used, /([0-9]+)Mi/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "Mi"
    return 1
  } else if ( match(used, /([0-9]+)Gi/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "Gi"
    return 1
  } else if ( match(used, /([0-9]+)Ti/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "Ti"
    return 1
  } else if ( match(used, /([0-9]+)k/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "k"
    return 1
  } else if ( match(used, /([0-9]+)m/, value_split) ) {
    output[0] = int(value_split[1])
    output[1] = "m"
    return 1
  } else if ( match(used, /([0-9]+)/, value_split) ) {
		output[0] = int(value_split[1])
    output[1] = "" # unknown unit
    return 1
  }
  return 0
}
function to_unit(a, a_unit, b, b_unit) {
  if (a_unit == b_unit)
    return a
  if (b_unit == "Ti") {
    if (a_unit == "Ki")
      return a / 1024 / 1024 / 1024
    if (a_unit == "Mi")
      return a / 1024 / 1024
    if (a_unit == "Gi")
      return a / 1024
    if (a_unit == "")
      return a / 1024 / 1024 / 1024 / 1024
    print "unknown a unit: " a  a_unit " for b " b b_unit
    exit 1
  } else if (b_unit == "Gi") {
    if (a_unit == "Ki")
      return a / 1024 / 1024
    if (a_unit == "Mi")
      return a / 1024
    if (a_unit == "Gi")
      return a
    if (a_unit == "")
      return a / 1024 / 1024 / 1024
    print "unknown a unit: " a  a_unit " for b " b b_unit
    exit 1
  } else if (b_unit == "k") {
    if (a_unit == "")
      return a / 1000
    if (a_unit == "m")
      return a / 1000 / 1000
    print "unknown a unit: " a  a_unit " for b " b b_unit
    exit 1
  } else if (b_unit == "") {
    if (a_unit == "" ) {
      return a
    } else if (a_unit == "m") {
      return a / 1000
    }
  }
  print "unknown b unit: " b b_unit " with a unit " a a_unit
  exit 1
}
{
  if (split_unit($2, used) && split_unit($3, hard)) {
    value = to_unit(used[0], used[1], hard[0], hard[1])
    #value = normalize_units(unit, $2, $3)
    if (value != 0) {
      percentage = value / int(hard[0]) * 100
      printf "%-55s%-20s%-20s%s\n", $1, (sprintf("%.2f", value) hard[1]), $3, sprintf("%.2f%", percentage)
    }
  } else if ($1 == "Resource" && $2 == "Used") {
    printf "%-55s%-20s%-20s%s\n", "Resource", "Used", "Hard", "Used %"
  } else if ($1 == "--------") {
    printf "%-55s%-20s%-20s%s\n", "--------", "----", "----", "----"
  } else {
    print $0
  }
}
