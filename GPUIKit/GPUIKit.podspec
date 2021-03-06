Pod::Spec.new do |s|

  s.name         = "GPUIKit"
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
  s.dependency 'SDWebImage'       , '~> 4.4.5'
  s.dependency 'libextobjc'       , '~> 0.6'
  s.dependency 'FrameAccessor'    , '~> 2.0'
  s.dependency 'MBProgressHUD'    , '~> 1.1.0'

  s.dependency 'lottie-ios'       , '~> 2.5.3'
  s.dependency 'MJRefresh'        , '~> 3.1.16'
  s.dependency 'DZNEmptyDataSet'  , '~> 1.8.1'
  
end
