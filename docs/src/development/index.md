# Development

The model is plain OpenSCAD with no library dependencies. Shared parameters,
derived dimensions, and structural assertions live in
`dynamometer_dimensions.scad`; printable modules live in
`dynamometer_parts.scad`; and `dynamometer_assembly.scad` is the preview and
export entry point. `crimpdeq_reference.scad` is a self-contained, simplified
snapshot of the Crimpdeq v2 case and load-cell interface, used for fit and
collision checks. It is not a replacement enclosure design.

All dimensions are in millimetres and forces in newtons. Parameters can be
overridden from the command line with `-D name=value`; unsafe combinations
fail with an assertion.

The model is tested with the OpenSCAD development snapshot pinned for
[continuous integration](validation.md#continuous-integration), which
renders far faster than the 2021.01 release. It also works on 2021.01, which
is checked weekly.
