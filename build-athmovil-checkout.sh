
echo "⚙️ Starting ATH-Movil-Chechout.sh \n"

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '\d\{1,2\}\.\d\{1,2\}$')

echo "🛠 Compiling for simulator 💻 \n"
xcodebuild -sdk iphonesimulator${SDK_VERSION} \
			-project "athmovil-checkout.xcodeproj" \
			-configuration Release \
			-enable_bitcode=NO

echo "🛠 Compiling for iphone 📱 \n"
xcodebuild -sdk iphoneos${SDK_VERSION} \
			-project "athmovil-checkout.xcodeproj" \
			-configuration Release \
			-enable_bitcode=NO

echo "🏁 Ending ATH-Movil-Chechout.sh \n"
