Pod::Spec.new do |s|
  s.name             = 'Biome'
  s.version          = '1.0.0'
  s.summary          = 'Simple environment management for iOS / macOS / tvOS / watchOS!'
  s.description      = <<-DESC
Biome is a simple way to manage sets of variables between environments you might need to work with when developing your application.

One problem developers face, is the need to create multiple builds in order to test how their application functions in different environments. Biome aims to reduce the amount of re-building that needs to occur, by providing a mechanism to switch configurations during run-time.
                       DESC

  s.homepage         = 'https://github.com/ndizazzo/Biome'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ndizazzo' => 'nick.dizazzo@gmail.com' }
  s.source           = { :git => 'https://github.com/ndizazzo/Biome.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Biome/Classes/**/*'
end
