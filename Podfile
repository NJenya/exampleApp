# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'Music AI Application' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Music AI Application	
  pod 'DeviceKit'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Analytics', '10.27.0'

 post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end

