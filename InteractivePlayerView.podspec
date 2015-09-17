Pod::Spec.new do |s|
  s.name         = 'InteractivePlayerView'
  s.version      = '1.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/AhmettKeskin/InteractivePlayerView'
  s.authors      = { 'Ahmet Keskin' => 'supreme43tr@gmail.com' }
  s.social_media_url = 'https://twitter.com/_Ahmettkeskin'
  s.summary      = 'Custom music player view iOS'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/AhmettKeskin/InteractivePlayerView.git', :tag => s.version }
  s.resources = "ipv_source/*.{xib}"
  s.source_files = 'ipv_source/*.{swift}'
  s.framework    = 'SystemConfiguration'
  s.requires_arc = true
end