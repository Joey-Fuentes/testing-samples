#!/bin/bash -e

APP_URL=$(curl -u "$USERNAME:$ACCESS_KEY" -X POST "https://api-cloud.browserstack.com/app-automate/upload" -F "file=@./ui/espresso/BasicSample/app/build/outputs/apk/debug/app-debug.apk" | grep -Po '"app_url": *\K"[^"]*"' | sed 's/"//g')
TEST_URL=$(curl -u "$USERNAME:$ACCESS_KEY" -X POST "https://api-cloud.browserstack.com/app-automate/espresso/test-suite" -F "file=@./ui/espresso/BasicSample/app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk" | grep -Po '"test_url": *\K"[^"]*"' | sed 's/"//g')
BUILD_ID=$(curl -X POST "https://api-cloud.browserstack.com/app-automate/espresso/build" -d  "{\"devices\": [\"Google Pixel 3-9.0\"], \"app\": \"$APP_URL\", \"deviceLogs\" : true, \"testSuite\": \"$TEST_URL\"}" -H "Content-Type: application/json" -u "$USERNAME:$ACCESS_KEY" | grep -Po '"build_id": *\K"[^"]*"' | sed 's/"//g')
sleep 60
STATUS=$(curl -u "$USERNAME:$ACCESS_KEY" -X GET "https://api-cloud.browserstack.com/app-automate/espresso/v2/builds/$BUILD_ID" | grep -Po '"status": *\K"[^"]*"' | sed 's/"//g')
STATUS=$(echo $STATUS | awk '{print $1}')
if [ $STATUS == "passed" ]; then echo "On-target tests PASSED"; else exit 1; fi
echo $STATUS
