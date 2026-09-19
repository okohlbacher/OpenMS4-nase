cask "openms4-nase" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.6,affbd50eb0a2"
  sha256 arm:   "d3609071e3f757a05d7bde5e78c64838b50e9b38dc2ba2060a3e46d60a43e8ff",
         intel: "89a8e29f38e2f3bedb4747bbb21ebcac5646c3950181c44442e222905127d4c7"

  url "https://github.com/okohlbacher/OpenMS4-nase/releases/download/" \
      "nase-v#{version.csv.first}/OpenMS4-nase-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 nase tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-nase"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-nase-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/NucleicAcidSearchEngine"

  # libOpenMS has no versioned name, so a payload only runs with the Core it was built against.
  preflight do
    config = "#{HOMEBREW_PREFIX}/opt/openms4-core/lib/cmake/OpenMS/OpenMSConfig.cmake"
    core = File.exist?(config) ? File.read(config)[/set\(OpenMS_SOURCE_REVISION "([0-9a-f]{40})"\)/, 1] : nil
    next if core == "7d90cec8718d28518527acc10b495550f106de26"

    raise Cask::CaskError, "openms4-nase #{version.csv.first} was built against openms4-core 7d90cec8718d, " \
                           "but the installed openms4-core is #{core&.slice(0, 12) || "unknown"}. " \
                           "Install the openms4-nase release built for the installed Core."
  end

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
