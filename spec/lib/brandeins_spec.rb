# encoding: utf-8

require 'spec_helper'

require_lib 'brandeins'

describe BrandEins do

  it 'shows current version' do
    out = capture_stdout do
      BrandEins::CLI.start(['--version'])
    end
    expect(out.chomp).to eq BrandEins::VERSION
  end

  it 'shows setup instructions' do
    pending
    # pdf_tool = Object.new
    # pdf_tool.define_singleton_method(:available?) do true; end
    # pdf_tool.define_singleton_method(:cmd) do "Funky Monkey" end

    # out = capture_stdout do
    #   BrandEins::Setup.new( pdf_tool: pdf_tool ).run
    # end

    # assert !!out.chomp.match("you have Funky Monkey running"), "Missing Funky Monkey"
  end
end
