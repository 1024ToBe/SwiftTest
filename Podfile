# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
#source 'http://10.66.72.173:8082/nexus/repository/cocoapods-proxy/'
use_frameworks!
target 'SwiftTest' do
  # Comment the next line if you don't want to use dynamic frameworks


  # Pods for SwiftTest
    source 'https://github.com/CocoaPods/Specs.git'
    
    # UI布局
    pod 'SnapKit', '4.2.0'
    pod "SQLiteSwift3"
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
       end
      end
 end
