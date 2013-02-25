require 'spec_helper'

describe Dotmailer::DataField do
  describe 'Class' do
    let(:client) { double 'client' }

    subject { Dotmailer::DataField }

    before(:each) do
      subject.stub :client => client
    end

    describe '.all' do
      let(:data_fields) {
        [
          {
            'name'         => 'FIRSTNAME',
            'type'         => 'String',
            'visibility'   => 'Public',
            'defaultValue' => 'John'
          },
          {
            'name'         => 'CODE',
            'type'         => 'String',
            'visibility'   => 'Private',
            'defaultValue' => nil
          }
        ]
      }

      before(:each) do
        client.stub :get => data_fields
      end

      it 'should get the fields from the client' do
        client.should_receive(:get).with('/data-fields')

        subject.all
      end

      it 'should return a list of DataFields from the client' do
        subject.all.should == data_fields.map { |df| subject.new(df) }
      end
    end

    describe '.create' do
      let(:name) { 'FIRSTNAME' }

      let(:data_field) do
        {
          'name'         => name,
          'type'         => 'String',
          'visibility'   => 'Public',
          'defaultValue' => nil
        }
      end

      before(:each) do
        client.stub :post_json => data_field
      end

      it 'should call post_json on the client with the field' do
        client.should_receive(:post_json).with('/data-fields', data_field)

        subject.create name
      end

      it 'should return true' do
        subject.create(name).should == true
      end
    end
  end

  let(:name)       { 'FIRSTNAME' }
  let(:type)       { 'String' }
  let(:visibility) { 'Public' }
  let(:default)    { 'John' }

  let(:attributes) do
    {
      'name'         => name,
      'type'         => type,
      'visibility'   => visibility,
      'defaultValue' => default
    }
  end

  subject { Dotmailer::DataField.new(attributes) }

  its(:name)       { should == name }
  its(:type)       { should == type }
  its(:visibility) { should == visibility }
  its(:default)    { should == default }

  its(:to_s) { should == 'Dotmailer::DataField name: "FIRSTNAME", type: "String", visibility: "Public", default: "John"' }

  its(:to_json) { should == attributes.to_json }

  describe '#==' do
    specify { subject.should == Dotmailer::DataField.new(attributes) }
  end
end
