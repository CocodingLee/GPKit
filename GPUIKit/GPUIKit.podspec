Pod::Spec.new do |s|

  s.name         = "GPUIKit"
  s.version      = "1.0.0"
  s.summary      = "#{s.name}"
  s.homepage     = "https://github.com/CocodingLee/GPUIKit/#{s.name}"
  s.license      = { :type => "private",  :text => "private"}
  s.author       = { "yifan.lyw" => "jobs.li.yw@aliyun.com" }

  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source       = { :git => "git@github.com:CocodingLee/GPUIKit.git", :tag => "#{s.name}_#{s.version}" }
  s.source_files = "#{s.name}/**/*.*"
  s.public_header_files = "#{s.name}/**/*.{h}"

  # 依赖的系统库
  s.framework    = 'Accelerate'

  # 依赖的第三方库
  s.dependency 'SDWebImage'  , '~> 4.4.5'
  s.dependency 'libextobjc'  , '~> 0.6'
end
