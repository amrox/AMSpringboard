Pod::Spec.new do |s|
  s.name     = 'AMSpringBoard'
  s.version  = '0.1.5'
  s.summary  = 'A simple Springboard view, following the Data Source / Delegate pattern'
  s.homepage = 'https://github.com/amrox/AMSpringboard'
  s.author   = { 'Andy Mroczkowski' => 'andy@mrox.net' }
  s.source   = { :git => 'https://github.com/amrox/AMSpringboard.git', :tag => '0.1.15' }

  #s.description = 'An optional longer description of AMSpringBoard.'

  # A list of file patterns. If the pattern is a directory then the path will
  # automatically have '*.{h,m,mm,c,cpp}' appended.
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'

  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework SomeRequiredFramework' }

  s.dependency 'AMFoundation', :git => 'https://github.com/amrox/AMFoundation.git', :commit => '5d2c4aa6584bb799e9c846bdca6de66889fdcd06'
end
