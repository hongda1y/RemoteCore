#
# Be sure to run `pod lib lint RemoteCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RemoteCore'
  s.version          = '0.1.1'
  s.summary          = 'Remote Core : Easy handling networking request.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Remote Core : Easy handling networking request. It build on top of Alamofire.
                       DESC

  s.homepage         = 'https://github.com/hongda1y/RemoteCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hong Daly' => 'daly.hong@gbstech.com.kh' }
  s.source           = { :git => 'https://github.com/hongda1y/RemoteCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
#  s.source_files    = 'RemoteCore/Classes/**/*'
  s.swift_versions  = ['5.0','5.1']
  s.platform        = :ios, '11.0'
  s.requires_arc    = true
  
  
  s.subspec 'Core' do |core|
     core.source_files = 'RemoteCore/Classes/Core/**/*'
     core.dependency 'Alamofire', '~> 5.5'
  end
  
  
  s.subspec 'Local' do |subspec|
      subspec.dependency 'RemoteCore/Core'
      subspec.dependency 'RealmSwift', '~> 3.0'
      subspec.source_files = 'RemoteCore/Classes/Local/**/*'
  end
  
  
  s.default_subspec = 'Core'
  
  # s.resource_bundles = {
  #   'RemoteCore' => ['RemoteCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
