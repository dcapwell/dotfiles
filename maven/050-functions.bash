# creates a new maven project
mvn-gen() {
  if [ $# -lt 2 ]; then
    echo -e "Usage: mvn-gen [groupId] [artifactId]"
    return 1
  fi
  local groupId="$1"
  local artifactId="$2"
  mvn -B archetype:generate \
    -DarchetypeGroupId=com.github.dcapwell.dotfiles.archetype \
    -DarchetypeArtifactId=basic \
    -DarchetypeVersion=0.1 \
    -DinteractiveMode=false \
    -DgroupId="$groupId" \
    -DartifactId="$artifactId"
}
