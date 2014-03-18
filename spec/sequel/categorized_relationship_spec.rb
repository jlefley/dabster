require 'db_spec_helper'
require 'categorized_relationship'

Sequel::Model.db.create_table(:test_works) { primary_key :id }
Sequel::Model.db.create_table(:test_contributors) { primary_key :id }
Sequel::Model.db.create_table(:join_table) { 
  foreign_key :test_work_id, :test_works
  foreign_key :test_contributor_id, :test_contributors
  String :type
}

class TestContributorTestWork < Sequel::Model(:join_table)
end

class TestContributor < Sequel::Model
end

class TestWork < Sequel::Model
  plugin :categorized_relationship
  categorized_relationship :contributors, :type, class: 'TestContributor',
    relationship_class: 'TestContributorTestWork', right_key: :test_contributor_id
end

describe Sequel::Plugins::CategorizedRelationship do

  let(:work) { TestWork.create }
  let(:contributor) { TestContributor.create }
  let(:other_contributor) { TestContributor.create }

  before do
    work.add_contributor(contributor, 'type')
  end

  describe 'when adding related object' do
    it 'creates relationship with specified category' do
      relationship = TestContributorTestWork.first
      expect(relationship.test_contributor_id).to eq(contributor.id)
      expect(relationship.test_work_id).to eq(work.id)
      expect(relationship.type).to eq('type')
    end
  end

  describe 'when getting related object' do
    it 'returns associated objects sorted by category' do
      work.add_contributor(other_contributor, 'editor')
      expect(work.contributors).to eq(type: [contributor], editor: [other_contributor])
    end
  end

end
