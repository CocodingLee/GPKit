Pod::Spec.new do |s|

  s.name         = "GPPerformance"
  s.version      = "1.0.0"
  s.summary      = "#{s.name}"
  s.homepage     = "https://github.com/CocodingLee/#{s.name}/#{s.name}"
  s.license      = { :type => "private",  :text => "private"}
  s.author       = { "yifan.lyw" => "jobs.li.yw@aliyun.com" }

  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source       = { :git => "git@github.com:CocodingLee/#{s.name}.git", :tag => "#{s.name}_#{s.version}" }
  s.source_files = "#{s.name}/**/*.*"
  s.public_header_files = "#{s.name}/**/*.{h}"


  # 依赖的第三方库

  s.dependency 'FMDB'       	      , '~> 2.7.2'
  s.dependency 'coobjc'     	      , '~> 1.2.0'
  s.dependency 'FrameAccessor'      , '~> 2.0'
  s.dependency 'Masonry'            , '~> 1.1.0'
  s.dependency 'KSCrash'            , '~> 1.15.19'
  s.dependency 'YYModel'            , '~> 1.0.4'

  s.dependency 'GPUIKit'   
  s.dependency 'GPRoute'
  #s.dependency 'GPFoundation'

end
