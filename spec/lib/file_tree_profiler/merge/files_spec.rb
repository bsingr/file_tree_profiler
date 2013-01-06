require 'spec_helper'

describe FileTreeProfiler::Merge::Files do
  let(:source) do
    mock(:source).tap do |source|
      source.stub(:checksum).and_return('a1')
      source.stub(:name).and_return('foo')
    end
  end

  let(:target) do
    mock(:target).tap do |source|
      source.stub(:checksum).and_return('a1')
      source.stub(:name).and_return('foo')
    end
  end

  context :equal do
    before do
      subject.add :source, source
      subject.add :target, target
    end

    its(:name) { should == 'foo' }
    its(:status) { should == described_class::EQUAL }
  end

  context :different do
    before do
      source.stub(:checksum).and_return('b2')
      subject.add :source, source
      subject.add :target, target
    end

    its(:name) { should == 'foo' }
    its(:status) { should == described_class::DIFFERENT }
  end

  context :only_target do
    before do
      subject.add :target, target
    end

    its(:name) { should == 'foo' }
    its(:status) { should == described_class::ONLY_TARGET }
  end

  context :only_source do
    before do
      subject.add :source, source
    end

    its(:name) { should == 'foo' }
    its(:status) { should == described_class::ONLY_SOURCE }
  end
end
