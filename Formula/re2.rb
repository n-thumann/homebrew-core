class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-11-01.tar.gz"
  version "20211101"
  sha256 "8c45f7fba029ab41f2a7e6545058d9eec94eef97ce70df58e92d85cfc08b4669"
  license "BSD-3-Clause"
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/\D/, "") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f1036c8298f174909665c35f2b4f6ef0d072cef3856f5f7979d61475c710c9d0"
    sha256 cellar: :any,                 arm64_big_sur:  "2737e7f164fc5e71e47395e657e49c642299169187035bf580da377758d79f2a"
    sha256 cellar: :any,                 monterey:       "a839160b35d118ba9a98e241a63624dbaf78ab82c627dac5f22b40a679c62b53"
    sha256 cellar: :any,                 big_sur:        "37d27091caac14f59c8ec254572ae6bf4381b58bdd789d2dfce6335cceec283c"
    sha256 cellar: :any,                 catalina:       "34301adc3ba86bcc2cf7c0b97bc8310a7db2a0b89a8245bcf4b7c06c2c07bd6e"
    sha256 cellar: :any,                 mojave:         "2799d3471e7a1c34a9548073d20c18a989b279341b626b4b4402350f95298c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5af47e34dce6e8618fb7caaeab0fb5eeee5bbb7f2099efee34b596cbc8fe006"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Run this for the rest of the install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
