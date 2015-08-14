Pod::Spec.new do |s|

  s.name         = "CocoaUPnP"
  s.version      = "0.0.1"
  s.summary      = "A short description of CocoaUPnP."

  s.description  = <<-DESC
                   A longer description of CocoaUPnP in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/CocoaUPnP"
  s.license      = "MIT"
  s.author       = { "Paul Williamson" => "PaulW@arcam.co.uk" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/arcam/CocoaUPnP.git", :tag => "0.0.1" }
  s.source_files = "CocoaUPnP", "CocoaUPnP/**/*.{h,m}"
  s.requires_arc = true
  s.xcconfig     = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'CocoaAsyncSocket', '~> 7.4.1'
  s.dependency 'Ono', '~> 1.2'
  s.dependency 'AFNetworking', '~> 2.5.2'
  s.dependency 'GCDWebServer', '~> 3.2'

end
