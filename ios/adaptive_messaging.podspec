Pod::Spec.new do |s|
  s.name             = 'adaptive_messaging'
  s.version          = '1.0.24'
  s.summary          = 'Flutter iOS plugin for the Adaptive Messaging SDK.'
  s.description      = 'Registers FCM tokens, detects Adaptive push notifications, and displays in-app notifications for the Adaptive e-learning platform.'
  s.homepage         = 'https://github.com/AdaptiveSDK/AdaptiveiOSSDK'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'AlAdwaa' => 'dev_team@aladwaa.org' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AdaptiveMessaging', '~> 1.0.24'
  s.platform         = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version    = '5.9'
end
