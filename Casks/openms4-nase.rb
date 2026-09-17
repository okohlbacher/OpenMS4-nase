cask "openms4-nase" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.4,1ab61e144ddb"
  sha256 arm:   "6641b18a9c7b8ded103824743450a85eb0596c5c535f9e06477b3f46eb5ca6f9",
         intel: "42e8303f86f78cc284fd03c5f61e4da67c00d0edec0e5e2c910fe15c5ee7891e"

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
    next if core == "84847138c0de67149601aaa860af7ac8e2e64534"

    raise Cask::CaskError, "openms4-nase #{version.csv.first} was built against openms4-core 84847138c0de, " \
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
