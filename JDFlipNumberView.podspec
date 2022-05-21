Pod::Spec.new do |s|

  # META
  s.name         = 'JDFlipNumberView'
  s.version      = '3.0'
  s.author       = { 'Markus Emrich' => 'markus.emrich@gmail.com' }
  s.homepage     = 'https://github.com/calimarkus/JDFlipNumberView'
  s.license      = 'MIT'

  # DESCRIPTION
  s.summary      = 'Simulates an analog flip display (like at airports / train stations). Simple, powerful & customizable.'
  s.description  = 'The FlipNumberView is simulating an analog flip display (e.g. like those at an airport / train station). It\'s well abstracted and easy to use. Use it display numbers of any kind, e.g. countdowns, timers, clocks, etc. An example project is given. SwiftUI wrappers are available too.'
  s.screenshot   = 'https://user-images.githubusercontent.com/807039/169299475-7dd36912-7eeb-4f30-a7c7-459b11e7099e.png'

  # BUILD SETTINGS
  s.source         = { :git => 'https://github.com/calimarkus/JDFlipNumberView.git', :tag => "pod-#{s.version}" }
  s.platform       = :ios, '13.0'
  s.swift_versions = ['5.1']
  s.frameworks     = 'QuartzCore'


  # SUB SPECS (excluding the default image bundle)
  s.subspec 'Core' do |core|
    core.source_files = 'JDFlipNumberView/Private/*.{h,m}', 'JDFlipNumberView/FlipNumberView/*.{h,m}'
    core.private_header_files = 'JDFlipNumberView/JDFlipNumberDigitView.h', 'JDFlipNumberView/Private/*.{h}'
  end

  s.subspec 'FlipImageView' do |fiv|
    fiv.source_files = 'JDFlipNumberView/Private/*.{h,m}', 'JDFlipNumberView/FlipImageView/*.{h,m}', 'JDFlipNumberView/FlipNumberView/JDFlipNumberViewImageBundle.{h,m}'
    fiv.exclude_files = 'JDFlipNumberView/Private/JDFlipNumberViewImageCache.{h,m}'
    fiv.private_header_files = 'JDFlipNumberView/Private/*.{h}'
  end

  s.subspec 'FlipClockView' do |fcv|
    fcv.source_files = 'JDFlipNumberView/FlipClockView/*.{h,m}'
    fcv.dependency 'JDFlipNumberView/Core'
  end

  s.subspec 'DateCountdownFlipView' do |dcfv|
    dcfv.source_files = 'JDFlipNumberView/DateCountdownFlipView/*.{h,m}'
    dcfv.dependency 'JDFlipNumberView/Core'
  end

  s.subspec 'DefaultImageBundle' do |dib|
    dib.resource = "JDFlipNumberView/DefaultImageBundle/JDFlipNumberView.bundle"
    dib.dependency 'JDFlipNumberView/Core'
  end

  s.subspec 'NoImageBundle-NoSwiftUI' do |noswift|
    noswift.dependency 'JDFlipNumberView/Core'
    noswift.dependency 'JDFlipNumberView/FlipImageView'
    noswift.dependency 'JDFlipNumberView/FlipClockView'
    noswift.dependency 'JDFlipNumberView/DateCountdownFlipView'
  end

  s.subspec 'NoImageBundle' do |swift|
    swift.source_files = 'JDFlipNumberView/**/*.{h,m,swift}'
    swift.dependency 'JDFlipNumberView/NoImageBundle-NoSwiftUI'
  end
  
end
