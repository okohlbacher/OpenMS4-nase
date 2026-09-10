# OpenMSNASE 1.0.0 experimental

Independent NucleicAcidSearchEngine package. Its single executable consumes the exact installed Core SDK and OpenMSCLI revisions in `dependencies.lock.json`; it does not use sibling source or build directories. NASequence, ribonucleotide chemistry, ModifiedNASequenceGenerator, and every reader/writer remain in Core. This package owns the search workflow and executable registration.

Use the same compiler and build type as the installed SDKs. For matching Debug SDKs:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_PREFIX_PATH=/sdk/openms4 -DCMAKE_INSTALL_PREFIX=/sdk/openms4
cmake --build build --parallel 2
ctest --test-dir build --output-on-failure
cmake --install build
```

The two default tests parse generated INI/CTD metadata and check package identity. Scientific regression tests live in the installed-tools harness with the pinned TestData fixtures: select `^TOPP_NucleicAcidSearchEngine_` to run the two searches and four idXML/mzTab comparisons. Preserve their dependencies: the second search reuses the first search's digest output, and comparisons require FuzzyDiff. `OPENMS4_REGRESSION_TESTS=ON` verifies availability of the pinned TestData package; it does not register those six tests locally.

Run metadata tests before installing into an already discovered tool prefix, because build and installed manifests would duplicate the NucleicAcidSearchEngine registration. `OPENMS_TOOL_PREFIX_PATH` controls executable discovery, not native library loading. A combined install prefix uses relative Unix library paths; Windows deployments place Core/CLI and their dependency DLLs beside the executable. For separate fixed Unix prefixes, provide `CMAKE_INSTALL_RPATH` explicitly.

`tools.json` owns the executable name/category. `OPENMS4_REQUIRE_CLEAN_SOURCE=ON` rejects uncommitted inputs for published builds. Source archives must provide `OPENMS4_SOURCE_REVISION` and explicitly assert `OPENMS4_SOURCE_DIRTY`; Git checkouts derive them. The standalone CMake helpers are generated copies of the parent experiment's canonical helpers.
