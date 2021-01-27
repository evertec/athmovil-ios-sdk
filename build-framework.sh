
echo "⚙️ Starting build-framework.sh \n"

cd build
cp -R "Release-iphoneos" "Release"
cp -R "Release-iphonesimulator/athmovil_checkout.framework/Modules/athmovil_checkout.swiftmodule/" "Release/athmovil_checkout.framework/Modules/athmovil_checkout.swiftmodule/"
lipo -remove arm64 "Release-iphonesimulator/athmovil_checkout.framework/athmovil_checkout" -output "Release-iphonesimulator/athmovil_checkout.framework/athmovil_checkout"
lipo -create -output "Release/athmovil_checkout.framework/athmovil_checkout" "Release-iphoneos/athmovil_checkout.framework/athmovil_checkout" "Release-iphonesimulator/athmovil_checkout.framework/athmovil_checkout"
lipo -info "Release/athmovil_checkout.framework/athmovil_checkout"
otool -l -arch all Release/athmovil_checkout.framework/athmovil_checkout | grep libswift
rm -R Release-iphoneos
rm -R Release-iphonesimulator
rm -R athmovil-checkout.build

echo "🏁 Ending build-framework.sh \n"