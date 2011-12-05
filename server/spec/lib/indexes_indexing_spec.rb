# encoding: utf-8
#
require 'spec_helper'

describe Picky::Indexes do

  context 'after initialize' do
    let(:indexes) { described_class.new }
    it 'has no indexes' do
      indexes.indexes.should == []
    end
  end

  describe 'methods' do
    let(:indexes) { described_class.new }
    before(:each) do
      @index1 = stub :index1, :name => :index1
      @index2 = stub :index2, :name => :index2
      indexes.register @index1
      indexes.register @index2
    end
    describe 'index' do
      it 'takes a snapshot, then indexes and caches each' do
        @index1.should_receive(:index).once.with.ordered
        @index2.should_receive(:index).once.with.ordered

        indexes.index
      end
    end
    describe 'register' do
      it 'should have indexes' do
        indexes.indexes.should == [@index1, @index2]
      end
    end
    describe 'clear_indexes' do
      it 'clears the indexes' do
        indexes.clear_indexes

        indexes.indexes.should == []
      end
    end
    def self.it_delegates_each name
      describe name do
        it "calls #{name} on each in order" do
          @index1.should_receive(name).once.with.ordered
          @index2.should_receive(name).once.with.ordered

          indexes.send name
        end
      end
    end
    it_delegates_each :clear
    it_delegates_each :index
  end

end