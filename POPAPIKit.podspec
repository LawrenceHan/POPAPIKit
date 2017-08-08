Pod::Spec.new do |s|
  s.name         = "POPAPIKit"
  s.version      = "1.0.6"
  s.summary      = "A Protocol Oriented Networking Kit"
  s.description  = <<-DESC
  POPAPIKit is a pure Swift implemented and protocol oriented networking kit. POPAPIKit is highly inspired by [APIKit](https://github.com/ishkawa/APIKit)
  which created by [ishkawa](https://github.com/ishkawa).
                   DESC
  s.homepage     = "https://github.com/LawrenceHan/POPAPIKit"
  s.license      = "MIT"
  s.author       = { "LawrenceHan" => "yangfei6565@163.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/LawrenceHan/POPAPIKit.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.{swift,h,m}"
  s.dependency "Result", "~> 3.0"
end
