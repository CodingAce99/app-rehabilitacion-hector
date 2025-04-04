#!/bin/bash

echo "🧼 Limpiando proyecto Flutter..."
flutter clean

echo "📦 Ejecutando pub get..."
flutter pub get

echo "🧹 Limpiando Pods..."
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

echo "🚀 Abriendo Xcode..."
open ios/Runner.xcworkspace

echo "✅ Listo. Ahora abre Xcode, selecciona tu iPhone y pulsa ▶️ Run"
echo "📱 No olvides aceptar permisos en tu iPhone si es la primera vez."
echo "🔐 Y asegúrate de que Xcode/Terminal tienen acceso total al disco si falla algo."
