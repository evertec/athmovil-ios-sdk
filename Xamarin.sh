
clear

echo "⚙️ Starting Xamarin.sh \n"

# Remove the previous build
rm -R build

# Compile for iphone and simulator
sh build-athmovil-checkout.sh

# Join the framework for arm64 and x86_64 creating a Fat framework. This allows to run the SDK in simulator and device
sh build-framework.sh

# Using sharpie tool to create XamarinApiDef
echo "🏆 Creating XamarinApiDef"

cd build

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '\d\{1,2\}\.\d\{1,2\}$')

# Create the API def for the binding project in Xamarin. The name space is ATHMovilPaymentButton
sharpie -v
sharpie bind --sdk=iphoneos${SDK_VERSION} \
			 --output="XamarinApiDef" \
			 --namespace="ATHMovilPaymentButton" \
			 --scope="Release/athmovil_checkout.framework/Headers/" "Release/athmovil_checkout.framework/Headers/athmovil_checkout-Swift.h"

echo "🏁 Xamarin.sh XamarinApiDef is ready \n"
