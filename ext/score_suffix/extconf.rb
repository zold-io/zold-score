# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Zerocracy
# SPDX-License-Identifier: MIT

require 'mkmf'

# rubocop:disable Style/GlobalVars
$warnflags = ''
$CXXFLAGS << ' -std=c++11 -Wno-deprecated-register'
$CXXFLAGS.gsub!('-Wimplicit-int', '')
$CXXFLAGS.gsub!('-Wdeclaration-after-statement', '')
$CXXFLAGS.gsub!('-Wimplicit-function-declaration', '')
# rubocop:enable Style/GlobalVars

create_makefile 'score_suffix/score_suffix'
