#
# Be sure to run `pod lib lint ZLGitRemoteService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZLGitRemoteService'
  s.version          = '1.7.0'
  s.summary          = 'A short description of ZLGitRemoteService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'ZLGitRemoteService'

  s.homepage         = 'https://github.com/existorlive/ZLGitRemoteService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'existorlive' => '2068531506@qq.com' }
  s.source           = { :git => 'https://github.com/existorlive/ZLGitRemoteService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.module_name = 'ZLGitRemoteService'
  s.source_files = 'ZLGitRemoteService/Classes/**/*.{h,m,swift}'
  s.resource_bundle = {"ZLGitRemoteService.privacy"=>"Pod/Privacy/ZLGitRemoteService/PrivacyInfo.xcprivacy"}
  s.prefix_header_file= 'ZLGitRemoteService/Classes/ZLGitRemoteService-prefix.pch'
  s.public_header_files = ['ZLGitRemoteService/Classes/ZLGitRemoteSerivce_GeneralDefine.h',
                           'ZLGitRemoteService/Classes/ZLGitRemoteService.h',
                           'ZLGitRemoteService/Classes/Model/**/*.h',
                           'ZLGitRemoteService/Classes/PublicUtilities/**/*.h',
                           'ZLGitRemoteService/Classes/Base/**/*.h',
                           'ZLGitRemoteService/Classes/Manager/ZLSharedDataManager/*.h',
                           'ZLGitRemoteService/Classes/PublicModule/**/*.h']
 # s.vendored_frameworks = 'ZLGitRemoteService/Frameworks/Bugly.framework'
  s.pod_target_xcconfig = { 'LIBRARY_SEARCH_PATHS' => "$(PODS_TARGET_SRCROOT)/ZLGitRemoteService/Libs",
                            'FRAMEWORK_SEARCH_PATHS' => "$(PODS_TARGET_SRCROOT)/ZLGitRemoteService/Frameworks",
                            'DEFINES_MODULE' => 'YES'}
  s.swift_version = '5.0'
  # 由于引入了bugly静态库，因此ZLGitRemote也必须是静态库
#  s.static_framework = true
  
  # s.resource_bundles = {
  #   'ZLGitRemoteService' => ['ZLGitRemoteService/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'FMDB'
  s.dependency 'CocoaLumberjack'
  s.dependency 'MJExtension'
  s.dependency 'Apollo', '~> 0.39.0'
  s.dependency 'SYDCentralPivot'
  s.dependency 'Alamofire'
  s.dependency 'Kanna'
  s.dependency 'ZLUtilities'
  s.dependency "ObjectMapper"

end
