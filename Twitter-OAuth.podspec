Pod::Spec.new do |s|

  s.name                  = "Twitter-OAuth"
  s.version               = "0.1.2"
  s.summary               = "iOS Twitter OAuth Login and get UserInfo."
  s.homepage              = "https://github.com/Dwarven/Twitter-OAuth"
  s.license               = "MIT"
  s.author                = { "Dwarven" => "prison.yang@gmail.com" }
  s.social_media_url      = "https://twitter.com/DwarvenYang"
  s.ios.deployment_target = "7.0"
  s.source                = { :git => "https://github.com/Dwarven/Twitter-OAuth.git", :tag => s.version }
  s.source_files          = "Twitter-OAuth/TwitterOAuthViewController", "Twitter-OAuth/TwitterOAuthViewController/**/*.{h,m,c}"
  s.requires_arc          = false

end
