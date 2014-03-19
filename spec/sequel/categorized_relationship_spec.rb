require 'db_spec_helper'
require 'categorized_relationship'

Sequel::Model.db.create_table(:test_works) { primary_key :id }
Sequel::Model.db.create_table(:test_contributors) { primary_key :id }
Sequel::Model.db.create_table(:join_table) { 
  primary_key :id
  foreign_key :test_work_id, :test_works
  foreign_key :test_contributor_id, :test_contributors
  String :type
  TrueClass :pick
}

class TestContributorTestWork < Sequel::Model(:join_table)
end

class TestContributor < Sequel::Model
end

class TestWork < Sequel::Model
  plugin :categorized_relationship
  categorized_relationship :contributors, class: 'TestContributor',
    relationship_class: 'TestContributorTestWork', right_key: :test_contributor_id
end

describe Sequel::Plugins::CategorizedRelationship do

  let(:work) { TestWork.create }
  let(:contributor) { TestContributor.create }
  let(:other_contributor) { TestContributor.create }
  let(:another_contributor) { TestContributor.create }

  describe 'when adding related object' do
    it 'creates relationship to related object with attributes' do
      work.add_contributor(contributor, type: :author)
      relationship = TestContributorTestWork.first
      expect(relationship.test_contributor_id).to eq(contributor.id)
      expect(relationship.test_work_id).to eq(work.id)
      expect(relationship.type).to eq('author')
    end
  end

  describe 'when removing related object' do
    describe 'when specified object is related with specified attributes' do
      it 'removes the relationship to related object with specified attributes' do
        work.add_contributor(contributor, type: :author)
        work.add_contributor(other_contributor, type: :editor)

        work.remove_contributor(contributor, type: :author)

        expect(TestContributorTestWork.all.length).to eq(1)
        expect(TestContributorTestWork.first.type).to eq('editor')
      end
    end
    describe 'when specified object is not related with specified category' do
      it 'raises error' do
        expect { work.remove_contributor(contributor, type: :author) }.to raise_error(Sequel::Error)
      end
    end
  end

  describe 'when getting related object' do
    it 'returns associated objects sorted by specified attribute' do
      work.add_contributor(contributor, type: :author)
      work.add_contributor(other_contributor, type: :editor)
      expect(work.contributors_by(:type)).to eq(author: [contributor], editor: [other_contributor])
    end
    describe 'when filter critera is specified' do
      it 'returns only objects with relationships matching filter critera sorted by specified attribute' do
        work.add_contributor(contributor, type: :author, pick: false)
        work.add_contributor(other_contributor, type: :author, pick: true)
        expect(work.contributors_by(:type, pick: false)).to eq(author: [contributor])
      end
    end
  end

  describe 'when removing all related objects' do
    it 'removes all relationships matching specified conditions and related to model' do
      work.add_contributor(contributor, type: :author)
      work.add_contributor(other_contributor, type: :editor)
      work.add_contributor(another_contributor, type: :editor)

      work.remove_all_contributors(type: :editor)

      expect(TestContributorTestWork.all.length).to eq(1)
      expect(TestContributorTestWork.first.type).to eq('author')
    end

    describe 'when filtering by boolean field' do
      it 'removes all relationships matching specified conditions and related to model' do
        work.add_contributor(contributor, type: :editor, pick: true)
        work.add_contributor(other_contributor, type: :editor, pick: false)
        work.add_contributor(another_contributor, type: :editor, pick: false)
        
        work.remove_all_contributors(pick: false)
        
        expect(TestContributorTestWork.all.length).to eq(1)
      end
    end
  end

end
