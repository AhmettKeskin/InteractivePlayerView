
Pod::Spec.new do |s|
  s.name         = 'InteractivePlayerView'
  s.version      = '1.0'
  s.license      = { :type => 'Apache' }
  s.homepage     = 'https://github.com/AhmettKeskin/InteractivePlayerView'
  s.authors      = { 'Ahmet Keskin' => 'supreme43tr@gmail.com' }
  s.social_media_url = 'https://twitter.com/_Ahmettkeskin'
  s.summary      = 'Custom music player view iOS'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/AhmettKeskin/InteractivePlayerView.git', :tag => 'v1.0' }
  s.source_files = 'InteractivePlayerView.swift','InteractivePlayerView.xib'
  s.framework    = 'SystemConfiguration'
  s.requires_arc = true
end
