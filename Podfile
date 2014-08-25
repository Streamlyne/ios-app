platform :ios, '7.0'
# Streamlyne
pod "Streamlyne-Cocoa-SDK", :git => 'git@github.com:Streamlyne/Cocoa-SDK.git'
# UI
pod 'PKRevealController'
pod 'MBProgressHUD', '~> 0.8'
# Misc
pod 'PromiseKit', '<= 0.9.14'
pod 'CocoaLumberjack'
pod 'ReactiveCocoa'
pod 'TestFlightSDK'
pod 'FontAwesomeIconFactory'

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

