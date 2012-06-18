Pod::Spec.new do |s|
  s.name     = 'AMSpringboard'
  s.version  = '0.1.5'
  s.summary  = 'A simple Springboard view, following the Data Source / Delegate pattern'
  s.homepage = 'https://github.com/amrox/AMSpringboard'
  s.author   = { 'Andy Mroczkowski' => 'andy@mrox.net' }
  s.source   = { :git => 'https://github.com/amrox/AMSpringboard.git' }
  s.license  = { :type => 'MIT', :file => 'LICENSE'}
  s.platform = :ios, '5.0'
  #s.description = 'An optional longer description of AMSpringBoard.'
  s.source_files = 'AMSpringboard'
  s.frameworks = 'Foundation', 'UIKit'

  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework SomeRequiredFramework' }

  s.dependency 'AMFoundation', :git => 'https://github.com/amrox/AMFoundation.git', :commit => '61fd3da'
end
