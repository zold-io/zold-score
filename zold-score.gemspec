# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Zerocracy
# SPDX-License-Identifier: MIT

require 'English'
Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.5'
  s.name = 'zold-score'
  s.version = '0.6.0'
  s.license = 'MIT'
  s.summary = 'Zold score'
  s.description = 'Score calculating Ruby Gem for Zold'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/zold-io/zold-score'
  s.files = `git ls-files`.split($RS)
  s.extensions = %w[ext/score_suffix/extconf.rb]
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_dependency 'openssl', '~>3.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
