# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'


def shared_pods
    pod 'RxSwift', '~> 3.0'
end



target 'HenriPotier' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HenriPotier
  pod 'Moya/RxSwift'
  pod 'Alamofire', '~> 4.4'
  pod 'RxCocoa',    '~> 3.0'
  pod 'RxDataSources', '~> 1.0'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'Kingfisher', '~> 3.0'
  pod 'DZNEmptyDataSet'
  pod 'SVProgressHUD'
  pod 'Sugar'
  pod 'ReachabilitySwift', '~> 3'
  pod 'GSImageViewerController'
  shared_pods
  
  target 'HenriPotierTests' do
      inherit! :search_paths
      #use_frameworks!
      
      pod 'RxTest'
  end
  
end



target 'HenriPotierUITests' do
    #inherit! :search_paths
    # Pods for testing
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
