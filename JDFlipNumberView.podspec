Pod::Spec.new do |s|

  # META
  s.name         = 'JDFlipNumberView'
  s.version      = '2.2.4'
  s.author       = { 'Markus Emrich' => 'markus.emrich@gmail.com' }
  s.homepage     = 'https://github.com/calimarkus/JDFlipNumberView'
  s.license      = 'MIT'
    
  # DESCRIPTION
  s.summary      = 'A simple, yet powerful, customizable FlipNumberView based on CoreAnimation (Simulating an analog flip display).'
  s.description  = 'The FlipNumberView is simulating an analog flip display (like those for the departure time on the airport). It\'s well abstracted and damn easy to use. It may be used for Countdowns, Timers, clocks or any other number display. Supports automatic animation in either direction. An example project is given. Supports ARC.'
  s.screenshot   = 'https://github.com/calimarkus/JDFlipNumberView/raw/master/gfx/screenshots.png'

  # BUILD SETTINGS
  s.source       = { :git => 'https://github.com/calimarkus/JDFlipNumberView.git', :tag => "pod-#{s.version}" }
  s.platform     = :ios, '13.0'
  s.frameworks   = 'QuartzCore'
  s.requires_arc = true

  # SUB SPECS
  s.subspec 'Core' do |core|
    core.source_files = 'JDFlipNumberView/**/*.{h,m}'
    core.private_header_files = 'JDFlipNumberView/JDFlipNumberDigitView.h', 'JDFlipNumberView/JDFlipNumberViewImageFactory.h'
  end

  s.subspec 'FlipImageView' do |fiv|
    fiv.source_files = 'JDFlipNumberView/JDFlipImageView.{h,m}','JDFlipNumberView/JDFlipNumberViewImageFactory.{h,m}', 'JDFlipNumberView/UIView+JDFlipImageView.{h,m}'
    fiv.private_header_files = 'JDFlipNumberView/JDFlipNumberViewImageFactory.h'
  end

  s.subspec 'DefaultImageBundle' do |dib|
    dib.resource     = "JDFlipNumberView/JDFlipNumberView.bundle"
    dib.dependency 'JDFlipNumberView/Core'
  end
  
end
