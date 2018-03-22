Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.name = "UPMenu"
  s.summary = "UpperApp-like floating menu."
  s.requires_arc = true
  s.swift_version = '4.0'

  s.version = "0.1.0"

  s.license = { :type => "MIT", :file => "LICENSE" }
  
  s.author = { "Tubik Studio" => "ios@tubikstudio.com" }
  s.social_media_url = 'https://twitter.com/tubikstudio'

  s.homepage = "https://github.com/tubikstudio/UPMenu"

  s.source = { :git => "https://github.com/tubikstudio/UPMenu.git", :tag => "#{s.version}" }

  s.framework = "UIKit"

  s.source_files = "UPMenu/**/*.{swift}"

  s.resources = "UPMenu/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  
end
