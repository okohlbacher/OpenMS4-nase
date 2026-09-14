cask "openms4-nase" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0-ci.2,a9b317b889cc"
  sha256 arm:   "35300a3010f4b38c09315917b1294977cf3a2298bf4215f524fbdb408ec25a22",
         intel: "6f0b7c97096621c0624d10686d843cb3d1aefff045d92b221a83a3e7fec8d25b"

  url "https://github.com/okohlbacher/OpenMS4-nase/releases/download/" \
      "nase-v#{version.csv.first}/OpenMS4-nase-macos-#{arch}-Homebrew-#{version.csv.second}.tar.gz"
  name "OpenMS 4 nase tools"
  desc "Command-line mass-spectrometry tools built against the OpenMS Core SDK"
  homepage "https://github.com/okohlbacher/OpenMS4-nase"

  disable! date:    "2026-09-14",
           because: "was built against openms4-core 4.0.0-ci.2, and the tap now serves a binary-incompatible newer Core"

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
