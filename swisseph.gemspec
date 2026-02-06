Gem::Specification.new do |s|
  s.name              = 'swisseph'
  s.version           = '1.4.0'
  s.date              = '2026-02-06'
  s.summary           = 'Swiss Ephemeris for Ruby (astrology)'
  s.description       = 'Native bindings for the Swiss Ephemeris library (http://www.astro.com/swisseph/)'
  s.homepage          = 'https://github.com/dfl/swisseph'
  s.author            = 'David Lowenfels'
  s.email             = 'dfl@alum.mit.edu'
  s.license           = 'GPL-2.0-or-later'
  s.extra_rdoc_files  = ['README.md']

  # Include only Ruby files and our wrapper C file + CMakeLists.txt
  # Swiss Ephemeris sources are fetched at build time via CMake
  s.files             = Dir.glob('lib/**/*.rb') +
                        ['ext/swisseph/extconf.rb',
                         'ext/swisseph/swisseph.c',
                         'ext/swisseph/CMakeLists.txt']

  s.extensions        = ['ext/swisseph/extconf.rb']
  s.required_ruby_version = '>= 3.0'

  s.add_development_dependency 'minitest', '>= 5.16', '< 5.27'
  s.add_development_dependency 'minitest-reporters', '~> 1.6'
  s.add_development_dependency 'minitest-rg', '~> 5.3'
  s.add_development_dependency 'victor', '~> 0.3.4'

  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata['build_requirements'] = 'CMake >= 3.14'

  # Exclude fetched Swiss Ephemeris sources from RDoc to speed up gem installation
  s.rdoc_options = ['--exclude', 'swisseph_src']

  s.post_install_message = <<~MSG

    swisseph requires Swiss Ephemeris sources, which are automatically
    downloaded from GitHub during installation using CMake.

    If installation fails, ensure CMake 3.14+ is installed:
      - macOS: brew install cmake
      - Ubuntu/Debian: sudo apt-get install cmake
      - Or visit: https://cmake.org/download/

  MSG
end
