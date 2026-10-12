class Prosefix < Formula
  include Language::Python::Virtualenv

  desc "Clean, consistent prose in Markdown: spelling, style guide, typos, commas"
  homepage "https://github.com/AndrewBroz/prosefix"
  url "https://files.pythonhosted.org/packages/14/23/d0f47bb699c128b4661589a4df2d9ac9cad04f4d18f1ee9cbab4d279185f/prosefix-0.1.0.tar.gz"
  sha256 "bf385dc8c0370f517b66cc81aa34dc720f4cf86848d4cdeed41eb24bef30b405"
  license "MIT"

  depends_on "languagetool"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "typos-cli"
  depends_on "vale"

  # resource blocks for adjudicate, stylefix, proofix, spylls, pyyaml (generated)

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/stylefix", libexec/"bin/proofix"
    man1.install buildpath/"man/prosefix.1"
    resource("stylefix").stage { man1.install "man/stylefix.1" }
    resource("proofix").stage { man1.install "man/proofix.1" }
  end

  test do
    (testpath/"n.md").write "The color of the program is \"important\" -- really.\n"
    system bin/"prosefix", "--version"
    system bin/"prosefix", testpath/"n.md", "--llm", "none", "-q"
    assert_match "—", (testpath/"n.md").read
  end
end
