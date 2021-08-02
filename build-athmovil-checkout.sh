
# This script compile the code for simulator and device. For simulator it is the x86_64 arch and for device arm64 arch
# When compile for simulator this script is overriding the arch because Simulator includes the arm64 and x86_64 so arm64 arch is not
# necesary because it will be in the device compilation.

echo "⚙️ Starting ATH-Movil-Chechout.sh \n"

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '\d\{1,2\}\.\d\{1,2\}$')

# Compile the code for simulator. This overide the arch from the project, it is only for x86_64, the arch arm64 is excluded because
# in the next command will create the framework for arm64 arch in 
echo "🛠 Compiling for simulator 💻 \n"
xcodebuild -sdk iphonesimulator${SDK_VERSION} \
			-project "athmovil-checkout.xcodeproj" \
			-configuration Release \
			-enable_bitcode=NO \
			-arch "x86_64"

# Compile the code for the arch arm64 
echo "🛠 Compiling for iphone 📱 \n"
xcodebuild -sdk iphoneos${SDK_VERSION} \
			-project "athmovil-checkout.xcodeproj" \
			-configuration Release \
			-enable_bitcode=NO \

echo "🏁 Ending ATH-Movil-Chechout.sh \n"
