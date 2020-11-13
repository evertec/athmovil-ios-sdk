
clear

echo "⚙️ Starting Xamarin.sh \n"

#Remove the previous build
rm -R build

#Compile for iphone and simulator
sh build-athmovil-checkout.sh

#Compile for iphone and simulator
sh build-framework.sh

#Using sharpie tool to create XamarinApiDef
echo "🏆 Creating XamarinApiDef"

cd build

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '\d\{1,2\}\.\d\{1,2\}$')


sharpie -v
sharpie bind --sdk=iphoneos${SDK_VERSION} \
			 --output="XamarinApiDef" \
			 --namespace="ATHMovilPaymentButton" \
			 --scope="Release/athmovil_checkout.framework/Headers/" "Release/athmovil_checkout.framework/Headers/athmovil_checkout-Swift.h"

echo "🏁 Xamarin.sh XamarinApiDef is ready \n"
