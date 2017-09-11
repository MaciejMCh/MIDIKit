Pod::Spec.new do |s|
  s.name             = "MIDIKit"
  s.summary          = "A CoreMIDI interface that doesn't suck"
  s.version          = "1.0.0"
  s.homepage         = "https://github.com/JRHeaton/MIDIKit"
  s.license          = 'MIT'
  s.author           = { "JRHeaton" => "jheaton.dev@gmail.com" }
  s.source           = {
    :git => "https://github.com/MaciejMCh/MIDIKit.git",
    :tag => s.version.to_s
  }

  s.osx.source_files = 'MIDIKit/*'
end