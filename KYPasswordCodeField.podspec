#
#  Be sure to run `pod spec lint KYPasswordCodeField.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

s.name         = "KYPasswordCodeField"
s.version      = "0.0.3"
s.summary      = "KYPasswordCodeField是一个高定制，易用的密码/验证码输入框类库."

s.homepage     = "https://github.com/kingly09/KYPasswordCodeField"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "kingly" => "libintm@163.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/kingly09/KYPasswordCodeField.git", :tag => s.version.to_s }
s.social_media_url   = "https://github.com/kingly09"
s.source_files = 'KYPasswordCodeField/**/*'
s.frameworks   = "UIKit"
s.requires_arc = true


end
