# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 9-4-2021

### Added

- Release Ubuntu 20.04 LTS option (includes Powershel Core 7.1.4).
- `build.ps1` now allows for choice of OneView Powershell 5.50, 6.00, or 6.10.
- `build.ps1` allows the user to specify the Image Tag Name.
- `build.ps1` does (very) basic image management by allowing the user to delete the existing image by tag name. Consult the docker documentation for proper image management.
- `dockerfile` has options to manually override parameters in the `build.ps1` file. Consult this repos `README.md` on how to do this.
- Error-checking in place in `build.ps1` to ensure the user enters only OneView versions 5.50, 6.00, or 6.10 with this release.
