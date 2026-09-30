cask "openms4-nase" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.8,f19a59c7de77"
  sha256 arm:   "a40ee545e02ff1e354fa77c1aecb1a7259319c05c645a8a4307bd7bab9897d7e",
         intel: "e82918f6e5470aa954d18328e9815122964c0973f74f1a1f0a773cd29ad08f3a"

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
    next if core == "0529ec8bfe0785d546dab56f58456525ef0fef02"

    raise Cask::CaskError, "openms4-nase #{version.csv.first} was built against openms4-core 0529ec8bfe07, " \
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
