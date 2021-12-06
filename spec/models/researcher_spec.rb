require 'rails_helper'

RSpec.describe Researcher, type: :model do
  subject do
    described_class.new(
      email: 'researcher@example.com',
      password: 'researcher'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is not be valid without password' do
    subject.password = nil
    expect(subject).to_not be_valid
  end
end
