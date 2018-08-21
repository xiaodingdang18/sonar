



ProjectName="IntelligentLogisticsForIOS"
#scheme名字 -可以点击Product->Scheme->Manager    Schemes...查看
Scheme="IntelligentLogistics"

Workspace=`pwd` 

echo "xcodebuild clean"
xcodebuild -workspace "$Workspace/$ProjectName.xcworkspace" -scheme "$Scheme" clean

echo "xcodebuild analyze | tee xcodebuild.log | xcpretty --report json-compilation-database"
xcodebuild -workspace "$Workspace/$ProjectName.xcworkspace" \
-configuration Debug \
-scheme "$Scheme"  COMPILER_INDEX_STORE_ENABLE=NO analyze | tee xcodebuild.log | \
xcpretty -r  json-compilation-database

echo "mv compilation_db.json compile_commands.json"
mv ./build/reports/compilation_db.json ./compile_commands.json

echo "check folder existence"
if [ ! -d "build/sonar-reports" ]; then
mkdir -p build/sonar-reports
fi

echo "oclint-json-compilation-database"
oclint-json-compilation-database \
-v \
-- \
-report-type pmd -o build/sonar-reports/oclint.xml \
-max-priority-1=99999 -max-priority-2=99999 -max-priority-3=99999 \
-rc LONG_METHOD=300 \
-rc LONG_VARIABLE_NAME=50 \
-rc LONG_CLASS=3000 \
-rc NCSS_METHOD=300 \
-rc NESTED_BLOCK_DEPTH=8 \

echo "upload generated oclint report to sonar qube server"
#sonar-scanner -X

echo "clean up"
#rm -rf .scannerwork
#rm -rf xcodebuild.log
#rm -rf compile_commands.json
#rm -rf build/sonar-reports/oclint.xml

