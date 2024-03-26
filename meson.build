project(
    'ListenMoe',
    'vala',
    'c',
)

dependencies = [
    dependency('gtk4'),
    dependency('gstreamer-audio-1.0'),
    dependency('libsoup-3.0'),
    dependency('json-glib-1.0'),
]

sources = files()

subdir('src')

executable('listenmoe', sources, dependencies: dependencies, install: true, win_subsystem: 'windows')
