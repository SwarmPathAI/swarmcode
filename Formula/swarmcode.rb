class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.16.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.16.0/swarmcode-v0.16.0-darwin-universal.tar.gz"
  sha256 "634c7a969d2d104897faaf88bbcf033dd5c3e3f234aa4979d2bb9bcdd2e823a6"

  def install
    bin.install "swarmcode"
    # L1 default skills (docx/pptx/design/…) for first-launch sync.
    if File.directory?("default-skills")
      (share/"swarmcode").install "default-skills"
    end
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
