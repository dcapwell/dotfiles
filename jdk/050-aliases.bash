alias javadefault='java -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal 2>/dev/null'
if [ -e $HOME/Applications/mat.app/Contents/Eclipse/plugins/org.eclipse.equinox.launcher_*.jar ]; then
  alias eclipse_memory_analyzer='java -XstartOnFirstThread -Xmx${HEAP_ANALYZER_XMX:-20g} -jar $HOME/Applications/mat.app/Contents/Eclipse/plugins/org.eclipse.equinox.launcher_*.jar'
  alias mat=eclipse_memory_analyzer
  alias java_memory_analyzer=eclipse_memory_analyzer
fi
