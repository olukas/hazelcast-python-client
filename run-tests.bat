set HAZELCAST_VERSION=3.8.2-SNAPSHOT

set HAZELCAST_RC_VERSION=0.2-SNAPSHOT
set SNAPSHOT_REPO=https://oss.sonatype.org/content/repositories/snapshots
set RELEASE_REPO=http://repo1.maven.apache.org/maven2

call mvn dependency:get -DrepoUrl=%SNAPSHOT_REPO% -Dartifact=com.hazelcast:hazelcast-remote-controller:%HAZELCAST_RC_VERSION% -Ddest=hazelcast-remote-controller-%HAZELCAST_RC_VERSION%.jar
call mvn dependency:get -DrepoUrl=%SNAPSHOT_REPO% -Dartifact=com.hazelcast:hazelcast:%HAZELCAST_VERSION% -Ddest=hazelcast-%HAZELCAST_VERSION%.jar

call pip install -r test-requirements.txt --user

echo starting Hazelcast ...
start /min "hazelcast-remote-controller" cmd /c "java -Dhazelcast.enterprise.license.key=%HAZELCAST_ENTERPRISE_KEY% -cp hazelcast-remote-controller-%HAZELCAST_RC_VERSION%.jar;hazelcast-%HAZELCAST_VERSION%.jar com.hazelcast.remotecontroller.Main> rc_stdout.txt 2>rc_stderr.txt"

echo wait for Hazelcast to start ...
ping -n 15 127.0.0.1 > nul

echo Starting tests ...
call python -m nose -v --with-xunit --with-coverage --cover-xml --cover-package=hazelcast --cover-inclusive --nologcapture

