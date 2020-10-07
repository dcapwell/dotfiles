# functions 1024 based
function normalize_Ti(used) {
  if ( match(used, /([0-9]+)Ki/, value_split) )
    return (sprintf("%.2f", int(value_split[1]) / 1024 / 1024 / 1024) "Ti")
  else if ( match(used, /([0-9]+)Mi/, value_split) )
    return (sprintf("%.2f", int(value_split[1]) / 1024 / 1024) "Ti")
  else if ( match(used, /([0-9]+)Gi/, value_split) )
    return (sprintf("%.2f", int(value_split[1]) / 1024) "Ti")
  else if ( match(used, /([0-9]+)Ti/) )
    return used
  else
    return (sprintf("%.2f", int(used) / 1024 / 1024 / 1024 / 1024) "Ti")
}
# functions 1000 based
function normalize_k(used) {
  if ( match(used, /([0-9]+)k/) )
    return used
  else if ( match(used, /([0-9]+)m/) )
    return (sprintf("%.2f", int(used) / 1000 / 1000) "k")
  else
    return (sprintf("%.2f", int(used) / 1000) "k")
}
function normalize_no_unit(used) {
  if ( match(used, /([0-9]+)m/) )
    return sprintf("%.2f", int(used) / 1000)
  else {
    return used
  }
}

# dynamic dispatch
function normalize_units(used, hard) {
  if ( match(hard, /[0-9]+Ti/) ) {
    return normalize_Ti(used)
  } else if ( match(hard, /[0-9]+k/) ) {
    return normalize_k(used)
  } else if ( match(hard, /[0-9]+/) ) {
    return normalize_no_unit(used)
  } else {
    return used
  }
}
{
  value = normalize_units($2, $3)
  if (value != 0) {
    printf "%-55s%-20s%s\n", $1, value, $3
  }
}
