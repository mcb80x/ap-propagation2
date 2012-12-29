# => SRC FOLDER
toast 'src'

  # EXCLUDED FOLDERS (optional)
  # exclude: ['folder/to/exclude', 'another/folder/to/exclude', ... ]

  # => VENDORS (optional)
  vendors: ['third-party/jquery-1.8.3.js',
            'third-party/knockout-2.2.0.js',
            'third-party/jquery-ui-1.9.2.custom.js']

  # => OPTIONS (optional, default values listed)
  # bare: false
  packaging: false
  # expose: 'window'
  # minify: true

  # => HTTPFOLDER (optional), RELEASE / DEBUG (required)
  httpfolder: 'js'
  release: 'www/js/ap.js'
  debug: 'www/js/ap-debug.js'