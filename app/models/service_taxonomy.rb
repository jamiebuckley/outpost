class ServiceTaxonomy < ApplicationRecord
    belongs_to :service
    belongs_to :taxonomy

    has_paper_trail
end