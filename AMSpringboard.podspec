Pod::Spec.new do |s|
  s.name     = 'AMSpringboard'
  s.version  = '0.1.5'
  s.summary  = 'A simple Springboard view, following the Data Source / Delegate pattern.'
  s.homepage = 'https://github.com/amrox/AMSpringboard'
  s.author   = { 'Andy Mroczkowski' => 'andy@mrox.net' }
  s.source   = { :git => 'https://github.com/amrox/AMSpringboard.git', :commit => '25fb44161198ee79d62771912c65890648292a88' }
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.platform = :ios, '4.0'
  #s.description = 'An optional longer description of AMSpringBoard.'
  s.source_files = 'AMSpringboard'
  s.frameworks = 'Foundation', 'UIKit'

  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework SomeRequiredFramework' }

  #s.dependency 'AMFoundation', :git => 'https://github.com/amrox/AMFoundation.git', :commit => '61fd3da0a823b7d8b531447d2776ddd0646a81ea'
  s.dependency 'AMFoundation'
end
