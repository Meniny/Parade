Pod::Spec.new do |s|
  s.name              = 'Parade'
  s.module_name       = 'Parade'
  s.version           = '1.0.0'
  s.summary           = 'Parade is a operation queue manager.'
  s.homepage          = 'https://github.com/Meniny/Parade'
  s.authors           = { 'Elias Abel' => 'admin@meniny.cn' }
  s.social_media_url  = 'https://meniny.cn/'
  s.license           = { :type => 'MIT', :file => 'LICENSE.md' }
  s.source            = { :git => 'https://github.com/Meniny/Parade.git', :tag => s.version }
  s.source_files      = 'Parade/**/*.swift'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
end
