project(
    'ListenMoe',
    'vala',
    'c',
)

dependencies = [
    dependency('gtk4'),
    dependency('json-glib-1.0'),
    dependency('gstreamer-1.0'),
    dependency('libsoup-3.0'),
]

sources = files()

subdir('src')

executable('listenmoe', sources, dependencies: dependencies, install: true)
