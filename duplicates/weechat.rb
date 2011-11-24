require 'formula'

class Weechat < Formula
  head 'git://git.sv.gnu.org/weechat.git'
  url 'http://www.weechat.org/files/src/weechat-0.3.5.tar.bz2'
  homepage 'http://www.weechat.org'
  md5 '0d2a089bfbfa550e0c65618a171fb3c4'

  depends_on 'cmake' => :build
  depends_on 'gnutls'

  def cmake_install
    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32,64 and PPC
    # compiles, but our deps don't have that.
    archs = ['-arch ppc', '-arch i386', '-arch x86_64']
    inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs.join '|'}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs.join '|'}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    #FIXME: Compiling perl module doesn't work
    #NOTE: -DPREFIX has to be specified because weechat devs enjoy being non-standard
    system "cmake", "-DPREFIX=#{prefix}",
                    "-DENABLE_RUBY=ON",
                    "-DENABLE_PERL=OFF",
                    std_cmake_parameters, "."
    system "make install"
  end

  # there is much wrong with this in terms of Hombrew purity
  # relies on git://github.com/adamv/homebrew-alt.git recipes
  # for autoconf (v 2.68) and ruby 1.9.2
  def install
    ruby_prefix = '/usr/local/Cellar/ruby/1.9.2-p290'

    unless File.exists?(ruby_prefix)
      raise "You must install the keg-only ruby from git://github.com/slyphon/homebrew-alt.git"
    end

    inreplace 'cmake/FindRuby.cmake', 
      %q[PATHS /usr/bin /usr/local/bin /usr/pkg/bin],
      %Q[PATHS #{ruby_prefix}]

    header_dir = `#{ruby_prefix}/bin/ruby -r rbconfig -e 'puts Config::CONFIG[%[rubyhdrdir]]'`.chomp
    lib_dir = `#{ruby_prefix}/bin/ruby -r rbconfig -e 'puts Config::CONFIG[%[libdir]]'`.chomp
    so_name = `#{ruby_prefix}/bin/ruby -r rbconfig -e 'puts Config::CONFIG[%[LIBRUBY_SO]]'`.chomp

    system "cmake", "-DPREFIX=#{prefix}",
                    "-DENABLE_RUBY=ON",
                    "-DENABLE_PERL=OFF",
                    "-DRUBY_INCLUDE_PATH:PATH=#{header_dir}",
                    "-DRUBY_LIBRARY:FILEPATH=#{lib_dir}/#{so_name}",
                    std_cmake_parameters, "."

    system "make install"
  end
end
