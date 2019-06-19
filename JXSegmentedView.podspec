
Pod::Spec.new do |s|
  s.name         = "JXSegmentedView"
  s.version = "0.0.19"
  s.summary      = "一个轻量级、配置丰富、灵活扩展的分段控制器"
  s.homepage     = "https://github.com/pujiaxin33/JXSegmentedView"
  s.license      = "MIT"
  s.author       = { "pujiaxin33" => "317437084@qq.com" }
  s.platform     = :ios, "8.0"
  s.swift_versions = ["4.2", "5.0"]
  s.source       = { :git => "https://github.com/pujiaxin33/JXSegmentedView.git", :tag => "#{s.version}" }
  s.framework    = "UIKit"
  s.source_files  = "Sources", "Sources/**/*.{swift}"
  s.requires_arc = true
end
