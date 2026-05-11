#!/bin/bash
# Clone Flutter if it doesn't exist
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# Add flutter to path
export PATH="$PATH:$(pwd)/flutter/bin"

# Build the project properly for Vercel
flutter build web --release --base-href "/"
