Pod::Spec.new do |s|
  s.name     = 'HSUWebCache'
  s.version  = '0.1'
  s.platform = :ios, '7.0'
  s.license  = 'MIT'
  s.summary  = 'Additions for UIImageView and UIButton, set image with url.'
  s.homepage = 'https://github.com/tuoxie007/HSUWebCache'
  s.author   = { 'Jason Hsu' => 'support@tuoxie.me' }
  s.source   = { :git => 'https://github.com/tuoxie007/HSUWebCache.git', :tag => s.version.to_s }
  s.description = 'HSUWebCache is Additions for UIImageView and UIButton, set image with url.'
  s.source_files = '*.{h,m}'
  s.framework    = ['Foundation', 'UIKit']
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0'
end
