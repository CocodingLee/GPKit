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

end
