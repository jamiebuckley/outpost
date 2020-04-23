class Taxonomy < ApplicationRecord
    has_many :service_taxonomies
    has_many :services, through: :service_taxonomies

    has_many :children, class_name: "Taxonomy",
                            foreign_key: "parent_id",
                            dependent: :destroy

    belongs_to :parent, class_name: "Taxonomy", optional: true

    validates_presence_of :name, uniqueness: true

    has_paper_trail

    def slug
        name.parameterize
    end
end
