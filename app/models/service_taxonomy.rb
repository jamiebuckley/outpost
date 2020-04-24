class ServiceTaxonomy < ApplicationRecord
    belongs_to :service
    belongs_to :taxonomy

    has_associated_audits
end