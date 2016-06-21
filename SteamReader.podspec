Pod::Spec.new do |s|

# Library
s.name = 'SteamReader'
s.version = '0.1.0'
s.cocoapods_version = '1.0.1'
# use s.authors to add more authors
s.author = { 'Kyle Roberts' => '123kyle.roberts@gmail.com' }
s.social_media_url = "https://twitter.com/TheKyKy123"
# use :type, :file, or :text for custom license
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.homepage = 'https://github.com/123kyky/SteamReader'
# can use CocoaPods git keys here
s.source = { :git => 'https://github.com/123kyky/SteamReader.git', :tag => s.version.to_s }
s.summary = 'A simple app to browse and subscribe to Steam game news.'
s.description = <<-DESC
    A simple app to browse and subscribe to Steam game news.
    A simple app to browse and subscribe to Steam game news.
    A simple app to browse and subscribe to Steam game news.
DESC
s.screenshots = ''
s.documentation_url = 'https://github.com/123kyky/SteamReader'


# Platform
s.platform = :ios, '9.0'

# Files
s.source_files = 'SteamReader'

end
