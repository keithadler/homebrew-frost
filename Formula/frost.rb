class Frost < Formula
  include Language::Python::Virtualenv

  desc "Readable shell scripting language that is auditable before it runs"
  homepage "https://github.com/keithadler/frost"
  url "https://files.pythonhosted.org/packages/06/b2/77f3a32f766df7ca389a59ad9d3ecc1758a5382f8e4d5d02823323f70713/frostlang-0.9.4.tar.gz"
  sha256 "8d768314a9e5d46169b411031f028308a9e246eebf1c6ad4e93a133282c5b68b"
  license "MIT"

  depends_on "python@3.12"

  # The interpreter has no dependencies, so there are no resources to vendor.
  # The keystore extra needs a real cipher and is deliberately left out: brew
  # users who want it can `pip install "frostlang[keystore]"` alongside, and a
  # formula that pulled in cryptography would make every install pay for a
  # feature most of them will not use.

  def install
    virtualenv_install_with_resources
  end

  test do
    # Three assertions, because installing is not the same as working.
    assert_match version.to_s, shell_output("#{bin}/frost --version")

    # It parses and reports a verdict.
    (testpath/"clean.frost").write <<~FROST
      run "echo" with "installed"
      put it
    FROST
    assert_match "verdict: clean",
                 shell_output("#{bin}/frost --check #{testpath}/clean.frost")
    assert_equal "installed\n",
                 shell_output("#{bin}/frost #{testpath}/clean.frost")

    # And it still refuses what it is supposed to refuse. A build that
    # installed a frost which called everything clean would pass a test that
    # only checked the happy path.
    (testpath/"risky.frost").write <<~FROST
      run "rm" with "-rf", "/tmp/whatever"
    FROST
    output = shell_output(
      "#{bin}/frost --check --strict #{testpath}/risky.frost", 1
    )
    assert_match "verdict: dangerous", output
  end
end
