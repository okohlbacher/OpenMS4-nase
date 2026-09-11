cask "openms4-nase" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.1,082f13f6026e"
  sha256 arm:   "f13871b6df38784d58ef23b31b21d488f276ae55ccdeedc100e22097df6b05f0",
         intel: "644593292b273ce8c448f45894f1bcfab168e4de27f1e2f7cd3a09a04d382c3b"

  url "https://github.com/okohlbacher/OpenMS4-nase/releases/download/" \
      "nase-v#{version.csv.first}/OpenMS4-nase-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 nase tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-nase"

  depends_on formula: "okohlbacher/openms4-core/openms4-core"
  depends_on macos: :sequoia

  payload = "OpenMS4-nase-macos-#{arch}-Homebrew-#{version.csv.second}"
  binary "#{payload}/bin/NucleicAcidSearchEngine"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "."],
        chdir:          ".",
        writable_paths: ["."]
  end
end
