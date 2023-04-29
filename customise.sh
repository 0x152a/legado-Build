#!/bin/sh

# 清空18PlusList.txt
echo "">$APP_WORKSPACE/app/src/main/assets/18PlusList.txt
# 修改桌面阅读名为$APP_LAUNCH_NAME 
sed 's/"app_name">阅读/"app_name">'$APP_LAUNCH_NAME'/' $APP_WORKSPACE/app/src/main/res/values-zh/strings.xml -i
find $APP_WORKSPACE/app/src -regex '.*/storage/.*.kt' -exec sed "s/\${url}/\${url}$APP_WEBDAV_PATH/" {} -i \;
# 修改包名
sed "s/'.release'/'.$APP_PAKAGE_NAME_SUFFIX'/" $APP_WORKSPACE/app/build.gradle -i
sed "s/.release/.$APP_PAKAGE_NAME_SUFFIX/" $APP_WORKSPACE/app/google-services.json -i
# 签名apk
cp $INPUT_PATH/legado.jks $APP_WORKSPACE/app/legado.jks
sed '$r '"$INPUT_PATH/legado.sign"'' $APP_WORKSPACE/gradle.properties -i
# maven中央仓库回归
sed "/google()/i\        mavenCentral()" $APP_WORKSPACE/build.gradle -i
# Speed Up Gradle
sed -e '/android {/r '"$INPUT_PATH/speedup.gradle"'' \
    -e '/kapt {/a\  useBuildCache = true' \
    -e '/minSdkVersion/c\        minSdkVersion 26' \
    $APP_WORKSPACE/app/build.gradle -i
# 删除google services相关
sed -e "/com.google.firebase/d" \
    -e "/com.google.gms/d" \
    -e "/androidx.appcompat/a\    implementation 'androidx.documentfile:documentfile:1.0.1'" \
    $APP_WORKSPACE/app/build.gradle -i

