Pod::Spec.new do |s|

  s.name         = "Twitter-OAuth"
  s.version      = "0.1.0"
  s.summary      = "iOS Twitter OAuth Login and get UserInfo."
  s.homepage     = "https://github.com/Dwarven/Twitter-OAuth"
  s.license      = "MIT"
  s.author       = { "Dwarven YANG" => "dwarven.yang@gmail.com" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/Dwarven/Twitter-OAuth.git", :tag => "0.1.0" }
  s.source_files  = "Twitter-OAuth/TwitterOAuthViewController", "Twitter-OAuth/TwitterOAuthViewController/**/*.{h,m}"

end
