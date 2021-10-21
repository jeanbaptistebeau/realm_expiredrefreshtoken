platform :ios, '12.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
    pod 'RealmSwift', '=10.15.1'
    
end

target 'RealmTokenExpiredExample' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
