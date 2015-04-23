# creates a new maven project
mvn-gen() {
  if [ $# -lt 2 ]; then
    echo -e "Usage: mvn-gen [groupId] [artifactId]"
    return 1
  fi
  local groupId="$1"
  local artifactId="$2"
  mvn -B archetype:generate \
    -DarchetypeGroupId=org.apache.maven.archetypes \
    -DgroupId="$groupId" \
    -DartifactId="$artifactId"
}
