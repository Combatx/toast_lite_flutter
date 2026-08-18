#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint toast_lite.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'toast_lite'
  s.version          = '0.1.0'
  s.summary          = 'Lightweight toast and loading overlay for Flutter, callable from anywhere without a BuildContext.'
  s.description      = <<-DESC
Lightweight toast and loading overlay for Flutter, callable from anywhere without a BuildContext.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Makanbang Staff' => 'dev@makanbangstaffnew.id' }
  s.source           = { :path => '.' }
  s.source_files = 'toast_lite/Sources/toast_lite/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'toast_lite_privacy' => ['toast_lite/Sources/toast_lite/PrivacyInfo.xcprivacy']}
end
