
# This script create the fat framework, this fat framework allows to run the code in simulator and device
# Make sure that you have the same version specify in the XamarinReadme.md file

echo "⚙️ Starting build-framework.sh \n"

cd build
cp -R "Release-iphoneos" "Release"
cp -R "Release-iphonesimulator/athmovil_checkout.framework/Modules/athmovil_checkout.swiftmodule/" "Release/athmovil_checkout.framework/Modules/athmovil_checkout.swiftmodule/"

# Create the fat framework
lipo -create -output "Release/athmovil_checkout.framework/athmovil_checkout" "Release-iphoneos/athmovil_checkout.framework/athmovil_checkout" "Release-iphonesimulator/athmovil_checkout.framework/athmovil_checkout"
lipo -info "Release/athmovil_checkout.framework/athmovil_checkout"
otool -l -arch all Release/athmovil_checkout.framework/athmovil_checkout | grep libswift

# Remove all the folders created
rm -R Release-iphoneos
rm -R Release-iphonesimulator
rm -R athmovil-checkout.build

echo "🏁 Ending build-framework.sh \n"