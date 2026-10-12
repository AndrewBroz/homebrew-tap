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

  resource "adjudicate" do
    url "https://files.pythonhosted.org/packages/22/94/9b5198f55bc97ee7ceb5e71c498fe6f106fc16a9b5a9ae8a27955a681c9f/adjudicate-0.3.1.tar.gz"
    sha256 "f801ccb244c0aa9fb66adace70bba59b9aa774039a36cda9e1a643c51dee38c1"
  end

  resource "proofix" do
    url "https://files.pythonhosted.org/packages/7c/95/2aaa575b635b478cca5195674435681eb0a8c111d52d408dbddaa337b93a/proofix-0.6.0.tar.gz"
    sha256 "bbf066d3109ad3d828c9afc7b276b5d9ed3f71e287e14f33f68607eab62e3d16"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  # spylls' sdist builds with the legacy `poetry>=0.12` backend, which cannot be
  # built from source here (it pulls in Rust-based build dependencies), so use
  # the pure-Python wheel.
  resource "spylls" do
    url "https://files.pythonhosted.org/packages/cd/19/ce6fcb4b86e188983bcfc1f84e4ac6f3038ca8d68b6d70a678cdc566f66c/spylls-0.1.7-py2.py3-none-any.whl"
    sha256 "0c7fa4b66615f390bd12fd37939b85934c012309fd3cce8584844c54270b7776"
  end

  resource "stylefix" do
    url "https://files.pythonhosted.org/packages/f2/3f/9adb197abce3ffa9873450b4c4a26df36499227757a714b19ff49321d803/stylefix-0.8.0.tar.gz"
    sha256 "0ca8ae136ddd547e1f6581f14285f2d10b0c5aa0a31268efbaf55bd453f8a288"
  end

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
