Pod::Spec.new do |s|


  s.name         = "NewsLoopView"
  s.version      = "1.0"
  s.summary      = "NewsLoopView is a advitisement loop framework ."
  s.homepage     = "https://git.oschina.net/VJTong/VJNewsLoopView"
  s.license      = "MIT"
  s.author       =  "chengzhitong email:chengzhitong@vjwealth.com"

  s.source        = { :git => "https://git.oschina.net/VJTong/VJNewsLoopView.git", :tag => s.version.to_s }
  s.source_files  = "NewsLoopView/*.{h,m}"
  s.platform      = :ios, '6.0'
  s.requires_arc  = true
  s.frameworks    = 'UIKit'

end
